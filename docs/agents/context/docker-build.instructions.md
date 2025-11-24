---
applyTo: "containers/**"
---

# Docker Build Instructions

## Prerequisites and Setup

- **CRITICAL**: Docker and Docker Buildx must be available in your environment.
- Verify Docker setup: `docker --version && docker buildx version`
- Repository works from any directory - the build script path hardcoded to `/workspaces/containers` must be adjusted.

## Building Images Locally

- **NEVER CANCEL builds** - Even simple builds may take 1-5 minutes. Complex builds may take 10-30 minutes. Set timeouts to 60+ minutes.
- Use the build script: `scripts/build-image.sh -i <image> -t <tag> -s <suffix>`
  - **WARNING**: Script has hardcoded path `/workspaces/containers` that must be changed to current directory (`.`)
  - **CORRECTED COMMAND**: `docker buildx build --no-cache -t "armck/<image>:<tag>-<suffix>" -f "containers/<image>/<tag>/Dockerfile.<suffix>" .`

## Build Timing Expectations

- Ubuntu images: **~20 seconds** - NEVER CANCEL, set timeout 180+ seconds
- .NET images: **~17 seconds** - NEVER CANCEL, set timeout 180+ seconds  
- Python images: **5-30 minutes** - NEVER CANCEL, set timeout 3600+ seconds (may fail due to network constraints)
- Terraform images: **2-10 minutes** - NEVER CANCEL, set timeout 1800+ seconds
- Java/Pyspark images: **3-15 minutes** - NEVER CANCEL, set timeout 2400+ seconds

## Build Order Dependencies

**CRITICAL**: Build images in dependency order to avoid failures:
1. Ubuntu first
2. Python, Terraform, .NET, Java (depend on Ubuntu)
3. Pyspark (depends on Python)
4. Terraform-Azure (depends on Terraform)

## Build Script Usage

```bash
# Original script (requires path fix):
scripts/build-image.sh -i ubuntu -t 24.04 -s dev

# Corrected direct docker command:
docker buildx build --no-cache -t "armck/ubuntu:24.04-dev" -f "containers/ubuntu/24.04/Dockerfile.dev" .

# Multi-platform build:
docker buildx build --platform linux/amd64,linux/arm64 --no-cache -t "armck/ubuntu:24.04-dev" -f "containers/ubuntu/24.04/Dockerfile.dev" .
```

## Known Issues and Workarounds

- **Network dependencies**: Python builds download from python.org and may fail in restricted networks
  - Error: `curl: (6) Could not resolve host: www.python.org`
  - Workaround: Use pre-built Python images or ensure network access to python.org
- **Build script path**: Must use current directory (`.`) instead of hardcoded `/workspaces/containers`
  - Error: `path "/workspaces/containers" not found`
  - Fix: Use corrected Docker commands shown in this document
- **Multi-platform builds**: May require buildx setup and additional build time for ARM64 support

## Critical Reminders

- **NEVER CANCEL long-running builds** - Builds can take 5-30 minutes or more
- **Build in dependency order** when working with multiple images
- **Path corrections** required for build script usage
- **Multi-platform considerations** for production releases (linux/amd64, linux/arm64)
- **CRITICAL**: Always set Docker build timeouts to 60+ minutes for safety
