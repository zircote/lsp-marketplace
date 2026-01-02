# Validate Terraform LSP Plugin

Comprehensive validation of the terraform-lsp plugin including structure, tools, LSP, and hooks.

## Instructions

Execute each validation step and report results using checkmarks for pass, X for fail.

### 1. Plugin Structure Validation

Check required files exist:

```bash
echo "=== Plugin Structure Validation ===" && [ -f "$CLAUDE_PROJECT_DIR/.lsp.json" ] && echo "[PASS] .lsp.json" || echo "[FAIL] .lsp.json"
```

```bash
[ -f "$CLAUDE_PROJECT_DIR/.claude-plugin/plugin.json" ] && echo "[PASS] plugin.json" || echo "[FAIL] plugin.json"
```

```bash
[ -f "$CLAUDE_PROJECT_DIR/hooks/hooks.json" ] && echo "[PASS] hooks.json" || echo "[FAIL] hooks.json"
```

```bash
[ -f "$CLAUDE_PROJECT_DIR/commands/setup.md" ] && echo "[PASS] setup.md" || echo "[FAIL] setup.md"
```

```bash
[ -f "$CLAUDE_PROJECT_DIR/README.md" ] && echo "[PASS] README.md" || echo "[FAIL] README.md"
```

```bash
[ -f "$CLAUDE_PROJECT_DIR/CLAUDE.md" ] && echo "[PASS] CLAUDE.md" || echo "[FAIL] CLAUDE.md"
```

```bash
[ -d "$CLAUDE_PROJECT_DIR/tests" ] && [ -f "$CLAUDE_PROJECT_DIR/tests/main.tf" ] && echo "[PASS] tests/ directory" || echo "[FAIL] tests/ directory"
```

### 2. Configuration Validation

Validate JSON files are parseable:

```bash
echo "=== Configuration Validation ===" && python3 -m json.tool "$CLAUDE_PROJECT_DIR/.lsp.json" > /dev/null 2>&1 && echo "[PASS] .lsp.json valid JSON" || echo "[FAIL] .lsp.json invalid"
```

```bash
python3 -m json.tool "$CLAUDE_PROJECT_DIR/.claude-plugin/plugin.json" > /dev/null 2>&1 && echo "[PASS] plugin.json valid JSON" || echo "[FAIL] plugin.json invalid"
```

```bash
python3 -m json.tool "$CLAUDE_PROJECT_DIR/hooks/hooks.json" > /dev/null 2>&1 && echo "[PASS] hooks.json valid JSON" || echo "[FAIL] hooks.json invalid"
```

```bash
grep -q '"terraform"' "$CLAUDE_PROJECT_DIR/.lsp.json" && echo "[PASS] LSP has terraform entry" || echo "[FAIL] LSP missing terraform entry"
```

```bash
echo "[INFO] Hook count:" && grep -c '"name":' "$CLAUDE_PROJECT_DIR/hooks/hooks.json"
```

### 3. Tool Availability

Check required tools:

```bash
echo "=== Tool Availability ===" && echo "--- Required ---"
```

```bash
terraform --version 2>&1 | head -1
```

```bash
terraform-ls --version 2>&1 | head -1
```

Check recommended tools:

```bash
echo "--- Recommended ---"
```

```bash
tflint --version 2>&1 | head -1 || echo "[WARN] tflint not installed"
```

```bash
trivy --version 2>&1 | head -1 || echo "[WARN] trivy not installed"
```

```bash
checkov --version 2>&1 | head -1 || echo "[WARN] checkov not installed"
```

Check optional tools:

```bash
echo "--- Optional ---"
```

```bash
terraform-docs --version 2>&1 | head -1 || echo "[INFO] terraform-docs not installed"
```

```bash
infracost --version 2>&1 | head -1 || echo "[INFO] infracost not installed"
```

```bash
terragrunt --version 2>&1 | head -1 || echo "[INFO] terragrunt not installed"
```

