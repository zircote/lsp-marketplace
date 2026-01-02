# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Svelte development support through svelte-language-server LSP integration and automated hooks for formatting, linting, and type checking.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
# Global LSP server
npm install -g svelte-language-server

# Project development tools
npm install -D svelte-check prettier prettier-plugin-svelte eslint eslint-plugin-svelte
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | svelte-language-server configuration |
| `hooks/hooks.json` | Automated development hooks |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger on `PostToolUse` after `Write|Edit` operations. Hooks use graceful degradation when optional tools aren't installed.

**Hook categories:**
- **Formatting** (`.svelte`): Prettier with svelte plugin
- **Type Checking** (`.svelte`): svelte-check for component validation
- **Linting** (`.svelte`): ESLint with svelte plugin
- **Hints** (`.svelte`): TODO/FIXME detection

## When Modifying Hooks

Edit `hooks/hooks.json`. The hooks use Claude Code's standard event-based format:

```json
{
    "hooks": {
        "PostToolUse": [
            {
                "matcher": "Write|Edit",
                "hooks": [{ "type": "command", "command": "..." }],
                "conditions": { "fileExtensions": [".svelte"] }
            }
        ]
    }
}
```

**Best practices:**
- Use `|| true` to prevent hook failures from blocking writes
- Use `head -N` to limit output verbosity
- Use `command -v tool >/dev/null &&` for optional tool dependencies
- Use `npx` to run local node_modules binaries

## Svelte-Specific Guidance

### Component Structure
Svelte components use three sections:
- `<script>` - Component logic (JavaScript/TypeScript)
- `<style>` - Scoped CSS
- Markup - HTML with Svelte syntax

### TypeScript Support
Enable TypeScript in components with `<script lang="ts">`. The svelte-check tool validates types across components.

### Dependencies
Svelte tooling typically requires:
- Node.js 16+
- svelte compiler (usually in project deps)
- TypeScript (for type checking)

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `--no-config-lookup` flags where available)
- Documentation changes: update both README.md and commands/setup.md if relevant
- Test hooks manually before committing: run commands directly on a `.svelte` file
