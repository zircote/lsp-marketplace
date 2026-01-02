---
description: Interactive setup for Scala LSP development environment
---

# Scala LSP Setup

This command will configure your Scala development environment with Metals and essential tools.

## Prerequisites Check

First, verify Coursier is installed:

```bash
cs --version
```

If not installed:

```bash
brew install coursier/formulas/coursier
```

## Installation Steps

### 1. Install Metals LSP Server

```bash
cs install metals
```

### 2. Install Development Tools

```bash
# Formatting
cs install scalafmt

# Linting and refactoring
cs install scalafix
```

### 3. Verify Installation

```bash
metals --version
scalafmt --version
```

### 4. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test file
cat > test_lsp.scala << 'EOF'
object Main extends App {
  def greet(name: String): String = s"Hello, $name!"
  println(greet("World"))
}
EOF

# Run Scalafmt
scalafmt test_lsp.scala

# Clean up
rm test_lsp.scala
```
