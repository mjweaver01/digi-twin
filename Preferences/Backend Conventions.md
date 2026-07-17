---
type: preference
tags: [digi-twin, preference, backend]
owner: Mike
updated: 2026-05-20
status: current
---

# Backend Conventions

Universal defaults. Load the matching [[Stacks/Index|stack profile]] for project-specific patterns.

## Strengths and approach

Mike is a strong TypeScript developer but **not an expert in backend architecture**, especially outside the TS ecosystem. For backend design decisions:

- Ask clarifying questions before architecting
- Lean on AI for patterns in unfamiliar stacks
- Prefer proven, boring solutions over clever ones

## TypeScript backend by stack

| Stack | Pattern |
|-------|---------|
| [[Stacks/Bun Monolith]] | Bun.serve route handlers, raw pg or Kysely |
| [[Stacks/Express Monolith]] | Express endpoints, Kysely |
| [[Stacks/Vue Serverless]] | Thin Netlify functions → fat `server/` modules, Supabase |
| [[Stacks/Shopify App]] | Koa handlers, Knex + dbmate, Inversify DI |

## Database access

| Tool | Stack |
|------|-------|
| **Kysely** | Express Monolith (preferred for greenfield) |
| **Raw pg** | Bun Monolith (especially with pgvector/RAG) |
| **Supabase client** | Vue Serverless |
| **Knex + dbmate** | Shopify App |

Prefer Kysely on greenfield work. Use whatever the existing project uses on brownfield.

## API design

- Tight FE/BE contracts — share types where possible (see [[Patterns/Type Sharing]])
- Zod schemas at API boundaries for validation
- Auth patterns vary by stack — check the stack profile

## Related

- [[Stacks/Index]]
- [[Patterns/Type Sharing]]
