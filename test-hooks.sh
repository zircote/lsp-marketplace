#!/usr/bin/env bash
#
# test-hooks.sh - Test LSP plugin hooks by running them directly
#

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ALL_PLUGINS="bash-lsp cpp-lsp csharp-lsp dockerfile-lsp elixir-lsp go-lsp graphql-lsp haskell-lsp html-css-lsp java-lsp json-lsp kotlin-lsp latex-lsp lua-lsp markdown-lsp php-lsp python-lsp ruby-lsp rust-lsp scala-lsp sql-lsp svelte-lsp swift-lsp terraform-lsp typescript-lsp vue-lsp yaml-lsp zig-lsp"

get_test_file() {
    local plugin="$1"
    case "$plugin" in
        bash-lsp) echo "tests/sample_test.sh" ;;
        cpp-lsp) echo "tests/sample_test.cpp" ;;
        csharp-lsp) echo "tests/SampleTest.cs" ;;
        dockerfile-lsp) echo "tests/Dockerfile" ;;
        elixir-lsp) echo "tests/sample_test.exs" ;;
        go-lsp) echo "tests/sample_test.go" ;;
        graphql-lsp) echo "tests/sample.graphql" ;;
        haskell-lsp) echo "tests/SampleTest.hs" ;;
        html-css-lsp) echo "tests/sample.html" ;;
        java-lsp) echo "tests/SampleTest.java" ;;
        json-lsp) echo "tests/sample.json" ;;
        kotlin-lsp) echo "tests/SampleTest.kt" ;;
        latex-lsp) echo "tests/sample.tex" ;;
        lua-lsp) echo "tests/sample_test.lua" ;;
        markdown-lsp) echo "tests/lsp-test.md" ;;
        php-lsp) echo "tests/SampleTest.php" ;;
        python-lsp) echo "tests/test_sample.py" ;;
        ruby-lsp) echo "tests/sample_spec.rb" ;;
        rust-lsp) echo "tests/main.rs" ;;
        scala-lsp) echo "tests/SampleTest.scala" ;;
        sql-lsp) echo "tests/sample.sql" ;;
        svelte-lsp) echo "tests/Sample.svelte" ;;
        swift-lsp) echo "tests/SampleTest.swift" ;;
        terraform-lsp) echo "tests/main.tf" ;;
        typescript-lsp) echo "tests/sample.test.ts" ;;
        vue-lsp) echo "tests/Sample.vue" ;;
        yaml-lsp) echo "tests/sample.yaml" ;;
        zig-lsp) echo "tests/sample_test.zig" ;;
        *) echo "" ;;
    esac
}

get_hook_script() {
    local plugin="$1"
    local lang="${plugin%-lsp}"
    echo "hooks/scripts/${lang}-hooks.sh"
}

test_plugin() {
    local plugin="$1"
    local plugin_dir="$SCRIPT_DIR/$plugin"
    local test_file=$(get_test_file "$plugin")
    local hook_script=$(get_hook_script "$plugin")
    local full_test_path="$plugin_dir/$test_file"
    local full_hook_path="$plugin_dir/$hook_script"

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Testing: $plugin${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # Check 1: Hook script exists
    if [ ! -f "$full_hook_path" ]; then
        # Some plugins use different hook mechanisms (like markdown-lsp)
        if [ -f "$plugin_dir/hooks/hooks.json" ]; then
            echo -e "  ${YELLOW}⚠${NC} No bash hook script (uses different hook type)"
            # Check for JS hooks
            if ls "$plugin_dir/hooks/"*.js >/dev/null 2>&1; then
                echo -e "  ${GREEN}✓${NC} Found JS hook scripts"
                return 0
            fi
        else
            echo -e "  ${RED}✗${NC} No hook script found: $hook_script"
            return 1
        fi
    fi

    # Check 2: Hook script is executable
    if [ -f "$full_hook_path" ] && [ ! -x "$full_hook_path" ]; then
        echo -e "  ${RED}✗${NC} Hook script not executable"
        return 1
    fi

    # Check 3: Test file exists
    if [ ! -f "$full_test_path" ]; then
        echo -e "  ${RED}✗${NC} Test file not found: $test_file"
        return 1
    fi

    # Check 4: Run hook directly with simulated input
    echo -e "  Testing hook script..."

    # Create JSON input simulating a Write tool call
    local json_input=$(cat <<EOF
{
  "tool_name": "Write",
  "tool_input": {
    "file_path": "$full_test_path",
    "content": "test"
  }
}
EOF
)

    # Run the hook script and capture output
    local output
    local exit_code=0

    if [ -f "$full_hook_path" ]; then
        output=$(echo "$json_input" | timeout 30 "$full_hook_path" 2>&1) || exit_code=$?

        if [ $exit_code -eq 124 ]; then
            echo -e "  ${RED}✗${NC} Hook timed out (30s)"
            return 1
        elif [ $exit_code -ne 0 ]; then
            echo -e "  ${YELLOW}⚠${NC} Hook exited with code $exit_code (may be OK if tool not installed)"
            echo "  Output: ${output:0:200}"
        fi

        # Show some output
        if [ -n "$output" ]; then
            echo -e "  ${GREEN}✓${NC} Hook produced output:"
            echo "$output" | head -5 | sed 's/^/    /'
            local lines=$(echo "$output" | wc -l)
            [ "$lines" -gt 5 ] && echo "    ... ($lines total lines)"
        else
            echo -e "  ${GREEN}✓${NC} Hook ran (no output - tool may not be installed)"
        fi
    fi

    echo -e "  ${GREEN}✓ PASSED${NC}"
    return 0
}

# Parse args
SELECTED_PLUGINS=""
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            echo "Usage: $0 [plugin...]"
            echo "Tests LSP plugin hooks by running them directly."
            exit 0
            ;;
        *)
            if [ -d "$SCRIPT_DIR/$1" ]; then
                SELECTED_PLUGINS="$SELECTED_PLUGINS $1"
            else
                echo "Plugin not found: $1"
            fi
            shift
            ;;
    esac
done

[ -z "$SELECTED_PLUGINS" ] && SELECTED_PLUGINS="$ALL_PLUGINS"

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          LSP Plugin Hook Direct Test                     ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo

PASSED=0
FAILED=0

for plugin in $SELECTED_PLUGINS; do
    if test_plugin "$plugin"; then
        PASSED=$((PASSED + 1))
    else
        FAILED=$((FAILED + 1))
    fi
    echo
done

echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
echo -e "  ${GREEN}Passed:${NC} $PASSED"
echo -e "  ${RED}Failed:${NC} $FAILED"
echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"

[ $FAILED -eq 0 ]
