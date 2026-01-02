---
description: Interactive setup for C# LSP development environment
---

# C# LSP Setup

This command will configure your C# development environment with OmniSharp LSP and essential tools.

## Prerequisites Check

First, verify .NET is installed:

```bash
dotnet --version
```

## Installation Steps

### 1. Install OmniSharp LSP Server

**macOS (Homebrew):**

```bash
brew install omnisharp
```

**Or using dotnet tool:**

```bash
dotnet tool install --global csharp-ls
```

### 2. Verify Installation

```bash
omnisharp --version
# or
csharp-ls --version
```

### 3. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test project
dotnet new console -n TestProject && cd TestProject

# Build
dotnet build

# Clean up
cd .. && rm -rf TestProject
```
