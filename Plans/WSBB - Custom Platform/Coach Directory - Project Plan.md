# WSBB Coach Directory — Project Plan

**Client:** Tom Barry, Westside Barbell
**Request date:** 2026-05-23
**Last updated:** 2026-05-23
**Source:** Tom's email re: certified coach directory page
**Related:** [[Project Brief]], [[Phase 1 - Core LMS]], [[Rogue Equipped Gyms - Competitive Audit]]

---

## What Tom Wants

- A public-facing page listing coaches as they complete the Conjugate certification pathway
- Interactive map (simple + inexpensive) showing coach locations
- Tier/tag system distinguishing coach levels:
  - **Master Coach** — HQ faculty, top tier
  - **Instructor** — seminar certified
  - **Certified Coach** — pathway graduate
  - **Verified** — background-checked (cross-cutting tag, any tier)
- Self-managed profiles — coaches maintain their own photo, bio, location, contact info
- No manual admin uploads per coach
- Q1: Regular page or subdomain?
- Q2: Can Shopify customer accounts power the self-management?

Tom added Mike to all Thinkific accounts — pathway currently lives on Thinkific.

---

## Answers to Tom's Questions

**Q1 — Subdomain, not Shopify page.**
`coaches.wsbb.com` pointing to this app. Shopify adds a "Find a Coach" nav link there. Backlinks to subdomains carry SEO authority — not a concern. A subdomain is cleaner to build and own long-term.

**Q2 — No Shopify accounts needed.**
Coaches have an account on the custom platform. Same login covers courses + coach directory profile. Shopify is the storefront; it's not the right tool for user-managed data.

---

## Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| Runtime | **Bun** | Fast, native TypeScript, built-in test runner + bundler |
| API server | **Hono** | Lightweight, Bun-native, great TypeScript, edge-compatible |
| Frontend | **React + Vite** | SPA, Bun-powered dev server |
| ORM | **Drizzle ORM** | Type-safe, supports Postgres + SQLite with the same schema |
| DB (local) | **SQLite** | Zero setup, Drizzle's `better-sqlite3` driver |
| DB (prod) | **Postgres** | Switch via env var — same Drizzle schema, no code changes |
| Map | **Mapbox GL JS** via `react-map-gl` | Dark theme, custom tier-colored pins, free <50k loads/mo |
| Geocoding | **OpenCage API** | Free 2,500 req/day — fires when coach saves their address |
| File storage | **Cloudflare R2** | Coach photo uploads — S3-compatible, cheap egress |
| Auth | **Supabase Auth (JWT)** | Reuse existing platform auth — Hono middleware verifies JWT |
| Hosting | **Fly.io** or **Railway** | Bun-native deploys, Postgres included |

### Why Drizzle for Postgres + SQLite
Drizzle uses the exact same schema definition for both drivers. Locally you point at a `.db` file; in production you point at Postgres. No migration friction, no conditional code. This is the cleanest local dev story for a Postgres app.

### Why Hono over Express/Fastify
Bun runs Hono at ~300k req/sec in benchmarks. Hono's `c.req`, `c.json()`, and middleware chain feel like a modern fetch-based router — no `req/res` Node legacy. Also runs unchanged on Cloudflare Workers if we ever want to move the API to the edge.

---

## Project Structure

