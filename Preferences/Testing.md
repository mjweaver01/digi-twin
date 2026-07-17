---
type: preference
tags: [digi-twin, preference, testing]
owner: Mike
updated: 2026-07-16
status: draft
---

# Testing

> **Status: draft** — assembled from testing rules scattered across the vault plus proposed defaults. Mike: confirm the per-stack framework rows and delete this banner.

## Behavioral rules (already established elsewhere)

- **Bug fixes:** write a test that reproduces the bug, then make it pass ([[Preferences/AI Behavior]])
- **Validation work:** write tests for invalid inputs first, then make them pass ([[Preferences/AI Behavior]])
- Passing tests is **necessary, not sufficient** — Mike must understand what changed and why ([[Preferences/Code Review with AI]])
- AI agent tool loops: test with step limits to prevent runaway agents ([[Stacks/AI Agent App]])
- **Match the project** — if a repo already has a test setup, use it; don't introduce a second framework

## Framework by stack (proposed defaults — confirm)

| Stack | Runner | Notes |
|---|---|---|
| [[Stacks/Bun Monolith]] | `bun test` | Built-in — no extra dependency |
| [[Stacks/Vue Serverless]] | Vitest | Vite-native; `@vue/test-utils` for components |
| [[Stacks/Express Monolith]] | Vitest | Or match existing (often Jest on older repos) |
| [[Stacks/Shopify App]] | Match existing | Husky pre-commit already runs lint + test |

## Conventions (proposed — confirm)

- **Location:** colocate as `*.test.ts` next to the source file (or match the project's existing pattern)
- **Priority order:** shared logic and API boundaries first (Zod schemas, endpoint handlers, tool definitions) > UI components > glue code
- **Mocking:** mock external services at the boundary; don't mock what you own — refactor for testability instead
- **No coverage targets** — coverage follows the "write tests for the bug/behavior at hand" rule rather than a percentage
- Don't add a test framework to a project that has none unless asked ([[Preferences/Coding Philosophy]] — surgical changes)

## Related

- [[Preferences/AI Behavior]]
- [[Preferences/Code Review with AI]]
