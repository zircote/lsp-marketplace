# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing C# development support through OmniSharp LSP integration and 12 automated hooks for .NET builds, linting, formatting, and testing.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
brew install omnisharp
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | OmniSharp LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/csharp-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Conventions

- Prefer minimal diffs
- Keep hooks fast
- Use nullable reference types
- Prefer async/await throughout (avoid .Result/.Wait())
