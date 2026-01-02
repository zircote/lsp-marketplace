#!/bin/bash
# Java development hooks dispatcher
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

# Find project root (where pom.xml or build.gradle is)
find_project_root() {
    local d="$1"
    while [ "$d" != "/" ]; do
        [ -f "$d/pom.xml" ] && echo "$d" && return
        [ -f "$d/build.gradle" ] && echo "$d" && return
        [ -f "$d/build.gradle.kts" ] && echo "$d" && return
        d=$(dirname "$d")
    done
}

project_root=$(find_project_root "$dir")
build_tool=""
[ -f "$project_root/pom.xml" ] && build_tool="maven"
[ -f "$project_root/build.gradle" ] || [ -f "$project_root/build.gradle.kts" ] && build_tool="gradle"

case "$ext" in
    java)
        # Format with google-java-format if available
        if command -v google-java-format >/dev/null 2>&1; then
            google-java-format --replace "$file_path" 2>/dev/null || true
        fi

        # Compile check
        if [ -n "$project_root" ]; then
            cd "$project_root"
            if [ "$build_tool" = "maven" ]; then
                mvn compile -q 2>&1 | tail -20 || true
            elif [ "$build_tool" = "gradle" ]; then
                ./gradlew compileJava --console=plain -q 2>&1 | tail -20 || true
            fi
        fi

        # Checkstyle
        if command -v checkstyle >/dev/null 2>&1; then
            checkstyle -c /google_checks.xml "$file_path" 2>&1 | head -20 || true
        fi

        # SpotBugs (if JAR exists)
        if [ -n "$project_root" ]; then
            if [ "$build_tool" = "maven" ] && grep -q 'spotbugs-maven-plugin' "$project_root/pom.xml" 2>/dev/null; then
                echo "💡 Static analysis: mvn spotbugs:check"
            elif [ "$build_tool" = "gradle" ]; then
                echo "💡 Static analysis: ./gradlew spotbugsMain"
            fi
        fi

        # TODO/FIXME check
        grep -nE '(TODO|FIXME|XXX|HACK):?' "$file_path" 2>/dev/null | head -10 || true

        # Test file detection and hint
        if [[ "$filename" == *Test.java ]] || [[ "$filename" == *Tests.java ]]; then
            if [ "$build_tool" = "maven" ]; then
                echo "💡 Run tests: mvn test -Dtest=$(basename "$filename" .java)"
            elif [ "$build_tool" = "gradle" ]; then
                echo "💡 Run tests: ./gradlew test --tests $(basename "$filename" .java)"
            fi
        fi

        # Security: Check for common issues
        if grep -qE '(Runtime\.getRuntime\(\)\.exec|ProcessBuilder)' "$file_path" 2>/dev/null; then
            echo "⚠️ Command execution detected - ensure proper input validation"
        fi

        # Null safety hint
        if grep -qn '@Nullable\|@NonNull\|@NotNull' "$file_path" 2>/dev/null; then
            echo "📝 Null annotations detected - good practice!"
        elif grep -qE 'null\s*[!=]=|==\s*null' "$file_path" 2>/dev/null; then
            echo "💡 Consider using @Nullable/@NonNull annotations"
        fi
        ;;

    xml)
        if [[ "$filename" == "pom.xml" ]]; then
            # Validate POM
            if command -v mvn >/dev/null 2>&1; then
                cd "$project_root" && mvn validate -q 2>&1 | tail -10 || true
            fi

            # Dependency updates
            echo "💡 Check updates: mvn versions:display-dependency-updates"

            # Security audit
            if grep -q 'dependency-check-maven' "$file_path" 2>/dev/null; then
                echo "💡 Security scan: mvn dependency-check:check"
            fi
        fi
        ;;

    gradle|kts)
        if [[ "$filename" == "build.gradle" ]] || [[ "$filename" == "build.gradle.kts" ]]; then
            # Validate build
            if [ -n "$project_root" ]; then
                cd "$project_root" && ./gradlew help --console=plain -q 2>&1 | head -5 || true
            fi

            # Dependency updates
            echo "💡 Check updates: ./gradlew dependencyUpdates"
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
