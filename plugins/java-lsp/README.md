# java-lsp

A Claude Code plugin providing comprehensive Java development support through:

- **Eclipse JDT LS** integration for IDE-like features
- **12 automated hooks** for Maven/Gradle builds, linting, formatting, and testing
- **Java tool ecosystem** integration (Checkstyle, SpotBugs, JUnit)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# macOS (Homebrew)
brew install jdtls

# Or download from Eclipse
# https://download.eclipse.org/jdtls/snapshots/
```

## Features

### LSP Integration

The plugin configures Eclipse JDT LS for Claude Code via `.lsp.json`:

```json
{
    "java": {
        "command": "jdtls",
        "args": [],
        "extensionToLanguage": { ".java": "java" },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references / implementation
- Hover documentation
- Code actions and quick fixes
- Maven/Gradle project navigation
- Real-time diagnostics

### Automated Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `java-format-on-edit` | `**/*.java` | Auto-format with google-java-format |
| `java-compile-check` | `**/*.java` | Compile with Maven/Gradle |
| `java-checkstyle` | `**/*.java` | Style checking |
| `java-todo-fixme` | `**/*.java` | Surface TODO/FIXME comments |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `jdtls` | `brew install jdtls` | LSP server |
| `java` | JDK 21+ | Java runtime |
| `maven` or `gradle` | Package manager | Build tool |

## Project Structure

```
java-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # jdtls configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   ├── hooks.json            # Hook definitions
│   └── scripts/
│       └── java-hooks.sh
├── tests/
│   └── SampleTest.java       # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## License

MIT
