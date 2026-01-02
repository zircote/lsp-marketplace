---
description: Interactive setup for Go LSP development environment
---

# Go LSP Setup

This command will configure your Go development environment with gopls LSP and essential tools.

## Prerequisites Check

First, verify Go is installed:

```bash
go version
```

Ensure `~/go/bin` is in your PATH:

```bash
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.zshrc
source ~/.zshrc
```

## Installation Steps

### 1. Install gopls LSP Server

```bash
go install golang.org/x/tools/gopls@latest
```

### 2. Install Development Tools

```bash
# Linting
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Security scanning
go install golang.org/x/vuln/cmd/govulncheck@latest
go install github.com/securego/gosec/v2/cmd/gosec@latest

# Import management
go install golang.org/x/tools/cmd/goimports@latest

# Static analysis
go install honnef.co/go/tools/cmd/staticcheck@latest
```

### 3. Verify Installation

```bash
gopls version
golangci-lint --version
govulncheck -version
```

### 4. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test module
mkdir -p /tmp/test-go-lsp && cd /tmp/test-go-lsp
go mod init test
echo 'package main; func main() { println("Hello") }' > main.go

# Run checks
go vet ./...
golangci-lint run

# Clean up
cd - && rm -rf /tmp/test-go-lsp
```
