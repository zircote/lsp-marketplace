# kotlin-lsp

A Claude Code plugin providing comprehensive Kotlin development support through:

- **kotlin-language-server** integration for IDE-like features
- **12 automated hooks** for Gradle builds, linting, formatting, and testing
- **Kotlin tool ecosystem** integration (detekt, ktlint)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# macOS (Homebrew)
brew install kotlin-language-server
brew install ktlint detekt
```

## Features

### LSP Integration

The plugin configures kotlin-language-server for Claude Code via `.lsp.json`:

```json
{
    "kotlin": {
        "command": "kotlin-language-server",
        "args": [],
        "extensionToLanguage": { ".kt": "kotlin", ".kts": "kotlin" },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Code completion with null safety
- Coroutine-aware navigation
- Real-time diagnostics

### Automated Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `kotlin-format-on-edit` | `**/*.kt` | Auto-format with ktlint |
| `kotlin-lint-on-edit` | `**/*.kt` | Lint with detekt |
| `kotlin-compile-check` | `**/*.kt` | Compile with Gradle |
| `kotlin-null-check` | `**/*.kt` | Detect !! usage |

## Required Tools

| Tool | Installation | Purpose |
|------|--------------|---------|
| `kotlin-language-server` | `brew install kotlin-language-server` | LSP server |
| `ktlint` | `brew install ktlint` | Linting & formatting |
| `detekt` | `brew install detekt` | Static analysis |

## Project Structure

```
kotlin-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # kotlin-language-server configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── scripts/
│       └── kotlin-hooks.sh
├── tests/
│   └── SampleTest.kt         # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## License

MIT
