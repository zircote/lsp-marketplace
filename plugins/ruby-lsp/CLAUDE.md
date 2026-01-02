# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Ruby development support through Shopify's ruby-lsp integration and 12 automated hooks for linting, formatting, testing, and security scanning.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
gem install ruby-lsp rubocop bundler-audit brakeman
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | ruby-lsp LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/ruby-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Conventions

- Prefer minimal diffs
- Keep hooks fast
- Use strong parameters in Rails controllers
- Avoid string interpolation in SQL queries
