---
type: context
tags: [digi-twin, guide]
owner: Mike
updated: 2026-05-20
status: current
---

# How to Use the Digital Twin

A practical guide for getting value from this vault in day-to-day development with Cursor and other AI tools.

## What this is

A **portable developer profile** — one place for who you are, how you code, how AI should behave, and conventions by tech stack. No per-repo `CLAUDE.md` or `.cursor/rules/` needed.

## The three layers

| Layer | Source | What it answers |
|-------|--------|-----------------|
| **1. How AI should behave** | [[Preferences/AI Behavior]], [[Preferences/Code Review with AI]], [[Karpathy/CLAUDE]] | Ask before assuming, surgical diffs, review before ship |
| **2. How you code** | `Preferences/*`, `Patterns/*` | State mgmt, type sharing, tooling defaults |
| **3. What shape this project is** | `Stacks/*` (detected from `package.json`) | Bun monolith vs Vue serverless vs Shopify app, etc. |

Layer 1 applies everywhere. Layer 3 is detected at runtime from the open project — not looked up by repo name.

## Will this help?

**Yes**, especially when context-switching between D2C/SaaS projects, AI agent builds, Shopify apps, and freelance greenfield work.

| Scenario | How it helps |
|----------|--------------|
| Open an old client repo | Agent detects stack and applies the right conventions (Polaris vs Pinia vs Kysely) instead of greenfield defaults |
| Start a new Bun freelance project | Loads [[Stacks/Bun Monolith]] — single server, strict TS, shared types |
| AI agent feature work | [[Stacks/AI Agent App]] overlay when `@ai-sdk/*` is present — tools, Langfuse, human-in-the-loop |
| Backend architecture outside TS | Agent asks clarifying questions first instead of silently designing a system |
| Reviewing agent diffs | [[Preferences/Code Review with AI]] — handoff format, red flags, checkpoint PRs |

**Less useful for:** one-off scripts, Shopify themes without `package.json`, legacy stacks that don't match a profile, or quick Q&A with no coding conventions.

## Best ways to use it

### 0. Obsidian MCP (automatic context)

See [[Obsidian MCP Setup]] for one-time install. Daily habit:

- Keep **digi-twin** open in Obsidian while coding in other repos
- Cursor MCP `obsidian-mcp-tools` must show green in Settings

The agent fetches prefs/stacks via MCP (`search_vault_smart`, `get_vault_file`) — no copying MD files into each project.

### 1. Let the User Skill do the work

Global skill: `~/.cursor/skills/mike-digital-twin/SKILL.md`

Cursor should activate it on your projects. For important tasks, nudge explicitly:

> Follow my digital twin — detect the stack and match project config.

### 2. Invoke the behavioral layer on non-trivial tasks

Karpathy principles matter most when work is ambiguous:

- "Add export for user data" → agent should ask scope/format first
- "Make search faster" → agent should present tradeoffs, not silently add caching

If the agent assumes or over-engineers, point it at [[Karpathy/EXAMPLES]].

### 3. Keep the vault living — patch from real sessions

Update notes when you discover a preference in practice:

- New convention for Express projects → edit [[Stacks/Express Monolith]]
- Changed default for greenfield Bun work → edit [[Stacks/Bun Monolith]]

Small, concrete additions beat long essays.

### 4. Name the stack when starting greenfield

Detection is automatic, but stating intent helps:

> New Bun monolith with AI agents — follow Bun Monolith + AI Agent App stacks.

### 5. Obsidian for you, MCP for the agent

Edit and browse in Obsidian. The agent pulls notes via **Obsidian MCP** while digi-twin is the open vault. Filesystem read is fallback only if MCP is down.

### 6. Review before you commit

Before merging AI-assisted work:

1. **Diff** — read full diff; reject out-of-scope hunks
2. **Verify** — run the agent's verify steps yourself (test, lint, manual checks)
3. **Explain** — one sentence per major change; if you can't explain it, don't ship

Use [[Preferences/Code Review with AI]] prompts when the diff is large or unfamiliar.

### 7. Back up the vault

Push to a private git remote. This is professional context worth preserving.

## Stack detection quick reference

See [[Stacks/Index]] for the full decision tree. Summary:

| Profile | Signals |
|---------|---------|
| [[Stacks/Shopify App]] | `@shopify/app`, Polaris, Next + Koa |
| [[Stacks/Vue Serverless]] | Vue 3 + Pinia + serverless |
| [[Stacks/Bun Monolith]] | `bun.lock` + React |
| [[Stacks/Express Monolith]] | Vite + Express (+ Kysely) |
| [[Stacks/AI Agent App]] | `ai`, `@ai-sdk/*` (overlay on any runtime) |

**Project config always wins** when it conflicts with stack defaults — read `.prettierrc`, `eslint.config.*`, `tsconfig.json` in the open project.

## Gaps to watch

- **Stack detection isn't perfect** — legacy Vue 2, Astro-only, theme-only repos may not match. Add profiles when you hit those patterns often.
- **Skill + MCP must both work** — Tier 1 is inlined in the skill; Tiers 2–3 need MCP (or filesystem fallback). Verify with `get_server_info` on a real task.
- **Wrong vault open** — MCP returns another Obsidian vault's notes. Keep digi-twin open.
- **Don't let it bloat** — concise notes, one concern per file. Layering is the strength, not volume.

## Fastest way to improve it

Pick one active project, run a non-trivial task with "follow my digital twin," and note what the agent got wrong. Update the matching stack profile or preference note. Repeat.

## Related

- [[README]] — folder guide and technical setup
- [[Obsidian MCP Setup]] — install and troubleshoot MCP
- [[Preferences/AI Behavior]] — behavioral contract
- [[Preferences/Code Review with AI]] — review discipline with AI
- [[Stacks/Index]] — stack detection rules