```
coach-directory/
├── apps/
│   ├── api/                        # Bun + Hono backend
│   │   ├── src/
│   │   │   ├── index.ts            # Hono app entry, routes mounted here
│   │   │   ├── routes/
│   │   │   │   ├── coaches.ts      # GET /coaches, GET /coaches/:id
│   │   │   │   ├── profile.ts      # PUT /profile (auth required)
│   │   │   │   └── admin.ts        # admin publish/tag routes
│   │   │   ├── db/
│   │   │   │   ├── schema.ts       # Drizzle schema (shared Postgres + SQLite)
│   │   │   │   ├── index.ts        # DB client (switches on DATABASE_URL)
│   │   │   │   └── migrations/     # Drizzle-kit generated
│   │   │   ├── middleware/
│   │   │   │   └── auth.ts         # Supabase JWT verification
│   │   │   └── lib/
│   │   │       └── geocode.ts      # OpenCage geocoding helper
│   │   ├── package.json
│   │   └── bunfig.toml
│   │
│   └── web/                        # React + Vite frontend
│       ├── src/
│       │   ├── main.tsx
│       │   ├── App.tsx
│       │   ├── pages/
│       │   │   ├── Directory.tsx   # Public /coaches page
│       │   │   └── Profile.tsx     # Coach self-management (auth gated)
│       │   ├── components/
│       │   │   ├── CoachMap.tsx    # react-map-gl map component
│       │   │   ├── CoachCard.tsx   # Individual card
│       │   │   ├── CoachGrid.tsx   # Tiered grid sections
│       │   │   ├── FilterBar.tsx   # Tier filter + search + toggles
│       │   │   └── TierLegend.tsx  # Badge legend bar
│       │   └── lib/
│       │       ├── api.ts          # Fetch wrappers for Hono API
│       │       └── types.ts        # Shared types (mirrored from Drizzle schema)
│       ├── index.html
│       ├── vite.config.ts
│       └── package.json
│
├── package.json                    # Bun workspaces root
└── .env.example
```

---

## Database Schema (Drizzle)

```typescript
// apps/api/src/db/schema.ts

import { pgTable, sqliteTable, text, real, boolean, timestamp, integer } from 'drizzle-orm/pg-core'
// For SQLite locally, swap pg-core → sqlite-core. Same field definitions.

export const coachProfiles = pgTable('coach_profiles', {
  id:           text('id').primaryKey().$defaultFn(() => crypto.randomUUID()),
  userId:       text('user_id').notNull().unique(),      // FK → Supabase auth.users
  name:         text('name').notNull(),
  bio:          text('bio'),                             // 200 char recommended max
  specialty:    text('specialty'),                       // e.g. "Powerlifting / MMA"
  photoUrl:     text('photo_url'),                       // R2 object URL
  city:         text('city'),
  state:        text('state'),
  country:      text('country').default('US'),
  lat:          real('lat'),                             // geocoded
  lng:          real('lng'),                             // geocoded
  email:        text('email'),                           // public contact email
  website:      text('website'),
  instagram:    text('instagram'),
  tier:         text('tier', { enum: ['master', 'instructor', 'certified'] }),
  verified:     boolean('verified').default(false),      // background check passed
  takesClients: boolean('takes_clients').default(true),  // "Takes new clients" toggle
  isPublished:  boolean('is_published').default(false),  // admin approval gate
  createdAt:    timestamp('created_at').defaultNow(),
  updatedAt:    timestamp('updated_at').defaultNow(),
})

export const coachCertifications = pgTable('coach_certifications', {
  id:          text('id').primaryKey().$defaultFn(() => crypto.randomUUID()),
  userId:      text('user_id').notNull(),
  level:       integer('level').notNull(),               // 1, 2, or 3
  completedAt: timestamp('completed_at').defaultNow(),
  certifiedBy: text('certified_by'),                     // instructor name or 'thinkific'
  notes:       text('notes'),
})
```

### Local vs. Production switching

```typescript
// apps/api/src/db/index.ts
import { drizzle } from DATABASE_URL?.startsWith('file:')
  ? 'drizzle-orm/better-sqlite3'
  : 'drizzle-orm/postgres-js'

export const db = drizzle(process.env.DATABASE_URL!)
```

`.env.local` → `DATABASE_URL=file:./dev.db`
`.env.production` → `DATABASE_URL=postgres://...`

No other code changes needed.

---

## API Routes (Hono)

```
GET  /api/coaches              → all published coaches (supports ?tier=&state=&search=&verified=)
GET  /api/coaches/:id          → single coach profile
PUT  /api/profile              → update own profile (JWT required)
POST /api/profile/photo        → upload photo to R2 (JWT required)
GET  /api/admin/coaches        → all coaches incl. unpublished (admin JWT required)
PUT  /api/admin/coaches/:id    → set tier, verified, is_published (admin JWT required)
```

