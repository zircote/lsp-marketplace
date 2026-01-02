# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing HTML/CSS development support through vscode-html-language-server and vscode-css-language-server LSP integration, with automated hooks for formatting, linting, and validation.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
npm install -g vscode-langservers-extracted prettier stylelint stylelint-config-standard
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | HTML/CSS LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/html-css-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **HTML Formatting** (`**/*.html,htm`): Prettier format, HTML5 validation
- **CSS Formatting** (`**/*.css,scss,less`): Prettier format, stylelint
- **Validation** (`**/*.html,css`): Syntax validation, standards compliance

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `--format compact`, limit output with `head`)
- Documentation changes: update both README.md and commands/setup.md if relevant
- Follow HTML5 and CSS3 standards
