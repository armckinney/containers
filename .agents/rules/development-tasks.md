---
description: "Follow repository steps when adding or modifying container images and their metadata."
trigger: glob
globs: ["containers/**", ".github/workflows/**"]
paths: ["containers/**", ".github/workflows/**"]
applyTo: "containers/**,.github/workflows/**"
---

# Container Development Tasks

## Add an image

1. Create `containers/<image>/<version>/`.
2. Add both `Dockerfile` and `Dockerfile.dev` following the nearest related image's structure.
3. Add the image to the appropriate GitHub Actions build matrix and preserve dependency ordering.
4. Document the image in `containers/README.md`.
5. Build and validate the image before considering the change complete.

## Modify an image

- Understand the image's base and derived-image relationships before editing it.
- Build the changed image and test its actual functionality, not only whether the build completes.
- Check dependent images, especially when changing a shared base.
- Update version references when the change requires a new image version.

See `docs/development/development-tasks.md` for the source task checklist and `docs/development/testing-validation.md` for runtime validation examples.
