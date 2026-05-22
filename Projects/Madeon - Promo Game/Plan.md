# Madeon Promo Game — Build Plan

## Overview

A standalone promotional web app for Madeon, entered via `victory.band`. A fan enters their email, plays a short game (image puzzle or chess), and receives a personalized Shopify discount code via email upon completion. Lead data is captured and tied to a Shopify customer record for future marketing attribution.

**Entry point:** victory.band (Wix site — embed via iframe or redirect to hosted URL)
**Goal:** Lead capture + fan engagement → personalized discount code redeemable on Shopify

---

## Recommended Game: Image Puzzle

Image puzzle is the preferred path over chess — simpler game logic, fewer edge cases, more visually on-brand for an artist. Fan has a time limit to solve a sliding or jigsaw puzzle (e.g. album art). Any completion (or time expiry with partial progress) awards the code — participation is the gate, not skill.

Chess is a fallback option if the client prefers it. Uses `chess.js` + `react-chessboard`. "Participation" would be defined as making 1–3 moves in a session.

---

## Tech Stack

| Layer | Choice |
|---|---|
| Runtime | Bun |
| Frontend | React (Vite) |
| Backend | Hono on Bun |
| Database | SQLite via Kysely |
| Email | Resend |
| Discount | Shopify Admin REST API |
| Hosting | Railway |

---

## Architecture

```
victory.band
  → redirect/iframe to hosted Bun app

[Landing Page]
  Email input → POST /api/start → session created → game loads

[Game]
  Player completes puzzle/moves → POST /api/complete → discount code emailed

[Bun Server]
  /api/start    — validate email, create session, return sessionId
  /api/complete — validate session, create Shopify customer, mint code, send email
  /leaderboard  — public leaderboard data (anonymized)
  /admin        — protected admin dashboard (summary stats from DB)

[Shopify Admin API]
  - Find or create customer by email
  - Create price rule targeting that customer ID (prerequisite gating)
  - Mint unique discount code under that rule

[SQLite]
  sessions: id, email, startedAt, redeemedAt, completionTimeMs, score
  codes: email, code, shopifyCustomerId, createdAt
```

---

## API Routes

### `POST /api/start`
- Validate email format
- Block `+` addressed emails (e.g. `mike+1@gmail.com`)
- Block known disposable domains (use `disposable-email-domains` npm package)
- Check `codes` table — if email already has a code, return it (idempotent)
- Create session: `{ id: crypto.randomUUID(), email, startedAt: Date.now() }`
- Insert into `sessions` table
- Return `{ sessionId }`

### `POST /api/complete`
- Receive `{ sessionId, email, completionTimeMs, score }`
- Look up session — must exist, email must match, `redeemedAt` must be null
- Mark session as redeemed: `UPDATE sessions SET redeemedAt = now(), completionTimeMs = ?, score = ? WHERE id = ?`
- Check `codes` table again for email (double guard)
- Call Shopify: find or create customer by email → get `customerId`
- Call Shopify: create price rule with `prerequisite_customer_ids: [customerId]`
- Call Shopify: mint unique code under that rule
- Insert into `codes` table
- Send email via Resend with the code
- Return `{ success: true }`

### `GET /leaderboard`
- Public, no auth
- Returns top N completions ordered by `completionTimeMs` ASC (fastest wins)
- Anonymize email: `m***@gmail.com`
- Include: rank, anonymized email, completion time, date

### `GET /admin`
- Protected via `ADMIN_SECRET` header (env var, checked server-side)
- Returns high-level stats:
  - Total sessions started
  - Total codes issued
  - Completion rate (codes issued / sessions started)
  - Codes issued over time (daily breakdown)
  - Top completion times (full email visible)
  - Disposable/blocked email attempts count

---

## Database Schema (Kysely / SQLite)

```ts
// sessions
id                TEXT PRIMARY KEY   -- crypto.randomUUID()
email             TEXT NOT NULL
startedAt         INTEGER NOT NULL   -- Date.now()
redeemedAt        INTEGER            -- null until redeemed
completionTimeMs  INTEGER            -- null until redeemed, ms to complete
score             INTEGER            -- optional, puzzle-specific score

// codes
email             TEXT PRIMARY KEY
code              TEXT NOT NULL
shopifyCustomerId TEXT NOT NULL
createdAt         INTEGER NOT NULL
```

---

## Analytics Pages

### Public Leaderboard (`/leaderboard`)
- React page served by the Bun app (same origin)
- Shows top completions ranked by speed
- Anonymized emails (`m***@gmail.com`)
- Columns: Rank, Player, Time, Date
- Auto-refreshes every 60s
- On-brand styling matching the game UI

