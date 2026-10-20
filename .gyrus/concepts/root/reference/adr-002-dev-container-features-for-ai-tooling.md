---
title: Dev Container Features for AI Tooling
id: adr-002-dev-container-features-for-ai-tooling
type: adr
format: markdown
category: architecture
version: 2
status: accepted
last_updated: 2026-10-20T03:58:31Z
last_modified_by: ""
tenant: root
tags:
    - architecture
    - adr
    - devcontainer
    - ai
links:
    - concept: root/reference/adr-001-use-architecture-design-records
      rel: depends_on
---

# Architecture Decision Record: Dev Container Features for AI Tooling

## Context

* **Status:** Accepted
* **Date:** 2026-07-06
* **Author:** Antigravity

Standardizing local development environments across teams and workspaces is challenging. Specifically, developer productivity tools like Google's Antigravity CLI (`agy`) and GitHub Copilot require specific binary installations, configurations, and IDE extensions. Installing these manually on developers' host machines leads to version drift, permission issues, and setup fatigue.

---

## Decision

We will use the **Dev Container Features** specification (`devcontainer-feature.json` and `install.sh`) to encapsulate, install, and manage AI tooling.
* Each tool (e.g., `antigravity`, `copilot`) is packaged as an independent Dev Container Feature.
* These features handle binary downloads, system path configuration, host configuration bind mounts (e.g., Gemini and Copilot credentials), and default VS Code extensions.
* Standardized environments are distributed by referencing these features in target repositories' `.devcontainer/devcontainer.json`.

---

## Consequences

* **Positive / Gains:**
  * Zero-install developer onboarding: opening the repository in a container automatically provisions all tooling.
  * Consistency: guarantees every developer runs the exact same tool version.
  * Modularity: features can be mixed, matched, and published independently.
* **Negative / Trade-offs:**
  * Relies on Dev Container runtime compatibility (e.g., Docker, Dev Container CLI).
  * Feature options are set at container build/install time, requiring container rebuilds for config changes.
