#!/bin/bash
# Go development hooks dispatcher
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

# Find module root (where go.mod is)
find_module_root() {
    local d="$1"
    while [ "$d" != "/" ]; do
        [ -f "$d/go.mod" ] && echo "$d" && return
        d=$(dirname "$d")
    done
}

module_root=$(find_module_root "$dir")

case "$ext" in
    go)
        # Format with gofmt or goimports
        if command -v goimports >/dev/null 2>&1; then
            goimports -w "$file_path" 2>/dev/null || true
        else
            gofmt -w "$file_path" 2>/dev/null || true
        fi

        # Vet
        go vet "$file_path" 2>&1 | head -20 || true

        # Build check
        go build -o /dev/null "$file_path" 2>&1 | head -20 || true

        # Lint with golangci-lint
        if command -v golangci-lint >/dev/null 2>&1; then
            golangci-lint run --fast "$file_path" 2>&1 | head -30 || true
        elif command -v staticcheck >/dev/null 2>&1; then
            staticcheck "$file_path" 2>&1 | head -20 || true
        fi

        # Security scan with gosec
        if command -v gosec >/dev/null 2>&1; then
            gosec -quiet -fmt text "$file_path" 2>&1 | head -20 || true
        fi

        # TODO/FIXME check
        grep -nE '(TODO|FIXME|XXX|HACK):?' "$file_path" 2>/dev/null | head -10 || true

        # Error handling check
        if grep -qE 'err\s*:?=.*\n\s*[^if]' "$file_path" 2>/dev/null; then
            echo "⚠️ Possible unhandled error - ensure all errors are checked"
        fi

        # Test file detection and hint
        if [[ "$filename" == *_test.go ]]; then
            echo "💡 Run tests: go test -v -run . $dir"
        fi

        # Race detection hint for test files
        if [[ "$filename" == *_test.go ]] && grep -qE 'go\s+func|sync\.' "$file_path" 2>/dev/null; then
            echo "💡 Concurrency detected - consider: go test -race"
        fi

        # Benchmark hint
        if grep -qE 'func\s+Benchmark' "$file_path" 2>/dev/null; then
            echo "💡 Run benchmarks: go test -bench=. $dir"
        fi
        ;;

    mod)
        if [[ "$filename" == "go.mod" ]]; then
            # Tidy modules
            go mod tidy 2>&1 | head -10 || true

            # Verify
            go mod verify 2>&1 | head -10 || true

            # Vulnerability check
            if command -v govulncheck >/dev/null 2>&1; then
                govulncheck ./... 2>&1 | head -30 || true
            fi

            # Outdated hint
            echo "💡 Check updates: go list -m -u all"
        fi
        ;;

    sum)
        if [[ "$filename" == "go.sum" ]]; then
            # Verify checksums
            go mod verify 2>&1 | head -10 || true
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
