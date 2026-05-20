---
type: stack
tags: [digi-twin, stack, index]
owner: Mike
updated: 2026-05-20
status: current
---

# Stack Index

Decision tree for detecting which stack profile applies to the **open project**. Read `package.json` and lockfiles, then load the matching profile from `Stacks/`.

## Detection order

Apply the **first match**. If AI deps are present, also load [[Stacks/AI Agent App]] as an overlay.

```
1. @shopify/app OR @shopify/polaris in deps?
   → Shopify App

2. vue + pinia + (netlify-cli OR @netlify/functions OR vercel)?
   → Vue Serverless

3. bun.lock + react?
   → Bun Monolith

4. express + (vite OR react) + kysely?
   → Express Monolith

5. express + vite + react (no kysely)?
   → Express Monolith

6. next + koa?
   → Shopify App (or Next + Koa legacy pattern)

7. ai OR @ai-sdk/* in deps (no other match)?
   → AI Agent App (+ read project structure for runtime)

8. No clear match?
   → Preferences/* only + read project's .prettierrc, tsconfig.json
```

## Stack profiles

| Profile | Detection signals | Doc |
|---------|-------------------|-----|
| Bun Monolith | `bun.lock` + React + single-server | [[Stacks/Bun Monolith]] |
| Vue Serverless | Vue 3 + Pinia + serverless deploy | [[Stacks/Vue Serverless]] |
| Express Monolith | Vite + Express (+ Kysely) | [[Stacks/Express Monolith]] |
| Shopify App | `@shopify/app`, Polaris, Next + Koa | [[Stacks/Shopify App]] |
| AI Agent App | `ai`, `@ai-sdk/*` (overlay) | [[Stacks/AI Agent App]] |

## Fallback rule

When stack profile and **project-local config** conflict, **project wins**. Always read `.prettierrc`, `eslint.config.*`, `tsconfig.json` in the open project before applying defaults.

## Related

- [[Patterns/Runtime Choices]]
- [[Preferences/Editor & Tooling]]
