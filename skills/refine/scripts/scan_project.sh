#!/usr/bin/env bash
# scan_project.sh — Automated project config scanner for /refine skill
# Usage: bash scan_project.sh [project_path]
# Outputs structured text for Claude to consume during the SCAN phase.

set -euo pipefail

PROJECT="${1:-.}"
PROJECT="$(cd "$PROJECT" && pwd)"

echo "=== REFINE SCAN REPORT ==="
echo "Project: $PROJECT"
echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

# ─── PROJECT TYPE DETECTION ───
echo "--- PROJECT TYPE ---"

if [[ -f "$PROJECT/package.json" ]]; then
  echo "package_manager: npm"
  # Detect framework from dependencies
  deps=$(cat "$PROJECT/package.json")
  if echo "$deps" | grep -q '"next"'; then echo "framework: nextjs"
  elif echo "$deps" | grep -q '"react-router"'; then echo "framework: react-router"
  elif echo "$deps" | grep -q '"nuxt"'; then echo "framework: nuxt"
  elif echo "$deps" | grep -q '"@angular/core"'; then echo "framework: angular"
  elif echo "$deps" | grep -q '"svelte"'; then echo "framework: svelte"
  elif echo "$deps" | grep -q '"react"'; then echo "framework: react"
  elif echo "$deps" | grep -q '"vue"'; then echo "framework: vue"
  elif echo "$deps" | grep -q '"express"'; then echo "framework: express"
  elif echo "$deps" | grep -q '"hono"'; then echo "framework: hono"
  elif echo "$deps" | grep -q '"fastify"'; then echo "framework: fastify"
  else echo "framework: node"; fi
  echo "language: typescript/javascript"

  # Detect key libraries
  for lib in tailwindcss prisma mongoose drizzle sequelize playwright jest vitest cypress mocha; do
    if echo "$deps" | grep -q "\"$lib\""; then echo "has_lib: $lib"; fi
  done
  for lib in "@prisma/client" "better-auth" "next-auth" "lucia"; do
    if echo "$deps" | grep -q "\"$lib\""; then echo "has_lib: $lib"; fi
  done

  # Available npm scripts
  echo ""
  echo "--- NPM SCRIPTS ---"
  node -e "
    const pkg = require('$PROJECT/package.json');
    const scripts = pkg.scripts || {};
    Object.keys(scripts).forEach(k => console.log('script: ' + k + ' = ' + scripts[k]));
  " 2>/dev/null || echo "scripts: (parse error)"

elif [[ -f "$PROJECT/requirements.txt" ]] || [[ -f "$PROJECT/pyproject.toml" ]] || [[ -f "$PROJECT/setup.py" ]]; then
  echo "language: python"
  if [[ -f "$PROJECT/pyproject.toml" ]]; then
    echo "package_manager: pyproject"
    if grep -q "fastapi" "$PROJECT/pyproject.toml" 2>/dev/null; then echo "framework: fastapi"
    elif grep -q "django" "$PROJECT/pyproject.toml" 2>/dev/null; then echo "framework: django"
    elif grep -q "flask" "$PROJECT/pyproject.toml" 2>/dev/null; then echo "framework: flask"
    fi
  elif [[ -f "$PROJECT/requirements.txt" ]]; then
    echo "package_manager: pip"
    if grep -q "fastapi" "$PROJECT/requirements.txt" 2>/dev/null; then echo "framework: fastapi"
    elif grep -q "django" "$PROJECT/requirements.txt" 2>/dev/null; then echo "framework: django"
    elif grep -q "flask" "$PROJECT/requirements.txt" 2>/dev/null; then echo "framework: flask"
    fi
  fi
elif [[ -f "$PROJECT/go.mod" ]]; then
  echo "language: go"
  echo "package_manager: go_modules"
elif [[ -f "$PROJECT/Cargo.toml" ]]; then
  echo "language: rust"
  echo "package_manager: cargo"
elif [[ -f "$PROJECT/Gemfile" ]]; then
  echo "language: ruby"
  echo "package_manager: bundler"
  if grep -q "rails" "$PROJECT/Gemfile" 2>/dev/null; then echo "framework: rails"; fi
else
  echo "language: unknown"
