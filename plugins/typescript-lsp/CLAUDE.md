# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing TypeScript/JavaScript development support through vtsls LSP integration and 16 automated hooks for type checking, linting, formatting, testing, and security scanning.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
npm install -g @vtsls/language-server typescript eslint prettier
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | vtsls LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/typescript-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Formatting** (`**/*.ts,tsx,js,jsx`): prettier/biome format
- **Linting** (`**/*.ts,tsx,js,jsx`): eslint/biome, type checking
- **Security** (`**/*.ts,tsx,js,jsx`): eval/innerHTML detection
- **Dependencies** (`**/package.json`): npm audit, JSON validation

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `--format compact`, limit output with `head`)
- Documentation changes: update both README.md and commands/setup.md if relevant
