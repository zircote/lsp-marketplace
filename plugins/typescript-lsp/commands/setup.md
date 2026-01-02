---
description: Interactive setup for TypeScript LSP development environment
---

# TypeScript LSP Setup

This command will configure your TypeScript/JavaScript development environment with vtsls LSP and essential tools.

## Prerequisites Check

First, verify Node.js is installed:

```bash
node --version
npm --version
```

## Installation Steps

### 1. Install vtsls LSP Server

```bash
npm install -g @vtsls/language-server typescript
```

### 2. Install Development Tools

**Quick install (all recommended tools):**

```bash
npm install -g eslint prettier typescript-language-server
```

### 3. Verify Installation

```bash
# Check vtsls
vtsls --version

# Check TypeScript
tsc --version

# Check ESLint
eslint --version

# Check Prettier
prettier --version
```

### 4. Create Project Configuration (Optional)

**tsconfig.json:**

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

### 5. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test file
echo 'const greet = (name: string): string => `Hello, ${name}!`;' > test_lsp.ts

# Run type check
npx tsc --noEmit test_lsp.ts

# Clean up
rm test_lsp.ts
```
