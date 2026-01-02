# dockerfile-lsp

A Claude Code plugin providing comprehensive Dockerfile development support through:

- **docker-langserver LSP** integration for IDE-like features
- **Automated hooks** for linting with hadolint and best practices
- **Dockerfile tool ecosystem** integration (docker, hadolint)

## Quick Setup

```bash
# Run the setup command (after installing the plugin)
/setup
```

Or manually:

```bash
# Install docker-langserver (LSP)
npm install -g dockerfile-language-server-nodejs

# Install hadolint (linter)
# macOS (Homebrew)
brew install hadolint

# Linux
wget -qO /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
chmod +x /usr/local/bin/hadolint

# Ensure Docker is installed
docker --version
```

## Features

### LSP Integration

The plugin configures docker-langserver for Claude Code via `.lsp.json`:

```json
{
    "dockerfile": {
        "command": "docker-langserver",
        "args": ["--stdio"],
        "extensionToLanguage": {
            "Dockerfile": "dockerfile",
            ".dockerfile": "dockerfile"
        },
        "transport": "stdio"
    }
}
```

**Capabilities:**
- Go to definition for base images
- Hover documentation for instructions
- Code completion for Dockerfile instructions
- Real-time diagnostics
- Validation of instruction syntax

### Automated Hooks

All hooks run `afterWrite` and are configured in `hooks/hooks.json`.

#### Dockerfile Hooks

| Hook | Trigger | Tool Required | Description |
|------|---------|---------------|-------------|
| `hadolint` | `Dockerfile`, `*.dockerfile` | `hadolint` | Best practices and security linting |
| `docker-build-check` | `Dockerfile`, `*.dockerfile` | `docker` | Syntax validation via Docker |
| `todo-fixme` | `Dockerfile`, `*.dockerfile` | - | Surface TODO/FIXME/HACK/XXX/BUG comments |

**Hook Features:**
- Detects security issues (running as root, hardcoded secrets)
- Enforces best practices (layer caching, multi-stage builds)
- Validates instruction syntax
- Checks for deprecated instructions
- Suggests performance improvements

## Required Tools

### Core

| Tool | Installation | Purpose |
|------|--------------|---------|
| `docker-langserver` | `npm install -g dockerfile-language-server-nodejs` | LSP server |
| `docker` | [docker.com](https://www.docker.com/) | Container runtime & syntax validation |

### Recommended

| Tool | Installation | Purpose |
|------|--------------|---------|
| `hadolint` | `brew install hadolint` (macOS) | Dockerfile linter |

## Commands

### `/setup`

Interactive setup wizard for configuring the complete Dockerfile development environment.

**What it does:**

1. **Verifies Docker installation** - Checks `docker` CLI is available
2. **Installs docker-langserver** - LSP server for IDE features
3. **Installs hadolint** - Dockerfile linter
4. **Validates LSP config** - Confirms `.lsp.json` is correct
5. **Verifies hooks** - Confirms hooks are properly loaded

**Usage:**

```bash
/setup
```

## Project Structure

```
dockerfile-lsp/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── .lsp.json                  # docker-langserver configuration
├── commands/
│   └── setup.md              # /setup command
├── hooks/
│   ├── hooks.json            # Hook definitions
│   └── scripts/
│       └── dockerfile-hooks.sh  # Hook dispatcher
├── tests/
│   └── Dockerfile            # Sample multi-stage Dockerfile
├── CLAUDE.md                  # Project instructions
└── README.md                  # This file
```

## Troubleshooting

### docker-langserver not starting

1. Ensure Dockerfile exists in project
2. Verify installation: `docker-langserver --version`
3. Check LSP config: `cat .lsp.json`
4. Ensure file is named `Dockerfile` or has `.dockerfile` extension

### hadolint not linting

1. Verify installation: `hadolint --version`
2. Run manually: `hadolint Dockerfile`
3. Check for `.hadolint.yaml` configuration conflicts

### Hooks not triggering

1. Verify hooks are loaded: `cat hooks/hooks.json`
2. Check file patterns match your structure
3. Ensure tools are installed (`command -v hadolint`)

### Docker build check fails

1. Ensure Docker daemon is running
2. Check Dockerfile syntax with `docker build --check`
3. Note: `docker build --check` requires Docker 23.0+

## Configuration

### .hadolint.yaml

Customize hadolint rules for your project:

```yaml
# .hadolint.yaml
ignored:
  - DL3006  # Always tag the version of an image explicitly
  - DL3018  # Pin versions in apk add

trustedRegistries:
  - docker.io
  - gcr.io

override:
  error:
    - DL3001  # Ignore absolute WORKDIR
  warning:
    - DL3042  # Avoid cache busting with apt-get
```

### Dockerfile Best Practices

The hooks enforce and suggest:

- **Multi-stage builds** for smaller images
- **Layer caching** optimization
- **Version pinning** for base images and packages
- **Non-root user** for security
- **COPY instead of ADD** unless needed
- **Minimal layers** by combining RUN commands
- **.dockerignore** for build context optimization

## Common Hadolint Rules

| Rule | Description | Severity |
|------|-------------|----------|
| DL3000 | Use absolute WORKDIR | Warning |
| DL3002 | Don't switch to root USER | Warning |
| DL3008 | Pin versions in apt-get install | Warning |
| DL3009 | Delete apt-get lists after installing | Info |
| DL3015 | Avoid additional packages in yum install | Info |
| DL3025 | Use JSON notation for CMD and ENTRYPOINT | Warning |
| DL4006 | Use SHELL to change the default shell | Warning |

## License

MIT