fi

# ─── CLAUDE CONFIG INVENTORY ───
echo ""
echo "--- CLAUDE CONFIG FILES ---"

# CLAUDE.md
if [[ -f "$PROJECT/CLAUDE.md" ]]; then
  lines=$(wc -l < "$PROJECT/CLAUDE.md" | tr -d ' ')
  echo "claude_md: present ($lines lines)"
else
  echo "claude_md: absent"
fi

# .claude directory
if [[ -d "$PROJECT/.claude" ]]; then
  echo "claude_dir: present"

  # Settings
  for f in settings.json settings.local.json; do
    if [[ -f "$PROJECT/.claude/$f" ]]; then echo "  $f: present"; fi
  done

  # Skills
  if [[ -d "$PROJECT/.claude/skills" ]]; then
    skill_count=$(find "$PROJECT/.claude/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
    echo "  skills: $skill_count found"
    find "$PROJECT/.claude/skills" -name "SKILL.md" -print 2>/dev/null | while read -r f; do
      rel="${f#$PROJECT/}"
      echo "    - $rel"
    done
  else
    echo "  skills: none"
  fi

  # Agents
  if [[ -d "$PROJECT/.claude/agents" ]]; then
    agent_count=$(find "$PROJECT/.claude/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    echo "  agents: $agent_count found"
    find "$PROJECT/.claude/agents" -name "*.md" -print 2>/dev/null | while read -r f; do
      echo "    - $(basename "$f" .md)"
    done
  else
    echo "  agents: none"
  fi

  # Commands
  if [[ -d "$PROJECT/.claude/commands" ]]; then
    cmd_count=$(find "$PROJECT/.claude/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    echo "  commands: $cmd_count found"
    find "$PROJECT/.claude/commands" -name "*.md" -print 2>/dev/null | while read -r f; do
      echo "    - $(basename "$f" .md)"
    done
  else
    echo "  commands: none"
  fi
else
  echo "claude_dir: absent"
fi

# MCP config
if [[ -f "$PROJECT/.mcp.json" ]]; then
  echo "mcp_config: present"
  node -e "
    const mcp = require('$PROJECT/.mcp.json');
    const servers = mcp.mcpServers || {};
    Object.keys(servers).forEach(k => console.log('  mcp_server: ' + k));
  " 2>/dev/null || echo "  (parse error)"
else
  echo "mcp_config: absent"
fi

# ─── CLAUDE.MD QUALITY SIGNALS ───
echo ""
echo "--- CLAUDE.MD QUALITY SIGNALS ---"

if [[ -f "$PROJECT/CLAUDE.md" ]]; then
  content="$PROJECT/CLAUDE.md"

  check_signal() {
    if grep -qi "$1" "$content" 2>/dev/null; then
      echo "  $2: yes"
    else
      echo "  $2: no"
    fi
  }

  check_signal "anti.pattern\|never\|do not\|don't\|avoid" "has_anti_patterns"
  check_signal "test\|playwright\|jest\|vitest\|pytest" "mentions_testing"
  check_signal "lint\|eslint\|prettier\|format" "mentions_linting"
  check_signal "typecheck\|tsc\|type.check\|mypy" "mentions_typecheck"
  check_signal "hook\|PostToolUse\|PreToolUse" "mentions_hooks"
  check_signal "architecture\|structure\|directory" "has_architecture_section"
  check_signal "convention\|pattern\|style" "has_conventions"
  check_signal "checklist\|\- \[" "has_checklists"
  check_signal "tech.stack\|dependencies\|framework" "mentions_tech_stack"
  check_signal "delegat\|agent\|skill" "mentions_delegation"
else
  echo "  (no CLAUDE.md to analyze)"
fi

# ─── GIT STATUS ───
echo ""
echo "--- GIT STATUS ---"

if [[ -d "$PROJECT/.git" ]]; then
  echo "git: yes"
  branch=$(git -C "$PROJECT" branch --show-current 2>/dev/null || echo "unknown")
  echo "branch: $branch"
  dirty=$(git -C "$PROJECT" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  echo "dirty_files: $dirty"
else
  echo "git: no"
fi

echo ""
echo "=== END SCAN ==="
