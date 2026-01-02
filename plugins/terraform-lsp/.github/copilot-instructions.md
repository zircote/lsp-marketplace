# Copilot instructions

You are working in a Claude Code plugin for Terraform development with terraform-ls LSP integration.

## Priorities

1. Keep changes small and reviewable.
2. Hooks must be fast - use `head -N` to limit output, `|| true` to prevent blocking.
3. Update documentation when you change developer-facing behavior.

## Commands

- Setup: `/setup` (installs terraform-ls, tflint, trivy, checkov)
- Validate: `/validate` (verifies plugin installation)

## Key Files

- `.lsp.json` - terraform-ls LSP configuration
- `hooks/hooks.json` - 17 automated hooks
- `.claude/commands/*.md` - slash commands

## Hook Patterns

- Use `command -v tool >/dev/null &&` for optional dependencies
- Use `cd "$(dirname "$CLAUDE_FILE_PATH")"` for directory-scoped commands
- All hooks trigger on `afterWrite`