### 4. Hook Functionality Test

Test format hook:

```bash
echo "=== Hook Functionality Test ===" && echo "--- Format ---" && terraform fmt "$CLAUDE_PROJECT_DIR/tests/main.tf" > /dev/null 2>&1 && echo "[PASS] terraform fmt works" || echo "[FAIL] terraform fmt"
```

Test lint hook:

```bash
echo "--- Lint ---" && tflint --chdir="$CLAUDE_PROJECT_DIR/tests" --format compact 2>&1 | head -10
```

Test trivy security scan:

```bash
echo "--- Security (trivy) ---" && trivy config --severity HIGH,CRITICAL "$CLAUDE_PROJECT_DIR/tests" 2>&1 | grep -E '(HIGH|CRITICAL|Failures|Tests|MEDIUM)' | head -10
```

Test checkov security scan:

```bash
echo "--- Security (checkov) ---" && checkov -f "$CLAUDE_PROJECT_DIR/tests/security_test.tf" --compact --quiet 2>&1 | head -15
```

Test sensitive detection:

```bash
echo "--- Sensitive Detection ---" && grep -inE '(password|secret|api_key)' "$CLAUDE_PROJECT_DIR/tests/security_test.tf" | head -5 && echo "[PASS] Sensitive patterns detected"
```

Test TODO detection:

```bash
echo "--- TODO Detection ---" && grep -nE '(TODO|FIXME)' "$CLAUDE_PROJECT_DIR/tests/security_test.tf" | head -3 && echo "[PASS] TODO/FIXME detected"
```

### 5. Summary Report

Generate summary:

```bash
echo "" && echo "==========================================" && echo "       TERRAFORM-LSP PLUGIN VALIDATION   " && echo "==========================================" && echo ""
```

```bash
echo "Critical Checks:" && [ -f "$CLAUDE_PROJECT_DIR/.lsp.json" ] && echo "  [PASS] LSP config" || echo "  [FAIL] LSP config"
```

```bash
[ -f "$CLAUDE_PROJECT_DIR/.claude-plugin/plugin.json" ] && echo "  [PASS] Plugin manifest" || echo "  [FAIL] Plugin manifest"
```

```bash
[ -f "$CLAUDE_PROJECT_DIR/hooks/hooks.json" ] && echo "  [PASS] Hooks config" || echo "  [FAIL] Hooks config"
```

```bash
command -v terraform-ls > /dev/null 2>&1 && echo "  [PASS] terraform-ls installed" || echo "  [FAIL] terraform-ls not installed"
```

```bash
echo "" && echo "Optional Checks:"
```

```bash
command -v tflint > /dev/null 2>&1 && echo "  [PASS] tflint" || echo "  [WARN] tflint not installed"
```

```bash
command -v trivy > /dev/null 2>&1 && echo "  [PASS] trivy" || echo "  [WARN] trivy not installed"
```

```bash
command -v checkov > /dev/null 2>&1 && echo "  [PASS] checkov" || echo "  [WARN] checkov not installed"
```

## Expected Results

### Pass Criteria
- All plugin structure files exist
- JSON configs are valid and parseable
- terraform-ls is installed
- Security scanning detects intentional issues in `security_test.tf`

### Troubleshooting

| Issue | Solution |
|-------|----------|
| terraform-ls not found | Run `/setup` or `brew install hashicorp/tap/terraform-ls` |
| Invalid JSON | Check for trailing commas, missing quotes |
| tflint errors | Run `tflint --init` to install plugins |
| trivy not detecting issues | Ensure using `trivy config` not `trivy fs` |

## Manual LSP Test

To verify LSP is working in Claude Code:

1. Open any `.tf` file in the `tests/` directory
2. Hover over a resource name - should show documentation
3. Ctrl+click on `aws_s3_bucket.test.id` - should navigate to definition
4. Type `resource "aws_` - should show completion suggestions
