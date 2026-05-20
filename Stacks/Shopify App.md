---
type: stack
tags: [digi-twin, stack, shopify, next]
owner: Mike
updated: 2026-05-20
status: current
---

# Shopify App

Embedded Shopify app — Next.js frontend, Koa backend, often with extension sub-projects.

## Detection

- `@shopify/app`, `@shopify/polaris`, or `@shopify/shopify-app-*` in dependencies
- Next.js pages router + Koa server in same package
- May have `extensions/` folder for theme/POS/checkout UI

## Typical structure

```
web/                    # Main app package
  pages/                # Next.js file-based routes
  components/           # Polaris UI — Folder/Component pattern
  hooks/
  server/               # Koa API, services, handlers, database-layer
    handlers/
    services/
    database-layer/
    processors/         # async jobs (BullMQ)
  graphql/generated/    # Shopify Admin GraphQL codegen
  prisma/schema.prisma
extensions/             # Svelte, React POS, checkout UI
db/migrations/          # dbmate SQL migrations
```

## Conventions

| Area | Convention |
|------|------------|
| Runtime | Node |
| UI | **Shopify Polaris** + App Bridge — don't introduce other design systems |
| State | SWR via authenticated fetch hooks; React Context for shop data |
| Type sharing | No shared package; Knex models in `database-layer/models/`; GraphQL codegen for Shopify |
| ORM | **Knex** for queries; **Prisma** client registered; **dbmate** for migrations (source of truth) |
| DI | Inversify — `@injectable()`, `@inject()`, `reflect-metadata` |
| Lint/format | Prettier: **double quotes**, 120 cols, import sorting plugin |
| ESLint | `next/core-web-vitals` + `@typescript-eslint`; `no-console` error |
| Husky | pre-commit runs lint + test |
| Layering | handlers → services → database-layer repos → processors |
| Package manager | npm |

## When building new features

- Follow Polaris component patterns — check existing `components/` for Folder/Component structure
- Add dbmate migrations in `db/migrations/`, not Prisma migrate
- Use existing Inversify container registration pattern
- GraphQL types from codegen — don't hand-write Shopify API types
- **Do not apply greenfield Prettier defaults** — this stack uses double quotes and 120 cols

## Related

- [[Preferences/Frontend Conventions]]
- [[Patterns/Runtime Choices]]
