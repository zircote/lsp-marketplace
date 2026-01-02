#!/bin/bash
# TypeScript/JavaScript development hooks dispatcher
# Reads tool input from stdin and runs appropriate checks based on file type

set -o pipefail

# Read JSON input from stdin
input=$(cat)

# Extract file path from tool_input
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Exit if no file path
[ -z "$file_path" ] && exit 0

# Get file extension and name
ext="${file_path##*.}"
filename=$(basename "$file_path")
dir=$(dirname "$file_path")

# Find project root (where package.json is)
find_project_root() {
    local d="$1"
    while [ "$d" != "/" ]; do
        [ -f "$d/package.json" ] && echo "$d" && return
        d=$(dirname "$d")
    done
}

project_root=$(find_project_root "$dir")

case "$ext" in
    ts|tsx|js|jsx|mts|cts|mjs|cjs)
        # Format with prettier or biome
        if command -v prettier >/dev/null 2>&1; then
            prettier --write "$file_path" 2>/dev/null || true
        elif command -v biome >/dev/null 2>&1; then
            biome format --write "$file_path" 2>/dev/null || true
        fi

        # Lint with eslint or biome
        if command -v eslint >/dev/null 2>&1; then
            eslint --format compact "$file_path" 2>&1 | head -30 || true
        elif command -v biome >/dev/null 2>&1; then
            biome lint "$file_path" 2>&1 | head -30 || true
        fi

        # Type check TypeScript files
        if [[ "$ext" == "ts" || "$ext" == "tsx" || "$ext" == "mts" || "$ext" == "cts" ]]; then
            if [ -n "$project_root" ] && [ -f "$project_root/tsconfig.json" ]; then
                cd "$project_root" && npx tsc --noEmit --pretty 2>&1 | head -30 || true
            fi
        fi

        # TODO/FIXME check
        grep -nE '(TODO|FIXME|XXX|HACK):?' "$file_path" 2>/dev/null | head -10 || true

        # Security: Check for common issues
        if grep -qE '(eval\(|innerHTML\s*=|document\.write)' "$file_path" 2>/dev/null; then
            echo "⚠️ Potential security issue: eval/innerHTML/document.write detected"
        fi

        # Console.log detection (for production code)
        if [[ ! "$filename" =~ (test|spec)\. ]] && grep -qn 'console\.' "$file_path" 2>/dev/null; then
            grep -n 'console\.' "$file_path" | head -5
            echo "💡 Consider removing console statements for production"
        fi

        # Test file detection and hint
        if [[ "$filename" =~ \.(test|spec)\.(ts|tsx|js|jsx)$ ]]; then
            if [ -f "$project_root/package.json" ]; then
                if grep -q '"vitest"' "$project_root/package.json" 2>/dev/null; then
                    echo "💡 Run tests: npx vitest run $file_path"
                elif grep -q '"jest"' "$project_root/package.json" 2>/dev/null; then
                    echo "💡 Run tests: npx jest $file_path"
                fi
            fi
        fi

        # Import organization check (basic)
        if command -v eslint >/dev/null 2>&1; then
            eslint --rule 'import/order: warn' "$file_path" 2>&1 | grep -i 'import' | head -5 || true
        fi
        ;;

    json)
        # Validate JSON syntax
        if ! jq empty "$file_path" 2>/dev/null; then
            echo "⚠️ Invalid JSON syntax in $filename"
        fi

        if [[ "$filename" == "package.json" ]]; then
            # Check for npm audit
            if [ -n "$project_root" ]; then
                cd "$project_root"
                if command -v npm >/dev/null 2>&1; then
                    npm audit --json 2>/dev/null | jq -r '.metadata.vulnerabilities | to_entries[] | select(.value > 0) | "\(.key): \(.value)"' 2>/dev/null | head -10 || true
                fi
            fi

            # Outdated dependencies hint
            echo "💡 Check outdated: npm outdated"
        fi

        if [[ "$filename" == "tsconfig.json" ]]; then
            echo "💡 Validate config: npx tsc --showConfig"
        fi
        ;;

    md)
        # Markdown lint
        if command -v markdownlint >/dev/null 2>&1; then
            markdownlint "$file_path" 2>&1 | head -20 || true
        fi
        ;;
esac

exit 0
