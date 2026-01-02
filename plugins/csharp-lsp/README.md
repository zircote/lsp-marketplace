# csharp-lsp

A Claude Code plugin providing comprehensive C# development support through:

- **OmniSharp LSP** integration for IDE-like features
- **12 automated hooks** for .NET builds, linting, formatting, and testing
- **.NET ecosystem** integration (dotnet CLI, xUnit, NuGet)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# macOS (Homebrew)
brew install omnisharp
# or
dotnet tool install --global csharp-ls
```

## Features

### LSP Integration

The plugin configures OmniSharp for Claude Code via `.lsp.json`:

```json
{
    "csharp": {
        "command": "omnisharp",
        "args": ["-lsp"],
        "extensionToLanguage": { ".cs": "csharp" },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references / implementation
- Hover documentation
- NuGet package completion
- .NET solution navigation
- Real-time diagnostics

### Automated Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `csharp-format-on-edit` | `**/*.cs` | Auto-format with dotnet format |
| `csharp-build-check` | `**/*.cs` | Build with dotnet build |
| `csharp-todo-fixme` | `**/*.cs` | Surface TODO/FIXME comments |
| `csharp-null-check` | `**/*.cs` | Detect null-forgiving operators |

## Required Tools

| Tool | Installation | Purpose |
|------|--------------|---------|
| `omnisharp` | `brew install omnisharp` | LSP server |
| `dotnet` | [dotnet.microsoft.com](https://dotnet.microsoft.com) | .NET SDK |

## Project Structure

```
csharp-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # OmniSharp configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── scripts/
│       └── csharp-hooks.sh
├── tests/
│   └── SampleTest.cs         # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## License

MIT
