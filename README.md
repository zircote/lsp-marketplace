# LSP Marketplace

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Claude Plugin](https://img.shields.io/badge/claude-plugin-orange.svg)](https://docs.anthropic.com/en/docs/claude-code/plugins)
[![Plugins](https://img.shields.io/badge/plugins-28-brightgreen.svg)](#available-plugins)

A curated collection of LSP-enabled Claude Code plugins providing language-specific development workflows with automated hooks for code quality, security, and diagnostics.

## Overview

This marketplace provides **28 language-specific LSP plugins** for Claude Code. Each plugin lives in its own GitHub repository and integrates with the corresponding Language Server Protocol implementation to provide real-time diagnostics, formatting, and code analysis through automated PostToolUse hooks.

## Quick Start

```bash
# Install a plugin directly from its repo
claude /plugin add zircote/rust-lsp
claude /plugin add zircote/python-lsp
claude /plugin add zircote/go-lsp
```

## Available Plugins

| Plugin | Repository | Description |
|--------|------------|-------------|
| bash-lsp | [zircote/bash-lsp](https://github.com/zircote/bash-lsp) | Bash/Shell with bash-language-server and ShellCheck |
| cpp-lsp | [zircote/cpp-lsp](https://github.com/zircote/cpp-lsp) | C/C++ with clangd, clang-tidy, clang-format |
| csharp-lsp | [zircote/csharp-lsp](https://github.com/zircote/csharp-lsp) | C# with OmniSharp and dotnet format |
| dockerfile-lsp | [zircote/dockerfile-lsp](https://github.com/zircote/dockerfile-lsp) | Dockerfile with dockerfile-language-server and hadolint |
| elixir-lsp | [zircote/elixir-lsp](https://github.com/zircote/elixir-lsp) | Elixir with ElixirLS and mix format |
| go-lsp | [zircote/go-lsp](https://github.com/zircote/go-lsp) | Go with gopls, gofmt, golangci-lint |
| graphql-lsp | [zircote/graphql-lsp](https://github.com/zircote/graphql-lsp) | GraphQL with graphql-language-service |
| haskell-lsp | [zircote/haskell-lsp](https://github.com/zircote/haskell-lsp) | Haskell with haskell-language-server, hlint, ormolu |
| html-css-lsp | [zircote/html-css-lsp](https://github.com/zircote/html-css-lsp) | HTML/CSS with vscode-html-languageserver and stylelint |
| java-lsp | [zircote/java-lsp](https://github.com/zircote/java-lsp) | Java with Eclipse JDT LSP, checkstyle |
| json-lsp | [zircote/json-lsp](https://github.com/zircote/json-lsp) | JSON with vscode-json-languageserver |
| kotlin-lsp | [zircote/kotlin-lsp](https://github.com/zircote/kotlin-lsp) | Kotlin with kotlin-language-server and ktlint |
| latex-lsp | [zircote/latex-lsp](https://github.com/zircote/latex-lsp) | LaTeX with texlab and chktex |
| lua-lsp | [zircote/lua-lsp](https://github.com/zircote/lua-lsp) | Lua with lua-language-server and luacheck |
| markdown-lsp | [zircote/markdown-lsp](https://github.com/zircote/markdown-lsp) | Markdown with marksman and markdownlint |
| php-lsp | [zircote/php-lsp](https://github.com/zircote/php-lsp) | PHP with intelephense, php-cs-fixer, phpstan |
| python-lsp | [zircote/python-lsp](https://github.com/zircote/python-lsp) | Python with pylsp/pyright, ruff, black, mypy |
| ruby-lsp | [zircote/ruby-lsp](https://github.com/zircote/ruby-lsp) | Ruby with solargraph and rubocop |
| rust-lsp | [zircote/rust-lsp](https://github.com/zircote/rust-lsp) | Rust with rust-analyzer, clippy, rustfmt, cargo-audit |
| scala-lsp | [zircote/scala-lsp](https://github.com/zircote/scala-lsp) | Scala with Metals and scalafmt |
| sql-lsp | [zircote/sql-lsp](https://github.com/zircote/sql-lsp) | SQL with sql-language-server and sqlfluff |
| svelte-lsp | [zircote/svelte-lsp](https://github.com/zircote/svelte-lsp) | Svelte with svelte-language-server |
| swift-lsp | [zircote/swift-lsp](https://github.com/zircote/swift-lsp) | Swift with sourcekit-lsp and swiftformat |
| terraform-lsp | [zircote/terraform-lsp](https://github.com/zircote/terraform-lsp) | Terraform with terraform-ls, tflint, trivy, checkov |
| typescript-lsp | [zircote/typescript-lsp](https://github.com/zircote/typescript-lsp) | TypeScript/JavaScript with vtsls, eslint, prettier |
| vue-lsp | [zircote/vue-lsp](https://github.com/zircote/vue-lsp) | Vue.js with Volar and eslint-plugin-vue |
| yaml-lsp | [zircote/yaml-lsp](https://github.com/zircote/yaml-lsp) | YAML with yaml-language-server and yamllint |
| zig-lsp | [zircote/zig-lsp](https://github.com/zircote/zig-lsp) | Zig with zls and zig fmt |

## Plugin Structure

Each plugin follows a consistent structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json       # Plugin manifest
├── .lsp.json             # LSP server configuration
├── hooks/
│   ├── hooks.json        # Hook definitions
│   └── scripts/          # Hook implementation scripts
├── commands/
│   └── setup.md          # /setup command
├── tests/                # Test files for validation
├── CLAUDE.md             # Plugin documentation
├── README.md             # User documentation
└── LICENSE               # MIT License
```

## Hook System

All plugins use PostToolUse hooks that trigger on `Write|Edit` operations:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PLUGIN_ROOT/hooks/scripts/language-hooks.sh\"",
            "timeout": 120
          }
        ]
      }
    ]
  }
}
```

When you edit a file, the plugin automatically:
1. Runs the language server for diagnostics
2. Executes linters and formatters
3. Reports issues inline in Claude's response

## Requirements

Each plugin requires its respective LSP server to be installed. Run `/setup` after installing a plugin to install dependencies.

## License

MIT License - see [LICENSE](LICENSE) for details.
