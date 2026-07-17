---
type: preference
tags: [digi-twin, preference, tooling]
owner: Mike
updated: 2026-07-16
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
| Yarn (usually — match the project's lockfile) | [[Stacks/Vue Serverless]] |
| npm | [[Stacks/Express Monolith]], [[Stacks/Shopify App]] |

## Tab size

2 spaces everywhere.

## Claude Code status line

Custom status line showing model, cwd, git branch + dirty state, a color-coded context-window bar, session cost, and lines changed:

```
⚡ Fable 5 │ digi-twin │ ⎇ master ✗ │ ████░░░░░░ 42% │ $1.23 │ +120/-45
```

- Source of truth: `scripts/claude-statusline.sh`
- Install on a new machine: `bash scripts/setup-claude-statusline.sh` (needs `jq`; backs up and merges into `~/.claude/settings.json`)
- After editing the local copy (`~/.claude/statusline.sh`), copy changes back to `scripts/claude-statusline.sh` so other machines pick them up.

## Related

- [[Preferences/Coding Philosophy]] — match the project when conventions differ
