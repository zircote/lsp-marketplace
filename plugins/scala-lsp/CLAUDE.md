# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Scala development support through Metals LSP integration and automated hooks for formatting, linting, and building.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
cs install metals scalafmt scalafix
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | Metals LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/scala-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Conventions

- Prefer minimal diffs
- Keep hooks fast
- Use immutable data structures
- Prefer pattern matching over conditionals
