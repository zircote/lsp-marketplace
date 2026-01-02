# marksman-lsp

[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-blueviolet)](https://claude.ai/code)
[![LSP](https://img.shields.io/badge/LSP-Marksman-blue)](https://github.com/artempyanykh/marksman)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Node.js](https://img.shields.io/badge/Node.js-18%2B-339933?logo=node.js)](https://nodejs.org)

A Claude Code plugin providing **Markdown language server support** via [Marksman](https://github.com/artempyanykh/marksman), plus validation hooks for code blocks, links, frontmatter, and Claude Code syntax.

## Features

### LSP Operations

| Operation | Description |
|-----------|-------------|
| `documentSymbol` | Navigate all headings with proper nesting |
| `goToDefinition` | Jump from `[link](#heading)` to the heading |
| `findReferences` | Find all links pointing to a heading |
| `hover` | Preview section content |
| `workspaceSymbol` | Search headings across all markdown files |

### Validation Hooks

| Hook | Trigger | Validates |
|------|---------|-----------|
| `validate-code-blocks` | onSave | Code blocks have language identifiers |
| `validate-links` | onSave | Internal anchors and file links exist |
| `validate-frontmatter` | onSave | YAML frontmatter structure |
| `validate-claude-code` | onSave | LSP operations, slash commands |

## Dependencies

- **[Marksman](https://github.com/artempyanykh/marksman)** - Markdown language server
- **Node.js 18+** - For validation hooks
- **Claude Code** - With `ENABLE_LSP_TOOL=1`

## Installation

### 1. Install Marksman

```bash
# macOS
brew install marksman

# Linux (x86_64)
curl -L https://github.com/artempyanykh/marksman/releases/latest/download/marksman-linux-x64 -o marksman
chmod +x marksman && sudo mv marksman /usr/local/bin/

# Windows
scoop install marksman
# or
winget install artempyanykh.marksman
```

Verify installation:
```bash
marksman --version
```

### 2. Install the Plugin

**Option A: From release tarball**
```bash
tar -xzf marksman-lsp.tar.gz
/plugin install ./marksman-lsp --scope user
```

**Option B: From repository**
```bash
git clone https://github.com/zircote/markdown-lsp.git
/plugin install ./markdown-lsp --scope user
```

**Option C: Local development (plugin-dir mode)**
```bash
cd /path/to/markdown-lsp
# Claude Code auto-detects .claude-plugin/plugin.json
```

### 3. Enable LSP Tool

```bash
export ENABLE_LSP_TOOL=1
```

Or add to your shell profile (`~/.zshrc`, `~/.bashrc`):
```bash
echo 'export ENABLE_LSP_TOOL=1' >> ~/.zshrc
```

## Usage

### LSP Operations

Use the LSP tool in Claude Code on any `.md` file:

```bash
# Get document outline
LSP documentSymbol README.md line=1 char=1

# Jump to heading from link
LSP goToDefinition README.md line=15 char=10

# Find all references to a heading
LSP findReferences README.md line=20 char=4

# Preview section content
LSP hover README.md line=15 char=10

# Search across workspace
LSP workspaceSymbol README.md line=1 char=1
```

### Validation Hooks

Hooks run automatically on save. Diagnostics appear in Claude Code's system reminders.

Example output:
```
lsp-test.md:
  [Line 186:1] Code block missing language identifier (warning)
  [Line 198:26] Broken anchor link: #does-not-exist (warning)
```

## Project Structure

```
marksman-lsp/
├── .claude-plugin/
│   └── plugin.json      # Plugin metadata
├── .lsp.json            # LSP server configuration
├── hooks/
│   ├── hooks.json       # Hook definitions
│   ├── validate-code-blocks.js
│   ├── validate-links.js
│   ├── validate-frontmatter.js
│   └── validate-claude-code.js
├── tests/
│   └── lsp-test.md      # Test file for all features
├── src/
│   └── index.ts         # MCP server (optional)
├── CLAUDE.md            # Project context for Claude
└── README.md
```

## Configuration

### LSP Configuration (`.lsp.json`)

```json
{
  "markdown": {
    "command": "marksman",
    "args": ["server"],
    "extensionToLanguage": {
      ".md": "markdown"
    },
    "transport": "stdio"
  }
}
```

### Hook Configuration (`hooks/hooks.json`)

```json
{
  "markdownDiagnostics": [
    {
      "name": "validateCodeBlocks",
      "trigger": "onSave",
      "filePattern": "**/*.md",
      "command": "$CLAUDE_PROJECT_DIR/hooks/validate-code-blocks.js"
    }
  ]
}
```

## Development

### Testing Hooks Locally

```bash
# Test individual hooks
node hooks/validate-code-blocks.js tests/lsp-test.md
node hooks/validate-links.js tests/lsp-test.md
node hooks/validate-frontmatter.js tests/lsp-test.md
node hooks/validate-claude-code.js tests/lsp-test.md
```

### Adding New Hooks

1. Create a new `.js` file in `hooks/`
2. Output JSON: `{ "diagnostics": [...] }`
3. Register in `hooks/hooks.json`

Diagnostic format:
```json
{
  "line": 10,
  "column": 1,
  "severity": "warning",
  "message": "Description of issue",
  "source": "hook-name"
}
```

## Troubleshooting

### LSP Not Working

1. **Check marksman is installed**: `which marksman`
2. **Verify LSP enabled**: `echo $ENABLE_LSP_TOOL` (should be `1`)
3. **Restart Claude Code** after installing plugin
4. **Check `.lsp.json` location**: Must be in project root for plugin-dir mode

### Hooks Not Running

1. **Check hooks are executable**: `ls -la hooks/*.js`
2. **Verify Node.js available**: `which node`
3. **Test hook manually**: `node hooks/validate-links.js README.md`

## Security

- Never commit tokens or API keys
- Hooks run with user permissions
- All hook output is JSON (no shell injection)

## License

MIT

## Links

- [Marksman GitHub](https://github.com/artempyanykh/marksman)
- [Claude Code Docs](https://claude.ai/code/docs)
- [LSP Specification](https://microsoft.github.io/language-server-protocol/)
