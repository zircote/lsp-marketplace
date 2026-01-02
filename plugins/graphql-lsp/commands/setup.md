---
description: Interactive setup for GraphQL LSP development environment
---

# GraphQL LSP Setup

This command will configure your GraphQL development environment with graphql-lsp server and essential tools.

## Prerequisites Check

First, verify Node.js is installed:

```bash
node --version
npm --version
```

## Installation Steps

### 1. Install graphql-lsp Server

```bash
npm install -g graphql-language-service-cli graphql
```

### 2. Install Development Tools

**Quick install (all recommended tools):**

```bash
npm install -g prettier @graphql-eslint/eslint-plugin graphql-tag
```

### 3. Verify Installation

```bash
# Check graphql-lsp
graphql-lsp --version

# Check GraphQL
graphql --version

# Check Prettier
prettier --version
```

### 4. Create Project Configuration (Optional)

**`.graphqlrc.yml`:**

```yaml
schema: schema.graphql
documents:
  - 'src/**/*.graphql'
  - 'src/**/*.gql'
extensions:
  endpoints:
    default:
      url: http://localhost:4000/graphql
```

Or **`graphql.config.js`:**

```javascript
module.exports = {
  schema: './schema.graphql',
  documents: ['./src/**/*.{graphql,gql}'],
  extensions: {
    endpoints: {
      default: {
        url: 'http://localhost:4000/graphql',
      },
    },
  },
};
```

### 5. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test schema
cat > test_schema.graphql << 'EOF'
type Query {
  hello: String!
}
EOF

# Validate schema
graphql-inspector validate test_schema.graphql

# Format with Prettier
prettier --write test_schema.graphql

# Clean up
rm test_schema.graphql
```

## Optional: Code Generation Setup

Install GraphQL Code Generator:

```bash
npm install -g @graphql-codegen/cli

# Initialize configuration
graphql-codegen init
```
