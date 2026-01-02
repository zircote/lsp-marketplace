# html-css-lsp

A Claude Code plugin providing comprehensive HTML/CSS development support through:

- **vscode-html-language-server** and **vscode-css-language-server** LSP integration for IDE-like features
- **Automated hooks** for formatting, linting, and validation
- **Web ecosystem** integration (Prettier, stylelint)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install HTML/CSS language servers
npm install -g vscode-langservers-extracted

# Install development tools
npm install -g prettier stylelint stylelint-config-standard
```

## Features

### LSP Integration

The plugin configures both HTML and CSS language servers for Claude Code via `.lsp.json`:

```json
{
    "html": {
        "command": "vscode-html-language-server",
        "args": ["--stdio"],
        "extensionToLanguage": {
            ".html": "html",
            ".htm": "html"
        },
        "transport": "stdio"
    },
    "css": {
        "command": "vscode-css-language-server",
        "args": ["--stdio"],
        "extensionToLanguage": {
            ".css": "css",
            ".scss": "scss",
            ".less": "less"
        },
        "transport": "stdio"
    }
}
```

**HTML Capabilities:**
- Tag completion and validation
- Hover documentation
- HTML5 syntax checking
- Emmet abbreviations
- Auto-closing tags
- Real-time diagnostics

**CSS Capabilities:**
- Property completion
- Color previews
- CSS validation
- SCSS/LESS support
- Vendor prefix suggestions
- Real-time diagnostics

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### HTML Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `html-format-on-edit` | `**/*.html,htm` | Auto-format with Prettier |
| `html-validate` | `**/*.html,htm` | HTML5 validation |
| `html-todo-fixme` | `**/*.html,htm` | Surface TODO/FIXME comments |

#### CSS Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `css-format-on-edit` | `**/*.css,scss,less` | Auto-format with Prettier |
| `css-lint` | `**/*.css,scss,less` | Lint with stylelint |
| `css-validate` | `**/*.css` | CSS syntax validation |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `vscode-html-language-server` | `npm install -g vscode-langservers-extracted` | HTML LSP server |
| `vscode-css-language-server` | `npm install -g vscode-langservers-extracted` | CSS LSP server |

### Recommended

| Tool | Installation | Purpose |
|------|--------------|---------|
| `prettier` | `npm install -g prettier` | Formatting |
| `stylelint` | `npm install -g stylelint` | CSS linting |
| `stylelint-config-standard` | `npm install -g stylelint-config-standard` | Standard CSS rules |

## Project Structure

```
html-css-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # HTML/CSS LSP configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   ├── hooks.json            # Hook definitions
│   └── scripts/
│       └── html-css-hooks.sh
├── tests/
│   ├── sample.html           # Sample HTML file
│   └── sample.css            # Sample CSS file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### Language servers not starting

1. Verify installation: `vscode-html-language-server --version`
2. Check LSP config: `cat .lsp.json`
3. Ensure Node.js is installed: `node --version`

### Formatting not working

1. Check Prettier installation: `prettier --version`
2. Create `.prettierrc` in project root if needed

### Stylelint not working

1. Check stylelint installation: `stylelint --version`
2. Create `.stylelintrc.json` in project root:

```json
{
  "extends": "stylelint-config-standard"
}
```

## License

MIT
