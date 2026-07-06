# ADR 004: Three-Tiered AI Context Classification

* **Status**: Accepted
* **Date**: 2026-07-06
* **Author**: Antigravity

## Context

AI agent instructions and capabilities in a repository are consumed differently depending on the tool (e.g., Google Antigravity vs. GitHub Copilot). Previously, we mapped all instruction sets as "skills." However, treating all guidelines as skills resulted in Copilot treating passive, directory-scoped rules (like Docker build instructions) as manual slash commands. Conversely, treating all guidelines as global rules results in context pollution. We need to distinguish between global rules, path-specific contexts, and explicit skills, and map them to their corresponding native locations for each AI tool.

## Decision

We will structure and map repository-specific AI instructions using a three-tiered classification:

1. **Rules (Global & Passive)**:
   * **Purpose**: Workspace-wide coding guidelines.
   * **Source**: `docs/agents/AGENTS.md`
   * **Antigravity**: Symlinked to `.agents/AGENTS.md` (automatic rule).
   * **Copilot**: Symlinked to `.github/copilot-instructions.md` (automatic repository instruction).

2. **Context (Path-scoped & Passive)**:
   * **Purpose**: Directory-scoped rules (e.g. docker-build, workflows) that should only load for matching files.
   * **Source**: `docs/agents/context/*.instructions.md`
   * **Antigravity**: Symlinked to `.agents/context/` (since agy does not support native path scoping, it parses it from the context directory).
   * **Copilot**: Symlinked to `.github/instructions/*.instructions.md` using native `applyTo` glob patterns to trigger automatic loading.

3. **Skills (Task-specific & Active)**:
   * **Purpose**: User-triggered slash commands or automated agents actions.
   * **Source**: `docs/agents/skills/`
   * **Antigravity**: Symlinked to `.agents/skills/` (native skills directory).
   * **Copilot**: Symlinked to `.github/prompts/<name>.prompt.md` (native prompt files/slash commands).

We introduce the option `contextPath` (default `docs/agents/context`) alongside `rulefilePath` and `skillsPath` in the devcontainer features to configure this mapping.

## Consequences

* **Positive**:
  * Tools consume guidelines in their native-friendly way: Copilot uses automatic path-scoped context triggers and manual prompt commands.
  * Context pollution is reduced since path-scoped instructions are loaded only when relevant.
  * Agy registers modular skills cleanly.
* **Neutral/Negative**:
  * Slightly more files to maintain, but follows standard tool layouts.
