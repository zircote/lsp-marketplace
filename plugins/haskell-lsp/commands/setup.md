# Haskell LSP & Toolchain Setup

Set up haskell-language-server (HLS) integration and install all tools required by the hooks in this project.

## Instructions

Execute the following setup steps in order:

### 1. Verify ghcup Installation

Check if ghcup is installed:

```bash
ghcup --version
```

If not installed, guide the user to install ghcup:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Or visit: https://www.ghcup.haskell.org/

### 2. Install GHC (Haskell Compiler)

Install the latest stable GHC version:

```bash
ghcup install ghc latest
ghcup set ghc latest
```

Verify installation:

```bash
ghc --version
```

### 3. Install cabal (Build Tool)

Install the latest cabal version:

```bash
ghcup install cabal latest
ghcup set cabal latest
```

Update cabal package list:

```bash
cabal update
```

Verify installation:

```bash
cabal --version
```

### 4. Install Haskell Language Server

Install HLS matching your GHC version:

```bash
ghcup install hls latest
ghcup set hls latest
```

Verify installation:

```bash
haskell-language-server-wrapper --version
```

### 5. Install Development Tools

Install hlint for linting:

```bash
cabal install hlint --installdir=$HOME/.local/bin --overwrite-policy=always
```

Install ormolu for formatting (choose one):

```bash
# Option 1: ormolu (opinionated, less configuration)
cabal install ormolu --installdir=$HOME/.local/bin --overwrite-policy=always

# Option 2: fourmolu (more configurable)
cabal install fourmolu --installdir=$HOME/.local/bin --overwrite-policy=always
```

### 6. Verify PATH Configuration

Ensure Haskell binaries are in your PATH:

```bash
echo $PATH | grep -q ".ghcup/bin" && echo "ghcup in PATH" || echo "Add ~/.ghcup/bin to PATH"
echo $PATH | grep -q ".local/bin" && echo "local bin in PATH" || echo "Add ~/.local/bin to PATH"
```

If needed, add to your shell profile (~/.bashrc, ~/.zshrc, etc.):

```bash
export PATH="$HOME/.ghcup/bin:$HOME/.local/bin:$PATH"
```

### 7. Verify LSP Configuration

Check that `.lsp.json` exists and is properly configured:

```bash
cat .lsp.json
```

Expected configuration:

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

### 8. Verify Hooks Configuration

Confirm hooks are loaded:

```bash
cat hooks/hooks.json | head -50
```

### 9. Verify Tool Installation

Check all tools are accessible:

```bash
command -v ghc && echo "GHC: ✓" || echo "GHC: ✗"
command -v cabal && echo "cabal: ✓" || echo "cabal: ✗"
command -v haskell-language-server-wrapper && echo "HLS: ✓" || echo "HLS: ✗"
command -v hlint && echo "hlint: ✓" || echo "hlint: ✗"
command -v ormolu && echo "ormolu: ✓" || echo "ormolu: ✗"
```

## Tool Summary

| Tool | Purpose | Hook |
|------|---------|------|
| `haskell-language-server-wrapper` | LSP server for IDE features | Core |
| `ghc` | Haskell compiler | `haskell-build-check`, `haskell-warnings` |
| `cabal` | Build tool and package manager | `haskell-build-check` |
| `hlint` | Linting and suggestions | `haskell-lint-on-edit` |
| `ormolu`/`fourmolu` | Code formatting | `haskell-format-on-edit` |

## Troubleshooting

### ghcup command not found

Add ghcup to your PATH:
```bash
source ~/.ghcup/env
```

Or permanently add to your shell profile:
```bash
echo 'source ~/.ghcup/env' >> ~/.bashrc  # or ~/.zshrc
```

### HLS not starting

- Ensure project has a `.cabal` file or `stack.yaml`
- Run `cabal build` or `stack build` to initialize project
- Check HLS and GHC versions match: `ghcup list`
- View HLS logs: `haskell-language-server-wrapper --lsp 2>&1 | tee hls.log`

### Tools not in PATH

Cabal installs tools to `~/.cabal/bin` or `~/.local/bin` by default. Add to PATH:
```bash
export PATH="$HOME/.local/bin:$HOME/.cabal/bin:$PATH"
```

### GHC/HLS version mismatch

HLS must match your GHC version:
```bash
ghcup list           # View available versions
ghcup tui            # Interactive version manager
ghcup install hls <version>
ghcup set hls <version>
```

### cabal update fails

If cabal update hangs or fails:
```bash
rm -rf ~/.cabal/packages
cabal update
```

## Quick Install (All Tools)

One-liner to install everything:

```bash
ghcup install ghc latest && \
ghcup install cabal latest && \
ghcup install hls latest && \
ghcup set ghc latest && \
ghcup set cabal latest && \
ghcup set hls latest && \
cabal update && \
cabal install hlint ormolu --installdir=$HOME/.local/bin --overwrite-policy=always
```

After running this command, provide a status summary showing which tools were installed successfully and any that failed.

## Optional: Stack Installation

If you prefer Stack over Cabal:

```bash
ghcup install stack latest
ghcup set stack latest
stack setup
```

Update hooks to use `stack build` instead of `cabal build`.
