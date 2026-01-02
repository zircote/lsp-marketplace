#!/bin/bash
# Svelte development hooks for Claude Code
# Handles: linting, formatting, type checking

set -o pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

[ -z "$file_path" ] && exit 0
[ ! -f "$file_path" ] && exit 0

ext="${file_path##*.}"

case "$ext" in
    svelte)
        # Prettier formatting
        if command -v prettier >/dev/null 2>&1; then
            prettier --write "$file_path" --plugin prettier-plugin-svelte 2>/dev/null || true
        fi

        # ESLint (linting)
        if command -v eslint >/dev/null 2>&1; then
            eslint --fix "$file_path" 2>/dev/null || true
        fi

        # Svelte check (type checking)
        if command -v svelte-check >/dev/null 2>&1; then
            svelte-check --fail-on-warnings 2>/dev/null || true
        fi

        # Surface TODO/FIXME comments
        grep -n -E '(TODO|FIXME|HACK|XXX|BUG):' "$file_path" 2>/dev/null || true
        ;;
esac

exit 0
