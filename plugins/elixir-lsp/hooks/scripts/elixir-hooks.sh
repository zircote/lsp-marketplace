#!/bin/bash
# Elixir development hooks for Claude Code
# Handles: formatting, linting, testing

set -o pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

[ -z "$file_path" ] && exit 0
[ ! -f "$file_path" ] && exit 0

ext="${file_path##*.}"

case "$ext" in
    ex|exs)
        # Mix format (formatting)
        if command -v mix >/dev/null 2>&1; then
            mix format "$file_path" 2>/dev/null || true
        fi

        # Credo (linting)
        if command -v mix >/dev/null 2>&1; then
            mix credo "$file_path" --strict 2>/dev/null || true
        fi

        # Dialyzer (static analysis) - run on directory
        # if command -v mix >/dev/null 2>&1; then
        #     mix dialyzer 2>/dev/null || true
        # fi

        # Surface TODO/FIXME comments
        grep -n -E '(TODO|FIXME|HACK|XXX|BUG):' "$file_path" 2>/dev/null || true
        ;;
    eex|heex|leex)
        # Format templates
        if command -v mix >/dev/null 2>&1; then
            mix format "$file_path" 2>/dev/null || true
        fi
        ;;
esac

exit 0
