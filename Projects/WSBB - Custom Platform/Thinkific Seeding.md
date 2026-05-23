# Thinkific → Coach Directory Seeding

**Related:** [[Coach Directory - Project Plan]]
**Scripts:** `apps/api/src/scripts/fetch-thinkific.ts` + `seed-db.ts`

---

## Overview

Two-step process. Pull from Thinkific first, inspect the JSON, then seed the DB. Safe to re-run at any time.

```
Step 1: bun run scripts/fetch-thinkific.ts   → coaches-raw.json
Step 2: bun run scripts/seed-db.ts           → upserts into DB
```

---

## Thinkific API

**Base URL:** `https://api.thinkific.com/api/public/v1`

**Auth headers (API Key method — simplest for scripts):**
```
X-Auth-API-Key: {key}
X-Auth-Subdomain: {subdomain}   // e.g. "westsidebarbell"
```

Get API key: Thinkific Admin → Settings → API → Create API Key

**Two APIs exist:**
- REST Admin API (`/v1`) — stable, API key auth → use this for seeding
- GraphQL API (`/v2`) — newer, Bearer token auth → Thinkific recommends for new dev

We use REST for the seed script because API key auth requires no OAuth flow.

---

## Key Endpoints Used

### List courses
```
GET /courses?page=1&limit=250
```
Returns all courses. Use this first run (with no course IDs set) to identify the pathway course IDs.

### Get completed enrollments for a course
```
GET /enrollments?query[course_id]={id}&query[completed]=true&page=1&limit=250
```
Returns only enrollments where `completed = true`. The `query[completed]` filter is a first-class param.

### Get a single user
```
GET /users/{user_id}
```
Returns: `id`, `email`, `first_name`, `last_name`, `full_name`, `avatar_url`, `bio`, `roles`, `created_at`

### Pagination
All list endpoints use `page` + `limit`. Response includes:
```json
{
  "items": [...],
  "meta": {
    "pagination": {
      "current_page": 1,
      "next_page": 2,
      "total_pages": 4,
      "total_count": 87
    }
  }
}
```
Max `limit` is 250. Scripts handle all pages automatically.

---

## .env Setup

```bash
# .env.local (apps/api)

THINKIFIC_API_KEY=your_key_here
THINKIFIC_SUBDOMAIN=westsidebarbell   # or whatever the subdomain is

# Fill these in after running the script once without them
# (it will print a course list so you can find the right IDs)
THINKIFIC_LEVEL1_ID=12345
THINKIFIC_LEVEL2_ID=12346
THINKIFIC_LEVEL3_ID=12347
```

---

## Tier Mapping

| Thinkific Course | Level | DB Tier |
|-----------------|-------|---------|
| Level 1 Pathway | 1 | `certified` |
| Level 2 Pathway | 2 | `instructor` |
| Level 3 Pathway | 3 | `master` |

If a coach completed multiple levels, they get the **highest** tier. All completed levels are stored in `coach_certifications`.

Note: "Master" tier may be reserved for HQ faculty regardless of level — confirm with Tom (open question in project plan).

---

## What Gets Seeded

### `coach_profiles`
- `user_id` = `thinkific_{id}` (synthetic, until real auth is wired)
- `thinkific_id` = Thinkific user ID (for future cross-referencing)
- `name`, `email` from Thinkific user record
- `bio`, `photo_url` from Thinkific (often empty — coaches fill in via dashboard)
- `tier` = highest completed pathway level
- `is_published = false` — admin must approve before going live

### `coach_certifications`
One row per completed pathway level per coach. Stores `level`, `completed_at`, `certified_by = 'thinkific'`.

---

## Running It

### First run (find course IDs)
```bash
cd apps/api
bun run scripts/fetch-thinkific.ts
# Prints a table of all courses — find Level 1/2/3 and add IDs to .env
```

### Full run
```bash
bun run scripts/fetch-thinkific.ts
# → coaches-raw.json created

cat coaches-raw.json | head -50   # inspect
# or open in VS Code / Cursor

bun run scripts/seed-db.ts --dry-run   # preview what will happen
bun run scripts/seed-db.ts             # write to DB
```

### Re-seeding (idempotent)
The seed script upserts on `user_id`. Re-running:
- Inserts new coaches not yet in the DB
- Upgrades tier if a coach completed a higher level since last run
- Does NOT overwrite bio, photo, city, etc. that coaches have already filled in

---

## After Seeding

1. Open the admin panel (`/admin/coaches`)
2. Review each profile — some may have bio/photo from Thinkific, most won't
3. Publish coaches who are ready, or send them the "complete your profile" email first
4. For coaches with no Thinkific bio/photo, they'll fill in via the self-management dashboard

---

## Future: Automated Sync (Phase E)

Replace the manual script with a Thinkific webhook:
- Event: `course.completed`
- Payload includes `user_id` and `course_id`
- Our Hono webhook handler: look up the course → determine tier → upsert `coach_certifications` → if new highest tier, update `coach_profiles.tier` → send "you're eligible" email

Webhook registration via Thinkific API:
```
POST /webhooks
{
  "topic": "course_completed",
  "target_url": "https://coaches.wsbb.com/api/webhooks/thinkific"
}
```

---

*Notes by Mike Weaver | 2026-05-23*
