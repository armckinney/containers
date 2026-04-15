# Devcontainer Features Release

This release contains devcontainer features that can be consumed from other repositories.

## Quick Start

Add features to your `.devcontainer/devcontainer.json`:

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/v1.0.0/docker-in-docker.tgz": {},
    "https://github.com/armckinney/containers/releases/download/v1.0.0/gemini.tgz": {
      "version": "latest",
      "nodeChannel": "current"
    }
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
    "https://github.com/armckinney/containers/releases/download/v1.0.0/docker-in-docker.tgz": {}
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
    "https://github.com/armckinney/containers/releases/download/v1.0.0/gemini.tgz": {
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

## Resources

- [Google Gemini Documentation](https://ai.google.dev/)
- [NodeSource Repository](https://nodesource.com/blog/nodejs-and-npm/)
- [VS Code Docker Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
