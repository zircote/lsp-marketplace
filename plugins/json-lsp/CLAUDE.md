# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing JSON development support through vscode-json-language-server integration and automated hooks for validation and formatting.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
npm install -g vscode-langservers-extracted prettier
brew install jq
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | vscode-json-language-server configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/json-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Conventions

- Prefer minimal diffs
- Keep hooks fast
- Use 2-space indentation for JSON files
- Prefer explicit JSON over JSONC comments when possible
