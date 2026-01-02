# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing YAML development support through yaml-language-server integration and automated hooks for validation and formatting.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
npm install -g yaml-language-server prettier
pip install yamllint
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | yaml-language-server configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/yaml-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Conventions

- Prefer minimal diffs
- Keep hooks fast
- Use 2-space indentation
- Prefer explicit keys over anchors for clarity
