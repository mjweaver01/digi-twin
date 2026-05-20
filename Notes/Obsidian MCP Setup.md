---
type: context
tags: [digi-twin, guide, mcp, obsidian]
owner: Mike
updated: 2026-05-20
status: current
---

# Obsidian MCP Setup

Connect Cursor to this vault via **Obsidian MCP** so agents pull context automatically when developing in any other repo — no per-project `CLAUDE.md` files.

## Architecture

| Piece | Role |
|-------|------|
| **digi-twin vault** (Obsidian) | Knowledge base you edit |
| **Local REST API** plugin | Authenticated HTTP API to the open vault |
| **MCP Tools** plugin | MCP server binary + semantic search |
| **Global `~/.cursor/mcp.json`** | Cursor talks to MCP from every workspace |
| **`mike-digital-twin` User Skill** | Policy: what to load, stack detection, Karpathy rules |

**Critical habit:** keep the **digi-twin** vault open in Obsidian while coding elsewhere. MCP queries whichever vault Obsidian currently has open.

## One-time install

From the repo root:

```bash
chmod +x scripts/setup-obsidian-mcp.sh
./scripts/setup-obsidian-mcp.sh
```

Then in Obsidian (digi-twin vault):

1. **Settings → Community plugins** — enable **Local REST API** and **MCP Tools**
2. **Local REST API** — generate or copy the API key
3. Paste the key into `~/.cursor/mcp.json` (see `cursor/mcp.json.example` in this repo)

Copy the example MCP config:

```bash
# Merge into ~/.cursor/mcp.json — keep your existing OBSIDIAN_API_KEY
```

Point `command` at:

```text
/Users/michaelweaver/Websites/digi-twin/.obsidian/plugins/mcp-tools/bin/mcp-server
```

Restart **Cursor → Settings → MCP → obsidian-mcp-tools** until status is green.

Install the User Skill:

```bash
mkdir -p ~/.cursor/skills/mike-digital-twin
cp skills/mike-digital-twin/SKILL.md ~/.cursor/skills/mike-digital-twin/
```

## Verify

In any project (not necessarily digi-twin), ask the agent:

> Use Obsidian MCP: run get_server_info, then search_vault_smart for "AI Behavior" in Preferences.

Expected: MCP responds with vault content from this repo.

## Agent workflow (automatic)

When the User Skill activates on non-trivial dev work:

1. `get_server_info` — confirm MCP is up
2. `search_vault_smart` — find relevant prefs/stacks/patterns
3. `get_vault_file` — load matched notes (e.g. `Stacks/Bun Monolith.md`)
4. Read open project's `package.json` for stack detection
5. Read project `.prettierrc` / `tsconfig.json` (project config wins)

**Fallback:** if MCP is down, read files from `/Users/michaelweaver/Websites/digi-twin/`.

## MCP tools used most

| Tool | Use |
|------|-----|
| `get_server_info` | Health check |
| `search_vault_smart` | Semantic search with folder filters |
| `get_vault_file` | Load a specific note |
| `list_vault_files` | Browse `Stacks/`, `Preferences/` |

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| MCP errored in Cursor | Obsidian not running, or wrong vault open, or plugins disabled |
| Wrong content returned | Open **digi-twin** in Obsidian, not another vault |
| `command` not found | Re-run `./scripts/setup-obsidian-mcp.sh` |
| 401 / auth errors | Regenerate API key in Local REST API; update `mcp.json` |

## Related

- [[How to Use the Digital Twin]]
- [[README]]
- [[Preferences/AI Behavior]]
