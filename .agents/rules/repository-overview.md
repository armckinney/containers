---
description: "Use the container repository layout and image dependency model when changing image definitions, build scripts, or build workflows."
trigger: glob
globs: ["containers/**", "scripts/**", ".github/workflows/**"]
paths: ["containers/**", "scripts/**", ".github/workflows/**"]
applyTo: "containers/**,scripts/**,.github/workflows/**"
---

# Container Repository Structure

- Container definitions live under `containers/<image>/<version>/` and normally include `Dockerfile` and `Dockerfile.dev`.
- Treat Ubuntu as the base for Python, Terraform, .NET, and Java images. Pyspark depends on Python, and Terraform-Azure depends on Terraform.
- Before changing a base image, inspect its downstream images and account for them in build and validation plans.
- Build related images in dependency order: Ubuntu first; then Python, Terraform, .NET, and Java; then Pyspark after Python and Terraform-Azure after Terraform.
- Keep image definitions, build-matrix workflows, and `containers/README.md` consistent when adding or changing an image.
- Consult `docs/development/repository-overview.md` when the repository structure or image layering needs more context.
