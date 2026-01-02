# scala-lsp

A Claude Code plugin providing comprehensive Scala development support through:

- **Metals** LSP integration for IDE-like features
- **Automated hooks** for formatting, linting, and building
- **Scala ecosystem** integration (Scalafmt, Scalafix, SBT)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install Metals via Coursier
cs install metals

# Install development tools
cs install scalafmt scalafix
```

## Features

### LSP Integration

The plugin configures Metals for Claude Code via `.lsp.json`:

```json
{
    "scala": {
        "command": "metals",
        "args": [],
        "extensionToLanguage": {
            ".scala": "scala",
            ".sc": "scala",
            ".sbt": "sbt"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Code completion
- Refactoring support
- Real-time diagnostics

### Automated Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `scalafmt` | `**/*.scala` | Code formatting |
| `scalafix` | `**/*.scala` | Linting and refactoring |
| `scala-todo-fixme` | `**/*.scala` | Surface TODO/FIXME comments |

## Required Tools

| Tool | Installation | Purpose |
|------|--------------|---------|
| `metals` | `cs install metals` | LSP server |
| `scalafmt` | `cs install scalafmt` | Formatting |
| `scalafix` | `cs install scalafix` | Linting |

## Project Structure

```
scala-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # Metals configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── scripts/
│       └── scala-hooks.sh
├── tests/
│   └── SampleTest.scala      # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## License

MIT
