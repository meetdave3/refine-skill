# Project Archetypes

Recommended Claude Code configuration by project type. Use as a baseline — adapt to the specific project.

---

## React / Next.js Frontend

### CLAUDE.md Priorities
- Component patterns (file structure, naming, props interface)
- State management approach (server state vs client state)
- Styling conventions (Tailwind classes, CSS modules, theme tokens)
- Data fetching patterns (server components, loaders, SWR/React Query)
- Anti-patterns: useEffect for fetching, prop drilling, inline styles, any over unknown

### Recommended Skills
- **UI/Component skill** — design system reference, component creation workflow
- **Test writer** — E2E test patterns, component test patterns

### Recommended Agents
- **Frontend specialist** — React performance, accessibility, responsive design
- Only if project is large enough to warrant it

### Recommended Hooks
- PostToolUse: typecheck on .tsx edits
- PostToolUse: lint on file changes
- PostToolUse: run related tests on component changes

### MCP Servers
- Browser automation (for visual testing)
- Figma (if design-to-code workflow exists)

---

## Python Backend (FastAPI / Django / Flask)

### CLAUDE.md Priorities
- API route patterns (path structure, request/response schemas)
- Database patterns (ORM usage, migration workflow, query patterns)
- Auth patterns (middleware, decorators, token handling)
- Error handling (exception hierarchy, error response format)
- Anti-patterns: raw SQL without parameterization, N+1 queries, blocking in async

### Recommended Skills
- **API endpoint skill** — route creation workflow with schema validation
- **Migration skill** — database migration creation and testing

### Recommended Agents
- **Database analyst** — query optimization, schema review
- Only for data-heavy projects

### Recommended Hooks
- PostToolUse: pytest on .py file changes
- PostToolUse: mypy/pyright typecheck
- PostToolUse: ruff/black format check

### MCP Servers
- PostgreSQL/MySQL for direct DB access
- Redis if caching layer exists

---

## Fullstack (React Router / Next.js + API)

### CLAUDE.md Priorities
- Clear separation of frontend vs backend conventions
- Data flow: server → loader/API → component
- Shared types / schema definitions
- Auth flow end-to-end
- Anti-patterns: mixing server/client code, duplicating types, direct DB access from components

### Recommended Skills
- **UI skill** — frontend component patterns
- **API skill** — backend endpoint patterns
- **Test writer** — E2E flows that cross the stack

### Recommended Agents
- **Frontend specialist** — component layer
- **Backend specialist** — API/DB layer
- Useful when the two layers have very different conventions

### Recommended Hooks
- PostToolUse: typecheck (catches type mismatches across layers)
- PostToolUse: relevant E2E tests on route changes
- Stop: full lint + typecheck

### MCP Servers
- Database access (for debugging data issues)
- Browser automation (for E2E validation)

---

## Monorepo (Turborepo / Nx / pnpm workspaces)

### CLAUDE.md Priorities
- Package map: which package does what
- Shared vs package-specific conventions
- Dependency rules (who can import from whom)
- Build order and caching
- Anti-patterns: circular dependencies, importing internals, bypassing shared packages

### Recommended Skills
- **Per-package skills** — each major package gets domain-specific guidance
- **Integration skill** — cross-package change workflow

### Recommended Agents
- **Package specialists** — one per major package area
- **Integration reviewer** — checks cross-package changes

### Recommended Hooks
- PostToolUse: affected package tests
- PostToolUse: typecheck affected packages
- Stop: full build verification

### MCP Servers
- Depends on what the monorepo contains

---

## Go / Rust Systems

### CLAUDE.md Priorities
- Module/crate structure and responsibilities
- Error handling patterns (Go: error wrapping; Rust: Result/Option)
- Concurrency patterns (goroutines/channels; async/tokio)
- Testing patterns (table-driven tests, integration test setup)
- Build and cross-compilation commands
- Anti-patterns: ignoring errors, data races, unnecessary unsafe

### Recommended Skills
- **Test writer** — table-driven test generation (Go), property tests (Rust)
- Fewer skills generally needed — these ecosystems have strong conventions

### Recommended Agents
- Usually not needed unless project is very large
- **Performance profiler** — for systems with strict latency requirements

### Recommended Hooks
- PostToolUse: `go test ./...` or `cargo test`
- PostToolUse: `go vet` or `cargo clippy`
- PostToolUse: format check (`gofmt`, `rustfmt`)

### MCP Servers
- Rarely needed — Go/Rust projects tend to be self-contained

---

## CLI / Library

### CLAUDE.md Priorities
- Public API design principles
- Backwards compatibility rules
- Documentation patterns (docstrings, README, examples)
- Release workflow and versioning
- Anti-patterns: breaking changes without major version, leaking internals

### Recommended Skills
- **API design skill** — consistent interface patterns
- **Documentation skill** — generating/updating docs

### Recommended Agents
- Usually not needed

### Recommended Hooks
- PostToolUse: full test suite (libraries need high test coverage)
- PostToolUse: documentation generation check
- Stop: all tests pass, no breaking changes

### MCP Servers
- Rarely needed

---

## Configuration Sizing Quick Reference

| Archetype | CLAUDE.md Lines | Skills | Agents | Hooks | MCP |
|-----------|----------------|--------|--------|-------|-----|
| React Frontend | 100–200 | 2–3 | 0–1 | 2–3 | 0–1 |
| Python Backend | 100–200 | 1–2 | 0–1 | 2–3 | 1 |
| Fullstack | 150–250 | 3–4 | 0–2 | 3–4 | 1–2 |
| Monorepo | 200–300 | 4–8 | 2–4 | 3–5 | 1–2 |
| Go/Rust Systems | 80–150 | 1–2 | 0 | 2–3 | 0 |
| CLI/Library | 80–150 | 1–2 | 0 | 2–3 | 0 |
