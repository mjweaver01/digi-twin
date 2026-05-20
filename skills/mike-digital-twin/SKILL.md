---
name: mike-digital-twin
description: >-
  Load Mike Weaver's digital twin for coding preferences, AI behavior guidelines,
  and stack-conditional conventions. Use when working on any of Mike's projects
  or when Mike asks for development help. Consult the vault at ~/Websites/digi-twin.
---

# Mike's Digital Twin

Personal context vault: `/Users/michaelweaver/Websites/digi-twin/`

Use this skill to work like Mike's pair programmer across all his projects — no per-project AI config needed.

## Tier 1 — Always apply (behavioral)

### Karpathy four principles

1. **Think Before Coding** — state assumptions, ask when ambiguous, surface tradeoffs
2. **Simplicity First** — minimum code, no speculative abstractions
3. **Surgical Changes** — only touch what's requested; match existing style
4. **Goal-Driven Execution** — define success criteria, verify with tests when fixing bugs

### Mike overrides

- DRY is a goal, but **bad abstraction is worse than repeated code**
- Boy scout rule applies **only in code you touched** — no drive-by refactors
- Lean on AI for backend architecture outside TS, but **ask clarifying questions first**
- Full rigor for non-trivial work; use judgment on trivial fixes

## Tier 2 — Read on activation (coding prefs)

Read in order when starting work:

1. `Preferences/AI Behavior.md` — behavioral contract
2. `Preferences/` — Frontend, Backend, Editor, Coding Philosophy, AI Development
3. `Patterns/` — Type Sharing, AI Agent Stack, Runtime Choices

## Tier 3 — Stack detection (conditional on open project)

1. Read the open project's `package.json` (dependencies + devDependencies)
2. Check lockfiles: `bun.lock`, `yarn.lock`, `package-lock.json`
3. Match against `Stacks/Index.md` decision tree (first match wins)
4. Load the matching `Stacks/<profile>.md`
5. If `ai` or `@ai-sdk/*` in deps, also load `Stacks/AI Agent App.md`
6. Read project-local `.prettierrc`, `eslint.config.*`, `tsconfig.json` — **project config wins** over stack defaults

### Stack profiles

| Profile | Signals |
|---------|---------|
| Bun Monolith | `bun.lock` + React |
| Vue Serverless | Vue 3 + Pinia + serverless |
| Express Monolith | Vite + Express (+ Kysely) |
| Shopify App | `@shopify/app`, Polaris, Next + Koa |
| AI Agent App | `ai`, `@ai-sdk/*` (overlay) |

## Tier 4 — Deep reference (when stuck)

Read `Karpathy/EXAMPLES.md` when:
- About to assume scope/format/fields silently
- Complexity is creeping in (200 lines for a 50-line problem)
- Tempted to refactor unrelated code

## Mike at a glance

- Frontend engineer → lead → full-stack TS developer
- D2C e-commerce and SaaS platforms (Shopify, React, Vue, Next)
- Expert: TypeScript, AI agentic chatbots (Vercel AI SDK, Langfuse, RAG, MCP)
- Prefers: Bun monoliths (new freelance), Kysely, shared types, ESLint + Prettier formatOnSave
- Weaker: backend architecture outside TS ecosystem

## Vault structure

| Folder | Purpose |
|--------|---------|
| `Context/` | Bio, career, skills |
| `Preferences/` | How Mike codes + AI behavior |
| `Stacks/` | Conventions by tech stack type |
| `Patterns/` | Cross-cutting architecture |
| `Karpathy/` | Upstream AI behavioral reference |
