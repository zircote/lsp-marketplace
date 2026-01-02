# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Lua development support through lua-language-server LSP integration and 10 automated hooks for linting, formatting, and code quality.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
brew install lua-language-server  # macOS
cargo install stylua
luarocks install luacheck
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | lua-language-server LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/lua-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Formatting** (`**/*.lua`): StyLua
- **Linting** (`**/*.lua`): Luacheck, syntax validation
- **Quality** (`**/*.lua`): TODO/FIXME detection, complexity checks

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `--check` for validation, limit output with `head`)
- Documentation changes: update both README.md and commands/setup.md if relevant
- Follow Lua naming conventions (snake_case for functions, PascalCase for classes/modules)
