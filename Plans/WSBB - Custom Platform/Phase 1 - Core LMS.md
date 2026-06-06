# WSBB Platform — Phase 1: Core LMS

**Stack:** Vue 3 + Pinia + Vite + Netlify Functions + Supabase + Stripe + Mux
**Goal:** Replace Thinkific (Conjugate Club) with a custom LMS embedded in the nitro.ai codebase
**Community:** Discord embed — zero build time, ships with Phase 1
**Out of scope this phase:** Course builder admin UI, certificates, blog, native community

---

## Deliverables

1. Supabase schema (courses, enrollments, progress)
2. Video hosting pipeline via Mux
3. Stripe → Supabase access control (webhooks)
4. Course catalog UI (`/courses`)
5. Course player UI (`/courses/:slug/learn/:lessonId`)
6. Discord community embed
7. Content + user migration scripts

---

## 1. Supabase Schema

All via Supabase migrations. Use the Supabase client (`.from('table').select(...)`) — no raw SQL layer.

### Tables

```sql
-- Courses
courses (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  title text not null,
  description text,
  thumbnail_url text,
  is_free boolean default false,
  published boolean default false,
  sort_order int default 0,
  created_at timestamptz default now()
)

-- Modules (sections within a course)
modules (
  id uuid primary key default gen_random_uuid(),
  course_id uuid references courses(id) on delete cascade,
  title text not null,
  sort_order int default 0
)

-- Lessons
lessons (
  id uuid primary key default gen_random_uuid(),
  module_id uuid references modules(id) on delete cascade,
  title text not null,
  type text not null check (type in ('video','text','pdf','audio')),
  content text,              -- markdown for text lessons
  asset_url text,            -- PDF/audio file URL (Supabase Storage)
  mux_asset_id text,         -- Mux asset ID (set after upload)
  mux_playback_id text,      -- Mux playback ID (set after transcode)
  duration_seconds int,
  is_free_preview boolean default false,
  sort_order int default 0,
  published boolean default false
)

-- Bundles (e.g. Unlimited Access)
bundles (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  title text not null,
  stripe_price_id text,      -- Stripe Price ID for subscription
  stripe_product_id text,
  is_active boolean default true
)

-- Bundle → Course join
bundle_courses (
  bundle_id uuid references bundles(id) on delete cascade,
  course_id uuid references courses(id) on delete cascade,
  primary key (bundle_id, course_id)
)

-- Enrollments (one row per user per course OR bundle)
enrollments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  course_id uuid references courses(id),     -- null if bundle enrollment
  bundle_id uuid references bundles(id),     -- null if course enrollment
  stripe_subscription_id text,
  stripe_customer_id text,
  status text not null check (status in ('active','cancelled','past_due','trialing')),
  current_period_end timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
)

-- Lesson Progress
lesson_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  lesson_id uuid references lessons(id) on delete cascade,
  completed boolean default false,
  completed_at timestamptz,
  last_watched_at timestamptz,
  watch_seconds int default 0,   -- for resume position
  unique(user_id, lesson_id)
)
```

### RLS Policies

```sql
-- courses: anyone can read published courses
-- lessons: free_preview OR enrolled users only
-- enrollments: user can read their own rows only
-- lesson_progress: user can read/write their own rows only
```

Enable RLS on all tables. Write policies in Supabase dashboard or migration files.

---

## 2. Video Hosting — Mux

