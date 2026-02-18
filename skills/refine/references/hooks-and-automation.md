# Hooks & Automation Patterns

## Hook Events

| Event | Fires When | Common Use |
|-------|-----------|------------|
| **PreToolUse** | Before a tool executes | Block dangerous operations, add constraints |
| **PostToolUse** | After a tool completes | Run tests, lint, typecheck on file changes |
| **Notification** | Claude sends a notification | Play sounds, send alerts |
| **Stop** | Claude is about to stop responding | Final validation, checklist verification |
| **SubagentStop** | A subagent finishes | Aggregate results, trigger next step |

---

## Hook Configuration

Hooks are configured in `.claude/settings.local.json` under the `hooks` key:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "npm test -- --related $CLAUDE_FILE_PATH 2>&1 | tail -20"
          }
        ]
      }
    ]
  }
}
```

### Matcher Patterns
- Tool name: `"Edit"`, `"Write"`, `"Bash"`
- Multiple tools: `"Edit|Write"`
- File pattern (in command): use `$CLAUDE_FILE_PATH` env var

### Environment Variables Available
- `$CLAUDE_FILE_PATH` — path of the file being operated on
- `$CLAUDE_TOOL_NAME` — name of the tool that was called

---

## Proven Hook Recipes

### Auto-Test on File Edit (JavaScript/TypeScript)
Runs related tests whenever a file is edited or written.
```json
{
  "matcher": "Edit|Write",
  "hooks": [{
    "type": "command",
    "command": "npx jest --findRelatedTests $CLAUDE_FILE_PATH --passWithNoTests 2>&1 | tail -20"
  }]
}
```

**Playwright variant:**
```json
{
  "matcher": "Edit|Write",
  "hooks": [{
    "type": "command",
    "command": "npx playwright test --grep $(basename $CLAUDE_FILE_PATH .ts) 2>&1 | tail -30"
  }]
}
```

### Auto-Test on File Edit (Python)
```json
{
  "matcher": "Edit|Write",
  "hooks": [{
    "type": "command",
    "command": "python -m pytest tests/ -x --tb=short -q 2>&1 | tail -20"
  }]
}
```

### Lint on File Change
```json
{
  "matcher": "Edit|Write",
  "hooks": [{
    "type": "command",
    "command": "npx eslint $CLAUDE_FILE_PATH --fix 2>&1 | tail -10"
  }]
}
```

### Typecheck on TypeScript Edit
```json
{
  "matcher": "Edit|Write",
  "hooks": [{
    "type": "command",
    "command": "[[ $CLAUDE_FILE_PATH == *.ts* ]] && npx tsc --noEmit 2>&1 | tail -15 || true"
  }]
}
```

### Sound on Completion (macOS)
```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [{
          "type": "command",
          "command": "afplay /System/Library/Sounds/Glass.aiff"
        }]
      }
    ]
  }
}
```

### Stop Hook — Final Validation
Runs before Claude stops to ensure quality.
```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [{
          "type": "command",
          "command": "npm run lint && npm run typecheck 2>&1 | tail -20"
        }]
      }
    ]
  }
}
```

---

## Hook Design Principles

1. **Keep hooks fast** — under 5 seconds. Slow hooks break flow.
2. **Tail the output** — use `| tail -N` to limit what Claude reads back.
3. **Fail gracefully** — use `|| true` for optional checks, let critical ones fail.
4. **Scope narrowly** — only run on relevant file types/paths.
5. **Don't overlap** — if a PostToolUse runs tests, don't also run tests in Stop.

---

## MCP Server Patterns

### Database Access
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://..."]
    }
  }
}
```

### File System (Scoped)
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/allowed/path"]
    }
  }
}
```

### Browser Automation
```json
{
  "mcpServers": {
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    }
  }
}
```

### When to Add MCP Servers

| Need | MCP Server |
|------|-----------|
| Query production DB | postgres/mysql server |
| Browser testing/scraping | puppeteer server |
| Search documentation | fetch/brave-search server |
| File operations outside project | filesystem server (scoped) |
| Custom internal API | Build a custom MCP server |

### When NOT to Use MCP
- If Claude can already do it with Bash (curl, git, npm)
- If the integration is one-off (just use Bash)
- If it requires secrets you don't want in config files

---

## Permission Configuration

Settings in `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm test*)",
      "Bash(npx eslint*)",
      "Bash(npx tsc*)",
      "Bash(git *)",
      "mcp__server_name__tool_name"
    ],
    "deny": [
      "Bash(rm -rf*)",
      "Bash(npm publish*)"
    ]
  }
}
```

### Permission Principles
1. **Allowlist dev commands** — test, lint, typecheck, build
2. **Deny destructive commands** — rm -rf, force push, publish
3. **Scope MCP permissions** — only allow tools Claude actually needs
4. **Review periodically** — remove unused permissions
