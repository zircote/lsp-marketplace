---
description: Interactive setup for Kotlin LSP development environment
---

# Kotlin LSP Setup

This command will configure your Kotlin development environment with kotlin-language-server and essential tools.

## Prerequisites Check

First, verify Java is installed (JDK 17+ required):

```bash
java -version
```

## Installation Steps

### 1. Install Kotlin Language Server

```bash
brew install kotlin-language-server
```

### 2. Install Development Tools

```bash
# Linting and formatting
brew install ktlint

# Static analysis
brew install detekt
```

### 3. Verify Installation

```bash
kotlin-language-server --version
ktlint --version
detekt --version
```

### 4. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration with a Kotlin file in a Gradle project.
