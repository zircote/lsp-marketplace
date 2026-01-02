# LSP Marketplace

A marketplace of LSP-enabled Claude Code plugins providing language-specific development workflows with automated hooks for code quality, security, and diagnostics.

## Overview

This marketplace provides **28 language-specific LSP plugins** for Claude Code. Each plugin integrates with the corresponding Language Server Protocol implementation to provide real-time diagnostics, formatting, and code analysis through automated PostToolUse hooks.

## Quick Start

```bash
# Add this marketplace to Claude Code
claude /plugin marketplace add zircote/lsp-marketplace

# List available plugins
claude /plugin list

# Install a specific plugin
claude /plugin install rust-lsp@lsp-marketplace
claude /plugin install python-lsp@lsp-marketplace
claude /plugin install go-lsp@lsp-marketplace
```

## Available Plugins

| Plugin | Language | LSP Server | Key Features |
|--------|----------|------------|--------------|
| `bash-lsp` | Bash/Shell | bash-language-server | ShellCheck integration, syntax validation |
| `cpp-lsp` | C/C++ | clangd | Clang-tidy, compile commands, diagnostics |
| `csharp-lsp` | C# | OmniSharp | .NET analysis, Roslyn diagnostics |
| `dockerfile-lsp` | Dockerfile | dockerfile-language-server | Hadolint, best practices |
| `elixir-lsp` | Elixir | elixir-ls | Mix integration, dialyzer |
| `go-lsp` | Go | gopls | go vet, staticcheck, golangci-lint |
| `graphql-lsp` | GraphQL | graphql-language-service | Schema validation, query analysis |
| `haskell-lsp` | Haskell | haskell-language-server | HLint, GHC diagnostics |
| `html-css-lsp` | HTML/CSS | vscode-html-languageserver | W3C validation, accessibility |
| `java-lsp` | Java | Eclipse JDT.LS | Maven/Gradle, SpotBugs |
| `json-lsp` | JSON | vscode-json-languageserver | Schema validation, formatting |
| `kotlin-lsp` | Kotlin | kotlin-language-server | Detekt, ktlint |
| `latex-lsp` | LaTeX | texlab | ChkTeX, bibliography |
| `lua-lsp` | Lua | lua-language-server | Luacheck, type annotations |
| `markdown-lsp` | Markdown | marksman | Link validation, structure |
| `php-lsp` | PHP | intelephense | PHPStan, Psalm |
| `python-lsp` | Python | pylsp/pyright | Ruff, mypy, black |
| `ruby-lsp` | Ruby | solargraph | RuboCop, Sorbet |
| `rust-lsp` | Rust | rust-analyzer | Clippy, cargo-audit, cargo-deny |
| `scala-lsp` | Scala | Metals | Scalafix, Scalafmt |
| `sql-lsp` | SQL | sql-language-server | SQLFluff, query validation |
| `svelte-lsp` | Svelte | svelte-language-server | Component validation |
| `swift-lsp` | Swift | sourcekit-lsp | SwiftLint, SwiftFormat |
| `terraform-lsp` | Terraform | terraform-ls | tfsec, tflint, checkov |
| `typescript-lsp` | TypeScript | typescript-language-server | ESLint, Prettier |
| `vue-lsp` | Vue | Volar | Template validation |
| `yaml-lsp` | YAML | yaml-language-server | Schema validation, anchors |
| `zig-lsp` | Zig | zls | Zig compiler diagnostics |

## Plugin Structure

Each plugin follows a consistent structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json       # Plugin manifest
├── hooks/
│   ├── hooks.json        # Hook definitions
│   └── scripts/          # Hook implementation scripts
├── commands/             # Slash commands (optional)
├── tests/                # Test files for hook validation
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

Each plugin requires its respective LSP server to be installed. See individual plugin README files for setup instructions.

## Contributing

1. Fork this repository
2. Create a new plugin following the structure above
3. Add tests in the `tests/` directory
4. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.

## Related

- [zircote/marketplace](https://github.com/zircote/marketplace) - Main Claude Code plugin marketplace
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
