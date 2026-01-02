# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing SQL development support through sql-language-server LSP integration and sqlfluff for linting and formatting.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
npm install -g sql-language-server
pip install sqlfluff
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | sql-language-server LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Formatting** (`**/*.sql`): sqlfluff format
- **Linting** (`**/*.sql`): sqlfluff lint
- **Quality** (`**/*.sql`): TODO/FIXME detection

## When Modifying Hooks

Edit `hooks/hooks.json`. The script handles SQL files and runs appropriate tools:

- Use `|| true` to prevent hook failures from blocking writes
- Use `head -N` to limit output verbosity
- Use `command -v tool >/dev/null &&` for optional tool dependencies

## When Modifying LSP Config

Edit `.lsp.json`. The `extensionToLanguage` map controls which files use the LSP. Current config maps `.sql` files to the `sql` language server.

## SQL-Specific Guidance

### Dialect Support
sqlfluff supports multiple SQL dialects (postgres, mysql, sqlite, bigquery, etc.). Users should configure their dialect in `.sqlfluff` config file.

### Formatting vs Linting
- `sqlfluff format` - Rewrites SQL to conform to style guide
- `sqlfluff lint` - Reports issues without modifying files

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `--quiet`, limit output with `head`)
- Documentation changes: update both README.md and commands/setup.md if relevant
