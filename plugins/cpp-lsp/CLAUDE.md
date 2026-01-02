# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing C/C++ development support through clangd LSP integration and 14 automated hooks for compilation, linting, formatting, and memory analysis.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
brew install llvm cppcheck
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | clangd LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/cpp-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Conventions

- Prefer minimal diffs
- Keep hooks fast
- Use smart pointers over raw new/delete
- Ensure compile_commands.json exists for proper LSP support
