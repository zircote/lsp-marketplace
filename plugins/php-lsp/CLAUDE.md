# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing PHP development support through Phpactor LSP integration and automated hooks for linting, formatting, static analysis, and testing.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
composer global require phpactor/phpactor friendsofphp/php-cs-fixer phpstan/phpstan squizlabs/php_codesniffer
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | Phpactor LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/php-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Conventions

- Prefer minimal diffs
- Keep hooks fast
- Follow PSR-12 coding standards
- Use type declarations for parameters and return types
