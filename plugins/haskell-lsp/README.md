# haskell-lsp

A Claude Code plugin providing comprehensive Haskell development support through:

- **haskell-language-server (HLS)** integration for IDE-like features
- **Automated hooks** for formatting, linting, and code quality
- **Haskell toolchain** integration (hlint, ormolu/fourmolu, cabal/stack)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install GHC and cabal via ghcup (recommended)
ghcup install ghc latest
ghcup install cabal latest
ghcup install hls latest

# Install development tools
cabal install hlint
cabal install ormolu
# Or alternatively: cabal install fourmolu
```

## Features

### LSP Integration

The plugin configures haskell-language-server for Claude Code via `.lsp.json`:

```json
{
    "haskell": {
        "command": "haskell-language-server-wrapper",
        "args": ["--lsp"],
        "extensionToLanguage": {
            ".hs": "haskell",
            ".lhs": "haskell"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation with type information
- Code actions and refactoring
- Workspace symbol search
- Real-time type checking and diagnostics
- Import management

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### Core Haskell Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `haskell-format-on-edit` | `**/*.hs` | Auto-format with ormolu or fourmolu |
| `haskell-lint-on-edit` | `**/*.hs` | Lint with hlint |
| `haskell-build-check` | `**/*.hs` | Compile check with cabal/stack |
| `haskell-todo-fixme` | `**/*.hs` | Surface TODO/FIXME comments |

#### Quality & Documentation

| Hook | Trigger | Description |
|------|---------|-------------|
| `haskell-haddock-check` | `**/src/**/*.hs` | Check Haddock documentation |
| `haskell-warnings` | `**/*.hs` | Show GHC warnings |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `ghcup` | [ghcup.haskell.org](https://www.ghcup.haskell.org/) | Haskell toolchain manager |
| `ghc` | `ghcup install ghc` | Haskell compiler |
| `cabal` | `ghcup install cabal` | Build tool and package manager |
| `haskell-language-server` | `ghcup install hls` | LSP server |

### Recommended

| Tool | Installation | Purpose |
|------|--------------|---------|
| `hlint` | `cabal install hlint` | Linting and suggestions |
| `ormolu` | `cabal install ormolu` | Code formatter (opinionated) |
| `fourmolu` | `cabal install fourmolu` | Code formatter (configurable) |
| `stack` | `ghcup install stack` | Alternative build tool |

## Commands

### `/setup`

Interactive setup wizard for configuring the complete Haskell development environment.

**What it does:**

1. **Checks for ghcup** - Ensures ghcup is installed
2. **Installs GHC** - Latest stable compiler
3. **Installs cabal** - Build tool and package manager
4. **Installs HLS** - Haskell Language Server
5. **Installs dev tools** - hlint, ormolu/fourmolu
6. **Validates LSP config** - Confirms `.lsp.json` is correct
7. **Verifies hooks** - Confirms hooks are properly loaded

**Usage:**

```bash
/setup
```

**Quick install command** (from the wizard):

```bash
ghcup install ghc latest && \
ghcup install cabal latest && \
ghcup install hls latest && \
cabal update && \
cabal install hlint ormolu
```

| Command | Description |
|---------|-------------|
| `/setup` | Full interactive setup for HLS and all tools |

## Configuration

### Formatter Selection

By default, hooks use `ormolu` for formatting. To use `fourmolu` instead:

1. Install fourmolu: `cabal install fourmolu`
2. Edit `hooks/hooks.json` and change `ormolu` to `fourmolu`

### Customizing Hooks

Edit `hooks/hooks.json` to:
- Disable hooks by setting `"enabled": false`
- Adjust output limits (`head -N`)
- Modify matchers for different file patterns
- Add project-specific hooks

Example - use fourmolu:
```json
{
    "name": "haskell-format-on-edit",
    "event": "afterWrite",
    "hooks": [
        {
            "type": "command",
            "command": "command -v fourmolu >/dev/null && fourmolu -i $FILE || true"
        }
    ],
    "matcher": "**/*.hs"
}
```

## Project Structure

```
haskell-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # HLS configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── hooks.json            # Automated hooks
├── tests/
│   └── SampleTest.hs         # Sample test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### HLS not starting

1. Ensure you have a `*.cabal` or `stack.yaml` file in project root
2. Run `cabal build` or `stack build` to generate initial build artifacts
3. Verify installation: `haskell-language-server-wrapper --version`
4. Check LSP config: `cat .lsp.json`

### GHC version mismatch

HLS must match your GHC version. Use ghcup to manage:
```bash
ghcup list
ghcup install hls <version>
ghcup set hls <version>
```

### Formatter not found

Ensure formatter is in PATH:
```bash
which ormolu
# If not found:
cabal install ormolu --installdir=$HOME/.local/bin
```

Add `~/.local/bin` or `~/.cabal/bin` to your PATH.

### hlint errors

Update hlint to latest version:
```bash
cabal install hlint --overwrite-policy=always
```

### Hooks not triggering

1. Verify hooks are loaded: `cat hooks/hooks.json`
2. Check file patterns match your structure
3. Ensure required tools are installed (`command -v hlint`)

### Too much output

Reduce `head -N` values in hooks.json for less verbose output.

## License

MIT
