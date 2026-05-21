# WSBB — Custom Platform Project Brief

**Client:** Westside Barbell (WSBB)
**Goal:** Replace Thinkific (Conjugate Club) + Drop-in Blog with a custom-built platform
**Base:** nitro.ai codebase
**Already in place:** Supabase (users/auth), Stripe (payments)
**Date:** 2026-05-21

---

## What We're Replacing

### Thinkific (conjugateclub.com)
- Course hosting and delivery (video, text, PDFs, audio)
- Membership/subscription access control
- Student progress tracking and completion
- Community Q&A and form checks
- Course catalog and landing pages
- Student management and enrollment
- Analytics

**Current courses in bundle:**
- Conjugate Method Powerlifting (Free)
- Conjugate Method for Olympic Weightlifting (Free)
- Conjugate Method for Strongman (Free)
- Louie Simmons Archive
- 8-Week Specialty Programming
- WSBB Exercise Index (Free)
- Resource Library
- Workouts

### Drop-in Blog
- Blog CMS (write, edit, publish)
- SEO tooling
- Categories/tags/authors
- RSS, sitemap
- Text-to-speech audio versions of posts

---

## Full Build Scope

### 1. Video Hosting — Biggest Infrastructure Piece
Thinkific handles video hosting/streaming. Need a dedicated solution:
- **Mux** (recommended) — great API, adaptive HLS, per-minute pricing, built-in analytics
- **Cloudflare Stream** — ~60% cheaper, solid
- **Bunny.net** — budget option, excellent CDN

Requires: upload pipeline, transcoding, HLS delivery, player integration (Mux Player / Plyr / Video.js). ~1–2 weeks of focused work.

### 2. Course/LMS Data Model (Supabase)
Key tables: `courses`, `modules`, `lessons`, `enrollments`, `lesson_progress`, `certificates`, `bundles`, `bundle_courses`

Lesson types: video, text, PDF, quiz, audio

### 3. Access Control (Stripe → Supabase)
- Webhook handlers: `subscription.created`, `subscription.cancelled`, `subscription.updated`, `invoice.payment_failed`
- Each event updates enrollment state in Supabase
- Middleware on course routes checks enrollment
- Free courses bypass check
- Stripe Customer Portal for self-serve billing

### 4. Student-Facing Course UI
- Course catalog / landing pages
- Course player: video player + lesson sidebar nav
- Progress tracking (mark complete, % done, resume where left off)
- Certificate generation on completion (Puppeteer or `pdf-lib`)

### 5. Admin / Instructor Dashboard
- Course builder: create/edit courses, modules, lessons; drag-and-drop reorder
- Video upload UI with progress indicator
- Student roster (enrollment + progress)
- Revenue + enrollment analytics
- Bulk email to enrolled students

### 6. Community Features
Conjugate Club has active Q&A and form checks (video submissions for staff feedback).
- **Fast path:** Embed Discord or use Circle.so, link from platform
- **Native path:** Threaded comments/Q&A per course in Supabase (Phase 2)
- Form checks (video uploads from members) = complex, treat as Phase 2+

### 7. Blog CMS (Drop-in Blog replacement)
**Admin:**
- Rich text editor (Tiptap recommended)
- Image upload to Supabase Storage or Cloudflare R2
- Draft/published/scheduled states
- Categories, tags, authors
- SEO fields (meta title, description, OG image)

**Public:**
- Blog index with pagination, post pages, category/tag pages
- Full-text search (Supabase `tsvector`)
- Auto-generated RSS feed and sitemap.xml
- Social sharing
- Text-to-speech (ElevenLabs API) — TBD priority

### 8. Migration
- Export Thinkific content (videos, text, quizzes, PDFs) — export is not clean, needs cleanup
- Re-upload all videos to new host (8+ courses, unknown hours of footage)
- Migrate blog posts from Drop-in Blog (formatting cleanup likely)
- Reconcile/migrate existing Thinkific users to Supabase auth
- Migrate or grandfather existing Stripe subscriptions (on Thinkific's Stripe account)
- SEO: 301 redirects from all old URLs — critical for WSBB's content authority

---

## What nitro.ai Already Provides
- Next.js with Supabase auth + Stripe wiring
- User dashboard shell
- AI chat functionality
- Deployment pipeline

---

## Phasing

| Phase | Focus | Key Deliverables |
|-------|-------|-----------------|
| 1 | Core LMS | Video hosting, DB schema, Stripe access control, course player UI, migrate users + content |
| 2 | Admin & Polish | Course builder admin, progress tracking, certificates, analytics |
| 3 | Blog | Blog CMS, public frontend, SEO, RSS/sitemap, migrate posts |
| 4 | Community | Native Q&A/discussion or Discord embed |
| 5 | Advanced | Drip scheduling, cohorts, mobile PWA, email automation, workout logging |

---

## Key Risks
- **Video migration volume** — unknown total hours of content to re-upload and transcode
- **Stripe subscription migration** — existing active subs on Thinkific's Stripe account need a clean handoff plan
- **User migration** — Thinkific user DB → Supabase auth reconciliation
- **SEO continuity** — URL structure changes must be handled carefully
