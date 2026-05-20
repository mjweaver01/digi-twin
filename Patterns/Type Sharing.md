---
type: pattern
tags: [digi-twin, pattern]
owner: Mike
updated: 2026-05-20
status: current
---

# Type Sharing

Mike prefers sharing types between frontend and backend, although it can be difficult depending on project structure.

## Patterns by stack

### Dedicated types folder — [[Stacks/Bun Monolith]]

`src/types/` imported by both frontend and endpoints:

```
src/types/
  conversation.ts
  user.ts
  expert.ts
```

Single folder, relative imports. No code generation. Preferred for monoliths.

### Direct server imports — [[Stacks/Vue Serverless]]

Frontend imports constants/types directly from `server/`:

```typescript
import { models, defaultModel } from '../../server/constants';
```

Ambient types in `global.d.ts` for FE-only shapes.

### Split types — [[Stacks/Express Monolith]]

- `src/types.ts` — UI models
- `server/db/types` — Kysely-generated DB types
- `server/types/` — integration types

### No shared package — [[Stacks/Shopify App]]

Path aliases across Next + Koa but no shared types package. DB models in `database-layer/models/`, GraphQL codegen for Shopify types.

## Preferred approach (greenfield)

1. **Kysely** for DB types — generated from schema
2. **Zod schemas** at API boundaries — infer with `z.infer`
3. **`src/types/`** for DTOs consumed by both FE and BE in monoliths
4. Avoid duplicating interface definitions

## Related

- [[Preferences/Backend Conventions]]
- [[Preferences/Coding Philosophy]]
