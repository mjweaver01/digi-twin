---
type: stack
tags: [digi-twin, stack, bun, react]
owner: Mike
updated: 2026-07-16
status: current
---

# Bun Monolith

Single Bun process serves React SPA + REST API. Mike's preferred pattern for **new freelance greenfield** work.

## Detection

- `bun.lock` present (`bun.lockb` only on legacy pre-Bun-1.2 projects)
- `react` in dependencies
- Single entry: `src/index.ts` with `Bun.serve`, or monolithic `src/` layout

## Typical structure

```
src/
  index.ts          # Bun.serve entry + route table
  endpoints/        # HTTP handlers — export { GET, POST }
  frontend/         # React SPA (pages, components, hooks, contexts)
  types/            # Shared TS types (FE + BE)
  db/               # connection, schema.sql, migrations/
  tools/            # AI tool definitions (if agent app)
  utils/
```

## Conventions

| Area | Convention |
|------|------------|
| Runtime | Bun — `bun run`, `bun test` |
| TypeScript | Strict (`noUncheckedIndexedAccess`, `verbatimModuleSyntax`) |
| Type sharing | Dedicated `src/types/` — preferred pattern |
| State | React Context + hooks + AI SDK `useChat` for chat |
| Endpoints | Export handler objects `{ GET, POST }`; central routes map |
| Database | Raw `pg` + SQL migrations, or Kysely if added |
| Lint/format | Prettier: semicolons, 80 cols, single quotes |
| Package manager | Bun |

## VSCode settings

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

## When building new features

- Add shared types to `src/types/` first
- Wire endpoints in central route table in `index.ts`
- Match existing endpoint handler pattern
- Don't split into separate FE/BE processes unless asked

## Related

- [[Stacks/AI Agent App]] — if `@ai-sdk/*` present
- [[Patterns/Type Sharing]]
- [[Stacks/Index]]
