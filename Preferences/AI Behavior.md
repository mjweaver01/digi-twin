---
type: preference
tags: [digi-twin, preference, ai]
owner: Mike
updated: 2026-05-20
status: current
---

# AI Behavior

How AI assistants should behave when working with Mike. This note merges the [[Karpathy/CLAUDE|Karpathy four principles]] with Mike-specific overrides.

Full rationale: [[Karpathy/README]]. Anti-pattern examples: [[Karpathy/EXAMPLES]].

## The four principles

### 1. Think Before Coding

Don't assume. Don't hide confusion. Surface tradeoffs.

- State assumptions explicitly. If uncertain, **ask**.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

**Mike override:** I lean on AI for backend architecture, especially outside TypeScript — but still ask clarifying questions first. Don't silently design a whole system.

### 2. Simplicity First

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No error handling for impossible scenarios.
- If 200 lines could be 50, rewrite it.

**Mike override:** I prefer DRY code, but **a bad abstraction is worse than repeated code**. Don't extract until the pattern is proven.

### 3. Surgical Changes

Touch only what you must. Clean up only your own mess.

- Don't "improve" adjacent code, comments, or formatting.
- Match existing style, even if you'd do it differently.
- Mention unrelated dead code — don't delete it unless asked.

**Mike override:** I follow the **boy scout rule** (leave things better than you found them), but only in code I actually touched. No drive-by refactors.

### 4. Goal-Driven Execution

Define success criteria. Loop until verified.

- "Fix the bug" → write a test that reproduces it, then make it pass
- "Add validation" → write tests for invalid inputs, then make them pass
- For multi-step tasks, state a brief plan with verification steps

## Review partnership

Mike reviews every non-trivial AI-assisted change before ship. See [[Preferences/Code Review with AI]].

**Mike override:**

- AI output is **draft until Mike reviewed** — agents propose; Mike owns what merges
- Tests prove the agent's story, not that Mike understands the system
- When speed vs. certainty conflicts, **certainty wins** on production-impacting code
- Agents end non-trivial work with a **review handoff** (summary, verify steps, risks) — never "ready to merge"
- **Mike owns Git** — never `git commit` (or push/amend/merge/rebase) unless Mike explicitly asks; see [[Preferences/Code Review with AI]]

## When to read deeper reference

Before implementing non-trivial work, read this note. If the task is ambiguous or complexity is creeping in, read [[Karpathy/EXAMPLES]] — especially:

- Hidden assumptions (Section 1)
- Over-abstraction (Section 2)
- Drive-by refactors (Section 3)
- Missing verification loops (Section 4)

## Tradeoff

These guidelines bias toward **caution over speed**. For trivial fixes (typos, obvious one-liners), use judgment — not every change needs the full rigor.

## Related

- [[Preferences/Code Review with AI]]
- [[Preferences/Coding Philosophy]]
- [[Preferences/AI Development]]
