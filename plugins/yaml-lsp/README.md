# yaml-lsp

A Claude Code plugin providing comprehensive YAML development support through:

- **yaml-language-server** integration for IDE-like features
- **Automated hooks** for validation and formatting
- **YAML ecosystem** integration (yamllint, prettier)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install yaml-language-server
npm install -g yaml-language-server

# Install development tools
pip install yamllint
npm install -g prettier
```

## Features

### LSP Integration

The plugin configures yaml-language-server for Claude Code via `.lsp.json`:

```json
{
    "yaml": {
        "command": "yaml-language-server",
        "args": ["--stdio"],
        "extensionToLanguage": {
            ".yaml": "yaml",
            ".yml": "yaml"
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

### Automated Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `yamllint` | `**/*.yaml` | YAML validation |
| `prettier` | `**/*.yaml` | Formatting |
| `yq-validate` | `**/*.yaml` | Syntax validation |
| `yaml-todo-fixme` | `**/*.yaml` | Surface TODO/FIXME comments |

## Required Tools

| Tool | Installation | Purpose |
|------|--------------|---------|
| `yaml-language-server` | `npm i -g yaml-language-server` | LSP server |
| `yamllint` | `pip install yamllint` | Validation |
| `prettier` | `npm i -g prettier` | Formatting |
| `yq` | `brew install yq` | YAML processing |

## Project Structure

```
yaml-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # yaml-language-server configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── scripts/
│       └── yaml-hooks.sh
├── tests/
│   └── sample.yaml           # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## License

MIT
