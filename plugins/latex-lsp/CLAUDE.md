# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing LaTeX development support through Texlab LSP integration and automated hooks for linting and quality checks.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
cargo install --locked texlab
brew install chktex  # macOS
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | Texlab LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Linting** (`**/*.tex`): chktex for LaTeX style checking
- **Bibliography** (`**/*.bib`): BibTeX syntax validation
- **Quality** (`**/*.tex`): TODO/FIXME detection

## When Modifying Hooks

Edit `hooks/hooks.json`. Each hook follows this pattern:

```json
{
    "name": "hook-name",
    "event": "afterWrite",
    "hooks": [{ "type": "command", "command": "..." }],
    "matcher": "**/*.tex"
}
```

- Use `|| true` to prevent hook failures from blocking writes
- Use `head -N` to limit output verbosity
- Use `command -v tool >/dev/null &&` for optional tool dependencies

## When Modifying LSP Config

Edit `.lsp.json`. The `extensionToLanguage` map controls which files use the LSP. Current config maps `.tex` files to `latex` and `.bib` files to `bibtex`.

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `-q` for quiet mode, limit output with `head`)
- Documentation changes: update both README.md and commands/setup.md if relevant
