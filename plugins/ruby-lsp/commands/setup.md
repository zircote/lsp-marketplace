---
description: Interactive setup for Ruby LSP development environment
---

# Ruby LSP Setup

This command will configure your Ruby development environment with ruby-lsp and essential tools.

## Prerequisites Check

First, verify Ruby is installed:

```bash
ruby --version
gem --version
```

## Installation Steps

### 1. Install Ruby LSP Server

```bash
gem install ruby-lsp
```

### 2. Install Development Tools

```bash
# Linting and formatting
gem install rubocop

# Security scanning
gem install bundler-audit brakeman

# Testing
gem install rspec
```

### 3. Verify Installation

```bash
ruby-lsp --version
rubocop --version
```

### 4. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test file
echo 'def greet(name) = "Hello, #{name}!"' > test_lsp.rb

# Run RuboCop
rubocop test_lsp.rb

# Clean up
rm test_lsp.rb
```
