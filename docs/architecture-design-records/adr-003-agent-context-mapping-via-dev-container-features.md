# ADR 003: Agent Context Mapping via Dev Container Features

* **Status**: Accepted
* **Date**: 2026-07-06
* **Author**: Antigravity

## Context

AI coding assistants (like Google Antigravity and GitHub Copilot) rely on specific workspace context files (e.g., `.agents/AGENTS.md` and `.github/copilot-instructions.md`) to follow repository-specific rules. Maintaining separate, duplicate instruction files across different tool paths leads to synchronization issues and outdated documentation. We need a way to maintain a single central source of truth for guidelines (rules and modular skills) and dynamically link or compile them for each active tool.

## Decision

We will implement dynamic context mapping directly inside our custom Dev Container Features (`antigravity` and `copilot`):
* We introduce a single unified feature option: `rulefilePath` (with default `AGENTS.md`) which points to the central rules file in the workspace.
* We introduce a single unified feature option: `skillsPath` (with default `docs/agents/skills`) which points to modular skill folders in the workspace.
* Because workspace mounting occurs after feature installation (`install.sh`), we cache the option paths to `/usr/local/share/<feature>/config.env` at build time.
* During container startup, a `postCreateCommand` lifecycle script (`setup-symlinks.sh`) sources the cached configuration:
  * For **Antigravity**: It symlinks the entire workspace rules index and the modular skills directory to `.agents/`.
  * For **Copilot**: It symlinks the central rules file to `.github/copilot-instructions.md`, and symlinks individual skills into `.github/prompts/<name>.prompt.md` to leverage Copilot's native support for reusable custom prompts and slash commands.
* Setting `rulefilePath` or `skillsPath` to `"none"`, `"false"`, or leaving them blank disables this integration.

## Consequences

* **Positive**:
  * Single Source of Truth: Developers maintain a single ruleset (`AGENTS.md`) and a single skills directory, which are automatically translated to tool-specific paths.
  * Modular Rules: Custom instructions can be divided into clean, focused folders.
  * Flexibility: Standardized default paths can be overridden or disabled using devcontainer feature options.
* **Neutral/Negative**:
  * Relies on post-create container lifecycle execution.
  * Sourced variables need to be kept generic and identical in implementation scripts to ensure long-term maintainability.
