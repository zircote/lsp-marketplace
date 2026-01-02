# sql-lsp

A Claude Code plugin providing comprehensive SQL development support through:

- **sql-language-server LSP** integration for IDE-like features
- **sqlfluff** integration for linting and formatting
- **Automated hooks** for code quality and validation

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install sql-language-server
npm install -g sql-language-server

# Install sqlfluff
pip install sqlfluff
```

## Features

### LSP Integration

The plugin configures sql-language-server for Claude Code via `.lsp.json`:

```json
{
    "sql": {
        "command": "sql-language-server",
        "args": ["up", "--method", "stdio"],
        "extensionToLanguage": {
            ".sql": "sql"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- SQL syntax highlighting
- Auto-completion for SQL keywords
- Table and column name completion
- Query validation
- Real-time diagnostics

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### Core SQL Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `sql-format-on-edit` | `**/*.sql` | Auto-format with sqlfluff |
| `sql-lint-on-edit` | `**/*.sql` | Lint SQL with sqlfluff |
| `sql-todo-fixme` | `**/*.sql` | Surface TODO/FIXME/XXX/HACK comments |

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `sql-language-server` | `npm install -g sql-language-server` | LSP server for SQL |

### Recommended

| Tool | Installation | Purpose |
|------|--------------|---------|
| `sqlfluff` | `pip install sqlfluff` | SQL linter and formatter |

## Commands

### `/setup`

Interactive setup wizard for configuring the SQL development environment.

**What it does:**

1. **Installs sql-language-server** - LSP server for IDE features
2. **Installs sqlfluff** - SQL linter and formatter
3. **Validates LSP config** - Confirms `.lsp.json` is correct
4. **Verifies hooks** - Confirms hooks are properly loaded

**Usage:**

```bash
/setup
```

## Configuration

### .sqlfluff

Create a `.sqlfluff` configuration file in your project root:

```ini
[sqlfluff]
dialect = postgres
# Or: mysql, sqlite, bigquery, redshift, snowflake, etc.

[sqlfluff:rules]
max_line_length = 120
indent_unit = space
tab_space_size = 4

[sqlfluff:rules:L010]
# Keywords should be upper case
capitalisation_policy = upper

[sqlfluff:rules:L030]
# Function names should be upper case
capitalisation_policy = upper
```

### Customizing Hooks

Edit `hooks/hooks.json` to:
- Disable hooks by removing entries
- Adjust output limits (`head -N`)
- Modify matchers for different file patterns
- Add project-specific hooks

Example - disable a hook:
```json
{
    "name": "sql-lint-on-edit",
    "enabled": false,
    ...
}
```

## Project Structure

```
sql-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # sql-language-server configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   └── hooks.json            # Automated hooks
├── tests/
│   └── sample.sql            # Sample SQL file
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### sql-language-server not starting

1. Ensure `.sql` files exist in project root
2. Verify installation: `sql-language-server --version`
3. Check LSP config: `cat .lsp.json`

### sqlfluff errors

1. Verify installation: `sqlfluff --version`
2. Check dialect configuration in `.sqlfluff`
3. Run manually: `sqlfluff lint yourfile.sql`

### Hooks not triggering

1. Verify hooks are loaded: `cat hooks/hooks.json`
2. Check file patterns match your structure
3. Ensure required tools are installed (`command -v sqlfluff`)

## License

MIT
