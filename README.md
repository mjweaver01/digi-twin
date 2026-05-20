# digi-twin

Personal knowledge vault and **digital twin** for Mike Weaver — skills, coding preferences, stack-conditional patterns, and AI behavior guidelines. Used by Cursor across all projects without per-repo `CLAUDE.md` or `.cursor/rules/` files.

## Folder guide

| Folder | Purpose |
|--------|---------|
| [`Context/`](Context/) | Who Mike is — bio, career, skills |
| [`Preferences/`](Preferences/) | How Mike codes and how AI should behave |
| [`Stacks/`](Stacks/) | Conventions by tech stack type (detected at runtime) |
| [`Patterns/`](Patterns/) | Cross-cutting architectural patterns |
| [`Karpathy/`](Karpathy/) | Upstream AI behavioral reference (four principles + examples) |

## Context stack (for AI)

1. **How AI should behave** — [[Preferences/AI Behavior]], backed by [[Karpathy/CLAUDE]]
2. **How Mike codes** — `Preferences/*`, `Patterns/*`
3. **What shape this project is** — detect stack from open project's `package.json` → load `Stacks/<profile>.md`

## Stack detection

No repo catalog. When working in a project, AI reads `package.json` and matches against [[Stacks/Index]]. If `@ai-sdk/*` is present, also load [[Stacks/AI Agent App]].

Project-local config (`.prettierrc`, `tsconfig.json`) always wins over stack defaults.

## Cursor integration

Global User Skill at `~/.cursor/skills/mike-digital-twin/SKILL.md` loads this vault from any project.

When editing this vault itself, `.cursor/rules/karpathy-guidelines.mdc` applies the Karpathy behavioral guidelines.

## Obsidian

This is an Obsidian vault. Open the folder in Obsidian to browse and edit notes. `.obsidian/` is gitignored.
