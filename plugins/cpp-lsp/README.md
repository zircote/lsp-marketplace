# cpp-lsp

A Claude Code plugin providing comprehensive C/C++ development support through:

- **clangd LSP** integration for IDE-like features
- **14 automated hooks** for compilation, linting, formatting, and analysis
- **LLVM tool ecosystem** integration (clang-tidy, clang-format, cppcheck)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# macOS (Homebrew)
brew install llvm

# The clangd binary is included with LLVM
# Ensure /opt/homebrew/opt/llvm/bin is in your PATH
```

## Features

### LSP Integration

The plugin configures clangd for Claude Code via `.lsp.json`:

```json
{
    "cpp": {
        "command": "clangd",
        "args": [],
        "extensionToLanguage": {
            ".c": "c", ".h": "c",
            ".cpp": "cpp", ".cc": "cpp", ".cxx": "cpp",
            ".hpp": "cpp", ".hxx": "cpp", ".hh": "cpp"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references / declaration
- Hover documentation
- Header navigation
- Include completion
- Real-time diagnostics

### Automated Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `cpp-format-on-edit` | `**/*.cpp,c,h,hpp` | Auto-format with clang-format |
| `cpp-tidy-on-edit` | `**/*.cpp,c` | Lint with clang-tidy |
| `cpp-compile-check` | `**/*.cpp,c` | Compile check with clang/gcc |
| `cpp-cppcheck` | `**/*.cpp,c` | Static analysis with cppcheck |

## Required Tools

| Tool | Installation | Purpose |
|------|--------------|---------|
| `clangd` | `brew install llvm` | LSP server |
| `clang-format` | Included with LLVM | Formatting |
| `clang-tidy` | Included with LLVM | Linting |
| `cppcheck` | `brew install cppcheck` | Static analysis |

## Configuration

Create a `.clang-format` file in your project root:

```yaml
BasedOnStyle: Google
IndentWidth: 4
ColumnLimit: 100
```

Create a `.clang-tidy` file:

```yaml
Checks: 'clang-analyzer-*,modernize-*,performance-*,bugprone-*'
```

## Project Structure

```
cpp-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # clangd configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── scripts/
│       └── cpp-hooks.sh
├── tests/
│   └── sample_test.cpp       # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### clangd not finding headers

Create `compile_commands.json` using:

```bash
# CMake
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .

# Bear (for Make projects)
bear -- make
```

## License

MIT
