# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Haskell development support through haskell-language-server (HLS) integration and automated hooks for formatting, linting, and code quality.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
ghcup install ghc latest
ghcup install cabal latest
ghcup install hls latest
cabal update
cabal install hlint ormolu
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | haskell-language-server configuration |
| `hooks/hooks.json` | Automated development hooks |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Core** (`**/*.hs`): format (ormolu/fourmolu), lint (hlint), build check
- **Quality** (`**/*.hs`, `**/src/**/*.hs`): todo/fixme, warnings, haddock check

## When Modifying Hooks

Edit `hooks/hooks.json`. Each hook follows this pattern:

```json
{
    "name": "hook-name",
    "event": "afterWrite",
    "hooks": [{ "type": "command", "command": "..." }],
    "matcher": "**/*.hs"
}
```

- Use `|| true` to prevent hook failures from blocking writes
- Use `head -N` to limit output verbosity
- Use `command -v tool >/dev/null &&` for optional tool dependencies

## When Modifying LSP Config

Edit `.lsp.json`. The `extensionToLanguage` map controls which files use the LSP. Current config maps `.hs` and `.lhs` files to the `haskell` language server.

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `--fast` where available, limit output with `head`)
- Documentation changes: update both README.md and commands/setup.md if relevant
- Use type signatures for all top-level functions
- Prefer pointfree style where it improves readability
