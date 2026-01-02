---
description: Interactive setup for Lua LSP development environment
---

# Lua LSP Setup

This command will configure your Lua development environment with lua-language-server and essential tools.

## Prerequisites Check

First, verify Lua is installed:

```bash
lua -v
```

## Installation Steps

### 1. Install lua-language-server

**macOS:**
```bash
brew install lua-language-server
```

**Linux:**
```bash
# Download from GitHub releases
curl -L https://github.com/LuaLS/lua-language-server/releases/latest/download/lua-language-server-linux-x64.tar.gz -o luals.tar.gz
tar -xzf luals.tar.gz -C ~/.local/bin
rm luals.tar.gz
```

**Windows:**
```bash
# Download from GitHub releases
# https://github.com/LuaLS/lua-language-server/releases
```

### 2. Install Formatting Tools

```bash
# StyLua (Rust-based formatter)
cargo install stylua
```

### 3. Install Linting Tools

```bash
# Luacheck (requires LuaRocks)
luarocks install luacheck
```

### 4. Install Testing Framework (Optional)

```bash
# Busted testing framework
luarocks install busted
```

### 5. Verify Installation

```bash
lua-language-server --version
stylua --version
luacheck --version
```

### 6. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test file
cat > test_lsp.lua << 'EOF'
local function greet(name)
    return "Hello, " .. name .. "!"
end

print(greet("World"))
EOF

# Run Luacheck
luacheck test_lsp.lua

# Format with StyLua
stylua --check test_lsp.lua

# Clean up
rm test_lsp.lua
```

## Configuration

Create `.luacheck` for project-specific linting rules:

```lua
-- .luacheck
std = "lua51+busted"
ignore = {"212/self", "213"}
max_line_length = 120
```

Create `.stylua.toml` for formatting preferences:

```toml
# .stylua.toml
column_width = 100
line_endings = "Unix"
indent_type = "Spaces"
indent_width = 4
quote_style = "AutoPreferDouble"
```