Public routes return only `is_published = true` rows. Auth middleware checks Supabase JWT on protected routes.

---

## Page Layout (Informed by Rogue Audit)

Rogue's key insight: **the map is the hero** — it goes at the top, full-width, prominent. It signals "these coaches are everywhere." Everything below is secondary.

```
┌─────────────────────────────────────────────────────────────┐
│  HERO: "Conjugate Method Certified Coaches"                  │
│  [Bebas Neue, dark/gold, Tom's exact design]                 │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  TIER LEGEND: [MASTER INSTRUCTOR] [INSTRUCTOR] [CERTIFIED]   │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  MAPBOX MAP  — full width, 360px height                      │
│  Gold pins = Master  ·  Silver = Instructor  ·  Muted = Cert │
│  Click pin → scroll to + pulse-highlight card below          │
│  Click card → pan + zoom map to that pin                     │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  FILTER BAR                                                  │
│  [All] [Master] [Instructor] [Certified]  🔍 name/city       │
│  [Sort ▾]  [✓ Verified only]  [✓ Takes new clients]          │
│  [→ Complete the Pathway]              12 coaches            │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  ── MASTER INSTRUCTORS ──────────────────────────────────── │
│  [card]  [card]                                              │
│  ── INSTRUCTORS ─────────────────────────────────────────── │
│  [card]  [card]  [card]                                      │
│  ── CERTIFIED COACHES ───────────────────────────────────── │
│  [card]  [card]  [card]  [card]  [card]                      │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  FOOTER CTA: "Complete the Pathway → Start Level 1"          │
└─────────────────────────────────────────────────────────────┘
```

### Differences from Tom's wireframe (improvements from Rogue audit)

| Element | Tom's Wireframe | Updated Plan |
|---------|----------------|--------------|
| Map position | Below hero/legend/filters | **Above filters** — map is the hero |
| Photo size | 64px avatar | **120px headshot** — builds more personal trust |
| "Takes clients" filter | Not present | **Added** — most useful filter for people searching |
| Pathway CTA | Footer only | **Also in filter bar** — always visible, drives enrollment |
| Pin ↔ card link | Static | **Bidirectional** — click pin scrolls to card; click card pans map |

Everything else in Tom's wireframe (color palette, fonts, tier badges, card layout, bio, specialty, contact button) stays exactly as designed.

---

## Map Implementation

```tsx
// apps/web/src/components/CoachMap.tsx
import Map, { Marker, Popup } from 'react-map-gl'
import 'mapbox-gl/dist/mapbox-gl.css'

const TIER_COLORS = {
  master:     '#c8a96e',   // gold
  instructor: '#c0bdb8',   // silver
  certified:  '#a8a49c',   // muted
}

// Custom SVG marker per tier
// Click marker → call onPinClick(coachId) → parent scrolls card into view
// Card hover/click → call flyTo({ center: [coach.lng, coach.lat] })
```

Map style: `mapbox://styles/mapbox/dark-v11` as the base — matches WSBB's palette out of the box. Fine-tune in Mapbox Studio if needed.

Geocoding on profile save:
```typescript
// apps/api/src/lib/geocode.ts
// POST to OpenCage with city + state + country
// Store lat/lng in coach_profiles
// Only re-geocode if address fields changed
```

---

## Self-Management Flow

1. Coach completes a Thinkific pathway level
2. Admin manually sets `tier` + creates `coach_certifications` record (short-term)
   → Later: Thinkific webhook → Make.com → `POST /api/admin/coaches/:id` auto-sets tier
3. Coach gets email: "You're eligible for the directory — complete your profile"
4. Coach logs in, goes to `/profile` (auth gated, only renders if they have a tier set)
5. Fills out: bio, specialty, city/state, photo upload, contact info, "Takes new clients" toggle
6. On save: geocode fires, lat/lng stored, profile saved as `is_published = false`
7. Admin reviews in admin panel, flips `is_published = true`
8. Coach appears on the public directory

