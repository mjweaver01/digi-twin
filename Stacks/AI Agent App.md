---
type: stack
tags: [digi-twin, stack, ai]
owner: Mike
updated: 2026-05-20
status: current
---

# AI Agent App

Overlay profile for any project using the Vercel AI SDK. Combines with a runtime profile (Bun Monolith, Express Monolith, Vue Serverless).

## Detection

- `ai` or `@ai-sdk/react` or `@ai-sdk/openai` in dependencies
- Tool definitions, Langfuse config, or `/mcp` endpoint

## Core stack

| Layer | Tool |
|-------|------|
| Agent framework | Vercel AI SDK v6 — `streamText`, `generateText`, `tool()`, `useChat` |
| Providers | Multi-provider via `@ai-sdk/openai`, `@ai-sdk/anthropic`, etc. |
| Tool schemas | Zod + AI SDK `tool()` |
| Prompt management | Langfuse with push/pull sync scripts |
| Observability | Langfuse tracing + OpenTelemetry |
| External access | MCP server at `/mcp` |

## Agent patterns

| Pattern | When |
|---------|------|
| `ToolLoopAgent` | Multi-step agent with expert/model selection, step limits |
| `streamText` + tools | Streaming chat with tool calling loop |
| `useChat` | Frontend streaming state |
| `createTools(userId)` | Factory returning context-aware tool sets |

## Tool definition

```typescript
import { tool } from 'ai';
import { z } from 'zod';

export const searchKnowledge = tool({
  description: 'Search the knowledge base',
  parameters: z.object({ query: z.string() }),
  execute: async ({ query }) => { /* ... */ },
});
```

## RAG (when present)

1. Chunk documents
2. Generate embeddings → pgvector or custom vector store
3. Query with reranking
4. Inject context into system prompt

## Human-in-the-loop

External-write tools (publish, send email, modify external systems) use `needsApproval: true`.

## Prompt management

- Version prompts in repo (`constants/prompts/`, `langfuse/` dirs)
- Sync via CLI: `prompts:push`, `prompts:pull`, `prompts:sync`
- Don't hardcode long prompts inline in handlers

## When building AI features

- Read [[Patterns/AI Agent Stack]] for full architecture
- Add tools to `tools/` directory with Zod schemas
- Wrap chat handlers with Langfuse tracing
- Test tool loops with step limits to prevent runaway agents

## Related

- [[Preferences/AI Development]]
- [[Patterns/AI Agent Stack]]
- [[Preferences/AI Behavior]]
