# zig-lsp

A Claude Code plugin providing comprehensive Zig development support through:

- **ZLS (Zig Language Server)** integration for IDE-like features
- **Automated hooks** for formatting, linting, and code quality
- **Zig build system** integration

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install ZLS
# macOS (Homebrew)
brew install zls

# Or build from source
git clone https://github.com/zigtools/zls
cd zls
zig build -Doptimize=ReleaseSafe
# Copy zig-out/bin/zls to a directory in your PATH
```

## Features

### LSP Integration

The plugin configures ZLS for Claude Code via `.lsp.json`:

```json
{
    "zig": {
        "command": "zls",
        "args": [],
        "extensionToLanguage": {
            ".zig": "zig",
            ".zon": "zig"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Code actions and quick fixes
- Workspace symbol search
- Real-time diagnostics
- Auto-completion

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### Core Zig Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `zig-fmt-on-edit` | `**/*.zig` | Auto-format with `zig fmt` |
| `zig-build-check` | `**/*.zig` | Compile check with `zig build` or `zig test` |
| `zig-ast-check` | `**/*.zig` | AST validation with `zig ast-check` |

#### Code Quality

| Hook | Trigger | Description |
|------|---------|-------------|
| `zig-todo-fixme` | `**/*.zig` | Surface TODO/FIXME/XXX/HACK comments |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `zig` | [ziglang.org](https://ziglang.org/download/) | Zig compiler |
| `zls` | `brew install zls` or build from source | LSP server |

### Installation Methods

**macOS (Homebrew):**
```bash
brew install zig zls
```

**Linux (package manager):**
```bash
# Arch
sudo pacman -S zig zls

# Ubuntu/Debian (snap)
sudo snap install zig --classic --beta
```

**Build from source:**
```bash
# Install Zig
wget https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz
tar -xf zig-linux-x86_64-0.13.0.tar.xz
sudo mv zig-linux-x86_64-0.13.0 /usr/local/zig
export PATH=$PATH:/usr/local/zig

# Build ZLS
git clone https://github.com/zigtools/zls
cd zls
zig build -Doptimize=ReleaseSafe
sudo cp zig-out/bin/zls /usr/local/bin/
```

## Commands

### `/setup`

Interactive setup wizard for configuring the complete Zig development environment.

**What it does:**

1. **Verifies Zig installation** - Checks `zig` compiler
2. **Installs ZLS** - LSP server for IDE features
3. **Validates LSP config** - Confirms `.lsp.json` is correct
4. **Verifies hooks** - Confirms hooks are properly loaded

**Usage:**

```bash
/setup
```

| Command | Description |
|---------|-------------|
| `/setup` | Full interactive setup for LSP and Zig tools |

## Configuration

### zls.json

ZLS can be configured via `zls.json` in your project root:

```json
{
    "enable_snippets": true,
    "enable_ast_check_diagnostics": true,
    "enable_autofix": true,
    "enable_import_embedfile_argument_completions": true,
    "warn_style": true,
    "highlight_global_var_declarations": true
}
```

### Customizing Hooks

Edit `hooks/hooks.json` to:
- Disable hooks by removing entries
- Adjust output limits (`head -N`)
- Modify matchers for different file patterns
- Add project-specific hooks

Example - disable a hook:
```json
{
    "name": "zig-ast-check",
    "enabled": false,
    ...
}
```

## Project Structure

```
zig-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # ZLS configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── hooks.json            # Automated hooks
├── tests/
│   └── sample_test.zig       # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### ZLS not starting

1. Ensure `build.zig` exists in project root
2. Run `zig build` to generate initial build artifacts
3. Verify installation: `zls --version`
4. Check LSP config: `cat .lsp.json`

### Zig fmt fails

Ensure the file has valid syntax:
```bash
zig ast-check file.zig
```

### Hooks not triggering

1. Verify hooks are loaded: `cat hooks/hooks.json`
2. Check file patterns match your structure
3. Ensure required tools are installed (`command -v zls`)

### Too much output

Reduce `head -N` values in hooks.json for less verbose output.

## License

MIT
