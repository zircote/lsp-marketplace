# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Zig development support through ZLS (Zig Language Server) integration and automated hooks for formatting, compilation checks, and code quality.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
# macOS
brew install zig zls

# Or build from source
git clone https://github.com/zigtools/zls
cd zls
zig build -Doptimize=ReleaseSafe
sudo cp zig-out/bin/zls /usr/local/bin/
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | ZLS LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Formatting** (`**/*.zig`): zig fmt
- **Compilation** (`**/*.zig`): zig build check, zig ast-check
- **Quality** (`**/*.zig`): TODO/FIXME detection

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `--check` for formatting, limit output with `head`)
- Documentation changes: update both README.md and commands/setup.md if relevant
- Use `zig fmt` for all code formatting (enforces standard Zig style)
