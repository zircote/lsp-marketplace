# Test Files

This directory contains test Terraform configurations for validating the terraform-lsp plugin.

## Purpose

These files are designed to:

1. **Trigger all hooks** - Each file targets specific hooks in `hooks/hooks.json`
2. **Test LSP functionality** - Resources, variables, outputs for completion testing
3. **Validate security scanning** - Intentional issues for trivy/checkov to detect

## Files

| File | Hooks Triggered | Purpose |
|------|-----------------|---------|
| `main.tf` | `terraform-fmt-on-edit`, `terraform-validate-on-edit`, `terraform-init-check`, `tflint-on-edit`, `terraform-plan-hint` | Core terraform resources |
| `variables.tf` | `terraform-fmt-on-edit`, `terraform-docs-hint` | Variable definitions with validation |
| `outputs.tf` | `terraform-fmt-on-edit` | Output value definitions |
| `terraform.tfvars` | `tfvars-fmt-on-edit`, `tfvars-sensitive-check` | Variable values |
| `security_test.tf` | `trivy-on-edit`, `checkov-on-edit`, `terraform-sensitive-check`, `terraform-todo-fixme` | Intentional security issues |

## Running Tests

Use the `/validate` command to run full plugin validation:

```bash
/validate
```

Or manually test individual components:

```bash
# Test terraform-ls
terraform-ls --version

# Test formatting
terraform fmt -check tests/

# Test validation (requires init)
cd tests && terraform init && terraform validate

# Test linting
tflint tests/

# Test security scanning
trivy config tests/
checkov -d tests/
```

## Expected Results

### Hooks

- **Format hooks**: Files should be auto-formatted on save
- **Validate hooks**: Syntax validation should pass
- **Security hooks**: `security_test.tf` should produce warnings for:
  - Unencrypted S3 bucket
  - Overly permissive security group (0.0.0.0/0)
  - RDS without encryption
  - Hardcoded password
- **TODO hook**: Should detect TODO/FIXME comments in `security_test.tf`

### LSP

- Go-to-definition should work for resource references
- Hover should show documentation
- Completion should work for resources, data sources, variables

## Notes

- `security_test.tf` contains INTENTIONAL security issues for testing
- DO NOT use these configurations in production
- Run `terraform init` before validation if LSP needs provider schemas
