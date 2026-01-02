# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Swift development support through SourceKit-LSP integration and automated hooks for formatting, linting, and building.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
xcode-select --install
brew install swiftformat swiftlint
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | SourceKit-LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/swift-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Conventions

- Prefer minimal diffs
- Keep hooks fast
- Follow Swift API Design Guidelines
- Use Swift Concurrency (async/await) for asynchronous code
