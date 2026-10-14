---
description: "Apply the repository's CI workflow and development-container conventions when editing workflows or the devcontainer."
trigger: glob
globs: [".github/workflows/**", ".devcontainer/**"]
paths: [".github/workflows/**", ".devcontainer/**"]
applyTo: ".github/workflows/**,.devcontainer/**"
---

# CI/CD and Development Environment

- The development image workflow runs for pull requests that change Dockerfiles or its workflow/build-matrix scripts.
- The release image workflow runs for changes to Dockerfiles or its workflow/build-matrix scripts pushed to `main`.
- Keep the dev and release build matrices aligned with supported container images.
- Image build workflows target both `linux/amd64` and `linux/arm64`; preserve multi-platform settings when changing build jobs.
- Set job timeouts to fit the work performed. Image builds can take substantially longer than the matrix-discovery jobs.
- Keep the `.devcontainer/` setup consistent with the repository's Docker-based development workflow.
- Consult `docs/development/ci-cd.md` for the source workflow summary.
