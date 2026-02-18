# Skills, Agents & Commands — Decision Framework

## When to Use What

| Lever | Use When | Example |
|-------|----------|---------|
| **CLAUDE.md** | Always-loaded project rules | "Never use useEffect for fetching" |
| **Skill** | Repeated workflow with domain knowledge | /ui, /test-writer, /translate |
| **Agent** | Autonomous specialist that needs delegation | frontend agent, perf optimizer |
| **Command** | One-shot action triggered by user | /commit, /release-msg |
| **Hook** | Automatic reaction to tool use | Run tests after file edit |
| **MCP Server** | External tool/service access | Database, browser, API |

### Decision Tree

```
Is it a rule Claude should ALWAYS follow?
  → CLAUDE.md

Is it a multi-step workflow triggered on demand?
  Does it need domain knowledge / reference files?
    → Skill (with references/)
  Is it a single action?
    → Command

Should it run automatically without user trigger?
  → Hook

Does it need an external service connection?
  → MCP Server

Does it need autonomous multi-step reasoning with a specific role?
  → Agent
```

---

## Skill Patterns (from top skills.sh entries)

### Pattern 1: Phase-Gated Workflow
Structure the skill as sequential phases with gates.
```
Phase 1: SCAN — gather context (read files, run commands)
  Gate: must complete scan before proceeding
Phase 2: PLAN — design the approach
  Gate: present plan, get approval
Phase 3: IMPLEMENT — make changes
  Gate: each change approved individually
Phase 4: VERIFY — run tests, check output
```
**Why it works:** Prevents Claude from jumping to implementation without understanding context. Forces deliberate progression.

**Used by:** /frontend-design, /refine, obra's skills

### Pattern 2: Anti-Pattern Specification
Define what the skill must NEVER do, not just what it should do.
```
## Anti-Patterns
- NEVER generate boilerplate without reading existing patterns first
- NEVER create a new component if an existing one can be extended
- NEVER skip the scan phase
```
**Why it works:** Negative constraints are more precise than positive instructions. Claude is already good at generating code — it needs to know what NOT to generate.

**Used by:** /frontend-design, Vercel's rule system

### Pattern 3: Rule-Based Architecture
Organize configuration as explicit, numbered rules.
```
Rule 1: All API routes return typed responses
Rule 2: Error responses use the ErrorResponse schema
Rule 3: Auth middleware is applied via route groups, not per-route
```
**Why it works:** Unambiguous, easy to reference ("see Rule 3"), easy to verify compliance.

**Used by:** Vercel's cursor-rules, large team configurations

### Pattern 4: Dynamic Context Fetching
Skill reads project files during execution to adapt.
```
1. Read package.json to detect framework
2. Read existing components to match patterns
3. Read test files to match test style
```
**Why it works:** Skill output matches the actual project, not a generic template.

### Pattern 5: Reference-Heavy Design
Skill is thin (workflow only), knowledge lives in reference files.
```
SKILL.md (50 lines) — orchestration
references/
  component-patterns.md — how to build components
  api-patterns.md — how to build APIs
  testing-guide.md — how to write tests
```
**Why it works:** Token-efficient. References loaded only when needed. Easy to update knowledge independently.

---

## Agent Design Patterns

### Specialist Agent
Deep expertise in one area. Knows tools, patterns, pitfalls.
```
# Frontend Agent
You are a React performance specialist for [project].
You have access to: React DevTools patterns, bundle analysis, ...
You focus on: component optimization, render reduction, lazy loading.
You do NOT: modify backend code, change database schemas.
```

### Analyst Agent
Reads and reports, doesn't modify.
```
# Performance Analyzer
You analyze bundle sizes, render counts, and load times.
You produce reports with specific recommendations.
You NEVER modify code directly.
```

### Verifier Agent
Checks work done by others.
```
# Code Reviewer
You review changes for: correctness, patterns compliance, test coverage.
You flag issues but don't fix them.
```

### When NOT to Create Agents

- **Solo dev, small project** — agents add complexity without benefit. Use skills instead.
- **Generic tasks** — "code helper" agent is just Claude with extra steps. Be specific or skip it.
- **One-off work** — if you'd only use it once, just do it in the main conversation.
- **Overlapping scope** — two agents that both "help with frontend" cause confusion. One specialist per domain.

---

## Command Patterns

Commands are simple, user-triggered, single-purpose.

### Good Commands
- `/commit` — generate conventional commit message from staged changes
- `/release-msg` — generate release notes from recent commits
- `/generate-prp` — create a product requirements document
- `/execute-prp` — implement from a PRP document

### Command vs Skill
- **Command:** "do this one thing now" (generate commit msg, create PR)
- **Skill:** "walk me through this workflow" (design a component, write tests, refine config)

Commands are typically < 50 lines. Skills are 100–400 lines with references.

---

## Sizing Guidelines

| Project | Skills | Agents | Commands | Hooks |
|---------|--------|--------|----------|-------|
| Small solo project | 0–1 | 0 | 0–1 | 0–1 |
| Medium project | 2–4 | 0–1 | 1–2 | 1–2 |
| Large / team project | 4–8 | 2–4 | 2–4 | 3–5 |
| Monorepo | 5–10 | 3–5 | 3–5 | 5+ |

Over-configuration is as bad as under-configuration. Each skill/agent should justify its existence with frequent use.
