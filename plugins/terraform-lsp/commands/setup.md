# Terraform LSP & Toolchain Setup

Set up terraform-ls LSP integration and install all Terraform tools required by the hooks in this project.

## Current Tool Versions (January 2026)

| Tool | Version | Notes |
|------|---------|-------|
| terraform | 1.14.3 | Includes new Actions feature |
| terraform-ls | 0.38.3 | LSP server |
| tflint | 0.60.0 | New .tflint.json config support |
| tfsec | 1.28.14 | **Deprecated** - migrate to Trivy |
| trivy | latest | Recommended replacement for tfsec |
| checkov | 3.2.495 | Python 3.9-3.13 supported |
| terraform-docs | 0.21.0 | |
| infracost | 0.10.43 | |
| terragrunt | 0.94.x | Approaching 1.0 release |

## Instructions

Execute the following setup steps in order:

### 1. Verify Terraform Installation

Check that Terraform is installed:

```bash
terraform --version
```

If not installed, guide the user to https://developer.hashicorp.com/terraform/install or use:

```bash
# macOS (Homebrew)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Linux (apt)
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### 2. Install terraform-ls (Language Server)

Check if terraform-ls is available:

```bash
which terraform-ls || echo "terraform-ls not found"
```

Install terraform-ls:

```bash
# macOS (Homebrew)
brew install hashicorp/tap/terraform-ls

# Linux - download from releases
# https://github.com/hashicorp/terraform-ls/releases

# Or via go install
go install github.com/hashicorp/terraform-ls@latest
```

### 3. Install Required Linting Tools

Install TFLint for configuration linting:

```bash
# macOS (Homebrew)
brew install tflint

# Linux
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Initialize TFLint plugins
tflint --init
```

### 4. Install Security Scanning Tools

**Option A: Trivy (Recommended)**

Trivy has replaced tfsec as Aqua Security's primary IaC scanner:

```bash
# macOS (Homebrew)
brew install trivy

# Linux (apt)
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update && sudo apt-get install trivy

# Scan terraform
trivy config .
```

**Option B: tfsec (Legacy)**

tfsec is deprecated but still functional:

```bash
# macOS (Homebrew)
brew install tfsec

# Linux/macOS (Go)
go install github.com/aquasecurity/tfsec/cmd/tfsec@latest
```

**Checkov** for compliance scanning:

```bash
# pip (Python 3.9-3.13)
pip install checkov

# Homebrew (macOS)
brew install checkov
```

### 5. Install Optional Tools

Documentation generator:

```bash
# macOS (Homebrew)
brew install terraform-docs

# Linux/macOS (Go)
go install github.com/terraform-docs/terraform-docs@v0.21.0
```

Cost estimation:

```bash
# Infracost
brew install infracost

# Or download from https://www.infracost.io/docs/
```

Terragrunt (if using multi-environment setups):

```bash
# macOS (Homebrew)
brew install terragrunt

# Or download from https://terragrunt.gruntwork.io/docs/getting-started/install/
```

### 6. Verify LSP Configuration

Check that `.lsp.json` exists and is properly configured:

```bash
cat .lsp.json
```

Expected configuration:
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

### 7. Initialize TFLint Configuration (recommended)

Create a `.tflint.hcl` configuration file for your project:

```bash
cat > .tflint.hcl << 'EOF'
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
  enabled = true
  version = "0.35.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}
EOF
```

Then initialize plugins:

```bash
tflint --init
```

### 8. Verify Hooks Configuration

Confirm hooks are loaded:

```bash
cat hooks/hooks.json | head -50
```

## Tool Summary

| Tool | Purpose | Hook |
|------|---------|------|
| `terraform-ls` | LSP server for IDE features | Core |
| `terraform fmt` | Code formatting | `terraform-fmt-on-edit` |
| `terraform validate` | Configuration validation | `terraform-validate-on-edit` |
| `tflint` | Linting and best practices | `tflint-on-edit` |
| `tfsec` / `trivy` | Security vulnerability scanning | `tfsec-on-edit` |
| `checkov` | Compliance and policy scanning | `checkov-on-edit` |
| `terraform-docs` | Documentation generation | `terraform-docs-hint` |
| `infracost` | Cost estimation | `terraform-cost-hint` |
| `terragrunt` | Multi-environment management | `terragrunt-*` hooks |

## Troubleshooting

### terraform-ls not starting
- Ensure `.tf` files exist in project root
- Run `terraform init` to initialize providers
- Check terraform-ls logs: `terraform-ls serve -log-file=/tmp/terraform-ls.log`

### terraform validate fails
- Run `terraform init` first to download providers
- Check for syntax errors with `terraform fmt -check`

### tflint errors
- Initialize plugins: `tflint --init`
- Update ruleset: `tflint --init --upgrade`

### tfsec/checkov not finding issues
- Ensure scanning the correct directory
- Check tool is up to date: `brew upgrade tfsec checkov`

### Hooks not running
- Verify Claude Code hooks are enabled in settings
- Check hook matcher patterns match your file structure

## Quick Install (macOS with Homebrew)

One-liner to install everything:

```bash
brew tap hashicorp/tap && \
brew install hashicorp/tap/terraform hashicorp/tap/terraform-ls \
             tflint trivy checkov terraform-docs infracost terragrunt
```

## Quick Install (Linux)

```bash
# Terraform and terraform-ls
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform terraform-ls

# TFLint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Security tools
pip install checkov
sudo apt-get install trivy

# Optional
go install github.com/terraform-docs/terraform-docs@v0.21.0
```

After running these commands, provide a status summary showing which tools were installed successfully and any that failed.

## Sources

- [Terraform Releases](https://releases.hashicorp.com/terraform/)
- [terraform-ls Releases](https://github.com/hashicorp/terraform-ls/releases)
- [TFLint Releases](https://github.com/terraform-linters/tflint/releases)
- [tfsec GitHub](https://github.com/aquasecurity/tfsec) - Note: migrating to Trivy
- [Checkov Releases](https://github.com/bridgecrewio/checkov/releases)
- [terraform-docs Releases](https://github.com/terraform-docs/terraform-docs/releases)
- [Infracost Releases](https://github.com/infracost/infracost/releases)
- [Terragrunt Releases](https://github.com/gruntwork-io/terragrunt/releases)
