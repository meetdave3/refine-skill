# CLAUDE.md Patterns & Anti-Patterns

## Recommended Structure

A well-structured CLAUDE.md has these 8 sections in order. Not every project needs all 8 — include only what's relevant.

### 1. Identity & Role
What Claude should act as in this project. One line.
```
You are a senior fullstack engineer working on [project name], a [brief description].
```

### 2. Tech Stack
List actual versions and key libraries. Don't describe what they do — Claude knows.
```
## Tech Stack
- React 18 + React Router 7 (framework mode)
- Tailwind CSS + shadcn/ui components
- Prisma ORM (PostgreSQL)
- Playwright for E2E tests
- TypeScript 5.x strict mode
```

### 3. Development Commands
Exact commands to run. Include single-file variants.
```
## Commands
- Dev server: `npm run dev` (runs on localhost:3000)
- Test all: `npm test`
- Test single: `npx playwright test tests/specific.spec.ts`
- Lint: `npm run lint`
- Typecheck: `npx tsc --noEmit`
- Build: `npm run build`
```

### 4. Architecture & Directory Layout
Where things live. Use a tree or brief descriptions.
```
## Architecture
- app/routes/ — Page routes (file-based routing)
- app/components/ — Shared UI components
- app/lib/ — Utilities, hooks, helpers
- api/ — Backend API handlers
- prisma/ — Database schemas and migrations
```

### 5. Conventions & Patterns
How to write code in this project. Be specific.
```
## Conventions
- Use `useLoaderData()` for server data, never fetch in useEffect
- Form submissions use `<Form>` with action functions
- All new components go in app/components/ with PascalCase filenames
- Use `cn()` helper for conditional Tailwind classes
```

### 6. Anti-Patterns (Critical)
What Claude must NEVER do. More useful than positive instructions.
```
## Anti-Patterns — NEVER Do These
- NEVER use `useEffect` for data fetching — use loaders
- NEVER create new API routes when a loader/action works
- NEVER install new dependencies without asking first
- NEVER modify shared components without checking all usages
- NEVER use inline styles — always use Tailwind classes
- NEVER skip running tests after modifying shared code
```

### 7. Testing Strategy
How to test, what to test, what to skip.
```
## Testing
- E2E tests in tests/ using Playwright
- Run relevant tests after every change: `npx playwright test tests/affected.spec.ts`
- Tests use saved auth state (no login flow in tests)
- Visual regression: compare screenshots when UI changes
```

### 8. Delegation Rules
When to use skills, agents, or commands.
```
## Delegation
- Use /ui skill for any component creation or modification
- Use /test-writer skill for creating new E2E tests
- Use frontend agent for complex React performance issues
- Use /commit command for all git commits
```

---

## Common Anti-Patterns in CLAUDE.md Files

### BAD: Too vague
```
Write clean, maintainable code following best practices.
```
**Why bad:** Claude already tries to do this. Provides zero project-specific guidance.

### GOOD: Specific and actionable
```
All form inputs must use react-hook-form with zod validation schemas.
Schemas live in app/lib/schemas/ named [feature].schema.ts.
```

### BAD: Prose-heavy paragraphs
```
When working on this project, it's important to remember that we use a
specific pattern for data loading. The pattern involves using React Router's
loader functions to fetch data on the server side before the component renders.
This means you should avoid using useEffect for any data fetching operations...
```
**Why bad:** Burns tokens, hard to scan. Claude needs rules, not essays.

### GOOD: Scannable rules
```
## Data Loading
- ALWAYS use route loaders for data fetching
- NEVER use useEffect for data fetching
- Loader functions go in the route file, not separate files
```

### BAD: Generic template
```
## Project Overview
This is a web application...

## Getting Started
1. Clone the repo
2. Install dependencies
3. Run the dev server
```
**Why bad:** Claude doesn't need onboarding instructions. It needs rules for generating correct code.

### BAD: Duplicating documentation
```
## React Router
React Router v7 is a framework that provides file-based routing...
[200 lines explaining React Router]
```
**Why bad:** Claude already knows React Router. Only document YOUR project's specific patterns and deviations.

### GOOD: Project-specific deviations
```
## React Router (our patterns)
- We use flat routes, not nested folder routes
- Layout route is at app/routes/_layout.tsx
- Auth-required routes are prefixed with _auth
```

---

## Size Guidelines

| Project Size | CLAUDE.md Target | Reference Files |
|-------------|-----------------|-----------------|
| Small (solo) | 50–100 lines | 0–1 |
| Medium | 100–200 lines | 2–4 |
| Large / Team | 150–300 lines | 5+ (via skills) |

Over 300 lines in CLAUDE.md is a smell — split into skills with reference files.

---

## Per-Project-Type Emphasis

**Frontend (React/Vue/Svelte):** Heavy on component patterns, state management, styling conventions, anti-patterns for UI.

**Backend (Express/FastAPI/Django):** Heavy on API patterns, auth, database conventions, error handling, testing.

**Fullstack:** Split concerns — frontend conventions separate from backend. Architecture section is critical.

**CLI / Library:** Heavy on API design, testing, backwards compatibility, documentation patterns.

**Monorepo:** Must specify per-package rules, shared vs package-specific conventions, dependency management.
