# php-lsp

A Claude Code plugin providing comprehensive PHP development support through:

- **Phpactor** LSP integration for IDE-like features
- **Automated hooks** for linting, formatting, static analysis, and testing
- **PHP ecosystem** integration (PHP-CS-Fixer, PHPStan, Psalm, PHPUnit)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install Phpactor LSP
composer global require phpactor/phpactor

# Install development tools
composer global require friendsofphp/php-cs-fixer
composer global require phpstan/phpstan
composer global require squizlabs/php_codesniffer
```

## Features

### LSP Integration

The plugin configures Phpactor for Claude Code via `.lsp.json`:

```json
{
    "php": {
        "command": "phpactor",
        "args": ["language-server"],
        "extensionToLanguage": {
            ".php": "php",
            ".phtml": "php"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition / references
- Hover documentation
- Code completion
- Refactoring support
- Real-time diagnostics

### Automated Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `php-syntax-check` | `**/*.php` | PHP syntax validation |
| `php-cs-fixer` | `**/*.php` | Code style formatting |
| `phpstan-check` | `**/*.php` | Static analysis |
| `phpcs-lint` | `**/*.php` | PSR-12 compliance |
| `php-todo-fixme` | `**/*.php` | Surface TODO/FIXME comments |

## Required Tools

| Tool | Installation | Purpose |
|------|--------------|---------|
| `phpactor` | `composer global require phpactor/phpactor` | LSP server |
| `php-cs-fixer` | `composer global require friendsofphp/php-cs-fixer` | Formatting |
| `phpstan` | `composer global require phpstan/phpstan` | Static analysis |
| `phpcs` | `composer global require squizlabs/php_codesniffer` | Linting |

## Project Structure

```
php-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # Phpactor configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── scripts/
│       └── php-hooks.sh
├── tests/
│   └── SampleTest.php        # Test file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## License

MIT
