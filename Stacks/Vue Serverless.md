---
type: stack
tags: [digi-twin, stack, vue, serverless]
owner: Mike
updated: 2026-05-20
status: current
---

# Vue Serverless

Vue 3 SPA with Pinia state management and serverless backend (Netlify Functions or similar).

## Detection

- `vue` (^3.x) + `pinia` in dependencies
- `functions/` or `netlify.toml` or `@netlify/functions`
- Often `@supabase/supabase-js` for auth + database

## Typical structure

```
src/                    # Vue frontend
  pages/                # route-level views
  components/
  stores/               # Pinia stores
  styles/               # SCSS with global variables
server/                 # Shared backend logic (not deployed directly)
functions/              # Serverless entrypoints (*.mts)
global.d.ts             # ambient FE types
```

## Conventions

| Area | Convention |
|------|------------|
| Runtime | Node (Yarn or npm) |
| State | **Pinia** — options API stores with `state`/`getters`/`actions` |
| Type sharing | Direct imports from `server/` into frontend; ambient types in `global.d.ts` |
| Backend | Thin function wrappers → fat `server/` modules |
| Database | Supabase client (`.from('table').select(...)`) — no raw SQL layer |
| Styling | Global SCSS variables via Vite `@use` injection |
| Lint/format | Prettier: **no semicolons**, 100 cols, single quotes |
| TypeScript | Looser tsconfig — match existing, don't tighten unless asked |
| Alias | `@/` → `src/` (frontend only) |
| Package manager | Often Yarn |

## Pinia patterns

- One store per domain (messages, user, conversations, etc.)
- Cross-store getters via store factory calls
- `mapStores` in components; router injected via Pinia plugin

## When building new features

- Add store actions before wiring UI
- Put backend logic in `server/`, expose via thin `functions/` wrapper
- Import shared constants from `server/constants/` — don't duplicate on frontend

## Related

- [[Stacks/AI Agent App]] — common combo for chatbot products
- [[Patterns/Type Sharing]]
