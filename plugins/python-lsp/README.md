# python-lsp

A Claude Code plugin providing comprehensive Python development support through:

- **Pyright LSP** integration for IDE-like features
- **15 automated hooks** for type checking, linting, formatting, and testing
- **Python tool ecosystem** integration (ruff, black, pytest, mypy)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install Pyright LSP
npm install -g pyright

# Install Python tools
pip install ruff black isort mypy bandit pytest pip-audit
```

## Features

### LSP Integration

The plugin configures Pyright for Claude Code via `.lsp.json`:

```json
{
    "python": {
        "command": "pyright-langserver",
        "args": ["--stdio"],
        "extensionToLanguage": { ".py": "python", ".pyi": "python" },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Type inference and checking
- Import resolution
- Real-time diagnostics

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### Core Python Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `python-format-on-edit` | `**/*.py` | Auto-format with black or ruff |
| `python-isort-on-edit` | `**/*.py` | Sort imports with isort or ruff |
| `python-lint-on-edit` | `**/*.py` | Lint with ruff or flake8 |
| `python-type-check` | `**/*.py` | Type check with pyright or mypy |

#### Security & Quality

| Hook | Trigger | Tool Required | Description |
|------|---------|---------------|-------------|
| `python-bandit` | `**/*.py` | `bandit` | Security vulnerability scanning |
| `python-todo-fixme` | `**/*.py` | - | Surface TODO/FIXME/XXX/HACK comments |
| `python-docstring-hint` | `**/*.py` | - | Suggest docstrings for public functions |

#### Dependencies

| Hook | Trigger | Tool Required | Description |
|------|---------|---------------|-------------|
| `pip-audit` | `**/requirements.txt` | `pip-audit` | Security audit of dependencies |
| `pyproject-validate` | `**/pyproject.toml` | - | Validate TOML syntax |
| `unpinned-deps-check` | `**/requirements.txt` | - | Warn about unpinned versions |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `pyright` | `npm install -g pyright` | LSP server & type checking |
| `python` | System package manager | Python runtime |

### Recommended

| Tool | Installation | Purpose |
|------|--------------|---------|
| `ruff` | `pip install ruff` | Fast linting & formatting |
| `black` | `pip install black` | Code formatting |
| `isort` | `pip install isort` | Import sorting |
| `mypy` | `pip install mypy` | Static type checking |
| `bandit` | `pip install bandit` | Security scanning |
| `pytest` | `pip install pytest` | Testing framework |

### Optional

| Tool | Installation | Purpose |
|------|--------------|---------|
| `pip-audit` | `pip install pip-audit` | Dependency security |
| `safety` | `pip install safety` | Dependency vulnerability check |

## Commands

### `/setup`

Interactive setup wizard for configuring the complete Python development environment.

**What it does:**

1. **Verifies Python installation** - Checks `python` CLI is available
2. **Installs Pyright** - LSP server for IDE features
3. **Installs linting tools** - ruff, black, isort
4. **Installs type checkers** - mypy, pyright
5. **Installs security scanners** - bandit, pip-audit
6. **Validates LSP config** - Confirms `.lsp.json` is correct
7. **Verifies hooks** - Confirms hooks are properly loaded

**Usage:**

```bash
/setup
```

## Project Structure

```
python-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # Pyright configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   ├── hooks.json            # Hook definitions
│   └── scripts/
│       └── python-hooks.sh   # Hook dispatcher
├── tests/
│   └── test_sample.py        # Test file for all features
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### Pyright not starting

1. Ensure `python` files exist in project root
2. Verify installation: `pyright --version`
3. Check LSP config: `cat .lsp.json`

### Type errors not showing

1. Create `pyrightconfig.json` or `pyproject.toml` with pyright config
2. Ensure virtual environment is activated
3. Run `pyright` manually to check configuration

### Hooks not triggering

1. Verify hooks are loaded: `cat hooks/hooks.json`
2. Check file patterns match your structure
3. Ensure required tools are installed (`command -v ruff`)

## License

MIT
