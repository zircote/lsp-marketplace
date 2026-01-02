---
description: Interactive setup for Python LSP development environment
---

# Python LSP Setup

This command will configure your Python development environment with Pyright LSP and essential tools.

## Prerequisites Check

First, verify Python is installed:

```bash
python --version || python3 --version
```

## Installation Steps

### 1. Install Pyright LSP Server

```bash
npm install -g pyright
```

Or with pip:

```bash
pip install pyright
```

### 2. Install Python Development Tools

**Quick install (all recommended tools):**

```bash
pip install ruff black isort mypy bandit pytest pip-audit
```

**Or install individually:**

```bash
# Linting & Formatting
pip install ruff      # Fast linter and formatter
pip install black     # Code formatter
pip install isort     # Import sorter

# Type Checking
pip install mypy      # Static type checker

# Security
pip install bandit    # Security linter
pip install pip-audit # Dependency auditor

# Testing
pip install pytest    # Testing framework
```

### 3. Verify Installation

```bash
# Check Pyright
pyright --version

# Check Ruff
ruff --version

# Check Black
black --version

# Check Mypy
mypy --version
```

### 4. Create Project Configuration (Optional)

**pyproject.toml:**

```toml
[tool.pyright]
pythonVersion = "3.11"
typeCheckingMode = "standard"

[tool.ruff]
line-length = 88
target-version = "py311"

[tool.black]
line-length = 88
target-version = ['py311']

[tool.isort]
profile = "black"
```

### 5. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test file
echo 'def greet(name: str) -> str: return f"Hello, {name}"' > test_lsp.py

# Run type check
pyright test_lsp.py

# Clean up
rm test_lsp.py
```

## Troubleshooting

### Pyright not finding Python

Set the Python path in `pyrightconfig.json`:

```json
{
    "pythonVersion": "3.11",
    "venvPath": ".",
    "venv": ".venv"
}
```

### Virtual environment issues

Ensure your virtual environment is activated before running Claude Code:

```bash
source .venv/bin/activate
claude
```
