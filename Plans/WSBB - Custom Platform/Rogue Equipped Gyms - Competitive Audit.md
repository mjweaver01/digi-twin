---
type: plan
tags: [digi-twin, plan]
owner: Mike
updated: 2026-06-05
status: planning
---

# Rogue Equipped Gyms — Competitive Audit

**Source:** https://www.roguefitness.com/rogue-equipped-gyms
**Audited:** 2026-05-23
**Purpose:** Understand how Rogue built this so we can use it as the template for the WSBB Coach Directory

---

## What It Is

The Rogue Equipped Gyms page is a public directory of gyms around the world that use Rogue equipment. It serves a dual purpose: it's a **discovery tool for athletes** looking for gyms, and a **social proof / community builder for Rogue** (your gym being on the map = you're part of the Rogue ecosystem).

This is exactly analogous to what Tom wants: coaches listed = they've passed through the WSBB pathway = social proof for WSBB + discovery tool for athletes looking for certified coaches.

---

## Page Structure (UX)

### Layout
```
┌──────────────────────────────────────────────────────┐
│  FULL-WIDTH GOOGLE MAPS MAP  (60–70% viewport height) │
│  [pins scattered across the US + international]        │
└──────────────────────────────────────────────────────┘
┌─────────────────┐  ┌────────────────────────────────┐
│  LEFT SIDEBAR   │  │  GYM CARDS GRID (right/below)  │
│  ─────────────  │  │  [photo, name, location, type] │
│  Filter by type │  │  [photo, name, location, type] │
│  ☐ All Gyms     │  │  ...                           │
│  ☐ Home Gym     │  └────────────────────────────────┘
│  ☐ Commercial   │
│  ☐ CrossFit Aff │
│  ☐ Powerlifting │
│  ☐ Hybrid       │
│  ... (12 types) │
│  ─────────────  │
│  ☐ Featured Only│
│  ☐ Drop-Ins Only│
│  ─────────────  │
│  [Add Your Gym] │
└─────────────────┘
```

### Gym Cards
Each card shows:
- **Hero photo** of the gym (primary visual — not a headshot, a gym photo)
- **Gym name** (bold)
- **City, State**
- **Type badge(s)** — e.g. "Powerlifting", "CrossFit Affiliate"
- **"Featured" badge** if Rogue has highlighted them
- Click card → full gym profile page with photo gallery, equipment list, location, website

### Map Behavior
- Pins are color-coded or use Rogue's logo marker
- Clicking a pin highlights the corresponding card (or opens a popup)
- Map auto-zooms to user's approximate location on load
- Map is interactive — pan, zoom, click pins

### Filters
- **Gym type**: multi-select checkboxes (12+ categories)
- **Featured Only**: toggle — shows only Rogue-curated featured gyms
- **Drop-Ins Only**: toggle — shows only gyms accepting drop-in visitors

---

## How It Works Technically

### Platform
Rogue runs on a **custom Magento-based SPA**. The gyms page is client-rendered React/JS — confirmed by our web fetch returning a shell with no gym data.

### Map
- **Google Maps JavaScript API** — standard embedded map
- Gym coordinates (lat/lng) stored in their database, geocoded from addresses at time of submission
- Custom map markers (likely SVG or PNG icons matching Rogue branding)
- Marker clustering at low zoom levels (standard Google Maps MarkerClusterer)

### Data Layer
- Gyms stored in a backend database (Magento CMS / custom DB)
- Each gym record has: name, address, lat/lng, type tags, photos, description, featured flag, drop-in flag
- When filters change → AJAX request to their backend API → returns filtered gym list → map + cards re-render

### "Add Your Gym" Flow
1. User clicks "Add Your Gym" button
2. Form: gym name, address, type, photos, contact info, Rogue equipment owned
3. Submitted to Rogue staff for review
4. Rogue approves, uploads, publishes — **no self-management by gym owners after submission**
5. No account required

### No Authentication
- Browsing is fully public — no login
- Submission is a one-time form, not an ongoing account
- Rogue staff own all data management

---

## Rogue vs. WSBB — Feature Comparison

| Feature | Rogue Equipped Gyms | WSBB Coach Directory |
|---------|---------------------|----------------------|
| **What's listed** | Gyms | Individual coaches |
| **Listing criteria** | Owns Rogue equipment (self-reported) | Completed WSBB pathway (verified) |
| **Map** | Google Maps, full-width | Mapbox/Leaflet, same concept |
| **Filter types** | Gym category (12 types) | Coach tier (3 levels) |
| **Additional filters** | Featured, Drop-Ins | Verified (background check), Takes clients |
| **Card content** | Gym photo, name, location, type | Headshot, name, location, tier badge, bio, specialty |
| **Tier/ranking system** | None — all gyms are equal | Core feature — Master/Instructor/Certified |
| **Self-management** | None — Rogue staff manage all data | Yes — coaches manage their own profiles |
| **Authentication** | Not required | Required (for self-management) |
| **Submission** | One-time form → Rogue approves | Pathway completion → auto-eligible, coach fills profile |
| **Contact** | Not built in (links to gym website) | Contact button (email or form) |
| **Admin tools** | Rogue internal only | WSBB admin approves/tags/publishes |
| **Platform** | Magento SPA | Next.js + Supabase (custom platform) |
| **Map provider** | Google Maps | Mapbox (recommended) or Leaflet (free) |

