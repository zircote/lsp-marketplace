---
description: Interactive setup for C/C++ LSP development environment
---

# C/C++ LSP Setup

This command will configure your C/C++ development environment with clangd LSP and essential tools.

## Installation Steps

### 1. Install LLVM (includes clangd)

**macOS (Homebrew):**

```bash
brew install llvm
```

Add to PATH:

```bash
echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 2. Install Additional Tools

```bash
# Static analysis
brew install cppcheck

# CMake (for compile_commands.json generation)
brew install cmake
```

### 3. Verify Installation

```bash
clangd --version
clang-format --version
clang-tidy --version
cppcheck --version
```

### 4. Generate compile_commands.json

For CMake projects:

```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build
ln -s build/compile_commands.json .
```

For Make projects:

```bash
brew install bear
bear -- make
```

### 5. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```
