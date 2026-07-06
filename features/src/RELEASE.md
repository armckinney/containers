# Devcontainer Features Release

This release contains devcontainer features that can be consumed from other repositories.

## Quick Start

Add features to your `.devcontainer/devcontainer.json`:

Replace `<VERSION>` with your release tag (for example `v1.2.3`).

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-docker-in-docker.tgz": {},
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-antigravity.tgz": {},
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

### Options

- `rulefilePath`: Path to the central rules file, relative to the workspace root. Default is `AGENTS.md`. Set to `"none"`, `"false"`, or `""` (empty string) to disable rules symlinking.

#### Example

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-copilot.tgz": {
      "rulefilePath": "AGENTS.md"
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

## Antigravity CLI

Installs Google's Antigravity CLI (`agy`) and mounts local config files from the host.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-antigravity.tgz": {}
  }
}
```

### Options

- `rulefilePath`: Path to the central rules file, relative to the workspace root. Default is `AGENTS.md`. Set to `"none"`, `"false"`, or `""` (empty string) to disable rules symlinking.

#### Example

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-antigravity.tgz": {
      "rulefilePath": "AGENTS.md"
    }
  }
}
```

### Features

- Google Antigravity CLI (`agy`) installation
- Host config directory mounting at `~/.gemini/antigravity-cli`

### Verify Installation

```bash
agy --version
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

- [Google Antigravity Documentation](https://antigravity.google)
- [VS Code Docker Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
