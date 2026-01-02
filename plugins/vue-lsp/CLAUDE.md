# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Vue.js development support through vue-language-server (Volar) LSP integration and automated hooks for linting, formatting, type checking, and security scanning.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
npm install -g @vue/language-server typescript eslint prettier
```

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | vue-language-server (Volar) configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/vue-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger `afterWrite`. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Formatting** (`**/*.vue,js,ts,jsx,tsx`): prettier format
- **Linting** (`**/*.vue,js,ts,jsx,tsx`): eslint with vue plugin
- **Type Checking** (`**/*.vue`): TypeScript + Vue template checking
- **Security** (`**/*.vue,js,ts`): v-html/eval/innerHTML detection
- **Dependencies** (`**/package.json`): npm audit, JSON validation

## Conventions

- Prefer Vue 3 Composition API with `<script setup>` syntax
- Keep hooks fast (use `--format compact`, limit output with `head`)
- Documentation changes: update both README.md and commands/setup.md if relevant
