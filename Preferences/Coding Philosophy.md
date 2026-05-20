---
type: preference
tags: [digi-twin, preference]
owner: Mike
updated: 2026-05-20
status: current
---

# Coding Philosophy

Extends [[Preferences/AI Behavior|Simplicity First]] with Mike's engineering values.

## DRY — but not at all costs

Prefer Don't Repeat Yourself, but **a bad abstraction is worse than repeated code**. Extract when:

- The pattern appears 3+ times with the same shape
- The abstraction has a clear, stable name and boundary
- It reduces total complexity, not just line count

Don't extract "just in case" or for a single use.

## Boy scout rule

Leave code better than you found it — but **only in files you touched for the task**. Examples of acceptable cleanup in your diff:

- Remove imports your changes made unused
- Fix a typo in a comment you edited
- Add a missing type to a function you modified

Not acceptable: reformatting unrelated files, renaming variables in untouched modules, deleting dead code you noticed elsewhere.

## Tight contracts

Prefer explicit FE/BE contracts. Share types where possible. Use contemporary tools (Kysely, Zod schemas on API boundaries) to keep both sides honest.

See [[Patterns/Type Sharing]].

## Match the stack — then the project

1. Detect stack via [[Stacks/Index]] and load the matching profile
2. Read project-local `.prettierrc`, `eslint.config.*`, `tsconfig.json`
3. **Project config wins** when it conflicts with stack defaults or Mike's greenfield prefs

Examples of stack-level differences:
- [[Stacks/Shopify App]]: double-quote Prettier, 120 cols
- [[Stacks/Vue Serverless]]: no semicolons, 100 cols
- [[Stacks/Bun Monolith]]: strict TS, semicolons, 80 cols

## Related

- [[Preferences/Frontend Conventions]]
- [[Preferences/Backend Conventions]]
