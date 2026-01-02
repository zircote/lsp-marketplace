---
description: Interactive setup for Elixir LSP development environment
---

# Elixir LSP Setup

This command will configure your Elixir development environment with ElixirLS and essential tools.

## Prerequisites Check

First, verify Elixir is installed:

```bash
elixir --version
mix --version
```

## Installation Steps

### 1. Install ElixirLS

Download from GitHub releases:
https://github.com/elixir-lsp/elixir-ls/releases

Or build from source:

```bash
git clone https://github.com/elixir-lsp/elixir-ls.git
cd elixir-ls
mix deps.get && mix compile
mix elixir_ls.release -o release
```

### 2. Install Development Tools

```bash
# Update hex and rebar
mix local.hex --force
mix local.rebar --force

# Install Credo for linting
mix archive.install hex credo --force
```

### 3. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the integration:

```bash
# Create a test file
cat > test_lsp.ex << 'EOF'
defmodule Greeter do
  def greet(name), do: "Hello, #{name}!"
end
EOF

# Format
mix format test_lsp.ex

# Clean up
rm test_lsp.ex
```
