---
type: preference
tags: [digi-twin, preference, ai, review]
owner: Mike
updated: 2026-05-20
status: current
---

# Code Review with AI

How Mike uses AI as a dev tool without shipping code he hasn't owned. Complements [[Preferences/AI Behavior]] (agent behavior) with **review discipline** (Mike's gate before merge).

AI proposes; Mike decides. Passing tests is necessary, not sufficient — Mike must understand what changed and why.

## Git — Mike owns it

**Never run `git commit`** (or create commits) unless Mike explicitly asks in that message.

- OK: `git status`, `git diff`, `git log` — read-only inspection to help review
- Not OK: commit, amend, push, merge, rebase, tag — unless Mike explicitly requests that exact action

Mike stages and commits after reviewing the diff. Suggest a commit message if helpful; don't execute it.

## Agent obligations (every non-trivial task)

End with a **review handoff**, not "done" or "ready to merge":

1. **Summary** — what changed and why (not only a file list)
2. **How to verify** — exact commands (`test`, `lint`, `build`) and any manual checks
3. **Assumptions & risks** — what was guessed, not verified, or could break in prod
4. **Diff scope** — call out anything beyond what was asked

Do not imply the work is safe to ship. Propose; Mike reviews.

## Mike's obligations (before ship)

- Read the **full diff**; reject hunks not requested
- **Run verification yourself** — don't trust agent-reported green checks alone
- Explain each major change in **one sentence**; if you can't, don't ship yet
- Prefer **smaller PRs** when leaning on AI heavily — easier to review honestly

## Red flags — slow down

Extra scrutiny (agent should flag these proactively):

| Area | Examples |
|------|----------|
| Security & identity | Auth, sessions, tokens, permissions, API keys |
| Data & money | PII, payments, pricing, inventory, webhooks |
| Persistence | Migrations, schema changes, bulk updates |
| Dependencies | Major version bumps, new packages, lockfile churn |
| Size | Large diffs (~100+ lines or many files) without a checkpoint |

When speed conflicts with certainty on code teammates or users depend on, **certainty wins**.

## Review prompts (copy-paste)

- "Walk me through this diff hunk by hunk."
- "What could break in prod that tests wouldn't catch?"
- "What did you assume? What didn't you verify?"
- "Split this into a smaller change I can review in one pass."

## Checkpoint PRs

For multi-step or large work:

1. Agree on steps upfront
2. Ship reviewable chunks — one concern per PR when possible
3. Don't start step N+1 until step N is reviewed and merged (or explicitly accepted)

## Related

- [[Preferences/AI Behavior]]
- [[Preferences/AI Development]]
- [[Preferences/Coding Philosophy]]
- [[Karpathy/EXAMPLES]]
