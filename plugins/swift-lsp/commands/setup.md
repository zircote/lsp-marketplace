---
description: Interactive setup for Swift LSP development environment
---

# Swift LSP Setup

This command will configure your Swift development environment with SourceKit-LSP and essential tools.

## Prerequisites Check

First, verify Xcode/Swift is installed:

```bash
swift --version
xcode-select -p
```

## Installation Steps

### 1. Install Xcode Command Line Tools

```bash
xcode-select --install
```

SourceKit-LSP is included with Xcode.

### 2. Install Development Tools

```bash
# Formatting
brew install swiftformat

# Linting
brew install swiftlint
```

### 3. Verify Installation

```bash
sourcekit-lsp --help
swiftformat --version
swiftlint version
```

### 4. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test file
echo 'func greet(name: String) -> String { return "Hello, \(name)!" }' > test_lsp.swift

# Run SwiftFormat
swiftformat test_lsp.swift

# Run SwiftLint
swiftlint lint test_lsp.swift

# Clean up
rm test_lsp.swift
```
