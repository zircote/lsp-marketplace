# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Elixir development support through ElixirLS integration and automated hooks for formatting, linting, and testing.

## Setup

Run `/setup` to install all required tools.

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | ElixirLS configuration |
| `hooks/hooks.json` | Automated development hooks |
| `hooks/scripts/elixir-hooks.sh` | Hook dispatcher script |
| `commands/setup.md` | `/setup` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Conventions

- Prefer minimal diffs
- Keep hooks fast
- Use pattern matching extensively
- Prefer pipe operators for data transformations
