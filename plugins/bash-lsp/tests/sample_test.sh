# Hook test
#!/bin/bash
# Sample Bash test file for LSP plugin validation.
#
# This file contains various Bash constructs to test:
# - LSP operations (hover, go to definition, references)
# - Hook validation (linting, formatting)

set -euo pipefail

# Represents a user greeting
greet() {
    local name="$1"
    echo "Hello, ${name}!"
}

# Checks if a user is an adult (18+)
is_adult() {
    local age="${1:-}"
    if [[ -z "$age" ]]; then
        echo "false"
        return 1
    fi
    if [[ "$age" -ge 18 ]]; then
        echo "true"
        return 0
    else
        echo "false"
        return 1
    fi
}

# Calculates the average of numbers
calculate_average() {
    if [[ $# -eq 0 ]]; then
        echo "Error: Cannot calculate average of empty list" >&2
        return 1
    fi

    local sum=0
    local count=0
    for num in "$@"; do
        sum=$((sum + num))
        count=$((count + 1))
    done

    echo "scale=2; $sum / $count" | bc
}

# Find user by email in a simple associative array
declare -A USERS

add_user() {
    local name="$1"
    local email="$2"
    local age="${3:-}"
    USERS["$email"]="$name:$age"
}

find_by_email() {
    local email="$1"
    if [[ -v USERS["$email"] ]]; then
        echo "${USERS[$email]}"
    else
        echo ""
    fi
}

get_user_count() {
    echo "${#USERS[@]}"
}

# TODO: Add more test cases
# FIXME: Handle edge cases

# Test functions
test_greet() {
    local result
    result=$(greet "Alice")
    if [[ "$result" == "Hello, Alice!" ]]; then
        echo "test_greet passed"
    else
        echo "test_greet failed: expected 'Hello, Alice!' but got '$result'"
        exit 1
    fi
}

test_is_adult() {
    local result

    result=$(is_adult 25)
    if [[ "$result" != "true" ]]; then
        echo "test_is_adult failed: adult check"
        exit 1
    fi

    result=$(is_adult 15)
    if [[ "$result" != "false" ]]; then
        echo "test_is_adult failed: minor check"
        exit 1
    fi

    result=$(is_adult "")
    if [[ "$result" != "false" ]]; then
        echo "test_is_adult failed: no age check"
        exit 1
    fi

    echo "test_is_adult passed"
}

test_user_service() {
    add_user "Eve" "eve@example.com" "30"

    local count
    count=$(get_user_count)
    if [[ "$count" -ne 1 ]]; then
        echo "test_user_service failed: count test"
        exit 1
    fi

    local found
    found=$(find_by_email "eve@example.com")
    if [[ -z "$found" ]]; then
        echo "test_user_service failed: find test"
        exit 1
    fi

    echo "test_user_service passed"
}

test_calculate_average() {
    local result
    result=$(calculate_average 1 2 3 4 5)
    if [[ "$result" != "3.00" ]]; then
        echo "test_calculate_average failed: expected '3.00' but got '$result'"
        exit 1
    fi

    if calculate_average 2>/dev/null; then
        echo "test_calculate_average failed: should have errored on empty"
        exit 1
    fi

    echo "test_calculate_average passed"
}

# Run tests
main() {
    test_greet
    test_is_adult
    test_user_service
    test_calculate_average
    echo "All tests passed!"
}

main "$@"
