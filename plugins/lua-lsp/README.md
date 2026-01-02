# lua-lsp

A Claude Code plugin providing comprehensive Lua development support through:

- **lua-language-server** integration for IDE-like features
- **10 automated hooks** for linting, formatting, and code quality
- **Lua ecosystem** integration (StyLua, Luacheck)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install lua-language-server
brew install lua-language-server  # macOS
# or download from https://github.com/LuaLS/lua-language-server/releases

# Install formatting and linting tools
cargo install stylua
luarocks install luacheck
```

## Features

### LSP Integration

The plugin configures lua-language-server for Claude Code via `.lsp.json`:

```json
{
    "lua": {
        "command": "lua-language-server",
        "args": [],
        "extensionToLanguage": { ".lua": "lua" },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Type inference and annotations
- Module resolution
- Real-time diagnostics
- Code completion

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### Core Lua Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `lua-format-on-edit` | `**/*.lua` | Auto-format with StyLua |
| `lua-lint-on-edit` | `**/*.lua` | Lint with Luacheck |
| `lua-syntax-check` | `**/*.lua` | Validate Lua syntax |

#### Quality & Analysis

| Hook | Trigger | Description |
|------|---------|-------------|
| `lua-todo-fixme` | `**/*.lua` | Surface TODO/FIXME/XXX/HACK comments |
| `lua-complexity-check` | `**/*.lua` | Detect high cyclomatic complexity |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `lua-language-server` | `brew install lua-language-server` | LSP server |
| `lua` | System package manager | Lua runtime |

### Recommended

| Tool | Installation | Purpose |
|------|--------------|---------|
| `stylua` | `cargo install stylua` | Code formatting |
| `luacheck` | `luarocks install luacheck` | Linting |

### Optional

| Tool | Installation | Purpose |
|------|--------------|---------|
| `luarocks` | System package manager | Package manager |
| `busted` | `luarocks install busted` | Testing framework |

## Project Structure

```
lua-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # lua-language-server configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   ├── hooks.json            # Hook definitions
│   └── scripts/
│       └── lua-hooks.sh
├── tests/
│   └── sample_test.lua       # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### lua-language-server not starting

1. Ensure `.lua` files exist in project
2. Verify installation: `lua-language-server --version`
3. Check LSP config: `cat .lsp.json`

### Formatting not working

1. Verify StyLua installation: `stylua --version`
2. Create `.stylua.toml` for custom configuration
3. Run manually: `stylua --check .`

### Hooks not triggering

1. Verify hooks are loaded: `cat hooks/hooks.json`
2. Check file patterns match your structure
3. Ensure required tools are installed (`command -v stylua`)

## License

MIT
