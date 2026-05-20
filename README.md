# digi-twin

Personal knowledge vault and **digital twin** for AI-assisted development — skills, coding preferences, stack-conditional patterns, and behavioral guidelines for Cursor and other AI tools.

Works across all projects without per-repo `CLAUDE.md` or `.cursor/rules/` files.

**Getting started:** [How to Use the Digital Twin](Notes/How%20to%20Use%20the%20Digital%20Twin.md)  
**MCP setup:** [Obsidian MCP Setup](Notes/Obsidian%20MCP%20Setup.md)

## How context reaches Cursor

```text
Obsidian (digi-twin vault) ←→ MCP Tools + Local REST API
         ↑
Global ~/.cursor/mcp.json (obsidian-mcp-tools)
         ↑
Cursor Agent (any project) + mike-digital-twin User Skill
```

Keep **digi-twin** open in Obsidian while coding in other repos. The agent fetches notes via MCP; the skill defines what to load and how to detect stack from the open project.

## Folder guide

| Folder | Purpose |
|--------|---------|
| [Context/](Context/) | Bio, career, skills |
| [Preferences/](Preferences/) | Coding preferences and AI behavior |
| [Stacks/](Stacks/) | Conventions by tech stack (detected at runtime) |
| [Patterns/](Patterns/) | Cross-cutting architectural patterns |
| [Notes/](Notes/) | Guides and operational notes |
| [Karpathy/](Karpathy/) | AI behavioral reference ([upstream source](https://github.com/forrestchang/andrej-karpathy-skills)) |
| [.cursor/](.cursor/) | Cursor rules and MCP config example |
| [scripts/](scripts/) | Vault setup scripts |

## Context stack

1. **How AI should behave** — [Preferences/AI Behavior](Preferences/AI%20Behavior.md), backed by [Karpathy/CLAUDE](Karpathy/CLAUDE.md)
2. **How I code** — `Preferences/*`, `Patterns/*` (via Obsidian MCP)
3. **What shape this project is** — detect stack from the open project's `package.json` → load `Stacks/<profile>.md`

## Stack detection

No repo catalog. When working in a project, AI reads `package.json` and matches against [Stacks/Index](Stacks/Index.md). If `@ai-sdk/*` is present, also load [Stacks/AI Agent App](Stacks/AI%20Agent%20App.md).

Project-local config (`.prettierrc`, `tsconfig.json`) always wins over stack defaults.

## Setup

```bash
git clone <your-repo-url> ~/Websites/digi-twin
cd ~/Websites/digi-twin

# Obsidian plugins + MCP server binary
./scripts/setup-obsidian-mcp.sh

# Cursor User Skill
mkdir -p ~/.cursor/skills/mike-digital-twin
cp skills/mike-digital-twin/SKILL.md ~/.cursor/skills/mike-digital-twin/

# Cursor MCP — merge .cursor/mcp.json.example into ~/.cursor/mcp.json
# Use API key from Obsidian → Local REST API settings
```

Open the vault in [Obsidian](https://obsidian.md), enable plugins, restart MCP in Cursor Settings. Full steps: [Obsidian MCP Setup](Notes/Obsidian%20MCP%20Setup.md).

`.obsidian/` is gitignored (local plugins and workspace state).

## Cursor integration

- **Global User Skill** — [skills/mike-digital-twin/SKILL.md](skills/mike-digital-twin/SKILL.md) — policy and stack detection
- **Global MCP** — [.cursor/mcp.json.example](.cursor/mcp.json.example) — vault retrieval from any workspace
- **Vault rules** — `.cursor/rules/ai-behavior.mdc` (pointers to `Preferences/AI Behavior.md`); `vault-maintenance.mdc` for markdown edits

## Credits

Behavioral guidelines adapted from [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) by Forrest Chang, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.
