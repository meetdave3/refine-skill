# /refine: Claude Code Configuration Auditor

A meta-skill that audits, scores, and improves any project's Claude Code configuration. It analyzes your CLAUDE.md, skills, agents, hooks, MCP servers, and settings, then provides a scored report card with actionable improvements.

## Why This Exists

Most Claude Code projects are poorly configured. A typical project has a basic CLAUDE.md and nothing else, ignoring the 10+ configuration levers available (skills, subagents, hooks, MCP servers, path-scoped rules, settings, progressive disclosure, auto-memory).

**Configuration quality directly determines output quality.** A prompt that says "make it look good" gets generic output. A prompt that says "luxury editorial with generous negative space and a sharp orange accent" gets distinctive output. The same principle applies to project configuration. Vague CLAUDE.md files produce vague Claude behavior.

### The Inspiration

This skill was born from analyzing why the `/frontend-design` skill produces exceptional output. The answer: **constraint-driven prompting.**

1. **Ban the defaults**: anti-patterns ("NEVER do X") are more useful than positive instructions
2. **Force intent**: mandate thinking before doing (scan before scoring, score before implementing)
3. **Be specific**: concrete guidance, not vague aspirations
4. **Provide references**: curated knowledge loaded on-demand, not dumped into context

These are the same techniques the top 30 skills on [skills.sh](https://skills.sh) use: phase-gated workflows that prevent premature action, explicit anti-patterns that break Claude out of defaults, and interview-driven context gathering before execution.

### The Key Insight

The best skills share a formula: **specificity breeds quality.** The systematic-debugging skill has an "Iron Law," demanding no fixes without root cause investigation first. The brainstorming skill has a hard gate, blocking implementation until the user approves a design. These non-negotiable constraints, not vague suggestions, are what produce quality output.

`/refine` applies this same philosophy to the meta-layer: Claude Code configuration itself. It consolidates what was learned from the top community skills, the official Anthropic documentation, and real-world project analysis into a single interactive workflow.

### Why Interview-Driven

Different project types need different configurations. A solo developer's Python CLI needs different hooks and skills than a team's React monorepo. Rather than generating generic recommendations, `/refine` interviews you about gaps it found, ensuring recommendations are project-type-aware and never one-size-fits-all.

## Install

```bash
npx skills add meetdave3/refine-skill
```

## Usage

### Full audit + implementation
```
/refine
```
Runs all 4 phases: scan your project, score 8 dimensions, interview you about gaps, then implement fixes one at a time with your approval.

### Audit only (no changes)
```
/refine audit
```
Scans and scores your project. Produces a report card with letter grade (A-F). No files modified.

### Quick fixes
```
/refine quick
```
Scans, scores, skips the interview, and implements the top 3 highest-impact fixes.

## What It Scores

| # | Dimension | What It Measures |
|---|-----------|-----------------|
| 1 | CLAUDE.md Quality | Structure, specificity, anti-patterns, tech stack docs |
| 2 | Development Workflow | Test/lint/build commands, slash commands |
| 3 | Skills Coverage | Domain knowledge, design system, repeated patterns |
| 4 | Agent Architecture | Specialization, delegation, team structure |
| 5 | Automation (Hooks) | PostToolUse testing, validation loops, Stop hooks |
| 6 | Tool Integration | MCP servers, permissions, external tool access |
| 7 | Guard Rails | Anti-patterns specified, path-scoped rules, safety nets |
| 8 | Context Efficiency | Progressive disclosure, reference splitting, token budget |

Each dimension scored 0-3. Total /24 maps to a letter grade:

| Score | Grade |
|-------|-------|
| 21-24 | A |
| 17-20 | B |
| 12-16 | C |
| 7-11 | D |
| 0-6 | F |

## How It Works

### Phase 1: SCAN
Runs an automated scanner that detects your project type (language, framework, libraries), finds all Claude config files, and checks CLAUDE.md quality signals.

### Phase 2: SCORE
Scores each of 8 dimensions using evidence from the scan. Every score is backed by specific findings, never guesswork.

### Phase 3: INTERVIEW
Asks up to 5 targeted questions about gaps found in your config. Only asks about dimensions scoring below 2. Skipped in `quick` mode.

### Phase 4: IMPLEMENT
Generates specific changes ordered by impact (CLAUDE.md first, settings last). Each change is presented individually for your approval before being applied.

## Example Output (Audit Mode)

```
## Score Report

| # | Dimension            | Score | Evidence                                    |
|---|----------------------|-------|---------------------------------------------|
| 1 | CLAUDE.md Quality    | 2/3   | Good structure, missing anti-patterns        |
| 2 | Development Workflow | 3/3   | All commands present and documented          |
| 3 | Skills Coverage      | 2/3   | 6 skills, but no reference files in 2        |
| 4 | Agent Architecture   | 2/3   | 5 agents with clear specializations          |
| 5 | Automation (Hooks)   | 1/3   | Only test hook, no typecheck or lint hooks   |
| 6 | Tool Integration     | 0/3   | No MCP servers configured                    |
| 7 | Guard Rails          | 2/3   | Anti-patterns in CLAUDE.md, not in skills    |
| 8 | Context Efficiency   | 2/3   | Good splitting, CLAUDE.md slightly long      |
|   | TOTAL                | 14/24 | Grade: C                                     |
```

## Supported Project Types

- JavaScript/TypeScript (React, Next.js, Vue, Svelte, Express, Hono, Fastify)
- Python (FastAPI, Django, Flask)
- Go
- Rust
- Ruby (Rails)

## Repository Structure

```
refine-skill/
├── README.md
├── LICENSE
├── CLAUDE.md
└── skills/
    └── refine/
        ├── SKILL.md                    # 4-phase workflow orchestrator
        ├── scripts/
        │   └── scan_project.sh         # Automated project scanner
        └── references/
            ├── scoring-rubric.md       # 8-dimension scoring criteria
            ├── claude-md-patterns.md   # CLAUDE.md templates + anti-patterns
            ├── skills-and-agents.md    # Decision framework
            ├── hooks-and-automation.md # Hook recipes, MCP patterns
            └── project-archetypes.md   # Per-project-type configs
```

## License

MIT
