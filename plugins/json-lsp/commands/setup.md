---
description: Interactive setup for JSON LSP development environment
---

# JSON LSP Setup

This command will configure your JSON development environment with vscode-json-language-server and essential tools.

## Prerequisites Check

First, verify Node.js is installed:

```bash
node --version
npm --version
```

## Installation Steps

### 1. Install vscode-json-language-server

```bash
npm install -g vscode-langservers-extracted
```

This package includes vscode-json-language-server along with HTML, CSS, and ESLint language servers.

### 2. Install Development Tools

```bash
# JSON validation and processing
brew install jq

# Formatting
npm install -g prettier
```

### 3. Verify Installation

```bash
vscode-json-language-server --version
jq --version
prettier --version
```

### 4. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test file
cat > test_lsp.json << 'EOF'
{
  "name": "test",
  "version": "1.0.0",
  "features": [
    "validation",
    "formatting"
  ]
}
EOF

# Run jq validation
jq empty test_lsp.json

# Run prettier
prettier --write test_lsp.json

# Clean up
rm test_lsp.json
```
