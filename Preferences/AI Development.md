---
type: preference
tags: [digi-twin, preference, ai]
owner: Mike
updated: 2026-05-20
status: current
---

# AI Development

Mike has extensive experience building **AI agentic chatbots and workflows**. Load [[Stacks/AI Agent App]] when the open project has AI SDK dependencies.

## When to use AI in a project

- Conversational interfaces with tool calling
- RAG over domain knowledge bases
- Content generation with human-in-the-loop approval
- Prompt-managed features synced to Langfuse

## Standard stack

See [[Patterns/AI Agent Stack]] and [[Stacks/AI Agent App]].

## Tool design patterns

- Zod schemas define tool inputs
- Factory functions: `createTools(userId)` return context-aware tool sets
- External-write tools use `needsApproval` for human-in-the-loop
- Admin-only tools gated by role checks

## Prompt management

- Version prompts in repo, sync to Langfuse via CLI scripts
- Don't hardcode long prompts inline in handler code

## Agents vs simple completion

| Use agents (tool loops) when | Use simple completion when |
|------------------------------|----------------------------|
| User needs to query data, take actions | Single-shot text generation |
| Multi-step reasoning required | Formatting or summarization |
| External integrations involved | No tools needed |

## Related

- [[Preferences/AI Behavior]]
- [[Stacks/AI Agent App]]
- [[Patterns/AI Agent Stack]]
