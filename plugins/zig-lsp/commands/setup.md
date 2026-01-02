---
description: Interactive setup for Zig LSP development environment
---

# Zig LSP Setup

This command will configure your Zig development environment with ZLS (Zig Language Server) and essential tools.

## Prerequisites Check

First, verify Zig is installed:

```bash
zig version
```

## Installation Steps

### 1. Install Zig Compiler

**macOS (Homebrew):**
```bash
brew install zig
```

**Linux (Snap):**
```bash
sudo snap install zig --classic --beta
```

**Manual installation:**
```bash
# Download from https://ziglang.org/download/
# Extract and add to PATH
wget https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz
tar -xf zig-linux-x86_64-0.13.0.tar.xz
sudo mv zig-linux-x86_64-0.13.0 /usr/local/zig
echo 'export PATH=$PATH:/usr/local/zig' >> ~/.bashrc
source ~/.bashrc
```

### 2. Install ZLS (Zig Language Server)

**macOS (Homebrew):**
```bash
brew install zls
```

**Linux (Arch):**
```bash
sudo pacman -S zls
```

**Build from source:**
```bash
git clone https://github.com/zigtools/zls
cd zls
zig build -Doptimize=ReleaseSafe
sudo cp zig-out/bin/zls /usr/local/bin/
```

### 3. Verify Installation

```bash
zig version
zls --version
```

### 4. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test project
mkdir -p /tmp/test-zig-lsp && cd /tmp/test-zig-lsp
zig init-exe

# Run checks
zig fmt --check src/main.zig
zig build

# Clean up
cd - && rm -rf /tmp/test-zig-lsp
```

## Configuration

Create a `zls.json` in your project root for custom settings:

```bash
cat > zls.json <<EOF
{
    "enable_snippets": true,
    "enable_ast_check_diagnostics": true,
    "enable_autofix": true,
    "warn_style": true,
    "highlight_global_var_declarations": true
}
EOF
```
