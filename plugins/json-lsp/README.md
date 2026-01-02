# json-lsp

A Claude Code plugin providing comprehensive JSON development support through:

- **vscode-json-language-server** integration for IDE-like features
- **Automated hooks** for validation and formatting
- **JSON ecosystem** integration (jq, prettier)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install vscode-json-language-server
npm install -g vscode-langservers-extracted

# Install development tools
brew install jq
npm install -g prettier
```

## Features

### LSP Integration

The plugin configures vscode-json-language-server for Claude Code via `.lsp.json`:

```json
{
    "json": {
        "command": "vscode-json-language-server",
        "args": ["--stdio"],
        "extensionToLanguage": {
            ".json": "json",
            ".jsonc": "jsonc"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Schema validation
- Hover documentation
- Code completion
- Document outline
- Real-time diagnostics
- JSON Schema support

### Automated Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `jq-validate` | `**/*.json` | JSON syntax validation |
| `prettier` | `**/*.json` | Formatting |
| `json-todo-fixme` | `**/*.json` | Surface TODO/FIXME comments |

## Required Tools

| Tool | Installation | Purpose |
|------|--------------|---------|
| `vscode-json-language-server` | `npm i -g vscode-langservers-extracted` | LSP server |
| `jq` | `brew install jq` | JSON validation & processing |
| `prettier` | `npm i -g prettier` | Formatting |

## Project Structure

```
json-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # vscode-json-language-server configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   ├── hooks.json            # Hook definitions
│   └── scripts/
│       └── json-hooks.sh
├── tests/
│   └── sample.json           # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## License

MIT
