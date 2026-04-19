# Devcontainer Features Release

This release contains devcontainer features that can be consumed from other repositories.

## Quick Start

Add features to your `.devcontainer/devcontainer.json`:

Replace `<VERSION>` with your release tag (for example `v1.2.3`).

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-docker-in-docker.tgz": {},
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-gemini.tgz": {
      "version": "latest",
      "nodeChannel": "current"
    },
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-copilot.tgz": {},
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-vscode-customizations.tgz": {}
  }
}
```

---

## GitHub Copilot

Installs GitHub CLI and GitHub Copilot VS Code extensions. The `gh-copilot` CLI extension is installed automatically when GitHub authentication is available. Host config is mounted read-only from `${localEnv:HOME}/.config` to `/root/.config` so GitHub CLI can automatically read `/root/.config/gh` when present.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-copilot.tgz": {}
  }
}
```

---

## Docker-in-Docker

Installs Docker inside the container using privileged mode. Allows running Docker commands from within the container.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-docker-in-docker.tgz": {}
  }
}
```

### Features

- Full Docker CLI and daemon installation
- Automatic dockerd startup with privileged mode support
- `vfs` storage driver for nested container compatibility
- Docker Buildx and Docker Compose plugins included

### Storage Driver

The feature uses `vfs` storage driver by default for maximum compatibility in nested container environments (e.g., running inside another devcontainer).

### Troubleshooting

If Docker daemon fails to start:

```bash
tail -n 100 /var/log/dockerd.log
```

---

## Gemini CLI

Installs Google's Gemini CLI via npm and mounts local config files from the host. Includes VS Code code-assist extensions for enhanced development experience.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-gemini.tgz": {
      "version": "latest",
      "nodeChannel": "current"
    }
  }
}
```

### Options

#### `version`
- **Type**: string
- **Default**: `latest`
- **Description**: Version of Gemini CLI to install (or 'latest' for the newest version)

#### `nodeChannel`
- **Type**: string  
- **Default**: `current`
- **Description**: NodeSource channel to install for Node.js
  - `current`: Latest stable Node.js version
  - `lts`: Latest LTS Node.js version

### Features

- Automatic Node.js installation via NodeSource
- Google Gemini CLI installation
- VS Code extensions:
  - `google.gemini-cli-vscode-ide-companion`
  - `google.geminicodeassist`
- Host config file mounting at `~/.gemini`

### Prerequisites

- Requires Node.js 20+ (Gemini CLI requirement)
- The feature automatically installs compatible Node.js versions via NodeSource

### Verify Installation

```bash
node --version
npm --version
gemini --version
```

---

## VS Code Customizations

Applies standardized VS Code settings and extension recommendations for a consistent development environment.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-vscode-customizations.tgz": {}
  }
}
```

### Features

- Standardized terminal profile for Linux bash
- Common file exclusions for generated and metadata directories
- Editor save-formatting defaults, including Dockerfile override
- VS Code extensions:
  - `ms-azuretools.vscode-docker`
  - `yzhang.markdown-all-in-one`
  - `bierner.markdown-mermaid`
  - `github.vscode-github-actions`

---

## Resources

- [Google Gemini Documentation](https://ai.google.dev/)
- [NodeSource Repository](https://nodesource.com/blog/nodejs-and-npm/)
- [VS Code Docker Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
