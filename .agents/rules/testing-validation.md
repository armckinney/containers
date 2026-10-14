---
description: "Validate container image changes with Docker builds and runtime checks, including affected downstream images."
trigger: glob
globs: ["containers/**", ".github/workflows/**"]
paths: ["containers/**", ".github/workflows/**"]
applyTo: "containers/**,.github/workflows/**"
---

# Container Testing and Validation

- Validate every changed image with a Docker build and a runtime check before treating it as complete.
- Test the image that was just built, preferably by its local tag:

  ```bash
  docker run --rm <image>:<tag> <command>
  ```

- Check that the image's primary tools run and report a version or other expected output. Examples include `python3 --version`, `dotnet --version`, and `terraform version`.
- After changing a base image, check that affected derived images still build and run. In particular, check Python when changing Ubuntu, Pyspark when changing Python, and Terraform-Azure when changing Terraform.
- For multi-platform changes, verify the Buildx platform configuration when the environment supports it.
- Allow sufficient time for builds. Python source downloads can fail in restricted networks; distinguish a network failure from an image configuration failure.
- See `docs/development/testing-validation.md` for detailed image-specific scenarios.
