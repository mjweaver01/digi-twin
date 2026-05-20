---
type: preference
tags: [digi-twin, preference, frontend]
owner: Mike
updated: 2026-05-20
status: current
---

# Frontend Conventions

Universal defaults. Load the matching [[Stacks/Index|stack profile]] for project-specific patterns.

## Framework selection

Use whatever the project already uses — React, Vue, or Next.js. Don't migrate frameworks unless explicitly asked.

## State management

**Global state belongs in a state management layer.** Prop-drill DTOs and specific data into presentational components.

| Pattern | Stack | When |
|---------|-------|------|
| Pinia stores | [[Stacks/Vue Serverless]] | Vue apps |
| React Context + hooks | [[Stacks/Bun Monolith]] | React without heavy global needs |
| AI SDK `useChat` | [[Stacks/AI Agent App]] | Chat/streaming UI |
| SWR | [[Stacks/Shopify App]] | Next.js data fetching |
| Local `useState` | All | Component-scoped UI state |

Don't reach for Redux or add a global store for data that only one component tree needs.

## Component structure

- Functional components (React) / SFCs (Vue)
- Extract custom hooks / composables for reusable logic
- Colocate domain components; use a `ui/` folder for design system primitives
- PascalCase for components, camelCase for hooks/utils

## Styling

Match the stack: Tailwind ([[Stacks/Bun Monolith]], [[Stacks/Express Monolith]]), SCSS ([[Stacks/Vue Serverless]]), Polaris ([[Stacks/Shopify App]]).

## Path aliases

Common pattern: `@/` → `src/`. Check `tsconfig.json` / `vite.config.ts` in the open project.

## Related

- [[Patterns/Type Sharing]]
- [[Preferences/Editor & Tooling]]
