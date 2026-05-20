---
type: stack
tags: [digi-twin, stack, express, vite, react]
owner: Mike
updated: 2026-05-20
status: current
---

# Express Monolith

Vite React SPA with Express API in the same repo. Separate dev processes, Vite proxies to backend.

## Detection

- `vite` + `react` + `express` in dependencies
- `src/` (frontend) + `server/` (backend) layout
- Often `kysely` for database access

## Typical structure

```
src/              # Vite SPA (components/, hooks/, lib/)
server/           # Express API
  endpoints/      # route handlers
  tools/          # AI tools (if agent app)
  db/             # Kysely schema, migrations, types
  middleware/
  types/
scripts/          # seed, prompt sync
```

Dev: Vite proxies `/api` and `/uploads` to Express in `vite.config.ts`.

## Conventions

| Area | Convention |
|------|------------|
| Runtime | Node + `tsx` for dev |
| Type sharing | Split: `src/types.ts` (UI), `server/db/types` (Kysely), `server/types/` (integrations) |
| State | AI SDK `useChat` for chat; local `useState` elsewhere; no global store unless needed |
| ORM | **Kysely** — type-safe SQL, shared DDL for SQLite (local) + Postgres (prod) |
| Lint/format | ESLint flat config + Prettier; semicolons, 80 cols, single quotes |
| VSCode | formatOnSave + ESLint fix on save |
| Path alias | `@/*` → `src/*` |
| Components | shadcn in `ui/`, domain in `components/`, AI UI in `ai-elements/` |
| Package manager | npm |

## When building new features

- Add Kysely migrations in `server/db/schema.ts`
- New API routes in `server/endpoints/`
- Keep UI types in `src/types.ts`, DB types from Kysely codegen
- Zod validation at API boundaries

## Related

- [[Stacks/AI Agent App]] — common for copywriter/agent tools
- [[Patterns/Type Sharing]]
- [[Preferences/Backend Conventions]]
