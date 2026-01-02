# graphql-lsp

A Claude Code plugin providing comprehensive GraphQL development support through:

- **graphql-lsp** server integration for IDE-like features
- **Automated hooks** for validation, formatting, and linting
- **GraphQL ecosystem** integration (Prettier, GraphQL Code Generator)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install graphql-lsp server
npm install -g graphql-language-service-cli

# Install development tools
npm install -g prettier @graphql-eslint/eslint-plugin
```

## Features

### LSP Integration

The plugin configures graphql-lsp for Claude Code via `.lsp.json`:

```json
{
    "graphql": {
        "command": "graphql-lsp",
        "args": ["server", "-m", "stream"],
        "extensionToLanguage": {
            ".graphql": "graphql",
            ".gql": "graphql"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Schema validation
- Query/mutation validation
- Auto-completion for types and fields
- Real-time diagnostics
- Fragment reference support

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### Core GraphQL Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `graphql-format-on-edit` | `**/*.graphql,*.gql` | Auto-format with Prettier |
| `graphql-validate` | `**/*.graphql,*.gql` | Validate queries against schema |
| `graphql-lint` | `**/*.graphql,*.gql` | Lint with graphql-eslint |

#### Quality & Security

| Hook | Trigger | Description |
|------|---------|-------------|
| `graphql-security-check` | `**/*.graphql,*.gql` | Detect deep nesting and complexity issues |
| `graphql-todo-fixme` | `**/*.graphql,*.gql` | Surface TODO/FIXME comments |

#### Schema Management

| Hook | Trigger | Description |
|------|---------|-------------|
| `graphql-schema-check` | `**/schema.graphql` | Validate schema syntax |
| `json-validate` | `**/*.json` | Validate GraphQL config files |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `graphql-lsp` | `npm install -g graphql-language-service-cli` | LSP server |
| `graphql` | `npm install -g graphql` | GraphQL runtime |

### Recommended

| Tool | Installation | Purpose |
|------|--------------|---------|
| `prettier` | `npm install -g prettier` | Formatting |
| `@graphql-eslint/eslint-plugin` | `npm install -g @graphql-eslint/eslint-plugin` | Linting |

### Optional

| Tool | Installation | Purpose |
|------|--------------|---------|
| `@graphql-codegen/cli` | `npm install -g @graphql-codegen/cli` | Code generation |
| `graphql-inspector` | `npm install -g @graphql-inspector/cli` | Schema diff and validation |

## Project Structure

```
graphql-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # graphql-lsp configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   ├── hooks.json            # Hook definitions
│   └── scripts/
│       └── graphql-hooks.sh
├── tests/
│   └── sample.graphql        # Sample schema
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### graphql-lsp not starting

1. Ensure `.graphqlrc` or `graphql.config.js` exists in project root
2. Verify installation: `graphql-lsp --version`
3. Check LSP config: `cat .lsp.json`

### Schema validation errors

1. Ensure schema file is specified in `.graphqlrc`
2. Verify schema syntax with `graphql-inspector validate`

## License

MIT
