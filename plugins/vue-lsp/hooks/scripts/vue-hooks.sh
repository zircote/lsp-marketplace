#!/bin/bash
# Vue development hooks for Claude Code
# Handles: linting, formatting

set -o pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

[ -z "$file_path" ] && exit 0
[ ! -f "$file_path" ] && exit 0

ext="${file_path##*.}"

case "$ext" in
    vue)
        # Prettier formatting
        if command -v prettier >/dev/null 2>&1; then
            prettier --write "$file_path" 2>/dev/null || true
        fi

        # ESLint (linting)
        if command -v eslint >/dev/null 2>&1; then
            eslint --fix "$file_path" 2>/dev/null || true
        fi

        # Vue type checking
        if command -v vue-tsc >/dev/null 2>&1; then
            vue-tsc --noEmit 2>/dev/null || true
        fi

        # Surface TODO/FIXME comments
        grep -n -E '(TODO|FIXME|HACK|XXX|BUG):' "$file_path" 2>/dev/null || true
        ;;
esac

exit 0
