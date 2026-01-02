# Dockerfile LSP & Toolchain Setup

Set up docker-langserver LSP integration and install all Dockerfile tools required by the hooks in this project.

## Current Tool Versions (January 2026)

| Tool | Version | Notes |
|------|---------|-------|
| docker-langserver | 0.11.0+ | LSP server (via npm) |
| hadolint | 2.12.0+ | Dockerfile linter |
| docker | 24.0+ | Container runtime (23.0+ for `--check`) |

## Instructions

Execute the following setup steps in order:

### 1. Verify Docker Installation

Check that Docker is installed:

```bash
docker --version
```

If not installed, guide the user to https://docs.docker.com/get-docker/ or use:

```bash
# macOS (Homebrew)
brew install --cask docker

# Linux (Ubuntu/Debian)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Start Docker daemon (Linux)
sudo systemctl start docker
sudo systemctl enable docker
```

### 2. Install docker-langserver (Language Server)

Check if docker-langserver is available:

```bash
which docker-langserver || echo "docker-langserver not found"
```

Install docker-langserver:

```bash
# npm (global install)
npm install -g dockerfile-language-server-nodejs

# Verify installation
docker-langserver --version
```

### 3. Install hadolint (Dockerfile Linter)

Check if hadolint is available:

```bash
which hadolint || echo "hadolint not found"
```

Install hadolint:

```bash
# macOS (Homebrew)
brew install hadolint

# Linux (download binary)
HADOLINT_VERSION=$(curl -s https://api.github.com/repos/hadolint/hadolint/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
wget -qO /usr/local/bin/hadolint "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64"
chmod +x /usr/local/bin/hadolint

# Windows (Scoop)
scoop install hadolint

# Docker (run as container)
docker pull hadolint/hadolint
```

### 4. Verify LSP Configuration

Check that `.lsp.json` exists and is properly configured:

```bash
cat .lsp.json
```

Expected configuration:
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

### 5. Verify Hooks Configuration

Confirm hooks are loaded:

```bash
cat hooks/hooks.json | head -20
cat hooks/scripts/dockerfile-hooks.sh | head -20
```

### 6. Test hadolint (Optional)

Run hadolint on the sample Dockerfile:

```bash
hadolint tests/Dockerfile
```

Expected output: hadolint suggestions or no output if the file follows best practices.

### 7. Create .hadolint.yaml (Optional)

Create a project-specific hadolint configuration:

```bash
cat > .hadolint.yaml << 'EOF'
# Hadolint configuration
# See: https://github.com/hadolint/hadolint#configure

# Ignore specific rules
ignored:
  # Uncomment rules to ignore
  # - DL3006  # Always tag the version of an image explicitly
  # - DL3018  # Pin versions in apk add

# Trusted container registries
trustedRegistries:
  - docker.io
  - gcr.io
  - ghcr.io

# Override rule severity
override:
  error:
    - DL3001  # Switch to absolute WORKDIR
  warning:
    - DL3042  # Avoid cache directory with pip install
  info:
    - DL3032  # yum clean all after yum install

# Label schema (if using labels)
label-schema:
  author: text
  version: semver
EOF
```

## Tool Summary

| Tool | Purpose | Hook |
|------|---------|------|
| `docker-langserver` | LSP server for IDE features | Core |
| `hadolint` | Dockerfile linting | `hadolint` |
| `docker` | Syntax validation | `docker-build-check` |

## Troubleshooting

### docker-langserver not starting

1. Ensure Dockerfile exists in project
2. Verify installation: `docker-langserver --version`
3. Check LSP config: `cat .lsp.json`
4. Restart Claude Code to reload LSP

### hadolint not found

1. Verify PATH includes installation directory
2. For Homebrew: ensure `/opt/homebrew/bin` or `/usr/local/bin` is in PATH
3. For Linux binary: ensure `/usr/local/bin` is in PATH
4. Run `which hadolint` to confirm location

### docker build --check fails

1. Ensure Docker daemon is running: `docker info`
2. Check Docker version: `docker --version` (need 23.0+)
3. Test manually: `docker build --check -f Dockerfile .`
4. Note: `--check` flag is optional, hooks will continue without it

### Hooks not running

1. Verify Claude Code hooks are enabled in settings
2. Check file matches patterns: `Dockerfile`, `Dockerfile.*`, `*.dockerfile`
3. Check hook script permissions: `chmod +x hooks/scripts/dockerfile-hooks.sh`
4. Test hook manually: `cat hooks/scripts/dockerfile-hooks.sh | bash`

### npm permission errors

If `npm install -g` fails with permission errors:

```bash
# Option 1: Use nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install --lts
npm install -g dockerfile-language-server-nodejs

# Option 2: Change npm default directory
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
npm install -g dockerfile-language-server-nodejs
```

## Quick Install (macOS with Homebrew)

One-liner to install everything:

```bash
npm install -g dockerfile-language-server-nodejs && \
brew install hadolint
```

## Quick Install (Linux)

```bash
# docker-langserver
npm install -g dockerfile-language-server-nodejs

# hadolint
HADOLINT_VERSION=$(curl -s https://api.github.com/repos/hadolint/hadolint/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
sudo wget -qO /usr/local/bin/hadolint "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64"
sudo chmod +x /usr/local/bin/hadolint

# Verify
docker-langserver --version
hadolint --version
```

After running these commands, provide a status summary showing which tools were installed successfully and any that failed.

## Sources

- [docker-langserver GitHub](https://github.com/rcjsuen/dockerfile-language-server-nodejs)
- [hadolint GitHub](https://github.com/hadolint/hadolint)
- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
