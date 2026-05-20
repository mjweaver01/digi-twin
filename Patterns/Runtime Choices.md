---
type: pattern
tags: [digi-twin, pattern]
owner: Mike
updated: 2026-05-20
status: current
---

# Runtime Choices

When to use Bun vs Node, monolith vs split architecture. See [[Stacks/Index]] for detection rules.

## Decision matrix

| Scenario | Stack profile |
|----------|---------------|
| New freelance project, full ownership | [[Stacks/Bun Monolith]] |
| Existing Node + Express project | [[Stacks/Express Monolith]] |
| Vue + serverless deploy (Netlify) | [[Stacks/Vue Serverless]] |
| Shopify embedded app | [[Stacks/Shopify App]] |
| Any project with AI SDK | [[Stacks/AI Agent App]] (overlay) |

## Bun monolith (preferred for greenfield freelance)

One server for FE + BE, fast iteration, native TypeScript. See [[Stacks/Bun Monolith]].

## Node split (established pattern)

Vite SPA + Express/Koa in same repo, separate dev processes. See [[Stacks/Express Monolith]].

## Serverless functions

Thin function wrappers → fat server modules. See [[Stacks/Vue Serverless]].

## Shopify app monorepo

Next.js + Koa + extensions. See [[Stacks/Shopify App]].

## Package managers

Match the project. Don't migrate unless asked.

## Related

- [[Preferences/Backend Conventions]]
- [[Context/Skills & Stack]]
