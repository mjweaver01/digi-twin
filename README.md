# digi-twin

Personal knowledge vault and **digital twin** for AI-assisted development — skills, coding preferences, stack-conditional patterns, and behavioral guidelines for Cursor and other AI tools.

Works across all projects without per-repo `CLAUDE.md` or `.cursor/rules/` files.

**Getting started:** [How to Use the Digital Twin](Notes/How%20to%20Use%20the%20Digital%20Twin.md)

## Folder guide

| Folder | Purpose |
|--------|---------|
| [Context/](Context/) | Bio, career, skills |
| [Preferences/](Preferences/) | Coding preferences and AI behavior |
| [Stacks/](Stacks/) | Conventions by tech stack (detected at runtime) |
| [Patterns/](Patterns/) | Cross-cutting architectural patterns |
| [Notes/](Notes/) | Guides and operational notes |
| [Karpathy/](Karpathy/) | AI behavioral reference ([upstream source](https://github.com/forrestchang/andrej-karpathy-skills)) |

## Context stack

1. **How AI should behave** — [Preferences/AI Behavior](Preferences/AI%20Behavior.md), backed by [Karpathy/CLAUDE](Karpathy/CLAUDE.md)
2. **How I code** — `Preferences/*`, `Patterns/*`
3. **What shape this project is** — detect stack from the open project's `package.json` → load `Stacks/<profile>.md`

## Stack detection

No repo catalog. When working in a project, AI reads `package.json` and matches against [Stacks/Index](Stacks/Index.md). If `@ai-sdk/*` is present, also load [Stacks/AI Agent App](Stacks/AI%20Agent%20App.md).

Project-local config (`.prettierrc`, `tsconfig.json`) always wins over stack defaults.

## Setup

```bash
git clone <your-repo-url> ~/Websites/digi-twin
mkdir -p ~/.cursor/skills/mike-digital-twin
cp skills/mike-digital-twin/SKILL.md ~/.cursor/skills/mike-digital-twin/
```

If you clone elsewhere, update the vault path in `SKILL.md`.

Optional: open the folder in [Obsidian](https://obsidian.md) to browse and edit notes. `.obsidian/` is gitignored.

## Cursor integration

- **Global User Skill** — [skills/mike-digital-twin/SKILL.md](skills/mike-digital-twin/SKILL.md) provides context from any project
- **Vault rules** — `.cursor/rules/karpathy-guidelines.mdc` applies when editing this repository

## Credits

Behavioral guidelines adapted from [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) by Forrest Chang, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.
