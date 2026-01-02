#!/bin/bash
# PHP development hooks for Claude Code
# Handles: formatting, linting, static analysis, security, testing

set -o pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

[ -z "$file_path" ] && exit 0
[ ! -f "$file_path" ] && exit 0

ext="${file_path##*.}"

case "$ext" in
    php|phtml)
        # Syntax check
        php -l "$file_path" 2>&1 || true

        # PHP-CS-Fixer (formatting)
        if command -v php-cs-fixer >/dev/null 2>&1; then
            php-cs-fixer fix "$file_path" --quiet 2>/dev/null || true
        fi

        # PHPStan (static analysis)
        if command -v phpstan >/dev/null 2>&1; then
            phpstan analyse "$file_path" --no-progress 2>/dev/null || true
        fi

        # Psalm (static analysis alternative)
        if command -v psalm >/dev/null 2>&1; then
            psalm "$file_path" --no-progress 2>/dev/null || true
        fi

        # PHP_CodeSniffer (linting)
        if command -v phpcs >/dev/null 2>&1; then
            phpcs --standard=PSR12 "$file_path" 2>/dev/null || true
        fi

        # Surface TODO/FIXME comments
        grep -n -E '(TODO|FIXME|HACK|XXX|BUG):' "$file_path" 2>/dev/null || true
        ;;
esac

exit 0
