<p align="center">
  <img width="100px" src="https://img.stackshare.io/stack/979421/default_7b21deccd8ef4e667218f8a46721601eec9455f4.png" alt="Containers" />
</p>

# Containers

*A layered image vault.*

Containers is a repository of standardized `Dockerfiles` that are built into images and hosted on the [GitHub Container Registry (GHCR)](https://github.com/armckinney?tab=packages), as well as reusable [Dev Container Features](features/src/RELEASE.md).
Many of these images are built on top of each other (i.e. `Ubuntu` > `Python` > `Pyspark`).

I utilize these images as well as various GitHub `template-repositories` in order to spin up standardized projects quick and seamless!

### Quick Start

Use these hosted images in your Dockerfile by identifying the desired base image; follows standard image syntax `ghcr.io/<owner>/<image>:<tag>`.

###### Dockerfile:
```dockerfile
FROM ghcr.io/armckinney/ubuntu:24.04

RUN other_cool_things.exe
...
```

View all of these images hosted at the GitHub Container Registry, [ghcr.io/armckinney](https://github.com/armckinney?tab=packages).

### Images

All published images in this repository use the format `ghcr.io/armckinney/<image>:<tag>`.
For per-image descriptions, base-image lineage, and feature details, see [containers/README.md](containers/README.md).

| Image | Available Tags | Source Directory |
| --- | --- | --- |
| ubuntu | `20.04`, `22.04`, `24.04`, `25.04` | [containers/ubuntu](containers/ubuntu) |
| terraform | `1.10.5` | [containers/terraform](containers/terraform) |
| terraform-azure | `2.73.0` | [containers/terraform-azure](containers/terraform-azure) |
| go | `1.25.0` | [containers/go](containers/go) |
| python | `3.9.5`, `3.12.3` | [containers/python](containers/python) |
| pyspark | `3.5.2` | [containers/pyspark](containers/pyspark) |
| java | `21` | [containers/java](containers/java) |
| dotnet | `8.0` | [containers/dotnet](containers/dotnet) |

### Usage

These images can be manually copied or downloaded from GitHub for individual use, or you can just build on top of them with the publicly hosted images.

### Dev Container Features

This repository also publishes reusable [Dev Container Features](https://containers.dev/implementors/features/) to extend development environments with preconfigured tooling, CLI utilities, and IDE integrations.

For detailed documentation, configuration options, and release assets, see [features/src/RELEASE.md](features/src/RELEASE.md).

| Feature | ID | Description | Source Directory |
| --- | --- | --- | --- |
| Antigravity CLI | `antigravity` | Installs Google's Antigravity CLI (`agy`), mounts host config, and sets up VS Code integration with optional agent rules mapping | [features/src/antigravity](features/src/antigravity) |
| Antigravity Remote | `antigravity-remote` | Runs the Antigravity daemon to connect to the devcontainer remotely | [features/src/antigravity-remote](features/src/antigravity-remote) |
| OpenAI Codex | `codex` | Installs the Codex CLI and VS Code extension, mounts host Codex configuration, and supports optional instruction and skills links | [features/src/codex](features/src/codex) |
| GitHub Copilot | `copilot` | Installs GitHub Copilot CLI, mounts host config, and sets up VS Code extensions with optional agent rules mapping | [features/src/copilot](features/src/copilot) |
| Databricks | `databricks` | Installs the Databricks CLI, mounts host credentials (`~/.databrickscfg`), and configures VS Code extensions | [features/src/databricks](features/src/databricks) |
| Docker-in-Docker | `docker-in-docker` | Enables running Docker inside the container using privileged mode | [features/src/docker-in-docker](features/src/docker-in-docker) |
| Gyrus | `gyrus` | Installs the Gyrus CLI, a local-first memory and context engine for developers and AI agents | [features/src/gyrus](features/src/gyrus) |
| VS Code Customizations | `vscode-customizations` | Applies standardized VS Code settings and extension recommendations | [features/src/vscode-customizations](features/src/vscode-customizations) |

#### Using Features in `devcontainer.json`

Reference the latest packaged feature tarballs from GitHub Releases:

```jsonc
{
  "features": {
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-antigravity.tgz": {},
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-antigravity-remote.tgz": {},
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-codex.tgz": {},
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-copilot.tgz": {},
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-databricks.tgz": {},
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-docker-in-docker.tgz": {},
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-gyrus.tgz": {},
    "https://github.com/armckinney/containers/releases/latest/download/devcontainer-feature-vscode-customizations.tgz": {}
  }
}
```

To test features locally using the Dev Container CLI:
```bash
make test-features                     # Test all features
make test-feature FEATURE=antigravity  # Test a specific feature
```

### Contributing
When adding new images or features to the repository, ensure workflows and documentation are updated accordingly.

A brief documentation summary should also be included in [containers/README.md](containers/README.md) for images or [features/src/RELEASE.md](features/src/RELEASE.md) for features.
