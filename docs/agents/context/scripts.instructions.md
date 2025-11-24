---
applyTo: "scripts/**"
---

# Scripts Instructions

## Build Script Usage

The main build script is `scripts/build-image.sh` but has known issues:

- **WARNING**: Script has hardcoded path `/workspaces/containers` that must be changed to current directory (`.`)
- **Error**: `path "/workspaces/containers" not found`

### Corrected Commands

Instead of using the script directly, use these corrected Docker commands:

```bash
# Original script (requires path fix):
scripts/build-image.sh -i ubuntu -t 24.04 -s dev

# Corrected direct docker command:
docker buildx build --no-cache -t "armck/ubuntu:24.04-dev" -f "containers/ubuntu/24.04/Dockerfile.dev" .

# Multi-platform build:
docker buildx build --platform linux/amd64,linux/arm64 --no-cache -t "armck/ubuntu:24.04-dev" -f "containers/ubuntu/24.04/Dockerfile.dev" .
```
