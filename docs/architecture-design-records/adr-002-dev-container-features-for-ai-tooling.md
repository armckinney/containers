# ADR 002: Dev Container Features for AI Tooling

* **Status**: Accepted
* **Date**: 2026-07-06
* **Author**: Antigravity

## Context

Standardizing local development environments across teams and workspaces is challenging. Specifically, developer productivity tools like Google's Antigravity CLI (`agy`) and GitHub Copilot require specific binary installations, configurations, and IDE extensions. Installing these manually on developers' host machines leads to version drift, permission issues, and setup fatigue.

## Decision

We will use the **Dev Container Features** specification (`devcontainer-feature.json` and `install.sh`) to encapsulate, install, and manage AI tooling.
* Each tool (e.g., `antigravity`, `copilot`) is packaged as an independent Dev Container Feature.
* These features handle binary downloads, system path configuration, host configuration bind mounts (e.g., Gemini and Copilot credentials), and default VS Code extensions.
* Standardized environments are distributed by referencing these features in target repositories' `.devcontainer/devcontainer.json`.

## Consequences

* **Positive**:
  * Zero-install developer onboarding: opening the repository in a container automatically provisions all tooling.
  * Consistency: guarantees every developer runs the exact same tool version.
  * Modularity: features can be mixed, matched, and published independently.
* **Neutral/Negative**:
  * Relies on Dev Container runtime compatibility (e.g., Docker, Dev Container CLI).
  * Feature options are set at container build/install time, requiring container rebuilds for config changes.
