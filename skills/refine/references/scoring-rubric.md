# Scoring Rubric

8 dimensions, scored 0–3 each. Total /24 → letter grade.

## Grading Scale

| Total | Grade | Meaning |
|-------|-------|---------|
| 21–24 | A | Excellent — minor polish only |
| 17–20 | B | Good — a few meaningful gaps |
| 12–16 | C | Adequate — significant room to improve |
| 7–11  | D | Weak — major config missing |
| 0–6   | F | Absent — essentially unconfigured |

---

## 1. CLAUDE.md Quality

**0 — Absent**
- No CLAUDE.md exists

**1 — Basic**
- [ ] CLAUDE.md exists
- [ ] Contains some project description

**2 — Good**
- [ ] Has structured sections (not just freeform prose)
- [ ] Specifies tech stack and key dependencies
- [ ] Includes dev commands (build, test, lint)
- [ ] Mentions project architecture or directory layout

**3 — Excellent**
- [ ] Has anti-patterns / "NEVER do X" rules
- [ ] Includes conventions section (naming, file structure, patterns)
- [ ] Specifies testing strategy and commands
- [ ] Has delegation guidance (when to use agents/skills)
- [ ] Uses checklists or explicit verification steps
- [ ] Sections are concise and scannable (not prose-heavy)

---

## 2. Development Workflow

**0 — Absent**
- No dev commands discoverable (no scripts, no CLAUDE.md commands)

**1 — Basic**
- [ ] Has package.json scripts OR CLAUDE.md mentions how to run/build

**2 — Good**
- [ ] Test command exists and is documented
- [ ] Lint command exists and is documented
- [ ] Build command exists and is documented
- [ ] Commands reference actual project tooling (not generic)

**3 — Excellent**
- [ ] Typecheck command exists and is documented
- [ ] Commands use correct flags for CI vs interactive use
- [ ] Slash commands exist for repeated workflows (commit, release, etc.)
- [ ] CLAUDE.md specifies which commands to run before committing
- [ ] Single-file test execution pattern documented

---

## 3. Skills Coverage

**0 — Absent**
- No skills directory exists

**1 — Basic**
- [ ] At least one skill exists with a SKILL.md

**2 — Good**
- [ ] Skills cover the project's primary domain (UI, API, data, etc.)
- [ ] Skills have reference files (not just the SKILL.md)
- [ ] Skills use structured workflows (not just instructions)

**3 — Excellent**
- [ ] Skills encode domain-specific knowledge (design system, API patterns, etc.)
- [ ] Skills use anti-patterns to prevent common mistakes
- [ ] Skills have phase-gated workflows (scan → plan → implement)
- [ ] Skills reference actual project files/components
- [ ] Skills cover repeated tasks the team does frequently

---

## 4. Agent Architecture

**0 — Absent**
- No agents defined

**1 — Basic**
- [ ] At least one agent exists

**2 — Good**
- [ ] Agents have clear specializations (not generic "helper")
- [ ] Agent descriptions specify what they CAN and CANNOT do
- [ ] Agents reference specific project areas or tools

**3 — Excellent**
- [ ] Agents form a complementary team (specialist, reviewer, etc.)
- [ ] CLAUDE.md has delegation rules (when to hand off to which agent)
- [ ] Agents have constrained scope (path-scoped, domain-scoped)
- [ ] Agent count matches project complexity (not over-engineered)

---

## 5. Automation (Hooks)

**0 — Absent**
- No hooks configured

**1 — Basic**
- [ ] At least one hook exists (any event)

**2 — Good**
- [ ] PostToolUse hook runs tests on file changes
- [ ] Hooks are scoped to relevant file patterns
- [ ] Hook commands are fast (< 5 seconds)

**3 — Excellent**
- [ ] Hooks create feedback loops (edit → test → report)
- [ ] Multiple hook events covered (PostToolUse, Stop, Notification)
- [ ] Hooks prevent common mistakes (typecheck on .ts edits, lint on save)
- [ ] Stop hook runs full validation before accepting completion
- [ ] Notification hooks for long-running tasks (sounds, alerts)

---

## 6. Tool Integration (MCP)

**0 — Absent**
- No MCP servers, no tool configuration

**1 — Basic**
- [ ] .mcp.json exists OR settings mention tool permissions

**2 — Good**
- [ ] MCP servers connect to project-relevant services
- [ ] Permissions are configured (allowlist, not wide-open)
- [ ] Tool access matches the project's needs (DB, API, browser, etc.)

**3 — Excellent**
- [ ] MCP servers cover the full workflow (dev, test, deploy, monitor)
- [ ] Permissions use least-privilege principle
- [ ] Tool configuration documented in CLAUDE.md
- [ ] Custom MCP servers for project-specific needs

---

## 7. Guard Rails

**0 — Absent**
- No anti-patterns, no constraints specified

**1 — Basic**
- [ ] At least one "don't do X" rule exists

**2 — Good**
- [ ] Anti-patterns are specific (not just "write good code")
- [ ] Rules reference actual project patterns (components, APIs, etc.)
- [ ] Path-scoped rules exist (different rules for different directories)

**3 — Excellent**
- [ ] Anti-patterns cover common AI mistakes for this stack
- [ ] Rules include bad/good examples
- [ ] Guard rails are in CLAUDE.md AND in relevant skills
- [ ] Safety nets exist (hooks that catch violations)
- [ ] Rules reference actual past mistakes or known failure modes

---

## 8. Context Efficiency

**0 — Absent**
- All config is in one giant file or no config at all

**1 — Basic**
- [ ] Config exists but is in a single large CLAUDE.md

**2 — Good**
- [ ] Information is split across CLAUDE.md + reference files
- [ ] CLAUDE.md is under 300 lines (not bloated)
- [ ] Reference files are loaded on-demand (via skills/agents)

**3 — Excellent**
- [ ] Progressive disclosure: CLAUDE.md has essentials, details in references
- [ ] Skills load domain knowledge only when invoked
- [ ] Token budget is respected (total loaded context < 5000 lines)
- [ ] No duplicate information across config files
- [ ] Reference files are concise (under 250 lines each)

---

## Scoring Output Format

Present scores as a table:

```
| # | Dimension            | Score | Notes                        |
|---|----------------------|-------|------------------------------|
| 1 | CLAUDE.md Quality    | 2/3   | Missing anti-patterns        |
| 2 | Development Workflow | 3/3   | All commands present         |
| ...                                                              |
|   | TOTAL                | 18/24 | Grade: B                     |
```

Always include specific notes explaining each score. Never score without evidence from the scan.
