---
description: Interactive setup for YAML LSP development environment
---

# YAML LSP Setup

This command will configure your YAML development environment with yaml-language-server and essential tools.

## Prerequisites Check

First, verify Node.js and Python are installed:

```bash
node --version
npm --version
python3 --version
```

## Installation Steps

### 1. Install yaml-language-server

```bash
npm install -g yaml-language-server
```

### 2. Install Development Tools

```bash
# Validation
pip install yamllint

# Formatting
npm install -g prettier

# YAML processing
brew install yq
```

### 3. Verify Installation

```bash
yaml-language-server --version
yamllint --version
prettier --version
yq --version
```

### 4. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test file
cat > test_lsp.yaml << 'EOF'
name: Test
version: 1.0.0
features:
  - validation
  - formatting
EOF

# Run yamllint
yamllint test_lsp.yaml

# Run prettier
prettier --write test_lsp.yaml

# Clean up
rm test_lsp.yaml
```
