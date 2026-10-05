---
id: standards-001-guidelines
title: Container Development & Quality Standards
category: technical
type: standards
format: markdown
owner_group: root
version: 1
status: active
last_modified_by: Antigravity
last_updated: 2026-10-05
tags:
  - standards
  - docker
  - devcontainer
  - quality
  - testing
dependencies: []
---

# Process & Engineering Standard: Container Development & Quality Standards

## 1. Objective & Scope

* **Owner / Sponsor:** Container Engineering & Automation Team
* **Effective Date:** 2026-10-05
* **Target Audience:** Maintainers and AI agents contributing to `containers/`, `features/`, and build automation scripts.

### Purpose
This standard specifies the quality rules, structural conventions, and testing requirements for authoring Dockerfiles, packaging Dev Container Features, and writing automation scripts in the `containers` repository.

---

## 2. Standard Guidelines & Rules

### Rule 1: Dockerfile Version Pinning & Multi-Stage Builds
* **Requirement:** All base image tags, external package downloads, and runtime binaries must have explicit version identifiers. Avoid `latest` tags in production `Dockerfile` definitions.
* **Rationale:** Ensures builds are deterministic, reproducible across environments, and immune to upstream breaking changes.

### Rule 2: Dual Dockerfile Architecture (`Dockerfile` vs `Dockerfile.dev`)
* **Requirement:** Each image directory under `containers/<image>/<tag>/` must provide:
  * `Dockerfile`: Production release image containing only runtime dependencies with minimal attack surface.
  * `Dockerfile.dev`: Development image adding developer conveniences, package compilers, and debugging symbols.
* **Rationale:** Keeps production images lightweight while allowing developer-friendly interactive workflows.

### Rule 3: Repository Root Build Context
* **Requirement:** All Docker builds must use the repository root (`.`) as the build context (e.g. `docker buildx build -f containers/ubuntu/24.04/Dockerfile .`).
* **Rationale:** Automation scripts and shared setup utilities expect context paths relative to repository root.

### Rule 4: Dev Container Feature Idempotency & Clean Separation
* **Requirement:** Feature `install.sh` scripts must:
  * Be strictly idempotent (safe to execute multiple times).
  * Check dependencies before installation (`apt-get update` followed by cleanup of `/var/lib/apt/lists/*`).
  * Support non-root `_REMOTE_USER` and set correct ownership on home directory mounts.
  * Cache workspace configuration variables during container build for later consumption by runtime hooks.
* **Rationale:** Dev containers execute installation at image build time before user home directories and workspaces are mounted.

### Rule 5: Test Coverage for Features & Scenarios
* **Requirement:** Every feature in `features/src/<feature>` must have corresponding automated tests in `features/test/<feature>/` including:
  * `test.sh`: Baseline installation check verifying CLI presence and executable exit code.
  * `scenarios.json`: Parameterized matrix testing custom options, flag toggles, and disabled symlink states.
* **Rationale:** Guarantees features work reliably across different base distributions and user configurations.

---

## 3. Recommended Tools & Examples

### Correct Pattern: Feature Installation Script
```bash
#!/bin/bash
set -euo pipefail

FEATURE_DIR="/usr/local/share/my-feature"
mkdir -p "${FEATURE_DIR}"

# Persist options for runtime lifecycle hooks
echo "OPTION_VAL=${MY_OPTION:-default}" >> "${FEATURE_DIR}/config.env"
chmod 644 "${FEATURE_DIR}/config.env"

# Clean up apt caches to minimize image layer size
rm -rf /var/lib/apt/lists/*
```

### Incorrect Pattern: Hardcoding Workspace Paths
```bash
# Anti-pattern: Assuming hardcoded workspace paths in install.sh
mkdir -p /workspaces/containers/.agents  # FAILS: workspace not mounted at install time!
```

---

## 4. Compliance & Enforcement

* **Enforcement Point:** 
  * GitHub Actions workflows gate PR merges on `devcontainer features test` and Docker multi-arch builds.
  * Local verification via `make test-features` and `make test-feature FEATURE=<name>`.
* **Exceptions:** Temporary experimental features or draft images must be quarantined on topic branches until full test suites and documentation are complete.
