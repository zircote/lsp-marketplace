<!-- Hook test -->
---
title: LSP Test Document
author: Test Author
date: 2025-12-31
tags:
  - testing
  - lsp
  - markdown
---

# LSP Test Document

This markdown file tests the marksman LSP features and validation hooks.

## Table of Contents

- [Features](#features)
- [Code Blocks](#code-blocks)
- [Links](#links)
- [References](#references)
- [Claude Code Syntax](#claude-code-syntax)

## Features

The marksman LSP provides:

1. **Document Symbols** - Navigate headings via `documentSymbol`
2. **Go to Definition** - Jump to heading definitions from links
3. **Find References** - Find all links pointing to a heading
4. **Hover** - Get information about links and references
5. **Workspace Symbol** - Search across all markdown files

## Code Blocks

### JavaScript

```javascript
function greet(name) {
  console.log(`Hello, ${name}!`);
}

greet('World');
```

### TypeScript

```typescript
interface User {
  id: number;
  name: string;
  email: string;
}

const user: User = {
  id: 1,
  name: 'Alice',
  email: 'alice@example.com'
};
```

### Python

```python
def fibonacci(n: int) -> int:
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

print(fibonacci(10))
```

### Shell

```bash
#!/bin/bash
echo "Installing marksman..."
brew install marksman
marksman --version
```

### JSON

```json
{
  "name": "marksman-lsp",
  "version": "0.1.0",
  "lsp": {
    "command": "marksman",
    "transport": "stdio"
  }
}
```

## Links

### Internal Links

These links test go-to-definition (click to jump):

- Link to [Features](#features)
- Link to [Code Blocks](#code-blocks)
- Link to [References](#references)
- Link to [Claude Code Syntax](#claude-code-syntax)
- Link to top: [LSP Test Document](#lsp-test-document)

### External Links

- [Marksman GitHub](https://github.com/artempyanykh/marksman)
- [Claude Code Docs](https://code.claude.com/docs)
- [LSP Specification](https://microsoft.github.io/language-server-protocol/)

### File Links

- [README](../README.md)
- [CLAUDE.md](../CLAUDE.md)
- [Plugin Config](../.claude-plugin/plugin.json)
- [LSP Config](../.lsp.json)

## References

This section is referenced from the [Table of Contents](#table-of-contents).

### Cross-References

The [Features](#features) section describes LSP capabilities.
The [Code Blocks](#code-blocks) section has examples in multiple languages.
See [Links](#links) for navigation examples.

### Wiki-Style Links

Marksman also supports wiki-style links if configured:

- [[Features]]
- [[Code Blocks]]
- [[References]]

## Claude Code Syntax

This section tests Claude Code specific markdown patterns.

### Slash Commands

Available commands in this project:

- `/plugin install` - Install this plugin
- `/help` - Get help

### Tool References

The LSP tool supports these operations:

| Operation | Description |
|-----------|-------------|
| `goToDefinition` | Jump to where a symbol is defined |
| `findReferences` | Find all references to a symbol |
| `hover` | Get hover information |
| `documentSymbol` | List all symbols in document |
| `workspaceSymbol` | Search symbols across workspace |

### Example LSP Tool Call

```markdown
Use the LSP tool with:
- filePath: tests/lsp-test.md
- line: 12 (the Features heading)
- character: 4
- operation: findReferences
```

## Nested Headings Test

### Level 3

#### Level 4

##### Level 5

###### Level 6

All heading levels should appear in document symbols.

## Edge Cases

### Empty Code Block

```
```

### Code Block Without Language

```
This code block has no language specified.
It should trigger a validation warning.
```

### Broken Link Test

This is a reference to a [non-existent section](#does-not-exist).

### Special Characters in Headings

Headings with special characters test URL encoding:

- Link to [Edge Cases](#edge-cases)
- Self-reference: [Special Characters in Headings](#special-characters-in-headings)

## Summary

This test file covers:

1. YAML frontmatter validation
2. Document symbol navigation (all heading levels)
3. Go-to-definition for internal links
4. Find references for headings
5. Code block syntax highlighting (JS, TS, Python, Bash, JSON)
6. External link formatting
7. File link resolution
8. Wiki-style link support
9. Claude Code specific syntax
10. Edge cases (empty blocks, missing languages, broken links)

Use the LSP tool to test each feature:

```bash
# Test document symbols
LSP operation=documentSymbol filePath=tests/lsp-test.md line=1 character=1

# Test go to definition (on a link)
LSP operation=goToDefinition filePath=tests/lsp-test.md line=14 character=10

# Test find references (on a heading)
LSP operation=findReferences filePath=tests/lsp-test.md line=20 character=4

# Test hover (on a link)
LSP operation=hover filePath=tests/lsp-test.md line=14 character=10
```
