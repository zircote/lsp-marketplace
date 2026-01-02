# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Dockerfile development support through docker-langserver LSP integration and automated hooks for linting with hadolint and best practices enforcement.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
# Install docker-langserver
npm install -g dockerfile-language-server-nodejs

# Install hadolint (macOS)
brew install hadolint
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | docker-langserver LSP configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/dockerfile-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite` via `PostToolUse` event. The hook script handles Dockerfile files (exact name `Dockerfile`, `Dockerfile.*` patterns, or `.dockerfile` extension).

**Hook actions:**
- **hadolint** - Linting for best practices and security
- **docker build --check** - Syntax validation (Docker 23.0+)
- **TODO/FIXME detection** - Surface code comments

Hooks use `command -v` checks to skip gracefully when optional tools aren't installed. All commands use `|| true` to prevent hook failures from blocking writes.

## When Modifying Hooks

Edit `hooks/scripts/dockerfile-hooks.sh`. The script receives JSON input via stdin and uses `jq` to extract the file path.

**File detection logic:**
```bash
# Matches: Dockerfile, Dockerfile.dev, Dockerfile.prod, *.dockerfile
if [[ "$filename" == "Dockerfile" ]] || [[ "$filename" == Dockerfile.* ]] || [[ "$ext" == "dockerfile" ]]; then
```

**Best practices:**
- Use `|| true` to prevent hook failures from blocking writes
- Use `2>/dev/null` to suppress stderr noise
- Use `command -v tool >/dev/null 2>&1` for optional tool dependencies
- Keep output concise (hadolint is already brief)

## When Modifying LSP Config

Edit `.lsp.json`. The `extensionToLanguage` map controls which files use the LSP:
- `Dockerfile` (exact match) maps to `dockerfile` language server
- `.dockerfile` extension maps to `dockerfile` language server

Note: Multi-file Dockerfile patterns (e.g., `Dockerfile.dev`) are handled by extension matching.

## Dockerfile-Specific Guidance

### Naming Conventions
Docker supports various Dockerfile naming patterns:
- `Dockerfile` - Standard name
- `Dockerfile.dev`, `Dockerfile.prod` - Environment-specific
- `*.dockerfile` - Alternative extension

The hooks and LSP are configured to handle all common patterns.

### Hadolint Rules
Hadolint enforces best practices including:
- Security (don't run as root, pin versions)
- Performance (layer caching, minimize layers)
- Maintainability (use JSON notation for CMD/ENTRYPOINT)

Users can customize rules with `.hadolint.yaml` in their project root.

### Docker Build Check
The `docker build --check` flag performs syntax validation without actually building. This requires Docker 23.0+. The hook gracefully handles older Docker versions or missing Docker installations.

## Conventions

- Prefer minimal diffs
- Keep hooks fast (hadolint is already quick)
- Documentation changes: update both README.md and commands/setup.md if relevant
- Test hooks manually before committing: run commands directly on a Dockerfile
