# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Kotlin development support through kotlin-language-server integration and 12 automated hooks for building, linting, formatting, and testing.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
brew install kotlin-language-server ktlint detekt
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | kotlin-language-server LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/kotlin-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Conventions

- Prefer minimal diffs
- Keep hooks fast
- Watch for !! (non-null assertions) - prefer safer alternatives
