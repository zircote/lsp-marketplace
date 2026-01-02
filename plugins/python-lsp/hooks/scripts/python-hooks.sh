#!/bin/bash
# Python development hooks dispatcher
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

case "$ext" in
    py)
        # Format with black or ruff
        if command -v ruff >/dev/null 2>&1; then
            ruff format "$file_path" 2>/dev/null || true
        elif command -v black >/dev/null 2>&1; then
            black --quiet "$file_path" 2>/dev/null || true
        fi

        # Sort imports with isort or ruff
        if command -v ruff >/dev/null 2>&1; then
            ruff check --select I --fix "$file_path" 2>/dev/null || true
        elif command -v isort >/dev/null 2>&1; then
            isort --quiet "$file_path" 2>/dev/null || true
        fi

        # Lint with ruff or flake8
        if command -v ruff >/dev/null 2>&1; then
            ruff check "$file_path" 2>&1 | head -30 || true
        elif command -v flake8 >/dev/null 2>&1; then
            flake8 "$file_path" 2>&1 | head -30 || true
        fi

        # Type check with pyright or mypy
        if command -v pyright >/dev/null 2>&1; then
            pyright "$file_path" 2>&1 | head -20 || true
        elif command -v mypy >/dev/null 2>&1; then
            mypy "$file_path" --no-error-summary 2>&1 | head -20 || true
        fi

        # Security scan with bandit
        if command -v bandit >/dev/null 2>&1; then
            bandit -q -ll "$file_path" 2>&1 | head -15 || true
        fi

        # TODO/FIXME check
        grep -nE '(TODO|FIXME|XXX|HACK):?' "$file_path" 2>/dev/null | head -10 || true

        # Test file detection and hint
        if [[ "$filename" == test_* ]] || [[ "$filename" == *_test.py ]]; then
            echo "💡 Run tests: pytest $file_path"
        fi

        # Docstring check for public functions
        if grep -qE '^\s*def [^_]' "$file_path" 2>/dev/null; then
            if ! grep -qE '"""' "$file_path" 2>/dev/null; then
                echo "📝 Consider adding docstrings to public functions"
            fi
        fi
        ;;

    pyi)
        # Type stub files - just type check
        if command -v pyright >/dev/null 2>&1; then
            pyright "$file_path" 2>&1 | head -20 || true
        fi
        ;;

    toml)
        if [[ "$filename" == "pyproject.toml" ]]; then
            # Validate pyproject.toml
            if command -v python >/dev/null 2>&1; then
                python -c "import tomllib; tomllib.load(open('$file_path', 'rb'))" 2>&1 || echo "⚠️ Invalid TOML syntax"
            fi

            # Check for outdated dependencies
            if command -v pip-audit >/dev/null 2>&1; then
                echo "💡 Security audit: pip-audit"
            fi

            # Dependency update hint
            echo "💡 Update deps: pip install --upgrade -e ."
        fi
        ;;

    txt)
        if [[ "$filename" == "requirements.txt" ]]; then
            # Security audit
            if command -v pip-audit >/dev/null 2>&1; then
                pip-audit -r "$file_path" 2>&1 | head -20 || true
            elif command -v safety >/dev/null 2>&1; then
                safety check -r "$file_path" 2>&1 | head -20 || true
            fi

            # Check for unpinned versions
            if grep -qE '^[a-zA-Z]' "$file_path" 2>/dev/null; then
                unpinned=$(grep -E '^[a-zA-Z][^=<>]*$' "$file_path" 2>/dev/null | head -5)
                if [ -n "$unpinned" ]; then
                    echo "⚠️ Unpinned dependencies detected:"
                    echo "$unpinned"
                fi
            fi
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
