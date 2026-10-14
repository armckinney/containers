---
description: "Apply the repository's build-script usage and path-context guidance when editing or running scripts."
trigger: glob
globs: ["scripts/**", ".github/workflows/scripts/**"]
paths: ["scripts/**", ".github/workflows/scripts/**"]
applyTo: "scripts/**,.github/workflows/scripts/**"
---

# Build Script Usage

- The main image build script is `scripts/build-image.sh` and accepts an image name, version tag, and suffix (`-i`, `-t`, and `-s`). The suffix defaults to `dev`; `-a` requests `linux/amd64,linux/arm64`.
- The script currently sets its build context to `/workspaces/containers`. If the repository is checked out elsewhere, that absolute path will fail. Prefer a direct Buildx command with `.` as context, or change the script to derive its repository root from its own location.
- Keep examples consistent with the actual Dockerfile path convention: `containers/<image>/<version>/Dockerfile.<suffix>`.
- Consult `docs/development/scripts.md` for the documented invocation and direct-command examples.
