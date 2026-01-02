# go-lsp

A Claude Code plugin providing comprehensive Go development support through:

- **gopls LSP** integration for IDE-like features
- **14 automated hooks** for linting, formatting, testing, and security scanning
- **Go tool ecosystem** integration (golangci-lint, govulncheck, go vet)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install gopls LSP (ensure ~/go/bin is in PATH)
go install golang.org/x/tools/gopls@latest

# Install development tools
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install golang.org/x/vuln/cmd/govulncheck@latest
go install golang.org/x/tools/cmd/goimports@latest
```

## Features

### LSP Integration

The plugin configures gopls for Claude Code via `.lsp.json`:

```json
{
    "go": {
        "command": "gopls",
        "args": [],
        "extensionToLanguage": { ".go": "go" },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references / implementation
- Hover documentation
- Package navigation
- Interface implementation discovery
- Real-time diagnostics

### Automated Hooks

#### Core Go Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `go-fmt-on-edit` | `**/*.go` | Auto-format with goimports/gofmt |
| `go-vet-on-edit` | `**/*.go` | Run go vet |
| `go-build-check` | `**/*.go` | Compile check |
| `go-lint-on-edit` | `**/*.go` | Lint with golangci-lint |

#### Security & Quality

| Hook | Trigger | Tool Required | Description |
|------|---------|---------------|-------------|
| `go-sec` | `**/*.go` | `gosec` | Security vulnerability scanning |
| `govulncheck` | `**/go.mod` | `govulncheck` | Known vulnerability check |
| `go-todo-fixme` | `**/*.go` | - | Surface TODO/FIXME comments |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `gopls` | `go install golang.org/x/tools/gopls@latest` | LSP server |
| `go` | [golang.org](https://golang.org) | Go compiler |

### Recommended

| Tool | Installation | Purpose |
|------|--------------|---------|
| `golangci-lint` | `go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest` | Comprehensive linting |
| `govulncheck` | `go install golang.org/x/vuln/cmd/govulncheck@latest` | Vulnerability scanning |
| `goimports` | `go install golang.org/x/tools/cmd/goimports@latest` | Import management |

## Project Structure

```
go-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # gopls configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   ├── hooks.json            # Hook definitions
│   └── scripts/
│       └── go-hooks.sh
├── tests/
│   └── sample_test.go        # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## License

MIT
