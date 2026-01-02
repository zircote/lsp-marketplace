# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin providing Terraform development support through terraform-ls LSP integration and 17 automated hooks for code quality, security, and infrastructure validation.

## Setup

Run `/setup` to install all required tools, or manually:

```bash
# macOS (Homebrew)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform hashicorp/tap/terraform-ls \
             tflint trivy checkov terraform-docs infracost terragrunt
```

Run `/validate` to verify the plugin installation and tool availability.

## Key Files

| File | Purpose |
|------|---------|
| `.lsp.json` | terraform-ls LSP configuration |
| `hooks/hooks.json` | 17 automated development hooks |
| `.claude/commands/setup.md` | `/setup` command definition |
| `.claude/commands/validate.md` | `/validate` command definition |
| `.claude-plugin/plugin.json` | Plugin metadata |

## Hook System

All hooks trigger on `PostToolUse` after `Write|Edit` operations. Hooks use `command -v` checks to skip gracefully when optional tools aren't installed.

**Hook categories:**
- **Core** (`.tf`): format, validate, init check, plan hint
- **Linting** (`.tf`): tflint, todo/fixme detection
- **Security** (`.tf`): trivy, checkov, sensitive value detection
- **Variables** (`.tfvars`): format, sensitive check
- **Terragrunt** (`terragrunt.hcl`): format, validate
- **Hints** (`main.tf`, `variables.tf`): docs, cost, provider upgrade suggestions

## When Modifying Hooks

Edit `hooks/hooks.json`. The hooks use Claude Code's standard event-based format:

```json
{
    "hooks": {
        "PostToolUse": [
            {
                "matcher": "Write|Edit",
                "hooks": [{ "type": "command", "command": "..." }],
                "conditions": { "fileExtensions": [".tf"] }
            }
        ]
    }
}
```

**Key fields:**
- `matcher`: Tool name pattern (e.g., `Write|Edit` for file operations)
- `conditions.fileExtensions`: File types to match (e.g., `[".tf", ".tfvars"]`)
- `conditions.pathPatterns`: Path globs for specific files (e.g., `["**/main.tf"]`)

**Best practices:**
- Use `|| true` to prevent hook failures from blocking writes
- Use `head -N` to limit output verbosity
- Use `command -v tool >/dev/null &&` for optional tool dependencies
- Use `cd "$(dirname "$CLAUDE_FILE_PATH")"` for directory-scoped commands

## When Modifying LSP Config

Edit `.lsp.json`. The `extensionToLanguage` map controls which files use the LSP:
- `.tf` files map to `terraform` language server
- `.tfvars` files map to `terraform-vars` language server

## Terraform-Specific Guidance

### Directory Structure
Terraform validation and init require working in the correct directory. Hooks use `cd "$(dirname "$CLAUDE_FILE_PATH")"` to ensure commands run in the module directory.

### Provider Initialization
Many terraform commands require `terraform init` first. The `terraform-init-check` hook warns when `.terraform` directory is missing.

### Security Scanning
The plugin includes three layers of security scanning:
1. `trivy` - Fast security vulnerability scanning (replaces deprecated tfsec)
2. `checkov` - Compliance and policy scanning
3. `terraform-sensitive-check` - Detects hardcoded secrets in config

## Conventions

- Prefer minimal diffs
- Keep hooks fast (use `--compact`, limit output with `head`)
- Documentation changes: update both README.md and commands/setup.md if relevant
- Test hooks manually before committing: run the command directly on a `.tf` file
