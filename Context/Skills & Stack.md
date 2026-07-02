---
type: context
tags: [digi-twin, context, skills]
owner: Mike
updated: 2026-07-02
status: current
---

# Skills & Stack

## Languages

| Language | Proficiency | Notes |
|----------|-------------|-------|
| TypeScript / JavaScript | Expert | Primary language; strict mode preferred on new projects |
| HTML / CSS | Expert | Tailwind, SCSS, CSS modules depending on project age |
| SQL | Working | Prefer type-safe query builders (Kysely) over raw SQL when possible |
| Python, Ruby, PHP | Familiar | Legacy/client work; lean on AI for architecture |

## Frontend frameworks

| Framework | Experience | Typical use |
|-----------|------------|-------------|
| React | Expert | React 18/19, hooks, Context, AI SDK `useChat` |
| Vue | Strong | Vue 3 + Pinia, Composition/Options API |
| Angular | Working | Earlier career; less common in recent projects |
| Next.js | Strong | Current stack at Govalo (pages router); also app router on newer work. Not my preferred framework but well-practiced. |

## Runtimes & tooling

| Tool | Preference |
|------|------------|
| **Bun** | Preferred for new freelance monoliths — single server for FE+BE, fast iteration |
| **Node** | Established projects, Netlify Functions, Shopify apps (Govalo) |
| **Vite** | Default FE bundler on greenfield projects |
| **ESLint + Prettier** | Prettier always (format on save); ESLint only on stacks that use it — see [[Preferences/Editor & Tooling]] |

## Backend & data

| Tool | When |
|------|------|
| **Kysely** | Preferred ORM/query builder — type-safe SQL, shared types with FE |
| **Supabase** | Auth + Postgres client ([[Stacks/Vue Serverless]]) |
| **Raw pg + pgvector** | When RAG/vector search is core ([[Stacks/Bun Monolith]]) |
| **Prisma** | Active at Govalo ([[Stacks/Shopify App]]); not my preferred ORM but well-practiced. Used alongside dbmate for migrations. |
| **BullMQ** | Async job queuing at Govalo ([[Stacks/Shopify App]]); Redis-backed, not my preferred pattern but familiar. |
| **Knex** | Legacy Shopify app queries ([[Stacks/Shopify App]]) |
| **Firebase** | Deprecated, in favor of Supabase when possible |

## E-commerce & platforms

Shopify (apps, themes, Admin API), Magento, WordPress, Stripe, custom MSPs.

## AI & agents

| Tool | Usage |
|------|-------|
| Vercel AI SDK | Core agent framework — `streamText`, `generateText`, tools, `useChat` |
| Langfuse | Prompt management, tracing, sync scripts |
| OpenTelemetry | Observability for AI pipelines |
| MCP | Model Context Protocol servers ([[Stacks/AI Agent App]]) |
| RAG / pgvector | Knowledge base indexing, HyPE, reranking |
| Temporal | Workflow orchestration (Triple Whale integrations) |

## Cloud & infra

GCP, Netlify, Firebase, MongoDB, Supabase, AWS S3, Docker, Railway.

## Process

Agile, Scrum, JIRA, Confluence. On-call experience (OpsGenie, DataDog).

## Related

- [[Preferences/Frontend Conventions]]
- [[Preferences/Backend Conventions]]
- [[Patterns/AI Agent Stack]]
- [[Patterns/Runtime Choices]]
