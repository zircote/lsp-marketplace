---
description: Interactive setup for PHP LSP development environment
---

# PHP LSP Setup

This command will configure your PHP development environment with Phpactor and essential tools.

## Prerequisites Check

First, verify PHP is installed:

```bash
php --version
composer --version
```

## Installation Steps

### 1. Install Phpactor LSP Server

```bash
composer global require phpactor/phpactor
```

### 2. Install Development Tools

```bash
# Formatting
composer global require friendsofphp/php-cs-fixer

# Static analysis
composer global require phpstan/phpstan
composer global require vimeo/psalm

# Linting
composer global require squizlabs/php_codesniffer
```

### 3. Verify Installation

```bash
phpactor --version
php-cs-fixer --version
phpstan --version
```

### 4. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test file
echo '<?php function greet(string $name): string { return "Hello, $name!"; }' > test_lsp.php

# Run PHP-CS-Fixer
php-cs-fixer fix test_lsp.php

# Run PHPStan
phpstan analyse test_lsp.php

# Clean up
rm test_lsp.php
```
