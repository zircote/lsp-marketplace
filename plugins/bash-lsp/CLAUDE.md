# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Bash/Shell development support through bash-language-server integration and automated hooks for linting and formatting.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
npm install -g bash-language-server
brew install shellcheck shfmt
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | bash-language-server configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/bash-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Conventions

- Prefer minimal diffs
- Keep hooks fast
- Use `set -euo pipefail` for strict mode
- Quote all variable expansions
- Use `[[ ]]` for conditionals
