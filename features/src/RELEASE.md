# Devcontainer Features Release

This release contains devcontainer features that can be consumed from other repositories.

## Quick Start

### Table of Contents
- [Antigravity CLI](#antigravity-cli)
- [Antigravity Remote Control](#antigravity-remote-control)
- [Databricks](#databricks)
- [Docker-in-Docker](#docker-in-docker)
- [GitHub Copilot](#github-copilot)
- [OpenAI Codex](#openai-codex)
- [Gyrus](#gyrus)
- [VS Code Customizations](#vs-code-customizations)

Each feature below has its own `devcontainer.json` snippet. The examples install the latest release. To pin a specific release, use `https://github.com/armckinney/containers/releases/download/<VERSION>/devcontainer-feature-<FEATURE>.tgz` and replace `<VERSION>` with the release tag (for example `v1.2.3`).

---

## Antigravity CLI

Installs Google's Antigravity CLI (`agy`), mounts local config files from the host, and configures the Google Antigravity VS Code extension.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-antigravity.tgz": {
      "instructionFilePath": ".agents/AGENTS.md", // Optional: central instruction file
      "rulesPath": ".agents/rules", // Optional: rules directory
      "skillsPath": ".agents/skills" // Optional: skills directory
    }
  }
}
```

### Options

- `instructionFilePath` (optional): Path to the central instruction file, relative to the workspace root. When present, the feature links it to `.agents/AGENTS.md` if that destination is unused.
- `rulesPath` (optional): Path to the rules directory, relative to the workspace root. When present, the feature links it to `.agents/rules` if that destination is unused.
- `skillsPath` (optional): Path to the modular skills directory, relative to the workspace root. Default is `""` (disabled). When configured, the feature links it to `.agents/skills` if that destination is unused.

> [!NOTE]
> All path options are strictly **opt-in** and default to empty (`""`). When omitted or left empty, no symlinks or files are created. When configured, symlinks are only created if the target file or directory already exists in the workspace—baseline files are never auto-generated.

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
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-antigravity-remote.tgz": {
      "registrationName": "my-box" // Optional: defaults to a generated persistent name
    }
  }
}
```

### Options

- `registrationName` (optional): Custom registration/session name for this Antigravity Remote daemon (e.g. `"my-box"`). Will be prefixed with `devcontainer-`. If omitted or empty, a persistent unique GUID is automatically generated and saved with `devcontainer-` prefix.

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

Installs the Databricks CLI, mounts host Databricks credentials and configuration (`~/.databrickscfg` and `~/.databricks`), and configures the Databricks VS Code extension.

> [!IMPORTANT]
> **Port Forwarding Required in `devcontainer.json`**: Dev Container Features cannot declare port forwarding (`forwardPorts` is not supported in `devcontainer-feature.json`). Consuming `devcontainer.json` configurations must explicitly declare `forwardPorts` and `portsAttributes` for port `8020` to enable the Databricks CLI OAuth authentication flow (`http://localhost:8020/callback`).

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-databricks.tgz": {
      "version": "latest" // Optional: CLI version; defaults to latest
    }
  },
  "forwardPorts": [8020], // Required for the Databricks OAuth callback
  "portsAttributes": {
    "8020": {
      "label": "Databricks OAuth",
      "onAutoForward": "silent",
      "requireLocalPort": true
    }
  }
}
```

### Options

- `version` (optional): Version of the Databricks CLI to install (e.g., `"latest"`, `"1.16.1"`). Defaults to `"latest"`.

### Features

- Databricks CLI installation (available as `databricks` globally in `/usr/local/bin`)
- Host credentials & token cache bind mounts:
  - `${localEnv:HOME}/.databrickscfg` -> `/root/.databrickscfg`
  - `${localEnv:HOME}/.databricks` -> `/root/.databricks`
- VS Code extension:
  - `databricks.databricks`
- VS Code port attributes configuration for port 8020 OAuth authentication callback (`http://localhost:8020/callback`) when forwarded by `devcontainer.json`

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
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-docker-in-docker.tgz": {}
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
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-copilot.tgz": {
      "instructionFilePath": ".agents/AGENTS.md", // Optional: central instruction file
      "instructionsPath": ".github/instructions", // Optional: source instructions directory
      "skillsPath": ".agents/skills" // Optional: skills directory
    }
  }
}
```

### Options

- `instructionFilePath` (optional): Path to the central instruction file, relative to the workspace root. When present, the feature links it to `.github/copilot-instructions.md` if that destination is unused.
- `instructionsPath` (optional): Path to the source directory of Markdown instructions, relative to the workspace root. Each source file is linked separately under `.github/instructions` with a `.instructions.md` suffix (for example, `rules.md` becomes `rules.instructions.md`). Existing destination files are preserved. The example uses Copilot's `.github/instructions` directory.
- `skillsPath` (optional): Path to the modular skills directory, relative to the workspace root. Default is `""` (disabled). When configured, the feature links it to `.agents/skills` if that destination is unused.

> [!NOTE]
> All path options are strictly **opt-in** and default to empty (`""`). When omitted or left empty, no symlinks or files are created. When configured, symlinks are only created if the target file or directory already exists in the workspace—baseline files are never auto-generated.

---

## OpenAI Codex

Installs the OpenAI Codex CLI and VS Code extension. The host's `${localEnv:HOME}/.codex` directory is bind-mounted to `/root/.codex` so CLI and extension settings, authentication, and local state are available in the container and persist across rebuilds. Optional path settings can link a central `AGENTS.md`, project rules, and skills into the locations Codex discovers.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-codex.tgz": {
      "instructionFilePath": ".agents/AGENTS.md", // Optional: central AGENTS.md
      "rulesPath": ".agents/rules", // Optional: Codex rules directory
      "skillsPath": ".agents/skills" // Optional: skills directory
    }
  }
}
```

