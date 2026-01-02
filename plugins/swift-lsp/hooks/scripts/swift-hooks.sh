#!/bin/bash
# Swift development hooks for Claude Code
# Handles: formatting, linting, building, testing

set -o pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

[ -z "$file_path" ] && exit 0
[ ! -f "$file_path" ] && exit 0

ext="${file_path##*.}"

case "$ext" in
    swift)
        # SwiftFormat (formatting)
        if command -v swiftformat >/dev/null 2>&1; then
            swiftformat "$file_path" --quiet 2>/dev/null || true
        fi

        # SwiftLint (linting)
        if command -v swiftlint >/dev/null 2>&1; then
            swiftlint lint --path "$file_path" --quiet 2>/dev/null || true
        fi

        # Syntax check via swift compiler
        if command -v swiftc >/dev/null 2>&1; then
            swiftc -parse "$file_path" 2>&1 || true
        fi

        # Surface TODO/FIXME comments
        grep -n -E '(TODO|FIXME|HACK|XXX|BUG):' "$file_path" 2>/dev/null || true
        ;;
esac

exit 0
