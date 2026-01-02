---
description: Interactive setup for Bash LSP development environment
---

# Bash LSP Setup

This command will configure your Bash/Shell development environment with bash-language-server and essential tools.

## Prerequisites Check

First, verify Node.js is installed:

```bash
node --version
npm --version
```

## Installation Steps

### 1. Install bash-language-server

```bash
npm install -g bash-language-server
```

### 2. Install Development Tools

```bash
# Linting
brew install shellcheck

# Formatting
brew install shfmt
```

### 3. Verify Installation

```bash
bash-language-server --version
shellcheck --version
shfmt --version
```

### 4. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test file
cat > test_lsp.sh << 'EOF'
#!/bin/bash
greet() {
    local name="$1"
    echo "Hello, $name!"
}
greet "World"
EOF

# Run ShellCheck
shellcheck test_lsp.sh

# Run shfmt
shfmt -w test_lsp.sh

# Clean up
rm test_lsp.sh
```
