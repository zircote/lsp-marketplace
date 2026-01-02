# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Java development support through Eclipse JDT LS integration and 12 automated hooks for building, linting, formatting, and testing.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
brew install jdtls
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | jdtls LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/java-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Formatting** (`**/*.java`): google-java-format
- **Building** (`**/*.java`): mvn compile / gradle compileJava
- **Linting** (`**/*.java`): checkstyle, SpotBugs hints
- **Dependencies** (`**/pom.xml`, `**/build.gradle`): validate, updates

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `-q`, limit output with `tail`)
- Documentation changes: update both README.md and commands/setup.md if relevant