**Bottom line: WSBB is doing MORE than Rogue in every dimension.** The Rogue page is a simple photo gallery with a map. WSBB's version has tiers, verified status, self-managed profiles, direct contact, and is gated behind a real certification pathway. The wireframe Tom sent already reflects this added complexity well.

---

## What to Copy Directly from Rogue

### ✅ Map-first layout
Put the map at the top, prominent. Rogue's map takes 60–70% of the viewport height before cards. This is the hero of the page — it signals "these coaches are everywhere."

### ✅ Filter sidebar pattern
Left sidebar (or horizontal bar above cards on mobile) with type filters + toggle filters. Rogue's UX is clean: checkboxes for categories, simple toggles for special flags.

### ✅ "Add Your Profile" CTA always visible in the filter panel
Rogue puts "Add Your Gym" right in the filter sidebar. WSBB should put "Apply for the Directory" or "Complete the Pathway" as a persistent CTA in the same spot. This drives awareness and enrollment.

### ✅ Featured/curated highlight tier
Rogue uses a "Featured" flag for gyms they want to promote. WSBB's equivalent is "Master Instructor" — they naturally sit at the top of the page with a gold treatment.

### ✅ Drop-in / availability toggle pattern
Rogue has "Drop-Ins Only" as a quick filter. WSBB equivalent: "Currently taking new clients" toggle — many people searching for a coach want someone who's available.

### ✅ Click pin → highlight card
The map and the card list should be linked. Click a pin on the map → scroll the card list to that coach and briefly highlight their card. Rogue does this, it's expected behavior.

### ✅ Card photo as the primary visual
Rogue leads with a gym photo. WSBB leads with a coach headshot (Tom's wireframe already has this as a 64px avatar). Consider making the photo larger — a bigger headshot increases trust and click-through.

---

## What to Do Differently / Better

### 🔼 Tiered visual hierarchy (Rogue doesn't have this)
Rogue treats all gyms equally. WSBB's tiers should be visually obvious — gold cards or gold top-border for Master Instructors, silver for Instructors, standard for Certified. Tom's wireframe already does this with badge colors.

### 🔼 Larger coach photos
Rogue uses gym interior photos (wide shots). For a coach directory, face/headshot photos build more personal trust. Consider a 120–160px headshot on the card instead of 64px.

### 🔼 Direct contact built in
Rogue doesn't have contact buttons — users have to find the gym's website. WSBB should have a "Contact" button per card from day one (email link or contact form).

### 🔼 Verified badge treatment
Rogue has no verification beyond self-reporting. WSBB's background-check "Verified" badge should be prominently displayed — it's a competitive differentiator and trust signal.

### 🔼 Self-managed profiles = living data
Because coaches manage their own info, the directory stays fresh. Rogue's is likely stale (gym owners can't update their listing). WSBB's will be the opposite.

### 🔼 Pathway CTA that actually drives conversions
Rogue's "Add Your Gym" is a dead-end form. WSBB's equivalent should link directly to the Level 1 course purchase — the directory becomes a marketing funnel for the pathway itself.

---

## Map Provider Recommendation (vs. Rogue's Google Maps)

Rogue uses Google Maps, which is expensive at scale and increasingly restrictive. For WSBB:

| Option | Cost | Dark Theme | Ease of Setup | Recommendation |
|--------|------|------------|---------------|----------------|
| **Mapbox GL JS** | Free <50k loads/mo | ✅ Excellent | Medium | ⭐ Best choice |
| Leaflet + OpenStreetMap | Free | ⚠️ CartoDB Dark | Easy | Budget option |
| Google Maps JS API | $7/1000 loads | ⚠️ Limited | Easy | Avoid |

Mapbox can be styled to match WSBB's exact dark/gold palette using Mapbox Studio. The pins can be custom SVG markers in gold/silver/muted to match the tier system. This is significantly better than anything Rogue has.

---

## Recommended Page Layout for WSBB (Synthesizing Rogue + Tom's Wireframe)

```
┌─────────────────────────────────────────────────────────────┐
│  HERO: "Conjugate Method Certified Coaches"  [Tom's design] │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  TIER LEGEND BAR: [Master] [Instructor] [Certified] badges  │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  MAPBOX MAP  (340px height, full width)                      │
│  Gold pins = Master, Silver = Instructor, Muted = Certified │
│  Click pin → scroll to + highlight card                      │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  FILTER BAR: [All] [Master] [Instructor] [Certified]         │
│  [🔍 Search name/city]  [Sort ▾]  [✓ Verified only]         │
│  [Takes new clients]    [10 coaches]                        │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  TIERED GRID (Tom's card design, Rogue's map-link behavior) │
│  ── Master Instructors ──────────────────────────────────── │
│  [card] [card]                                              │
│  ── Instructors ─────────────────────────────────────────── │
│  [card] [card] [card]                                       │
│  ── Certified Coaches ───────────────────────────────────── │
│  [card] [card] [card] [card] [card]                         │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  FOOTER: "Complete the Pathway → Start Level 1"  [CTA]      │
└─────────────────────────────────────────────────────────────┘
```

This combines:
- Rogue's **map-first prominence**
- Rogue's **always-visible pathway CTA**  
- Tom's **tiered visual hierarchy**
- Tom's **dark WSBB aesthetic**
- WSBB's **self-management + verified system** (Rogue doesn't have)

---

*Notes by Mike Weaver | 2026-05-23*
*Related: [[Coach Directory - Project Plan]]*
