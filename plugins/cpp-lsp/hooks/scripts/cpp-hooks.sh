#!/bin/bash
# C/C++ development hooks dispatcher
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
        [ -f "$d/CMakeLists.txt" ] && echo "$d" && return
        [ -f "$d/Makefile" ] && echo "$d" && return
        [ -f "$d/meson.build" ] && echo "$d" && return
        d=$(dirname "$d")
    done
}

project_root=$(find_project_root "$dir")

case "$ext" in
    c|h)
        # Format with clang-format
        if command -v clang-format >/dev/null 2>&1; then
            clang-format -i "$file_path" 2>/dev/null || true
        fi

        # Lint with clang-tidy
        if command -v clang-tidy >/dev/null 2>&1; then
            clang-tidy "$file_path" -- 2>&1 | head -30 || true
        fi

        # Compile check
        if command -v clang >/dev/null 2>&1; then
            clang -fsyntax-only -Wall -Wextra "$file_path" 2>&1 | head -20 || true
        elif command -v gcc >/dev/null 2>&1; then
            gcc -fsyntax-only -Wall -Wextra "$file_path" 2>&1 | head -20 || true
        fi

        # TODO/FIXME check
        grep -nE '(TODO|FIXME|XXX|HACK):?' "$file_path" 2>/dev/null | head -10 || true

        # Memory safety hints
        if grep -qE '(malloc|calloc|realloc|free)\s*\(' "$file_path" 2>/dev/null; then
            echo "📝 Manual memory management detected - ensure matching free() calls"
        fi
        ;;

    cpp|cc|cxx|hpp|hxx|hh)
        # Format with clang-format
        if command -v clang-format >/dev/null 2>&1; then
            clang-format -i "$file_path" 2>/dev/null || true
        fi

        # Lint with clang-tidy
        if command -v clang-tidy >/dev/null 2>&1; then
            clang-tidy "$file_path" -- -std=c++17 2>&1 | head -30 || true
        fi

        # Compile check
        if command -v clang++ >/dev/null 2>&1; then
            clang++ -fsyntax-only -std=c++17 -Wall -Wextra "$file_path" 2>&1 | head -20 || true
        elif command -v g++ >/dev/null 2>&1; then
            g++ -fsyntax-only -std=c++17 -Wall -Wextra "$file_path" 2>&1 | head -20 || true
        fi

        # Cppcheck
        if command -v cppcheck >/dev/null 2>&1; then
            cppcheck --enable=warning,style,performance "$file_path" 2>&1 | head -20 || true
        fi

        # TODO/FIXME check
        grep -nE '(TODO|FIXME|XXX|HACK):?' "$file_path" 2>/dev/null | head -10 || true

        # Modern C++ hints
        if grep -qE 'new\s+[A-Z]|delete\s+' "$file_path" 2>/dev/null; then
            echo "💡 Raw new/delete detected - consider smart pointers"
        fi

        # Memory safety hints
        if grep -qE 'std::unique_ptr|std::shared_ptr|std::make_unique|std::make_shared' "$file_path" 2>/dev/null; then
            echo "📝 Good: Using smart pointers"
        fi
        ;;

    cmake)
        if [[ "$filename" == "CMakeLists.txt" ]] && [ -n "$project_root" ]; then
            cd "$project_root"
            if [ -d "build" ]; then
                cmake --build build --target help 2>&1 | head -10 || true
            else
                echo "💡 Configure: cmake -B build -S ."
            fi
        fi
        ;;

    md)
        if command -v markdownlint >/dev/null 2>&1; then
            markdownlint "$file_path" 2>&1 | head -20 || true
        fi
        ;;
esac

exit 0
