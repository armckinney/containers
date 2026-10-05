---
id: tech-ref-001-api-cli
title: Automation CLI & Dev Container Features Reference
category: technical
type: technical-reference
format: markdown
owner_group: root
version: 1
status: active
last_modified_by: Antigravity
last_updated: 2026-10-05
tags:
  - technical-reference
  - cli
  - makefile
  - features
  - options
dependencies: []
---

# Technical Reference: Automation CLI & Dev Container Features Reference

## 1. Overview & Setup

This technical reference documents the build automation interfaces, Dev Container Feature configuration options, and published container image matrix for the `containers` repository.

---

## 2. Command Line Interface (CLI) Reference

### Automation Makefile Targets

The repository includes a top-level `Makefile` providing standard targets:

#### Target: `make test-features`
* **Description:** Runs all Dev Container Feature tests in parallel across the repository using the Dev Container CLI.
* **Usage:**
  ```bash
  make test-features
  ```

#### Target: `make test-feature FEATURE=<name>`
* **Description:** Runs the test suite for a specific Dev Container Feature.
* **Usage:**
  ```bash
  make test-feature FEATURE=antigravity
  make test-feature FEATURE=copilot
  ```
* **Parameters:**
  * `FEATURE` (Required): Name of feature under `features/src/` (e.g. `antigravity`, `gyrus`, `databricks`, `docker-in-docker`).

#### Target: `make test-image IMAGE=<name> TAG=<tag> [SUFFIX=dev] [MULTIARCH=1]`
* **Description:** Builds a container image locally using `scripts/build-image.sh`.
* **Usage:**
  ```bash
  make test-image IMAGE=ubuntu TAG=24.04
  make test-image IMAGE=python TAG=3.12.3 SUFFIX=dev
  make test-image IMAGE=python TAG=3.12.3 MULTIARCH=1
  ```

### Build Image Script (`scripts/build-image.sh`)

* **Syntax:** `scripts/build-image.sh -i <image> -t <tag> [-s <suffix>] [-a]`
* **Flags:**
  * `-i, --image`: Name of container image directory (e.g., `ubuntu`, `python`).
  * `-t, --tag`: Version tag directory (e.g., `24.04`, `3.12.3`).
  * `-s, --suffix`: Dockerfile flavor (`dev` or `prod`, defaults to `dev`).
  * `-a, --all`: Build multi-architecture platforms (`linux/amd64`, `linux/arm64`).

---

## 3. Dev Container Features Options Reference

Below is the configuration matrix for features in `features/src/`:

| Feature ID | Configurable Options | Default | Description |
| :--- | :--- | :--- | :--- |
| `antigravity` | `version` | `latest` | Target version of the Antigravity CLI (`agy`) binary. |
| | `rulefilePath` | `""` | Workspace relative path to global rules file (`AGENTS.md`). |
| | `contextPath` | `""` | Workspace relative path to path-scoped instructions (`docs/agents/context`). |
| | `skillsPath` | `""` | Workspace relative path to modular skills (`docs/agents/skills`). |
| `antigravity-remote` | `name` | `default` | Remote environment identifier for the background Antigravity daemon. |
| | `command` | `""` | Custom arguments passed to daemon startup. |
| `copilot` | `version` | `latest` | GitHub Copilot CLI release version. |
| | `rulefilePath` | `""` | Target path to symlink as `.github/copilot-instructions.md`. |
| | `contextPath` | `""` | Target path to symlink as `.github/instructions/`. |
| | `skillsPath` | `""` | Target path to compile as `.github/prompts/*.prompt.md`. |
| `gyrus` | `version` | `latest` | Target release version of the Gyrus Context Plane CLI. |
| `databricks` | `version` | `latest` | Databricks CLI version to install. |
| `docker-in-docker` | `version` | `latest` | Docker engine version inside container. |
| | `moby` | `true` | Use Moby open-source engine distribution. |
| `vscode-customizations` | `settings` | `{}` | JSON overrides to inject into container `.vscode/settings.json`. |

---

## 4. Container Images Registry Catalog

All published container images are hosted under GitHub Container Registry:

| Image Name | Available Tags | Lineage Base Image | GHCR Image URI |
| :--- | :--- | :--- | :--- |
| `ubuntu` | `20.04`, `22.04`, `24.04`, `25.04` | Canonical Ubuntu | `ghcr.io/armckinney/ubuntu:<tag>` |
| `python` | `3.9.5`, `3.12.3` | `ubuntu:24.04` | `ghcr.io/armckinney/python:<tag>` |
| `pyspark` | `3.5.2` | `python:3.12.3` | `ghcr.io/armckinney/pyspark:<tag>` |
| `terraform` | `1.10.5` | `ubuntu:24.04` | `ghcr.io/armckinney/terraform:<tag>` |
| `terraform-azure`| `2.73.0` | `terraform:1.10.5` | `ghcr.io/armckinney/terraform-azure:<tag>` |
| `go` | `1.25.0` | `ubuntu:24.04` | `ghcr.io/armckinney/go:<tag>` |
| `java` | `21` | `ubuntu:24.04` | `ghcr.io/armckinney/java:<tag>` |
| `dotnet` | `8.0` | `ubuntu:24.04` | `ghcr.io/armckinney/dotnet:<tag>` |

---

## 5. Frequently Asked Questions (FAQ) & Troubleshooting

* **Q: Why does `scripts/build-image.sh` fail with path errors in external checkouts?**
  * **A:** The script expects the repository root build context. Always execute build commands from workspace root (`.`).
* **Q: Why are `.agents` symlinks not appearing in devcontainer workspaces?**
  * **A:** Verify `rulefilePath`, `contextPath`, and `skillsPath` are explicitly configured in `.devcontainer/devcontainer.json` under the feature definition, and that target folders exist in the workspace.
