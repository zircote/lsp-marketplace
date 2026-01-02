# swift-lsp

A Claude Code plugin providing comprehensive Swift development support through:

- **SourceKit-LSP** integration for IDE-like features
- **Automated hooks** for formatting, linting, and building
- **Swift ecosystem** integration (SwiftFormat, SwiftLint)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# SourceKit-LSP is included with Xcode
xcode-select --install

# Install development tools
brew install swiftformat swiftlint
```

## Features

### LSP Integration

The plugin configures SourceKit-LSP for Claude Code via `.lsp.json`:

```json
{
    "swift": {
        "command": "sourcekit-lsp",
        "args": [],
        "extensionToLanguage": {
            ".swift": "swift"
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
| `swiftformat` | `**/*.swift` | Code formatting |
| `swiftlint` | `**/*.swift` | Linting and style checks |
| `swift-syntax` | `**/*.swift` | Syntax validation |
| `swift-todo-fixme` | `**/*.swift` | Surface TODO/FIXME comments |

## Required Tools

| Tool | Installation | Purpose |
|------|--------------|---------|
| `sourcekit-lsp` | Included with Xcode | LSP server |
| `swiftformat` | `brew install swiftformat` | Formatting |
| `swiftlint` | `brew install swiftlint` | Linting |

## Project Structure

```
swift-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # SourceKit-LSP configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── scripts/
│       └── swift-hooks.sh
├── tests/
│   └── SampleTest.swift      # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## License

MIT
