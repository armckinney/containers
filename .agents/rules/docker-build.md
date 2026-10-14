---
description: "Use the repository's Docker Buildx prerequisites, commands, dependency order, and timing guidance when building container images."
trigger: glob
globs: ["containers/**", "scripts/**"]
paths: ["containers/**", "scripts/**"]
applyTo: "containers/**,scripts/**"
---

# Docker Image Builds

- Ensure Docker and Docker Buildx are available before building: `docker --version && docker buildx version`.
- Run build commands from the repository root so `.` is the build context.
- The current `scripts/build-image.sh` uses the fixed project root `/workspaces/containers`. If that path is unavailable, use a direct Buildx command with `.` as the context or update the script to use the repository root.
- A direct single-platform build follows this form:

  ```bash
  docker buildx build --no-cache \
    -t "ghcr.io/armckinney/<image>:<version>-<suffix>" \
    -f "containers/<image>/<version>/Dockerfile.<suffix>" .
  ```

- Add `--platform linux/amd64,linux/arm64` when a multi-platform build is required.
- Do not cancel a running image build just because it is taking several minutes. Choose a timeout that allows the full build; use at least 60 minutes for potentially long builds.
- Build in dependency order: Ubuntu before its derived images; Python before Pyspark; Terraform before Terraform-Azure.
- Python source builds may fail when `python.org` is unreachable. Check network access before treating a download failure as a Dockerfile defect.
- Consult `docs/development/docker-build.md` for timing estimates and additional troubleshooting notes.
