---
description: Interactive setup for Svelte LSP development environment
---

# Svelte LSP Setup

This command will configure your Svelte development environment with svelte-language-server and essential tools.

## Current Tool Versions (January 2026)

| Tool | Version | Notes |
|------|---------|-------|
| svelte-language-server | 0.17.x | LSP server |
| svelte-check | 4.0.x | Type checking |
| prettier | 3.x | Code formatter |
| prettier-plugin-svelte | 3.x | Svelte formatter |
| eslint | 9.x | Linter |
| eslint-plugin-svelte | 3.x | Svelte linter |

## Prerequisites Check

First, verify Node.js is installed:

```bash
node --version
npm --version
```

If not installed, download from https://nodejs.org/ or use a version manager:

```bash
# macOS (Homebrew)
brew install node

# Linux (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install --lts
```

## Installation Steps

### 1. Install svelte-language-server (Global)

Check if svelte-language-server is available:

```bash
which svelte-language-server || echo "svelte-language-server not found"
```

Install globally:

```bash
npm install -g svelte-language-server
```

Verify installation:

```bash
svelte-language-server --version
```

### 2. Install Development Tools (Project-Level)

If you're in a Svelte project, install development dependencies:

```bash
# Type checking
npm install -D svelte-check

# Formatting
npm install -D prettier prettier-plugin-svelte

# Linting
npm install -D eslint eslint-plugin-svelte
```

### 3. Configure Prettier

Create `.prettierrc` in your project root:

```bash
cat > .prettierrc << 'EOF'
{
  "plugins": ["prettier-plugin-svelte"],
  "semi": true,
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "overrides": [
    {
      "files": "*.svelte",
      "options": {
        "parser": "svelte"
      }
    }
  ]
}
EOF
```

### 4. Configure ESLint

Initialize ESLint configuration:

```bash
# Create .eslintrc.json
cat > .eslintrc.json << 'EOF'
{
  "extends": ["eslint:recommended", "plugin:svelte/recommended"],
  "parserOptions": {
    "ecmaVersion": 2020,
    "sourceType": "module"
  },
  "env": {
    "browser": true,
    "es2017": true,
    "node": true
  },
  "rules": {
    "no-unused-vars": ["warn", { "argsIgnorePattern": "^_" }]
  }
}
EOF
```

### 5. Initialize TypeScript Support (Optional)

For TypeScript support in Svelte components:

```bash
# Install TypeScript
npm install -D typescript

# Initialize svelte-check configuration
npx svelte-check --init
```

This creates a `tsconfig.json` file configured for Svelte.

### 6. Verify LSP Configuration

Check that `.lsp.json` exists and is properly configured:

```bash
cat .lsp.json
```

Expected configuration:
```json
{
    "svelte": {
        "command": "svelte-language-server",
        "args": ["--stdio"],
        "extensionToLanguage": {
            ".svelte": "svelte"
        },
        "transport": "stdio"
    }
}
```

### 7. Verify Hooks Configuration

Confirm hooks are loaded:

```bash
cat hooks/hooks.json | head -50
```

### 8. Test the Setup

Create a test component and verify tooling:

```bash
# Create test file
cat > Test.svelte << 'EOF'
<script>
  let count = 0;
  function increment() {
    count += 1;
  }
</script>

<button on:click={increment}>
  Count: {count}
</button>

<style>
  button {
    padding: 0.5rem 1rem;
    font-size: 1rem;
  }
</style>
EOF

# Test formatting
npx prettier --check Test.svelte

# Test linting
npx eslint Test.svelte

# Test type checking
npx svelte-check --threshold warning

# Clean up
rm Test.svelte
```

## Tool Summary

| Tool | Purpose | Hook |
|------|---------|------|
| `svelte-language-server` | LSP server for IDE features | Core |
| `prettier` | Code formatting | `prettier-svelte` |
| `svelte-check` | Type checking and validation | `svelte-check` |
| `eslint` | Linting | `eslint-svelte` |

## Troubleshooting

### svelte-language-server not starting

1. Ensure `.svelte` files exist in project
2. Verify global installation: `npm list -g svelte-language-server`
3. Check Node.js version: `node --version` (requires v16+)
4. Try reinstalling: `npm install -g svelte-language-server --force`

### svelte-check errors

1. Ensure svelte is installed: `npm install -D svelte`
2. Initialize TypeScript: `npx svelte-check --init`
3. Check for missing peer dependencies: `npm install`

### Prettier not formatting Svelte files

1. Verify prettier-plugin-svelte is installed: `npm list prettier-plugin-svelte`
2. Check `.prettierrc` has the plugin configured
3. Test manually: `npx prettier --write "*.svelte"`

### ESLint errors

1. Ensure eslint-plugin-svelte is installed: `npm list eslint-plugin-svelte`
2. Update ESLint config to extend `plugin:svelte/recommended`
3. Check compatibility: `npm list eslint` (version 8.x or 9.x)

### Hooks not running

1. Verify Claude Code hooks are enabled
2. Check hook matcher patterns match your file structure
3. Ensure tools are installed: `command -v npx`

## Quick Install (Project with package.json)

One-liner to install all development tools:

```bash
npm install -D svelte-check prettier prettier-plugin-svelte eslint eslint-plugin-svelte typescript
```

## Quick Install (Global + Project Setup)

```bash
# Global LSP server
npm install -g svelte-language-server

# Project tools
npm install -D svelte-check prettier prettier-plugin-svelte eslint eslint-plugin-svelte

# Initialize configurations
npx prettier --init
npx eslint --init
```

After running these commands, provide a status summary showing which tools were installed successfully and any that failed.

## Sources

- [Svelte Language Server](https://github.com/sveltejs/language-tools/tree/master/packages/language-server)
- [svelte-check](https://github.com/sveltejs/language-tools/tree/master/packages/svelte-check)
- [Prettier Plugin Svelte](https://github.com/sveltejs/prettier-plugin-svelte)
- [ESLint Plugin Svelte](https://github.com/sveltejs/eslint-plugin-svelte)
