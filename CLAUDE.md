# /refine Skill

A meta-skill that audits and improves Claude Code configuration for any project. Installable via `npx skills add meetdave3/refine-skill`.

The skill's power comes from constraint-driven prompting: anti-patterns over prescriptions, phase-gated workflows that prevent premature action, and evidence-based recommendations grounded in actual project scans. These principles are the DNA of the skill and must survive all future changes.

## How the Skill Runs

```
User invokes /refine (or /refine audit, /refine quick)
    │
    ▼
SKILL.md (orchestrator)
    │
    ├── Phase 1: SCAN
    │   └── Runs scripts/scan_project.sh
    │       └── Outputs structured key:value text about the target project
    │
    ├── Phase 2: SCORE
    │   └── Reads references/scoring-rubric.md
    │       └── Scores 8 dimensions (0-3 each), produces letter grade
    │
    ├── Phase 3: INTERVIEW (skipped in quick mode)
    │   └── Question bank in SKILL.md, selected by which dimensions scored low
    │
    └── Phase 4: IMPLEMENT (skipped in audit mode)
        └── Reads relevant reference files on-demand:
            ├── references/claude-md-patterns.md
            ├── references/skills-and-agents.md
            ├── references/hooks-and-automation.md
            └── references/project-archetypes.md
```

Three things to keep separate: **SKILL.md is the workflow** (what to do in what order), **reference files are the knowledge** (best practices, patterns, recipes), **scan_project.sh is the data collector** (what exists in the target project). Each should be independently updatable without touching the others.

## How to Update This Skill

This skill encodes a snapshot of Claude Code's capabilities and best practices. It needs updating when Claude Code evolves, when new community patterns emerge, or when scoring criteria need refinement based on real usage.

### When Claude Code adds a new configuration lever

Example: Claude Code introduces a new config file type, a new hook event, a new way to define agents, or a new settings key.

1. **Update `scripts/scan_project.sh`**: add detection for the new config file or feature. Follow the existing pattern of outputting `key: value` lines. Test the scanner against a project that uses the new feature and one that doesn't.

2. **Decide: new scoring dimension or expand an existing one?** If the feature fits under an existing dimension (e.g., a new hook event belongs under "Automation"), add checklist items to that dimension in `references/scoring-rubric.md`. Only create a new dimension if the feature represents an entirely new category. Keep the total at 10 or fewer dimensions.

3. **If adding a new dimension**: update `scoring-rubric.md` (criteria at levels 0-3), the dimension table in `SKILL.md`, the grading scale denominator in `SKILL.md`, the scoring table in `README.md`, and the grading thresholds everywhere they appear. Search the repo for the old denominator (e.g., "/24") to find all locations.

4. **Update the relevant reference file** with best practices for the new feature. If no existing reference file fits, consider whether it warrants a new one or can be folded into the closest match.

5. **Update the "Claude Code configuration levers" list** at the bottom of this file.

6. **Test**: run `/refine audit` against at least two real projects. Verify the scanner detects the feature, the score reflects its presence/absence, and recommendations are specific.

### When adding a new project archetype

Example: a new framework becomes popular (Astro, SolidJS, Elixir/Phoenix) and projects using it need specific recommendations.

1. **Update `scripts/scan_project.sh`**: add framework detection in the project type section. Match on whatever config file or dependency is distinctive (e.g., `astro.config.mjs` for Astro, `mix.exs` for Elixir).

2. **Add the archetype to `references/project-archetypes.md`**: follow the existing format with sections for CLAUDE.md priorities, recommended skills, recommended agents, recommended hooks, and MCP servers. Include sizing guidance.

3. **Update the "Supported Project Types" section in `README.md`**.

4. **Test**: run the scanner against a real project of that type. Verify detection works and the archetype recommendations make sense.

### When refining scoring criteria

Based on real-world usage, you may find that a dimension is too easy or too hard to score well, or that the checklist items don't distinguish meaningfully between levels.

1. **Edit `references/scoring-rubric.md`** directly. Each level (0-3) should have concrete, verifiable checklist items, not vague quality descriptions. A good checklist item is: "CLAUDE.md specifies anti-patterns." A bad one is: "CLAUDE.md is well-written."

2. **Keep the 0-3 scale consistent**: 0 = feature absent entirely, 1 = exists but minimal, 2 = solid implementation covering the basics, 3 = excellent with advanced patterns. Don't let score inflation happen where basic config gets a 2.

3. **Test the updated criteria** by mentally scoring 3 real projects you know well. The scores should match your intuition. If they don't, the criteria need more work.

### When adding a new mode

The current modes are: full (`/refine`), audit-only (`/refine audit`), and quick (`/refine quick`). New modes should follow the pattern.

1. **Add the mode to the MODES section in `SKILL.md`**. Specify which phases it includes and what it skips.

2. **Add gate behavior** in each phase's Gate section, specifying what the new mode does at that gate.

3. **Update `README.md`** with usage example and description.

4. **Update the description frontmatter** in `SKILL.md` to include the new trigger.

### When updating best practices from new Anthropic guidance

Anthropic periodically publishes updated guidance on CLAUDE.md structure, prompting strategies, and tool usage.

