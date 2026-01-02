# vue-lsp

A Claude Code plugin providing comprehensive Vue.js development support through:

- **vue-language-server (Volar)** LSP integration for IDE-like features
- **Automated hooks** for linting, formatting, and type checking
- **Vue 3 ecosystem** integration (ESLint, Prettier, TypeScript)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install vue-language-server (Volar)
npm install -g @vue/language-server typescript

# Install development tools
npm install -g eslint prettier
```

## Features

### LSP Integration

The plugin configures vue-language-server (Volar) for Claude Code via `.lsp.json`:

```json
{
    "vue": {
        "command": "vue-language-server",
        "args": ["--stdio"],
        "extensionToLanguage": {
            ".vue": "vue"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Template type checking
- Component prop validation
- Import resolution
- Code actions and quick fixes
- Real-time diagnostics

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### Core Vue Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `vue-format-on-edit` | `**/*.vue` | Auto-format with Prettier |
| `vue-lint-on-edit` | `**/*.vue` | Lint with ESLint (vue plugin) |
| `vue-type-check` | `**/*.vue` | Type check Vue components |

#### JavaScript/TypeScript Support

| Hook | Trigger | Description |
|------|---------|-------------|
| `js-format-on-edit` | `**/*.js,ts,jsx,tsx` | Format JS/TS files |
| `js-lint-on-edit` | `**/*.js,ts,jsx,tsx` | Lint JS/TS files |

#### Quality & Security

| Hook | Trigger | Description |
|------|---------|-------------|
| `vue-todo-fixme` | `**/*.vue,js,ts` | Surface TODO/FIXME/XXX/HACK comments |
| `vue-security-check` | `**/*.vue,js,ts` | Detect eval/innerHTML/v-html usage |

#### Dependencies

| Hook | Trigger | Description |
|------|---------|-------------|
| `npm-audit` | `**/package.json` | Security audit of dependencies |
| `json-validate` | `**/*.json` | Validate JSON syntax |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `vue-language-server` | `npm install -g @vue/language-server` | LSP server (Volar) |
| `typescript` | `npm install -g typescript` | Type checking |

### Recommended

| Tool | Installation | Purpose |
|------|--------------|---------|
| `eslint` | `npm install -g eslint` | Linting |
| `eslint-plugin-vue` | Project-level | Vue-specific linting |
| `prettier` | `npm install -g prettier` | Formatting |

### Optional

| Tool | Installation | Purpose |
|------|--------------|---------|
| `@vitejs/plugin-vue` | Project-level | Vite integration |
| `vue-tsc` | Project-level | Vue TypeScript checking |

## Project Structure

```
vue-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # vue-language-server configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   ├── hooks.json            # Hook definitions
│   └── scripts/
│       └── vue-hooks.sh
├── tests/
│   └── Sample.vue            # Sample Vue 3 component
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### vue-language-server not starting

1. Ensure `package.json` exists in project root
2. Verify installation: `vue-language-server --version`
3. Check LSP config: `cat .lsp.json`

### Type errors not showing in templates

1. Create `tsconfig.json` with Vue support:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "preserve",
    "strict": true
  },
  "vueCompilerOptions": {
    "target": 3
  }
}
```

2. Install Vue TypeScript support: `npm install -D vue-tsc`

### ESLint not recognizing Vue files

Install Vue ESLint plugin in your project:
```bash
npm install -D eslint-plugin-vue
```

Add to `.eslintrc.json`:
```json
{
  "extends": ["plugin:vue/vue3-recommended"]
}
```

## License

MIT