---

## Build Phases

### Phase A — Foundation (Week 1)
- [ ] Bun workspace setup (`apps/api`, `apps/web`)
- [ ] Drizzle schema + migrations
- [ ] SQLite working locally, Postgres env var ready for prod
- [ ] Hono API with `/api/coaches` public route
- [ ] Supabase JWT middleware
- [ ] Seed script with 5–10 test coaches
- [ ] Admin route: set tier, verified, is_published

### Phase B — Public Directory (Week 1–2)
- [ ] React + Vite frontend wired to Hono API
- [ ] `CoachMap.tsx` — Mapbox, tier-colored pins, dark style
- [ ] `CoachCard.tsx` — matches Tom's wireframe, 120px photo
- [ ] `CoachGrid.tsx` — tiered sections, empty state handling
- [ ] `FilterBar.tsx` — tier filter, search, Verified toggle, Takes Clients toggle, coach count
- [ ] Bidirectional pin ↔ card linking
- [ ] Responsive (matches wireframe breakpoints: 900px, 560px)
- [ ] "Complete the Pathway" CTA in filter bar → links to Level 1 course

### Phase C — Self-Management (Week 2–3)
- [ ] `/profile` route — auth gated, only renders for coaches with a tier
- [ ] Form: bio, specialty, city/state, contact info, "Takes new clients" toggle
- [ ] Photo upload → R2 (presigned URL from Hono API)
- [ ] Geocoding on save
- [ ] Live card preview — see exactly how listing will look
- [ ] "Profile pending review" state after save

### Phase D — Admin Tools (Week 3)
- [ ] Simple admin UI at `/admin/coaches` (auth gated, admin role only)
- [ ] Table: all coaches, tier, published status, last updated
- [ ] Bulk actions: publish, unpublish, set tier, set verified
- [ ] "Pending review" queue for new/updated profiles

### Phase E — Automation (Phase 2)
- [ ] Thinkific webhook → Make.com → `POST /api/admin/coaches` auto-tag on course completion
- [ ] Email to coach on certification: "You're eligible — complete your profile"
- [ ] Email to coach when profile goes live
- [ ] Email to admin on new profile submission

---

## Cost Estimate

| Service | Local | Production |
|---------|-------|------------|
| Bun runtime | Free | Free |
| SQLite | Free | — |
| Postgres (Fly.io or Railway) | — | ~$5–7/month |
| Mapbox | Free | Free (<50k loads/mo) |
| OpenCage geocoding | Free | Free (<2,500/day) |
| Cloudflare R2 (photos) | — | ~$0 (10GB free) |
| Fly.io / Railway hosting | — | ~$5–10/month |
| **Total** | **$0** | **~$10–17/month** |

---

## Wireframe Reference

Tom's wireframe (`conjugate-coaches-directory.html`) is the design bible. Exact tokens to preserve:

```css
--bg:    #0a0a0a;
--gold:  #c8a96e;
--text:  #e8e4dc;
--muted: #a8a49c;
--card:  #151515;
```

Fonts: Bebas Neue (headings) · Barlow Condensed (labels/badges) · Barlow (body)

The only departures: map moves above filters, photo size increases to 120px, two new filter toggles added, bidirectional pin↔card linking added.

---

## Open Questions for Tom

1. **Pathway → tier mapping**: Level 1 = Certified, Level 2 = Instructor, Level 3 = Master? Or is Master HQ-only regardless of level?
2. **Verified / background check**: Manual process or external service (Checkr, Sterling)?
3. **Photo policy**: Required to publish? Aspect ratio / max size?
4. **Contact method**: Email link, contact form, or link to coach's own site?
5. **International**: US-only at launch, or global from day one?
6. **Existing coaches**: List to bulk-import at launch?
7. **"Takes new clients"**: Should this be coach-toggled or admin-toggled?

---

*Notes by Mike Weaver | 2026-05-23*
