#!/bin/bash
# Ruby development hooks dispatcher
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

# Find project root
find_project_root() {
    local d="$1"
    while [ "$d" != "/" ]; do
        [ -f "$d/Gemfile" ] && echo "$d" && return
        d=$(dirname "$d")
    done
}

project_root=$(find_project_root "$dir")

case "$ext" in
    rb|rake)
        # Syntax check
        ruby -c "$file_path" 2>&1 | head -10 || true

        # Format and lint with RuboCop
        if command -v rubocop >/dev/null 2>&1; then
            rubocop -a "$file_path" 2>/dev/null || true
            rubocop --format simple "$file_path" 2>&1 | head -30 || true
        fi

        # Security scan with Brakeman (for Rails apps)
        if [ -n "$project_root" ] && [ -d "$project_root/app" ]; then
            if command -v brakeman >/dev/null 2>&1; then
                brakeman -q --only-files "$file_path" 2>&1 | head -20 || true
            fi
        fi

        # TODO/FIXME check
        grep -nE '(TODO|FIXME|XXX|HACK):?' "$file_path" 2>/dev/null | head -10 || true

        # Test file detection
        if [[ "$filename" == *_spec.rb ]]; then
            echo "💡 Run tests: bundle exec rspec $file_path"
        elif [[ "$filename" == *_test.rb ]] || [[ "$filename" == test_*.rb ]]; then
            echo "💡 Run tests: bundle exec ruby $file_path"
        fi

        # Rails-specific checks
        if grep -qE 'class\s+\w+Controller' "$file_path" 2>/dev/null; then
            echo "📝 Controller detected"
            if grep -qE 'params\[' "$file_path" 2>/dev/null; then
                if ! grep -qE 'params\.require\|params\.permit' "$file_path" 2>/dev/null; then
                    echo "⚠️ Consider using strong parameters"
                fi
            fi
        fi

        # SQL injection check
        if grep -qE 'where\s*\(\s*["\x27].*#\{' "$file_path" 2>/dev/null; then
            echo "⚠️ Potential SQL injection - use parameterized queries"
        fi
        ;;

    gemspec)
        # Validate gemspec
        if command -v gem >/dev/null 2>&1; then
            gem build "$file_path" --force 2>&1 | tail -10 || true
        fi
        ;;

    Gemfile|gemfile)
        # Bundle check
        if command -v bundle >/dev/null 2>&1 && [ -n "$project_root" ]; then
            cd "$project_root"
            bundle check 2>&1 | head -10 || echo "💡 Run: bundle install"
        fi

        # Security audit
        if command -v bundle-audit >/dev/null 2>&1; then
            bundle-audit check 2>&1 | head -20 || true
        fi

        # Outdated gems
        echo "💡 Check updates: bundle outdated"
        ;;

    yml|yaml)
        # YAML syntax check
        if command -v ruby >/dev/null 2>&1; then
            ruby -e "require 'yaml'; YAML.load_file('$file_path')" 2>&1 || echo "⚠️ Invalid YAML syntax"
        fi
        ;;

    md)
        if command -v markdownlint >/dev/null 2>&1; then
            markdownlint "$file_path" 2>&1 | head -20 || true
        fi
        ;;
esac

exit 0
