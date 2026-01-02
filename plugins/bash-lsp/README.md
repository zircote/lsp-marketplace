# bash-lsp

A Claude Code plugin providing comprehensive Bash/Shell development support through:

- **bash-language-server** integration for IDE-like features
- **Automated hooks** for linting and formatting
- **Shell ecosystem** integration (ShellCheck, shfmt)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install bash-language-server
npm install -g bash-language-server

# Install development tools
brew install shellcheck shfmt
```

## Features

### LSP Integration

The plugin configures bash-language-server for Claude Code via `.lsp.json`:

```json
{
    "bash": {
        "command": "bash-language-server",
        "args": ["start"],
        "extensionToLanguage": {
            ".sh": "shellscript",
            ".bash": "shellscript",
            ".zsh": "shellscript"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Code completion
- Symbol navigation
- Real-time diagnostics

### Automated Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `shellcheck` | `**/*.sh` | Linting and best practices |
| `shfmt` | `**/*.sh` | Code formatting |
| `bash-syntax` | `**/*.sh` | Syntax validation |
| `bash-todo-fixme` | `**/*.sh` | Surface TODO/FIXME comments |

## Required Tools

| Tool | Installation | Purpose |
|------|--------------|---------|
| `bash-language-server` | `npm i -g bash-language-server` | LSP server |
| `shellcheck` | `brew install shellcheck` | Linting |
| `shfmt` | `brew install shfmt` | Formatting |

## Project Structure

```
bash-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # bash-language-server configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── scripts/
│       └── bash-hooks.sh
├── tests/
│   └── sample_test.sh        # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## License

MIT
