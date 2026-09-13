# Devcontainer Features Release

This release contains devcontainer features that can be consumed from other repositories.

## Quick Start

### Table of Contents
- [Antigravity CLI](#antigravity-cli)
- [Antigravity Remote Control](#antigravity-remote-control)
- [Databricks](#databricks)
- [Docker-in-Docker](#docker-in-docker)
- [GitHub Copilot](#github-copilot)
- [VS Code Customizations](#vs-code-customizations)

Add features to your `.devcontainer/devcontainer.json`:

Replace `<VERSION>` with your release tag (for example `v1.2.3`).

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-antigravity.tgz": {},
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-antigravity-remote.tgz": {},
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-databricks.tgz": {},
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-docker-in-docker.tgz": {},
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-copilot.tgz": {},
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-vscode-customizations.tgz": {}
  }
}
```

---

## Antigravity CLI

Installs Google's Antigravity CLI (`agy`), mounts local config files from the host, and configures the Google Antigravity VS Code extension.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-antigravity.tgz": {}
  }
}
```

### Options

- `rulefilePath`: Path to the central rules file, relative to the workspace root. Default is `docs/agents/AGENTS.md`. Set to `"none"`, `"false"`, or `""` (empty string) to disable rules symlinking.
- `contextPath`: Path to the path-scoped instructions directory, relative to the workspace root. Default is `docs/agents/context`. Set to `"none"`, `"false"`, or `""` (empty string) to disable context mapping.
- `skillsPath`: Path to the modular skills directory, relative to the workspace root. Default is `docs/agents/skills`. Set to `"none"`, `"false"`, or `""` (empty string) to disable skills mapping.

#### Example

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-antigravity.tgz": {
      "rulefilePath": "docs/agents/AGENTS.md",
      "contextPath": "docs/agents/context",
      "skillsPath": "docs/agents/skills"
    }
  }
}
```

### Features

- Google Antigravity CLI (`agy`) installation
- Host config directory mounting at `~/.gemini/antigravity-cli`
- VS Code extension:
  - `google.google-antigravity`

### Verify Installation

```bash
agy --version
```

---

## Antigravity Remote Control

Installs the Antigravity CLI and configures the headless Remote Control daemon. The daemon automatically launches on container startup.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-antigravity-remote.tgz": {}
  }
}
```

### Options

- `registrationName`: Custom registration/session name for this Antigravity Remote daemon (e.g. `"my-box"`). Will be prefixed with `devcontainer-`. If omitted or empty, a persistent unique GUID is automatically generated and saved with `devcontainer-` prefix.

#### Example

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-antigravity-remote.tgz": {
      "registrationName": "my-box"
    }
  }
}
```

### Features

- Antigravity CLI (`agy`) installation and PATH configuration
- Headless Remote Control daemon auto-startup via container entrypoint
- Host config and state directory bind mounts (`${localEnv:HOME}/.gemini` and `${localEnv:HOME}/.antigravity`) ensuring seamless authentication and session persistence across rebuilds
- Idempotent daemon start script (`/usr/local/share/antigravity-remote/start-daemon.sh`)
- Daemon execution log written to `/root/.antigravity/agy_daemon.log`

### Running Headless on a Desktop Machine for Remote Access

To keep the devcontainer and its Antigravity Remote Control daemon running on your desktop or laptop even when you are away from your desk:

1. **Start the container headlessly** via `@devcontainers/cli` (no need to keep VS Code open):
   ```bash
   devcontainer up --workspace-folder .
   ```

2. **Prevent system sleep while plugged in**:
   - **macOS**: In *System Settings > Energy Saver* (or *Displays / Lock Screen*), enable **"Prevent automatic sleeping on power adapter when the display is off"** (or run `caffeinate -d` in a terminal).
   - **Windows / Linux**: Set power sleep timeout to **"Never"** when plugged into power.

3. **Lock the screen instead of logging out**:
   - Lock your screen (<kbd>Cmd</kbd> + <kbd>Ctrl</kbd> + <kbd>Q</kbd> on macOS, <kbd>Win</kbd> + <kbd>L</kbd> on Windows).
   - Docker Desktop and the container daemon will continue running in the background.

You can now connect to and control your desktop container from anywhere via [https://antigravity.google.com/](https://antigravity.google.com/).

---

## Databricks

Installs the Databricks CLI, mounts host Databricks credentials and configuration (`~/.databrickscfg` and `~/.databricks`), configures the Databricks VS Code extension, and enables port forwarding on port 8020 for CLI OAuth authentication flows.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-databricks.tgz": {}
  }
}
```

### Options

- `version`: Version of the Databricks CLI to install (e.g., `"latest"`, `"1.16.1"`). Default is `"latest"`.

#### Example

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-databricks.tgz": {
      "version": "latest"
    }
  }
}
```

### Features

- Databricks CLI installation (available as `databricks` globally in `/usr/local/bin`)
- Host credentials & token cache bind mounts:
  - `${localEnv:HOME}/.databrickscfg` -> `/root/.databrickscfg`
  - `${localEnv:HOME}/.databricks` -> `/root/.databricks`
- VS Code extension:
  - `databricks.databricks`
- Port 8020 port forwarding and attributes for OAuth authentication callback (`http://localhost:8020/callback`)

### Verify Installation

```bash
databricks --version
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

- `rulefilePath`: Path to the central rules file, relative to the workspace root. Default is `docs/agents/AGENTS.md`. Set to `"none"`, `"false"`, or `""` (empty string) to disable rules symlinking.
- `contextPath`: Path to the path-scoped instructions directory, relative to the workspace root. Default is `docs/agents/context`. Set to `"none"`, `"false"`, or `""` (empty string) to disable context mapping.
- `skillsPath`: Path to the modular skills directory, relative to the workspace root. Default is `docs/agents/skills`. Set to `"none"`, `"false"`, or `""` (empty string) to disable skills mapping.

#### Example

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-copilot.tgz": {
      "rulefilePath": "docs/agents/AGENTS.md",
      "contextPath": "docs/agents/context",
      "skillsPath": "docs/agents/skills"
    }
  }
}
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
- [Databricks CLI Documentation](https://docs.databricks.com/en/dev-tools/cli/index.html)
- [Databricks VS Code Extension](https://marketplace.visualstudio.com/items?itemName=databricks.databricks)
