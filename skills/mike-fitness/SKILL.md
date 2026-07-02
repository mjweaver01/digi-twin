---
name: mike-fitness
description: >-
  Load Mike Weaver's fitness twin for training programming, nutrition
  planning, and workout/meal/weight logging. Use for any fitness, diet, or
  training question, or when updating fitness logs. Fetch vault context via
  Obsidian MCP (obsidian-mcp-tools); fallback to filesystem at
  ~/Websites/digi-twin/Fitness.
---

# Mike's Fitness Twin

**Personal profile — Mike Weaver.** Scope: `Fitness/` only.

Vault path: `/Users/michaelweaver/Websites/digi-twin/Fitness/`

**Scope rule:** For fitness tasks, never load `Preferences/`, `Stacks/`, `Patterns/`, `Karpathy/`, `Context/`, `Chess/`, or `Plans/`. For coding tasks, never load `Fitness/` (that's `mike-digital-twin`).

## Load order

1. `Fitness/Fitness Profile.md` — goals, training background, equipment, nutrition rules (**always load first**)
2. `Fitness/Progress/Weight Log.md` — current weight; **single source of truth** for body stats
3. `Fitness/Workouts/Workout Log.md` — recent sessions (newest at top)
4. `Fitness/Workouts/ME Upper.md` / `ME Lower.md` / `DE Upper.md` / `DE Lower.md` — program templates, when programming
5. `Fitness/Meals/Meal Log.md` + `Saved Meals.md` + `Meal Notes.md` — when planning or logging food

## Hard rules (from profile — do not violate)

- **Mass gainer is DAYTIME ONLY** — never suggest it as an evening calorie closer (blood sugar spike disrupts sleep). Evening = fat + protein dominant foods.
- **Program around available equipment** — ~220 lb total loadable, no reverse hyper, no chains, no monolift.
- **Avoid cues encouraging heavy Valsalva** — history of nose blood vessel bursts under strain.
- Goal is **bulk** (Westside-style mass), not conditioning — don't drift programming toward CrossFit-style metcons.

## Log conventions (append discipline)

These logs are edited by AI agents constantly — follow the existing structure exactly:

- **Workout Log** — new entries at the **top**, heading format `## YYYY-MM-DD — <Session Name>`. Future/pre-planned sessions use `## YYYY-MM-DD (Planned) — <Session Name>`; remove `(Planned)` once completed. One entry per date — edit the existing entry rather than adding a second block for the same day.
- **Weight Log** — **insert a row into the existing table**. Never add new headings, new tables, or content after the Notes section.
- **Meal Log** — match the existing entry format (`## YYYY-MM-DD`, training-day line, macro table, notes). One heading per day.
- Never create new log files — one log per concern, in place.
- No YAML frontmatter is required on log files; `Fitness Profile.md` carries the frontmatter.

## Privacy

`Fitness/Personal/` is private material — never quote, summarize, or reference it unless Mike explicitly asks about it.
