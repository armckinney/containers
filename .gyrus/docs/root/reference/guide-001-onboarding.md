---
id: guide-001-onboarding
title: Developer Onboarding & Image Authoring Runbook
category: technical
type: guide
format: markdown
owner_group: root
version: 1
status: active
last_modified_by: Antigravity
last_updated: 2026-10-05
tags:
  - guide
  - onboarding
  - runbook
  - docker
  - features
dependencies:
  - standards-001-guidelines
  - tech-ref-001-api-cli
---

# Guide: Developer Onboarding & Image Authoring Runbook

## Overview

This guide walks new contributors and automated agents through setting up their local development environment, creating new container images, and building reusable Dev Container Features in the `containers` repository.

### Prerequisites
* Docker Desktop or Docker Engine (v24+ with Buildx plugin).
* Dev Container CLI (`npm install -g @devcontainers/cli`).
* GNU Make.
* Optional: VS Code with Remote - Containers extension.

---

## Step-by-Step Instructions

### Step 1: Clone and Open Dev Container

Open the repository in VS Code using Dev Containers, or build the environment via Dev Container CLI:

```bash
# Clone the repository
git clone https://github.com/armckinney/containers.git
cd containers

# Launch devcontainer using Dev Container CLI
devcontainer up --workspace-folder .
```

All required tools (Docker CLI, Gyrus, Antigravity CLI, Copilot) are pre-installed via Dev Container Features.

---

### Step 2: Runbook: Adding a New Container Image Layer

To introduce a new container runtime or application layer:

1. Create the container directory under `containers/<name>/<version>/`:
   ```bash
   mkdir -p containers/my-runtime/1.0.0
   ```
2. Create both `Dockerfile` and `Dockerfile.dev`:
   ```dockerfile
   # containers/my-runtime/1.0.0/Dockerfile
   FROM ghcr.io/armckinney/ubuntu:24.04

   ARG RUNTIME_VERSION=1.0.0
   RUN apt-get update && apt-get install -y --no-install-recommends \
       curl ca-certificates \
       && rm -rf /var/lib/apt/lists/*
   ```
3. Test local image build using the Makefile:
   ```bash
   make test-image IMAGE=my-runtime TAG=1.0.0 SUFFIX=dev
   ```
4. Update repository documentation in `containers/README.md` and `README.md`.

---

### Step 3: Runbook: Authoring a New Dev Container Feature

To introduce a new reusable feature under `features/src/`:

1. Scaffold the feature directory:
   ```bash
   mkdir -p features/src/my-tool features/test/my-tool
   ```
2. Create `features/src/my-tool/devcontainer-feature.json`:
   ```json
   {
     "id": "my-tool",
     "version": "1.0.0",
     "name": "My Tool",
     "description": "Installs My Tool CLI",
     "options": {
       "version": {
         "type": "string",
         "proposals": ["latest", "1.0.0"],
         "default": "latest",
         "description": "Select version"
       }
     }
   }
   ```
3. Write `features/src/my-tool/install.sh`:
   * Ensure script runs with `set -euo pipefail`.
   * Test idempotency and unprivileged user permissions.
4. Add automated test scripts in `features/test/my-tool/test.sh`:
   ```bash
   #!/bin/bash
   set -e
   source dev-container-features-test-lib
   check "my-tool installed" my-tool --version
   reportResults
   ```
5. Test the feature locally:
   ```bash
   make test-feature FEATURE=my-tool
   ```

---

## Verification

To verify that your changes adhere to repository standards:

* **Feature Test Passing:**
  ```bash
  make test-features
  ```
  Expected: All feature test suites pass without container exit errors.
* **Gyrus Context Synchronization:**
  ```bash
  gyrus sync
  ```
  Expected: All architectural documents and dependency edges are parsed and indexed without warnings.

---

## Troubleshooting & Common Pitfalls

* **Issue: `docker: Error response from daemon: dial unix /var/run/docker.sock: connect: permission denied`**
  * **Cause:** User not in `docker` group inside the dev container.
  * **Resolution:** Ensure the `docker-in-docker` feature is enabled or use root permissions within the container.

* **Issue: `devcontainer features test` fails with timeout**
  * **Cause:** Slow network downloading base images during test matrix execution.
  * **Resolution:** Run feature test individually with `make test-feature FEATURE=<name>`.
