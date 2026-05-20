---
type: preference
tags: [digi-twin, preference, tooling]
owner: Mike
updated: 2026-05-20
status: current
---

# Editor & Tooling

## VSCode / Cursor settings

Mike prefers **ESLint and Prettier running automatically** via editor settings:

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  }
}
```

Apply per-language formatters for TypeScript, JavaScript, JSON, HTML, CSS, Markdown.

## Prettier defaults (Mike's greenfield preference)

| Setting | Value |
|---------|-------|
| `singleQuote` | `true` |
| `semi` | `true` |
| `printWidth` | `80` |
| `trailingComma` | `es5` |
| `arrowParens` | `avoid` |

**Stack overrides exist** — always check the project's `.prettierrc` before assuming defaults:

- [[Stacks/Vue Serverless]]: no semicolons, 100 cols
- [[Stacks/Shopify App]]: double quotes, 120 cols, import sorting plugin

## ESLint

- Use on new projects (flat config preferred — see [[Stacks/Express Monolith]])
- Some stacks ([[Stacks/Bun Monolith]], [[Stacks/Vue Serverless]]) rely on Prettier + TypeScript compiler only
- Don't add ESLint to a project that doesn't have it unless asked

## TypeScript

- **Strict mode** on new projects (`strict: true`, `noUncheckedIndexedAccess` when possible)
- Match existing tsconfig on brownfield — [[Stacks/Shopify App]] and [[Stacks/Vue Serverless]] are often looser

## Package managers

| Manager | Stack |
|---------|-------|
| Bun | [[Stacks/Bun Monolith]] |
| Yarn | [[Stacks/Vue Serverless]] |
| npm | [[Stacks/Express Monolith]], [[Stacks/Shopify App]] |

## Tab size

2 spaces everywhere.

## Related

- [[Preferences/Coding Philosophy]] — match the project when conventions differ