1. **Identify which reference file the guidance affects**. CLAUDE.md advice goes in `claude-md-patterns.md`. Skill/agent advice goes in `skills-and-agents.md`. Hook/MCP advice goes in `hooks-and-automation.md`.

2. **Update the relevant file** with the new guidance. Replace outdated advice rather than appending. Reference files should stay under 250 lines each.

3. **Check if the scoring rubric needs adjustment**. If new guidance makes a previous "excellent" practice obsolete, update what constitutes level 3.

## Quality Standards per File

### SKILL.md (target: under 400 lines)
The orchestrator. Contains workflow instructions, not knowledge. If you find yourself writing best-practice advice in SKILL.md, it belongs in a reference file instead. Every instruction should tell Claude what to *do*, not what to *know*. The anti-patterns section at the bottom is the most important part: it prevents the failure modes we've seen in practice.

### scan_project.sh (target: under 200 lines)
Outputs structured `key: value` text. Must be parseable by Claude without explanation. Detection should be fast (file existence checks + grep, not full parsing). Must handle missing files gracefully (no errors when a config file doesn't exist). Always exits cleanly on any project, even empty directories.

### references/scoring-rubric.md (target: under 250 lines)
Every checklist item must be verifiable from the scan output or by reading the project's files. No subjective criteria. Each level (0-3) should be mutually exclusive and easy to assign. If you find yourself debating between two levels, the criteria aren't crisp enough.

### references/claude-md-patterns.md (target: under 250 lines)
Templates and anti-patterns for CLAUDE.md files. The bad/good examples are the most valuable part. Focus on project-specific advice (what Claude can't infer) rather than generic writing advice.

### references/skills-and-agents.md (target: under 250 lines)
Decision framework for when to use each configuration lever. The decision tree and sizing guidelines are the most referenced sections. Keep patterns grounded in real examples from skills.sh, not hypotheticals.

### references/hooks-and-automation.md (target: under 200 lines)
Concrete, copy-pasteable hook recipes. Each recipe should include the JSON config and a one-line explanation of what it does. Recipes must actually work. Avoid documenting hooks that are theoretically possible but practically untested.

### references/project-archetypes.md (target: under 250 lines)
Per-project-type recommendations. Each archetype should be opinionated, not a menu of options. "Use X" is better than "consider X or Y." The sizing table at the bottom is the quick-reference version of all archetypes.

## Extension Points

These are the places where the skill is designed to grow:

1. **Scoring dimensions** (currently 8, max 10): add new ones in `scoring-rubric.md` + SKILL.md + README
2. **Project archetypes** (currently 6): add new ones in `project-archetypes.md` + scanner detection
3. **Modes** (currently 3): add new ones in SKILL.md + README
4. **Hook recipes**: append to `hooks-and-automation.md`
5. **Skill patterns**: append to `skills-and-agents.md`
6. **Scanner detection**: add new project types or config files to `scan_project.sh`
7. **Interview questions**: add to the question bank in SKILL.md, organized by dimension
8. **CLAUDE.md patterns**: add new templates or anti-patterns to `claude-md-patterns.md`

## Anti-Patterns for This Repo

- NEVER use em dashes in any file. Use colons, commas, periods, or parentheses instead.
- NEVER add framework-specific logic to SKILL.md. That belongs in `project-archetypes.md`.
- NEVER hardcode file paths. Always use the scanner to discover them at runtime.
- NEVER add scoring criteria without corresponding checklist items in `scoring-rubric.md`.
- NEVER make reference files depend on each other. Each must be self-contained.
- NEVER add a new scoring dimension without updating the rubric, SKILL.md, and README together.
- NEVER duplicate knowledge between reference files. Each file has a distinct responsibility.
- NEVER let reference files exceed 250 lines. Split them if they grow past that.
- NEVER write subjective scoring criteria. Every checklist item must be verifiable.

## Claude Code Configuration Levers (Current Inventory)

This is the complete list of configuration mechanisms the skill needs to know about. Update this list whenever Claude Code introduces new ones.

1. **CLAUDE.md**: project-level instructions, always loaded into context
2. **Skills** (`.claude/skills/*/SKILL.md`): on-demand workflows with reference files, invoked by `/skill-name`
3. **Agents** (`.claude/agents/*.md`): autonomous specialists that Claude can delegate to
4. **Commands** (`.claude/commands/*.md`): user-triggered one-shot actions, invoked by `/command-name`
5. **Hooks** (in `settings.local.json` under `hooks`): automatic reactions to tool use events (PreToolUse, PostToolUse, Notification, Stop, SubagentStop)
6. **MCP Servers** (`.mcp.json`): external tool and service connections
7. **Settings** (`.claude/settings.json`, `.claude/settings.local.json`): permissions, preferences, allowlists
8. **Path-scoped rules**: CLAUDE.md files in subdirectories that apply only to that subtree
9. **Auto-memory** (`~/.claude/projects/*/memory/`): persistent notes that survive across sessions

## Testing

```bash
# Test the scanner on any project
bash skills/refine/scripts/scan_project.sh /path/to/project

# Test the full skill (from within a target project directory)
# Run /refine audit to verify scan + score without making changes
```

Always test scanner changes against at least two different project types (e.g., one Node.js and one Python project). Verify that the scan output is parseable, scores are consistent with the rubric, and the skill does not recommend changes that don't match the project type.