### Options

- `instructionFilePath` (optional): Path to the central `AGENTS.md`, relative to the workspace root. When present and the workspace root has no `AGENTS.md`, the feature links it there. Existing files or links are silently preserved.
- `rulesPath` (optional): Path to the Codex rules directory, relative to the workspace root. When present, the feature links it to `.codex/rules` if that destination is unused.
- `skillsPath` (optional): Path to the skills directory, relative to the workspace root. When present and `.agents/skills` is unused, the feature links it there. Existing directories or links are silently preserved. Codex discovers project skills in `.agents/skills`.

There is no separate context directory option because Codex does not automatically load a context directory. Reference context files from `AGENTS.md` when needed. These path options default to empty and are disabled unless configured.

### Features

- Codex CLI installed system-wide as `codex`
- OpenAI Codex VS Code extension (`OpenAI.chatgpt`)
- Host Codex home bind mount (`${localEnv:HOME}/.codex` to `/root/.codex`) for shared settings, authentication, and state
- Optional symlink setup for central `AGENTS.md` and skills, silently skipping existing destinations to avoid conflicts with other tools

---

## Gyrus

Installs the Gyrus CLI, a high-performance local-first memory and context engine for software development teams and AI agents.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-gyrus.tgz": {
      "version": "latest" // Optional: CLI version; defaults to latest
    }
  }
}
```

### Options

- `version` (optional): Version of Gyrus to install (e.g., `"latest"`, `"0.1.11"`). Defaults to `"latest"`.

### Features

- Gyrus CLI installation (available as `gyrus` globally in `/usr/local/bin`)

### Verify Installation

```bash
gyrus --help
gyrus config show
```

---

## VS Code Customizations

Applies standardized VS Code settings and extension recommendations for a consistent development environment.

### Usage

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-vscode-customizations.tgz": {}
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
- [Gyrus Repository](https://github.com/armckinney/gyrus)
