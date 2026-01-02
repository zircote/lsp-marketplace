# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Go development support through gopls LSP integration and 14 automated hooks for linting, formatting, testing, and security scanning.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
go install golang.org/x/tools/gopls@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install golang.org/x/vuln/cmd/govulncheck@latest
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | gopls LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/go-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Formatting** (`**/*.go`): goimports/gofmt
- **Linting** (`**/*.go`): go vet, golangci-lint
- **Security** (`**/*.go`, `**/go.mod`): gosec, govulncheck
- **Dependencies** (`**/go.mod`): go mod tidy, verify

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `--fast`, limit output with `head`)
- Documentation changes: update both README.md and commands/setup.md if relevant
