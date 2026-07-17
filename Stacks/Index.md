---
type: stack
tags: [digi-twin, stack, index]
owner: Mike
updated: 2026-07-16
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

4. express + (vite OR react)?
   → Express Monolith (kysely usually present, but optional)

5. next + koa?
   → Shopify App

6. ai OR @ai-sdk/* in deps (no other match)?
   → AI Agent App (+ read project structure for runtime)

7. No clear match?
   → Preferences/* only + read project's .prettierrc, tsconfig.json
```

## Stack profiles

In detection order:

| Profile | Detection signals | Doc |
|---------|-------------------|-----|
| Shopify App | `@shopify/app`, Polaris, Next + Koa | [[Stacks/Shopify App]] |
| Vue Serverless | Vue 3 + Pinia + serverless deploy | [[Stacks/Vue Serverless]] |
| Bun Monolith | `bun.lock` + React + single-server | [[Stacks/Bun Monolith]] |
| Express Monolith | Vite + Express (+ Kysely) | [[Stacks/Express Monolith]] |
| AI Agent App | `ai`, `@ai-sdk/*` (overlay) | [[Stacks/AI Agent App]] |

## Choosing a stack (greenfield)

Detection covers existing projects. For new work, pick by scenario:

| Scenario | Stack profile |
|----------|---------------|
| New freelance project, full ownership | [[Stacks/Bun Monolith]] |
| Existing Node + Express project | [[Stacks/Express Monolith]] |
| Vue + serverless deploy (Netlify) | [[Stacks/Vue Serverless]] |
| Shopify embedded app | [[Stacks/Shopify App]] |
| Any project with AI SDK | [[Stacks/AI Agent App]] (overlay) |

Package managers: match the project. Don't migrate unless asked.

## Fallback rule

When stack profile and **project-local config** conflict, **project wins**. Always read `.prettierrc`, `eslint.config.*`, `tsconfig.json` in the open project before applying defaults.

## Related

- [[Preferences/Editor & Tooling]]
- [[Preferences/Backend Conventions]]
