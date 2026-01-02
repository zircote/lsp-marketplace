---
description: Interactive setup for SQL LSP development environment
---

# SQL LSP Setup

This command will configure your SQL development environment with sql-language-server LSP and sqlfluff for linting and formatting.

## Prerequisites Check

Verify you have Node.js and Python installed:

```bash
node --version
python --version || python3 --version
```

## Installation Steps

### 1. Install sql-language-server (LSP)

```bash
npm install -g sql-language-server
```

Verify installation:

```bash
sql-language-server --version
```

### 2. Install sqlfluff (Linter & Formatter)

```bash
pip install sqlfluff
```

Or with pipx for isolated installation:

```bash
pipx install sqlfluff
```

Verify installation:

```bash
sqlfluff --version
```

### 3. Create Project Configuration (Optional)

Create a `.sqlfluff` configuration file in your project root:

```bash
cat > .sqlfluff << 'EOF'
[sqlfluff]
# Set your SQL dialect
dialect = postgres
# Options: postgres, mysql, sqlite, bigquery, redshift, snowflake, tsql, etc.

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

[sqlfluff:rules:L014]
# Unquoted identifiers should be lower case
capitalisation_policy = lower
EOF
```

### 4. Verify LSP Configuration

Check that `.lsp.json` exists and is properly configured:

```bash
cat .lsp.json
```

Expected configuration:

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

### 5. Test sqlfluff

Test sqlfluff on a sample SQL file:

```bash
# Create test file
cat > test.sql << 'EOF'
select * from users where id = 1;
EOF

# Lint the file
sqlfluff lint test.sql

# Format the file
sqlfluff format test.sql

# Clean up
rm test.sql
```

## Supported SQL Dialects

sqlfluff supports multiple SQL dialects. Configure in `.sqlfluff`:

- `postgres` - PostgreSQL
- `mysql` - MySQL/MariaDB
- `sqlite` - SQLite
- `bigquery` - Google BigQuery
- `redshift` - Amazon Redshift
- `snowflake` - Snowflake
- `tsql` - Microsoft SQL Server / T-SQL
- `oracle` - Oracle SQL
- `db2` - IBM DB2
- `sparksql` - Apache Spark SQL
- `hive` - Apache Hive
- `clickhouse` - ClickHouse
- `athena` - AWS Athena

## Quick Install

```bash
# Install both tools
npm install -g sql-language-server
pip install sqlfluff
```

## Troubleshooting

### sql-language-server not found

1. Ensure Node.js is installed: `node --version`
2. Check npm global path: `npm config get prefix`
3. Ensure global npm binaries are in PATH

### sqlfluff not found

1. Ensure Python is installed: `python --version`
2. Check pip installation: `pip show sqlfluff`
3. Try: `python -m pip install sqlfluff`

### LSP not activating

1. Ensure `.sql` files exist in your project
2. Restart Claude Code after installation
3. Check LSP logs for errors

### Linting/formatting issues

1. Verify dialect in `.sqlfluff` matches your SQL flavor
2. Run manually: `sqlfluff lint yourfile.sql`
3. Check for syntax errors in SQL

## Verification

After setup, verify everything works:

```bash
# Check installations
sql-language-server --version
sqlfluff --version

# Verify LSP config
cat .lsp.json

# Test sqlfluff
echo "SELECT * FROM users;" | sqlfluff lint -
```

All commands should complete successfully without errors.