**Why Mux:** Best developer API, adaptive HLS streaming, Vue-compatible player, built-in analytics, per-minute pricing (cheapest at WSBB's scale). No vendor lock — playback IDs are portable.

### Setup
- Create Mux account → get `MUX_TOKEN_ID` + `MUX_TOKEN_SECRET`
- Add to Netlify env vars
- Install: `npm install @mux/mux-node @mux/mux-player` (or `mux-player-react` → use the web component version for Vue)

### Upload Pipeline (for admin/migration — Phase 2 will have UI)

```
Admin triggers upload
  → POST /functions/mux-upload-url
  → Netlify fn calls Mux API: creates direct upload URL
  → FE uploads file directly to Mux (no Netlify bandwidth)
  → Mux transcodes async
  → Mux fires webhook → POST /functions/mux-webhook
  → fn updates lessons SET mux_asset_id, mux_playback_id WHERE id = ?
```

### Netlify Functions needed

**`functions/mux-upload-url.mts`** — thin wrapper
```ts
// server/mux/createUploadUrl.ts (fat module)
// → calls Mux API, returns { uploadId, url }
// → fn creates pending lesson row or updates existing
```

**`functions/mux-webhook.mts`** — handle asset ready
```ts
// Verify Mux webhook signature
// On asset.ready: update lesson with mux_playback_id
// On asset.errored: mark lesson with error state
```

### Vue Player Component

Use `<mux-player>` web component (framework-agnostic, works in Vue):
```vue
<mux-player
  :playback-id="lesson.muxPlaybackId"
  :metadata-video-title="lesson.title"
  @timeupdate="onTimeUpdate"
  @ended="onLessonComplete"
/>
```

Track `timeupdate` → debounce → write `watch_seconds` to `lesson_progress` for resume.

---

## 3. Stripe → Supabase Access Control

### Webhook Handler — `functions/stripe-webhook.mts`

Handle these events:

| Event | Action |
|-------|--------|
| `customer.subscription.created` | Insert enrollment, status = 'active' |
| `customer.subscription.updated` | Update status + current_period_end |
| `customer.subscription.deleted` | Update status = 'cancelled' |
| `invoice.payment_failed` | Update status = 'past_due' |
| `invoice.payment_succeeded` | Update status = 'active' (handles recovery) |

Logic: look up `stripe_customer_id` → find user in Supabase → upsert enrollment.

**Note:** Use `stripe.webhooks.constructEvent(rawBody, sig, secret)` — raw body required, parse before JSON.

### Access Composable — `useAccess.ts`

```ts
// Returns: { hasAccess, isLoading, isFreeCourse }
// Checks enrollments table for active row matching user + course/bundle
// Free courses: bypass check (is_free = true on course row)
// Free preview lessons: bypass check (is_free_preview = true on lesson row)
```

Used in route guards and lesson components to gate content.

### Stripe Customer Portal

Add a "Manage Subscription" link in user dashboard → Netlify function creates a Stripe Billing Portal session → redirect. No custom billing UI needed.

---

## 4. Course Catalog — `/courses`

**Pinia store:** `useCourseStore`

```ts
state: {
  courses: Course[],
  enrollments: Enrollment[],
  bundles: Bundle[],
}
actions: {
  fetchCatalog()    // loads published courses + user's enrollments in parallel
  fetchBundle()     // loads bundle details + included courses
}
getters: {
  isEnrolled: (courseId) => boolean
  enrollmentStatus: (courseId) => 'active' | 'cancelled' | null
}
```

**UI:**
- Grid of course cards: thumbnail, title, short description, instructor tag, free badge
- Enrolled courses show progress % overlay
- CTA: "Start Learning" (enrolled) / "Free" (free course) / "Get Access" (locked → scrolls to bundle CTA)
- Bundle section at top: Unlimited Access card with pricing + subscribe button → Stripe Checkout

---

## 5. Course Player — `/courses/:slug/learn/:lessonId`

**Pinia stores:** `useCourseStore`, `useProgressStore`, `usePlayerStore`

### Layout

```
┌─────────────────────────────────────────────┐
│  ← Back to Courses    [Course Title]         │
├──────────────┬──────────────────────────────┤
│              │                              │
│  Sidebar     │   Main content area          │
│  ─────────   │   ──────────────────         │
│  Module 1    │   [Mux video player]         │
│    ✓ Lesson  │                              │
│    ● Lesson  │   Lesson title               │
│    ○ Lesson  │   Description / notes        │
│  Module 2    │                              │
│    ○ Lesson  │   [Mark as Complete btn]     │
│              │   [← Prev] [Next →]          │
│  ──────────  │                              │
│  Community   │                              │
│  [Discord ↗] │                              │
└──────────────┴──────────────────────────────┘
```

### Progress Store — `useProgressStore`

```ts
state: {
  progress: Record<lessonId, LessonProgress>
}
actions: {
  fetchProgress(courseId)
  markComplete(lessonId)       // upsert to lesson_progress
  updateWatchTime(lessonId, seconds)   // debounced, for resume
}
getters: {
  isComplete: (lessonId) => boolean
  coursePercent: (courseId) => number  // completed / total lessons
  resumeLesson: (courseId) => lessonId  // last incomplete lesson
}
```

### Player Store — `usePlayerStore`

```ts
state: {
  currentLesson: Lesson | null,
  isPlaying: boolean,
  currentTime: number,
}
actions: {
  loadLesson(lessonId)
  navigateNext()
  navigatePrev()
}
```

### Lesson Types

| Type | Renderer |
|------|----------|
| `video` | `<mux-player>` with resume from `watch_seconds` |
| `text` | Markdown renderer (e.g. `vue-markdown-it`) |
| `pdf` | `<iframe>` or PDF.js embed |
| `audio` | Native `<audio>` element with custom controls |

### Access Guard

Route-level guard: if `!hasAccess && !isFreeCourse && !lesson.isFreePreview` → redirect to `/courses/:slug` with locked state.

---

## 6. Discord Community Embed

Add to course player sidebar and user dashboard. Two options:

- **Widgetbot** (`https://widgetbot.io`) — embeds a Discord channel directly in the page, no redirect
- **Discord widget** — invite link + member count display, simple

Recommend Widgetbot for immersion. Add `VITE_DISCORD_SERVER_ID` + `VITE_DISCORD_CHANNEL_ID` to env.

---

## 7. Migration

### Step 1 — Audit Thinkific Content

Before writing any migration scripts:
- Export from Thinkific: Settings → Export → Course content (CSV/JSON + video links)
- Document all courses, modules, lessons, lesson types, and video asset IDs
- Count total video hours (determines Mux cost estimate)
- Identify which courses are free vs. paid

### Step 2 — Seed Course Data Script

```ts
// scripts/seed-courses.ts
// Reads exported Thinkific JSON → inserts into Supabase
// courses, modules, lessons (without mux IDs yet — those come after video upload)
```

### Step 3 — Bulk Video Upload to Mux

```ts
// scripts/upload-videos.ts
// For each lesson with a video:
//   1. Download from Thinkific CDN URL
//   2. POST to Mux direct upload or Mux import URL
//   3. Poll until asset.ready
//   4. Update lesson row with mux_asset_id + mux_playback_id
// Run with concurrency limit (3–5 parallel) to avoid rate limits
```

This is the longest-running step. Estimate: 2–4 hours per 100 videos depending on size.

### Step 4 — User Migration

Thinkific has its own user database. Options:

**Option A (recommended):** Invite flow
- Export Thinkific user emails
- Script: for each email, call `supabase.auth.admin.inviteUserByEmail()`
- Supabase sends invite email → user sets password
- On signup, insert enrollment rows based on their Thinkific subscription status

**Option B:** Silent import
- Import email + hashed password (requires Thinkific to export bcrypt hashes — unlikely)
- Fallback: force password reset on first login

### Step 5 — Stripe Subscription Migration

Two paths — decide with WSBB:

**Path A (cleanest):** Let existing Thinkific subs expire naturally
- New subscribers go through the new platform immediately
- Old subscribers get an invite to the new platform, keep access until renewal
- On renewal date, they resubscribe via new Stripe checkout
- Zero Stripe migration complexity

**Path B:** Full migration
- Thinkific uses their own Stripe account — you'd need access to transfer subscriptions
- Complex, risky, only worth it if there are many long-cycle annual subs

### Step 6 — SEO Redirects

Map old Thinkific URLs → new URLs, add to `netlify.toml`:

```toml
[[redirects]]
  from = "/courses/conjugatemethodpowerlifting1"
  to = "/courses/conjugate-method-powerlifting"
  status = 301

# ... one per course
```

Also redirect `conjugateclub.com` → `westside-barbell.com/courses` (DNS + Netlify redirect).

---

## Netlify Functions Summary

| Function | Purpose |
|----------|---------|
| `stripe-webhook.mts` | Handle Stripe subscription events → update enrollments |
| `mux-webhook.mts` | Handle Mux asset ready → update lesson with playback ID |
| `mux-upload-url.mts` | Generate Mux direct upload URL (admin only) |
| `enroll-free.mts` | Enroll authenticated user in a free course |
| `stripe-portal.mts` | Create Stripe billing portal session |

Thin wrappers → logic in `server/courses/`, `server/mux/`, `server/stripe/`

---

## New Vue Files Summary

```
src/
  pages/
    courses/
      index.vue               # /courses — catalog
      [slug]/
        index.vue             # /courses/:slug — landing page
        learn/
          [lessonId].vue      # /courses/:slug/learn/:lessonId — player
  components/
    courses/
      CourseCard.vue
      CoursePlayer.vue
      LessonSidebar.vue
      LessonRenderer.vue      # switches on lesson.type
      MuxVideoPlayer.vue
      ProgressBar.vue
      DiscordEmbed.vue
  stores/
    course.ts                 # useCourseStore
    progress.ts               # useProgressStore
    player.ts                 # usePlayerStore
  composables/
    useAccess.ts              # enrollment gate
```

---

## Open Questions Before Starting

1. **Domain:** Does Conjugate Club stay at `conjugateclub.com` long-term, or does everything move to `westside-barbell.com/courses`?
2. **Stripe account:** Is WSBB's Stripe account the same one already wired to nitro.ai, or is it a separate Conjugate Club account?
3. **Free course access:** Do free courses require a Supabase account (email signup), or truly public?
4. **Thinkific export:** Do you have admin access to Thinkific to pull the export?
5. **Video volume:** Rough estimate on total video hours across all 8 courses?

---

## Suggested Build Order

1. Supabase migrations (schema + RLS)
2. Stripe webhook function + `useAccess` composable
3. Mux setup + upload URL function + webhook
4. Seed script (course data into Supabase)
5. Course catalog page + store
6. Course player page + stores
7. Video upload migration script
8. User invite migration script
9. Netlify redirects
10. Discord embed
11. QA: enrollment flow end-to-end, video playback, progress tracking
