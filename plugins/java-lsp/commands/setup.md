---
description: Interactive setup for Java LSP development environment
---

# Java LSP Setup

This command will configure your Java development environment with Eclipse JDT LS and essential tools.

## Prerequisites Check

First, verify Java is installed (JDK 21+ recommended):

```bash
java -version
```

## Installation Steps

### 1. Install Eclipse JDT LS Server

**macOS (Homebrew):**

```bash
brew install jdtls
```

**Manual Installation:**

1. Download from: https://download.eclipse.org/jdtls/snapshots/
2. Extract to a directory (e.g., `~/.local/share/jdtls`)
3. Add to PATH or create a wrapper script

### 2. Install Build Tools

**Maven:**

```bash
brew install maven
```

**Gradle:**

```bash
brew install gradle
```

### 3. Install Development Tools (Optional)

```bash
# Google Java Format
brew install google-java-format

# Checkstyle (usually via Maven/Gradle plugin)
```

### 4. Verify Installation

```bash
jdtls --version
mvn -version
gradle --version
```

### 5. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test project
mkdir -p /tmp/test-java-lsp/src/main/java && cd /tmp/test-java-lsp
echo 'public class Main { public static void main(String[] args) { System.out.println("Hello"); } }' > src/main/java/Main.java

# Create minimal pom.xml
cat > pom.xml << 'EOF'
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>test</groupId>
  <artifactId>test</artifactId>
  <version>1.0</version>
</project>
EOF

# Compile
mvn compile

# Clean up
cd - && rm -rf /tmp/test-java-lsp
```
