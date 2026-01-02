---
description: Interactive setup for HTML/CSS LSP development environment
---

# HTML/CSS LSP Setup

This command will configure your HTML/CSS development environment with vscode language servers and essential tools.

## Prerequisites Check

First, verify Node.js is installed:

```bash
node --version
npm --version
```

## Installation Steps

### 1. Install HTML/CSS Language Servers

```bash
npm install -g vscode-langservers-extracted
```

This package includes:
- `vscode-html-language-server` - HTML language support
- `vscode-css-language-server` - CSS/SCSS/LESS language support
- `vscode-json-language-server` - JSON language support
- `vscode-eslint-language-server` - ESLint integration

### 2. Install Development Tools

**Quick install (all recommended tools):**

```bash
npm install -g prettier stylelint stylelint-config-standard
```

### 3. Verify Installation

```bash
# Check language servers
vscode-html-language-server --version
vscode-css-language-server --version

# Check formatting/linting tools
prettier --version
stylelint --version
```

### 4. Create Project Configuration (Optional)

**.prettierrc:**

```json
{
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": false,
  "trailingComma": "es5",
  "bracketSpacing": true,
  "htmlWhitespaceSensitivity": "css"
}
```

**.stylelintrc.json:**

```json
{
  "extends": "stylelint-config-standard",
  "rules": {
    "indentation": 2,
    "string-quotes": "double",
    "color-hex-case": "lower"
  }
}
```

### 5. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create test files
echo '<!DOCTYPE html><html><head><title>Test</title></head><body><h1>Hello World</h1></body></html>' > test_lsp.html
echo 'body { margin: 0; padding: 0; font-family: sans-serif; }' > test_lsp.css

# Run Prettier
prettier --write test_lsp.html test_lsp.css

# Run stylelint
stylelint test_lsp.css

# Clean up
rm test_lsp.html test_lsp.css
```
