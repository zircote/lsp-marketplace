# terraform-lsp

A Claude Code plugin providing comprehensive Terraform development support through:

- **terraform-ls LSP** integration for IDE-like features
- **17 automated hooks** for code quality, security, and validation
- **Terraform tool ecosystem** integration (tflint, tfsec, checkov, etc.)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# macOS (Homebrew)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform hashicorp/tap/terraform-ls \
             tflint tfsec checkov terraform-docs infracost terragrunt
```

## Features

### LSP Integration

The plugin configures terraform-ls for Claude Code via `.lsp.json`:

```json
{
    "terraform": {
        "command": "terraform-ls",
        "args": ["serve"],
        "extensionToLanguage": {
            ".tf": "terraform",
            ".tfvars": "terraform-vars"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Code completion for resources, data sources, variables
- Module navigation and IntelliSense
- Real-time diagnostics

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### Core Terraform Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `terraform-fmt-on-edit` | `**/*.tf` | Auto-format with `terraform fmt` |
| `terraform-validate-on-edit` | `**/*.tf` | Validate configuration syntax |
| `terraform-init-check` | `**/*.tf` | Warn if `terraform init` is required |
| `terraform-plan-hint` | `**/main.tf` | Suggest running `terraform plan` |

#### Linting & Quality

| Hook | Trigger | Tool Required | Description |
|------|---------|---------------|-------------|
| `tflint-on-edit` | `**/*.tf` | `tflint` | Best practices and provider-specific linting |
| `terraform-todo-fixme` | `**/*.tf` | - | Surface TODO/FIXME/XXX/HACK comments |

#### Security Scanning

| Hook | Trigger | Tool Required | Description |
|------|---------|---------------|-------------|
| `trivy-on-edit` | `**/*.tf` | `trivy` | Security vulnerability scanning (replaces tfsec) |
| `checkov-on-edit` | `**/*.tf` | `checkov` | Compliance and policy scanning |
| `terraform-sensitive-check` | `**/*.tf` | - | Detect hardcoded secrets |

#### Variable Files

| Hook | Trigger | Description |
|------|---------|-------------|
| `tfvars-fmt-on-edit` | `**/*.tfvars` | Auto-format variable files |
| `tfvars-sensitive-check` | `**/*.tfvars` | Warn about sensitive values |

#### Terragrunt Support

| Hook | Trigger | Tool Required | Description |
|------|---------|---------------|-------------|
| `terragrunt-fmt-on-edit` | `**/terragrunt.hcl` | `terragrunt` | Format Terragrunt files |
| `terragrunt-validate` | `**/terragrunt.hcl` | `terragrunt` | Validate Terragrunt config |

#### Contextual Hints

| Hook | Trigger | Description |
|------|---------|-------------|
| `terraform-docs-hint` | `**/variables.tf` | Suggest documentation update |
| `terraform-cost-hint` | `**/main.tf` | Suggest cost estimation with infracost |
| `terraform-lock-outdated` | `**/.terraform.lock.hcl` | Suggest provider upgrade |

#### Other

| Hook | Trigger | Description |
|------|---------|-------------|
| `markdown-lint-on-edit` | `**/*.md` | Lint markdown files |

## Required Tools

### Core (HashiCorp)

| Tool | Installation | Purpose |
|------|--------------|---------|
| `terraform` | `brew install hashicorp/tap/terraform` | Infrastructure provisioning |
| `terraform-ls` | `brew install hashicorp/tap/terraform-ls` | LSP server |

### Recommended Linting & Security

| Tool | Installation | Purpose |
|------|--------------|---------|
| `tflint` | `brew install tflint` | Terraform linter |
| `trivy` | `brew install trivy` | Security scanner (replaces tfsec) |
| `checkov` | `pip install checkov` | Compliance scanner |

### Optional Utilities

| Tool | Installation | Purpose |
|------|--------------|---------|
| `terraform-docs` | `brew install terraform-docs` | Documentation generator |
| `infracost` | `brew install infracost` | Cost estimation |
| `terragrunt` | `brew install terragrunt` | Multi-environment management |

## Commands

### `/setup`

Interactive setup wizard for configuring the complete Terraform development environment.

**What it does:**

1. **Verifies Terraform installation** - Checks `terraform` CLI is available
2. **Installs terraform-ls** - LSP server for IDE features
3. **Installs linting tools** - TFLint with provider plugins
4. **Installs security scanners** - tfsec and checkov
5. **Validates LSP config** - Confirms `.lsp.json` is correct
6. **Initializes TFLint config** - Sets up `.tflint.hcl` (if needed)
7. **Verifies hooks** - Confirms hooks are properly loaded

**Usage:**

```bash
/setup
```

**Quick install command** (macOS):

```bash
brew tap hashicorp/tap && \
brew install hashicorp/tap/terraform hashicorp/tap/terraform-ls \
             tflint tfsec checkov terraform-docs infracost terragrunt
```

## Configuration

### .tflint.hcl

Initialize TFLint for your cloud provider:

```bash
# Create config
cat > .tflint.hcl << 'EOF'
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
  enabled = true
  version = "0.31.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
EOF

# Install plugins
tflint --init
```

### Customizing Hooks

Edit `hooks/hooks.json` to:
- Disable hooks by removing entries
- Adjust output limits (`head -N`)
- Modify matchers for different file patterns
- Add project-specific hooks

Example - disable a hook:
```json
{
    "name": "checkov-on-edit",
    "enabled": false,
    ...
}
```

## Project Structure

```
terraform-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # terraform-ls configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── hooks.json            # 17 automated hooks
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### terraform-ls not starting

1. Ensure `.tf` files exist in project root
2. Run `terraform init` to initialize providers
3. Verify installation: `terraform-ls --version`
4. Check LSP config: `cat .lsp.json`

### terraform validate fails

Initialize the working directory first:
```bash
terraform init
```

### tflint errors

Initialize and update plugins:
```bash
tflint --init
tflint --init --upgrade
```

### trivy/checkov not detecting issues

1. Verify scanning correct directory
2. Update tools: `brew upgrade trivy checkov`
3. Check for exclusion patterns
4. For trivy: ensure `trivy config` (not `trivy fs`) for IaC scanning

### Hooks not triggering

1. Verify hooks are loaded: `cat hooks/hooks.json`
2. Check file patterns match your structure
3. Ensure required tools are installed (`command -v tflint`)

### Too much output

Reduce `head -N` values in hooks.json for less verbose output.

## License

MIT
