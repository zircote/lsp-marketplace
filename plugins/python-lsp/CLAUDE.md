# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Python development support through Pyright LSP integration and 15 automated hooks for type checking, linting, formatting, testing, and security scanning.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
npm install -g pyright
pip install ruff black isort mypy bandit pytest pip-audit
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | Pyright LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/python-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Formatting** (`**/*.py`): black/ruff format, isort
- **Linting** (`**/*.py`): ruff/flake8, type checking
- **Security** (`**/*.py`): bandit, pip-audit
- **Dependencies** (`**/requirements.txt`, `**/pyproject.toml`): audit, validation

## When Modifying Hooks

Edit `hooks/scripts/python-hooks.sh`. The script handles different file types and runs appropriate tools:

- Use `|| true` to prevent hook failures from blocking writes
- Use `head -N` to limit output verbosity
- Use `command -v tool >/dev/null &&` for optional tool dependencies

## When Modifying LSP Config

Edit `.lsp.json`. The `extensionToLanguage` map controls which files use the LSP. Current config maps `.py` and `.pyi` files to the `python` language server.

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `--quiet`, limit output with `head`)
- Documentation changes: update both README.md and commands/setup.md if relevant