### Admin Dashboard (`/admin`)
- Password-protected via a simple secret key in the URL or header (`?key=ADMIN_SECRET`)
- No separate auth system needed — this is internal use only
- Shows:
  - **Summary cards:** Total plays, Total codes issued, Completion rate %
  - **Daily chart:** Codes issued per day (line or bar)
  - **Full leaderboard:** Unmasked emails, completion times, code issued
  - **Drop-off:** Sessions started but never completed
- Built as a React page with Recharts for the chart
- Data fetched from `GET /admin` API route

---

## Shopify Integration

### Discount gating approach
Each code is gated to the specific Shopify customer at the API level using `customer_selection: "prerequisite"`. This enforces at checkout for logged-in customers. Guest checkout falls back to single-use code enforcement only.

```ts
// Step 1: Find or create customer
GET  /admin/api/2024-04/customers/search.json?query=email:{email}
POST /admin/api/2024-04/customers.json  // if not found

// Step 2: Create price rule per player
POST /admin/api/2024-04/price_rules.json
{
  title: `MADEON-GAME-${customerId}`,
  value_type: "percentage",
  value: "-10.0",
  target_type: "line_item",
  target_selection: "all",
  allocation_method: "across",
  starts_at: new Date().toISOString(),
  customer_selection: "prerequisite",
  prerequisite_customer_ids: [customerId],
  usage_limit: 1,
  once_per_customer: true
}

// Step 3: Mint code
POST /admin/api/2024-04/price_rules/{priceRuleId}/discount_codes.json
{
  code: `MADEON-${nanoid(8).toUpperCase()}`
}
```

Store Shopify Admin API token in `.env` — never exposed to frontend.

---

## Security Measures

| Threat | Mitigation |
|---|---|
| Skipping the game via direct API call | Session must exist in DB before code is issued |
| Replaying a completed session | `redeemedAt` checked — sessions are single-use |
| Same email getting multiple codes | `codes` table dedupe check at `/start` and `/complete` |
| Bulk requests / bots | Rate limit `/api/*` by IP — 3 requests/hour via `hono-rate-limiter` |
| Plus-addressed burner emails | Block any email containing `+` before the `@` |
| Disposable email domains | Block against `disposable-email-domains` npm package list |
| Shopify API key exposure | Key lives in `.env` on server only, never sent to client |
| Admin dashboard exposure | Protected by `ADMIN_SECRET` env var — simple header/query check |

---

## Email (Resend)

Send a simple transactional email on completion:

- **Subject:** Your Madeon discount code 🎵
- **Body:** Thank you for playing. Use code `MADEON-XXXXXXXX` at checkout for 10% off.
- **CTA button:** Link directly to the Shopify store

Use Resend's React Email templates for clean HTML output.

---

## Railway Deployment

- Single Railway service running the Bun app
- SQLite file persisted via Railway volume (attach a persistent disk)
- Environment variables set in Railway dashboard:
  - `SHOPIFY_ADMIN_TOKEN`
  - `SHOPIFY_SHOP_DOMAIN`
  - `RESEND_API_KEY`
  - `ADMIN_SECRET`
- Custom domain pointed from victory.band embed or redirect

---

## Scope Estimate

| Phase | Work | Est. |
|---|---|---|
| Bun project setup, DB, Hono routes | Backend skeleton | 0.5 day |
| Shopify API integration + discount minting | Core integration | 1 day |
| Image puzzle frontend (React) | Game UI | 1–2 days |
| Landing page + email capture flow | Frontend | 0.5 day |
| Email template (Resend) | Transactional email | 0.5 day |
| Security measures (rate limit, email validation) | Hardening | 0.5 day |
| Public leaderboard page | Analytics | 0.5 day |
| Admin dashboard + Recharts | Analytics | 1 day |
| Railway deploy + volume + env vars | Infra | 0.5 day |
| **Total** | | **~6–7 days** |

---

## Open Questions for Client

1. What discount value? (% off vs $ off, and how much)
2. Is participation enough to earn the code, or must they complete/win?
3. Does victory.band support iframe embeds, or will this be a redirect to a standalone URL?
4. What Shopify store do codes redeem against? Need admin API access.
5. Should codes expire? If so, how long?
6. Chess or image puzzle — client preference?
7. Leaderboard metric — fastest completion time, or a score-based system?

---

## Review Handoff Notes

- Shopify prerequisite gating only enforces for logged-in customers at checkout — guest checkout relies on single-use code only. Acceptable tradeoff for a promo campaign but client should be aware.
- `victory.band` integration scope is unknown until we confirm whether Wix supports iframe embeds or if we need a redirect flow.
- SQLite on Railway requires a persistent volume — confirm this is set up before first deploy or data will be lost on redeploy.
- Do not commit or deploy until Mike reviews Shopify API integration and email flow end-to-end.
