#!/bin/bash
# Kotlin development hooks dispatcher
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
        [ -f "$d/build.gradle.kts" ] && echo "$d" && return
        [ -f "$d/build.gradle" ] && echo "$d" && return
        [ -f "$d/pom.xml" ] && echo "$d" && return
        d=$(dirname "$d")
    done
}

project_root=$(find_project_root "$dir")

case "$ext" in
    kt|kts)
        # Format with ktlint
        if command -v ktlint >/dev/null 2>&1; then
            ktlint -F "$file_path" 2>/dev/null || true
            ktlint "$file_path" 2>&1 | head -20 || true
        fi

        # Detekt static analysis
        if command -v detekt >/dev/null 2>&1; then
            detekt --input "$file_path" 2>&1 | head -30 || true
        fi

        # Compile check
        if [ -n "$project_root" ]; then
            cd "$project_root"
            if [ -f "build.gradle.kts" ] || [ -f "build.gradle" ]; then
                ./gradlew compileKotlin --console=plain -q 2>&1 | tail -20 || true
            fi
        fi

        # TODO/FIXME check
        grep -nE '(TODO|FIXME|XXX|HACK):?' "$file_path" 2>/dev/null | head -10 || true

        # Null safety check
        if grep -qE '\?\.\|!!' "$file_path" 2>/dev/null; then
            bang_count=$(grep -c '!!' "$file_path" 2>/dev/null || echo "0")
            if [ "$bang_count" -gt 0 ]; then
                echo "⚠️ $bang_count non-null assertions (!!) detected - consider safer alternatives"
            fi
        fi

        # Test file detection
        if [[ "$filename" == *Test.kt ]] || [[ "$filename" == *Tests.kt ]]; then
            echo "💡 Run tests: ./gradlew test --tests $(basename "$filename" .kt)"
        fi

        # Coroutines hint
        if grep -qE 'suspend\s+fun|launch\s*\{|async\s*\{' "$file_path" 2>/dev/null; then
            echo "📝 Coroutines detected - ensure proper scope and exception handling"
        fi
        ;;

    gradle)
        if [ -n "$project_root" ]; then
            cd "$project_root"
            ./gradlew help --console=plain -q 2>&1 | head -5 || true
        fi
        echo "💡 Check updates: ./gradlew dependencyUpdates"
        ;;

    md)
        if command -v markdownlint >/dev/null 2>&1; then
            markdownlint "$file_path" 2>&1 | head -20 || true
        fi
        ;;
esac

exit 0
