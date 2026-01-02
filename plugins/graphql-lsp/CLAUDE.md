# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing GraphQL development support through graphql-lsp server integration and automated hooks for validation, formatting, and linting.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
npm install -g graphql-language-service-cli graphql prettier
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | graphql-lsp server configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/graphql-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Formatting** (`**/*.graphql,*.gql`): Prettier formatting
- **Validation** (`**/*.graphql,*.gql`): Schema and query validation
- **Linting** (`**/*.graphql,*.gql`): graphql-eslint rules
- **Security** (`**/*.graphql,*.gql`): Complexity and depth checks

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use compact output, limit with `head`)
- Use 2-space indentation for GraphQL schemas
- Documentation changes: update both README.md and commands/setup.md if relevant
