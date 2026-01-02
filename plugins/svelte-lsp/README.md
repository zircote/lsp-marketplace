# svelte-lsp

A Claude Code plugin providing comprehensive Svelte development support through:

- **svelte-language-server** integration for IDE-like features
- **Automated hooks** for formatting, linting, and type checking
- **Svelte ecosystem** integration (svelte-check, ESLint, Prettier)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install svelte-language-server globally
npm install -g svelte-language-server

# Install development tools
npm install -D svelte-check prettier prettier-plugin-svelte eslint eslint-plugin-svelte
```

## Features

### LSP Integration

The plugin configures svelte-language-server for Claude Code via `.lsp.json`.

**Capabilities:**
- Go to definition / references
- Hover documentation
- Code completion
- TypeScript integration
- Real-time diagnostics
- Component prop validation

### Automated Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `prettier-svelte` | `**/*.svelte` | Code formatting with Prettier |
| `svelte-check` | `**/*.svelte` | Type checking and validation |
| `eslint-svelte` | `**/*.svelte` | Linting with ESLint |
| `svelte-todo-fixme` | `**/*.svelte` | Surface TODO/FIXME comments |

## Required Tools

| Tool | Installation | Purpose |
|------|--------------|---------|
| `svelte-language-server` | `npm install -g svelte-language-server` | LSP server |
| `svelte-check` | `npm install -D svelte-check` | Type checking |
| `prettier` | `npm install -D prettier prettier-plugin-svelte` | Formatting |
| `eslint` | `npm install -D eslint eslint-plugin-svelte` | Linting |

## Configuration

### .prettierrc

Create a Prettier configuration for Svelte:

```json
{
  "plugins": ["prettier-plugin-svelte"],
  "overrides": [
    {
      "files": "*.svelte",
      "options": {
        "parser": "svelte"
      }
    }
  ]
}
```

### .eslintrc.json

Configure ESLint for Svelte:

```json
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
  }
}
```

## Project Structure

```
svelte-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # svelte-language-server configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── hooks.json            # Automated hooks
├── tests/
│   └── Sample.svelte         # Sample component for testing
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### svelte-language-server not starting

1. Ensure `.svelte` files exist in project
2. Verify installation: `which svelte-language-server`
3. Check LSP config: `cat .lsp.json`
4. Ensure Node.js is installed: `node --version`

### svelte-check errors

Initialize TypeScript configuration:
```bash
npm install -D typescript
npx svelte-check --init
```

### Prettier not formatting

1. Verify prettier-plugin-svelte is installed
2. Check `.prettierrc` configuration exists
3. Run manually: `npx prettier --write "**/*.svelte"`

### ESLint errors

Initialize ESLint:
```bash
npm init @eslint/config
npm install -D eslint-plugin-svelte
```

### Hooks not triggering

1. Verify hooks are loaded: `cat hooks/hooks.json`
2. Check file patterns match your structure
3. Ensure required tools are in node_modules

## License

MIT
