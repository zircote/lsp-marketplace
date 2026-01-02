# typescript-lsp

A Claude Code plugin providing comprehensive TypeScript/JavaScript development support through:

- **vtsls LSP** integration for IDE-like features
- **16 automated hooks** for type checking, linting, formatting, and testing
- **Node.js ecosystem** integration (ESLint, Prettier, Jest, Vitest)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install vtsls LSP
npm install -g @vtsls/language-server typescript

# Install development tools
npm install -g eslint prettier
```

## Features

### LSP Integration

The plugin configures vtsls for Claude Code via `.lsp.json`:

```json
{
    "typescript": {
        "command": "vtsls",
        "args": ["--stdio"],
        "extensionToLanguage": {
            ".ts": "typescript", ".tsx": "typescriptreact",
            ".js": "javascript", ".jsx": "javascriptreact"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Type inference and checking
- Import resolution
- Code actions and quick fixes
- Real-time diagnostics

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### Core TypeScript Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `ts-format-on-edit` | `**/*.ts,tsx,js,jsx` | Auto-format with Prettier or Biome |
| `ts-lint-on-edit` | `**/*.ts,tsx,js,jsx` | Lint with ESLint or Biome |
| `ts-type-check` | `**/*.ts,tsx` | Type check with tsc |

#### Quality & Security

| Hook | Trigger | Description |
|------|---------|-------------|
| `ts-todo-fixme` | `**/*.ts,tsx,js,jsx` | Surface TODO/FIXME/XXX/HACK comments |
| `ts-security-check` | `**/*.ts,tsx,js,jsx` | Detect eval/innerHTML/document.write |
| `ts-console-check` | `**/*.ts,tsx,js,jsx` | Warn about console statements |

#### Dependencies

| Hook | Trigger | Description |
|------|---------|-------------|
| `npm-audit` | `**/package.json` | Security audit of dependencies |
| `json-validate` | `**/*.json` | Validate JSON syntax |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `vtsls` | `npm install -g @vtsls/language-server` | LSP server |
| `typescript` | `npm install -g typescript` | Type checking |

### Recommended

| Tool | Installation | Purpose |
|------|--------------|---------|
| `eslint` | `npm install -g eslint` | Linting |
| `prettier` | `npm install -g prettier` | Formatting |

### Optional

| Tool | Installation | Purpose |
|------|--------------|---------|
| `biome` | `npm install -g @biomejs/biome` | Fast linter & formatter |
| `jest` | `npm install -g jest` | Testing |
| `vitest` | Project-level | Fast testing |

## Project Structure

```
typescript-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # vtsls configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   ├── hooks.json            # Hook definitions
│   └── scripts/
│       └── typescript-hooks.sh
├── tests/
│   └── sample.test.ts        # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### vtsls not starting

1. Ensure `tsconfig.json` exists in project root
2. Verify installation: `vtsls --version`
3. Check LSP config: `cat .lsp.json`

### Type errors not showing

1. Create or update `tsconfig.json`
2. Run `npx tsc --noEmit` manually

## License

MIT
