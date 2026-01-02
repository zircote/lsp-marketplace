---
description: Interactive setup for LaTeX LSP development environment
---

# LaTeX LSP Setup

This command will configure your LaTeX development environment with Texlab LSP and essential tools.

## Prerequisites Check

First, verify a TeX distribution is installed:

```bash
pdflatex --version || xelatex --version || lualatex --version
```

If not installed, install a TeX distribution:
- **macOS**: `brew install --cask mactex` or `brew install --cask basictex`
- **Linux**: `sudo apt install texlive-full` (Debian/Ubuntu) or `sudo dnf install texlive-scheme-full` (Fedora)
- **Windows**: Download and install [MiKTeX](https://miktex.org/) or [TeX Live](https://www.tug.org/texlive/)

## Installation Steps

### 1. Install Texlab LSP Server

**Option 1: Cargo (recommended)**

```bash
cargo install --locked texlab
```

**Option 2: Package Manager**

```bash
# macOS
brew install texlab

# Arch Linux
sudo pacman -S texlab

# Fedora
sudo dnf install texlab
```

### 2. Install ChkTeX (LaTeX Linter)

```bash
# macOS
brew install chktex

# Debian/Ubuntu
sudo apt install chktex

# Fedora
sudo dnf install chktex

# Arch Linux
sudo pacman -S chktex
```

### 3. Verify Installation

```bash
# Check Texlab
texlab --version

# Check ChkTeX
chktex --version

# Check LaTeX
pdflatex --version
```

### 4. Optional: Install Latexmk (Build Automation)

```bash
# Usually included with TeX Live
latexmk --version

# If not available, install TeX Live extras
sudo apt install latexmk  # Debian/Ubuntu
```

### 5. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Configuration (Optional)

### Texlab Configuration

Create `texlab.toml` or `.texlabrc` in your project root:

```toml
[build]
executable = "latexmk"
args = ["-pdf", "-interaction=nonstopmode", "-synctex=1", "%f"]
onSave = false

[chktex]
onEdit = true
onOpenAndSave = true

[formatting]
lineLength = 80
```

### ChkTeX Configuration

Create `.chktexrc` in your project root to customize warnings:

```
# Disable specific warnings
-n1  # Command terminated with space
-n2  # Non-breaking space (~) should be used
-n8  # Wrong length of dash

# Set tabsize
TabSize = 2
```

## Verification

Test the LSP integration:

```bash
# Create a test file
cat > test_lsp.tex << 'EOF'
\documentclass{article}
\begin{document}
Hello, \LaTeX!
\end{document}
EOF

# Run chktex
chktex test_lsp.tex

# Clean up
rm test_lsp.tex
```

## Troubleshooting

### Texlab not finding TeX distribution

Set the TeX path in `texlab.toml`:

```toml
[build]
executable = "/usr/local/texlive/2023/bin/x86_64-darwin/latexmk"
```

### Build not working

1. Ensure `latexmk` is installed
2. Check build configuration in `texlab.toml`
3. Verify TeX distribution is in PATH: `which pdflatex`

### ChkTeX too many warnings

Create `.chktexrc` to disable specific warnings (see Configuration section above).

## Quick Install (All Tools)

```bash
# macOS
brew install texlab chktex && brew install --cask basictex

# Debian/Ubuntu
sudo apt install texlive-latex-base texlive-latex-recommended \
                 texlive-latex-extra latexmk chktex && \
cargo install --locked texlab

# Fedora
sudo dnf install texlive-scheme-medium latexmk chktex && \
cargo install --locked texlab
```
