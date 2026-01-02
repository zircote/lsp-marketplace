# elixir-lsp

A Claude Code plugin providing comprehensive Elixir development support through:

- **ElixirLS** integration for IDE-like features
- **Automated hooks** for formatting, linting, and testing
- **Elixir ecosystem** integration (Mix, Credo, Dialyzer)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install ElixirLS (download from GitHub releases)
# https://github.com/elixir-lsp/elixir-ls/releases

# Install development tools (via Mix)
mix local.hex --force
mix local.rebar --force
mix archive.install hex credo --force
```

## Features

### LSP Integration

The plugin configures ElixirLS for Claude Code via `.lsp.json`.

**Capabilities:**
- Go to definition / references
- Hover documentation
- Code completion
- Dialyzer integration
- Real-time diagnostics

### Automated Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `mix-format` | `**/*.ex` | Code formatting |
| `credo` | `**/*.ex` | Linting |
| `elixir-todo-fixme` | `**/*.ex` | Surface TODO/FIXME comments |

## Required Tools

| Tool | Installation | Purpose |
|------|--------------|---------|
| `elixir-ls` | GitHub releases | LSP server |
| `mix format` | Built-in | Formatting |
| `credo` | `mix archive.install hex credo` | Linting |

## License

MIT
