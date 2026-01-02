# latex-lsp

A Claude Code plugin providing comprehensive LaTeX development support through:

- **Texlab LSP** integration for IDE-like features
- **Automated hooks** for linting and quality checks
- **LaTeX tool ecosystem** integration (chktex)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install Texlab LSP
cargo install --locked texlab

# Or on macOS with Homebrew
brew install texlab

# Install ChkTeX for linting
brew install chktex  # macOS
apt install chktex   # Debian/Ubuntu
```

## Features

### LSP Integration

The plugin configures Texlab for Claude Code via `.lsp.json`:

```json
{
    "latex": {
        "command": "texlab",
        "args": [],
        "extensionToLanguage": {
            ".tex": "latex",
            ".bib": "bibtex"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Code completion (commands, environments, citations)
- Document symbols and outline
- Real-time diagnostics
- Build integration

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### Core LaTeX Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `latex-chktex-on-edit` | `**/*.tex` | Lint LaTeX files with chktex |
| `latex-todo-fixme` | `**/*.tex` | Surface TODO/FIXME/XXX comments |

#### Bibliography

| Hook | Trigger | Description |
|------|---------|-------------|
| `latex-bib-lint` | `**/*.bib` | Check BibTeX syntax |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `texlab` | `cargo install --locked texlab` | LSP server for LaTeX |
| `pdflatex` or `xelatex` | TeX distribution (TeX Live, MiKTeX) | LaTeX compilation |

### Recommended

| Tool | Installation | Purpose |
|------|--------------|---------|
| `chktex` | `brew install chktex` (macOS) | LaTeX linting |
| `biber` or `bibtex` | Included with TeX distribution | Bibliography processing |
| `latexmk` | Included with TeX Live | Build automation |

## Commands

### `/setup`

Interactive setup wizard for configuring the LaTeX development environment.

**What it does:**

1. **Verifies TeX distribution** - Checks for LaTeX installation
2. **Installs Texlab** - LSP server for IDE features
3. **Installs ChkTeX** - LaTeX linter
4. **Validates LSP config** - Confirms `.lsp.json` is correct
5. **Verifies hooks** - Confirms hooks are properly loaded

**Usage:**

```bash
/setup
```

## Project Structure

```
latex-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # Texlab configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── hooks.json            # Hook definitions
├── tests/
│   └── sample.tex            # Sample LaTeX file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### Texlab not starting

1. Ensure `.tex` files exist in project root
2. Verify installation: `texlab --version`
3. Check LSP config: `cat .lsp.json`

### Build errors not showing

1. Ensure TeX distribution is installed: `pdflatex --version`
2. Check for `texlab.toml` or `.texlabrc` configuration
3. Verify build directory permissions

### Hooks not triggering

1. Verify hooks are loaded: `cat hooks/hooks.json`
2. Check file patterns match your structure
3. Ensure required tools are installed (`command -v chktex`)

### ChkTeX too verbose

Edit `hooks/hooks.json` to add filters:
```json
{
    "command": "chktex -q -n1 -n2 -n3 \"$FILE\" || true"
}
```

Where `-n1`, `-n2`, `-n3` disable specific warnings.

## License

MIT
