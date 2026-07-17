# Editing this vault

This repo needs no per-project AI config when it's the *context source* for other projects — but when editing **this vault itself**, follow the conventions in [.cursor/rules/vault-maintenance.mdc](.cursor/rules/vault-maintenance.mdc). Highlights:

- YAML frontmatter on notes: `type` / `tags` / `owner` / `updated` / `status` (log files exempt); bump `updated` on substantive edits. Blank-note template: [Templates/Note.md](Templates/Note.md)
- `Stacks/Index.md` is the canonical stack-detection order — changing it means updating the mirror tables in `skills/mike-digital-twin/SKILL.md` and `Notes/How to Use the Digital Twin.md`
- Personal domains (`Fitness/`, `Chess/`, `Homilies/`, `Plans/`) never mix into coding context
- Fitness logs: insert into existing structure, newest-first, templates stay at the bottom of the file — never append new headings or duplicate tables (conventions: `skills/mike-fitness/SKILL.md`)
- Don't duplicate `Karpathy/` content — link to it; don't edit vendored `Karpathy/` files
- **Mike owns Git** — never commit/push/stage; read-only git commands only
- **This repo is PUBLIC on GitHub** — nothing sensitive outside gitignored paths
- End non-trivial work with a review handoff (summary, verify steps, assumptions/risks) — never "ready to merge"
