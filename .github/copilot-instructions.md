# Containers Repository Instructions

This repository contains standardized Dockerfiles that are built into layered container images and hosted on DockerHub. Images build on top of each other (Ubuntu → Python → Pyspark).

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Prerequisites and Setup
- **CRITICAL**: Docker and Docker Buildx must be available in your environment.
- Verify Docker setup: `docker --version && docker buildx version`
- Repository works from any directory - the build script path hardcoded to `/workspaces/containers` must be adjusted.

### Building Images Locally
- **NEVER CANCEL builds** - Even simple builds may take 1-5 minutes. Complex builds may take 10-30 minutes. Set timeouts to 60+ minutes.
- Use the build script: `scripts/build-image.sh -i <image> -t <tag> -s <suffix>`
  - **WARNING**: Script has hardcoded path `/workspaces/containers` that must be changed to current directory (`.`)
  - **CORRECTED COMMAND**: `docker buildx build --no-cache -t "armck/<image>:<tag>-<suffix>" -f "containers/<image>/<tag>/Dockerfile.<suffix>" .`
- Build timing expectations:
  - Ubuntu images: **~20 seconds** - NEVER CANCEL, set timeout 180+ seconds
  - .NET images: **~17 seconds** - NEVER CANCEL, set timeout 180+ seconds  
  - Python images: **5-30 minutes** - NEVER CANCEL, set timeout 3600+ seconds (may fail due to network constraints)
  - Terraform images: **2-10 minutes** - NEVER CANCEL, set timeout 1800+ seconds
  - Java/Pyspark images: **3-15 minutes** - NEVER CANCEL, set timeout 2400+ seconds

### Image Structure and Dependencies
- **Base layer**: Ubuntu (20.04, 22.04, 24.04)
- **Python layer**: Built from Ubuntu, adds Python + development tools
- **Pyspark layer**: Built from Python, adds Java + Pyspark
- **Terraform layer**: Built from Ubuntu, adds Terraform toolchain
- **Terraform-Azure layer**: Built from Terraform, adds Azure CLI
- **.NET layer**: Built from Ubuntu, adds .NET SDK
- **Java layer**: Built from Ubuntu, adds Java runtime

### Build Order Dependencies
- **CRITICAL**: Build images in dependency order to avoid failures:
  1. Ubuntu first
  2. Python, Terraform, .NET, Java (depend on Ubuntu)
  3. Pyspark (depends on Python)
  4. Terraform-Azure (depends on Terraform)

## Validation and Testing

### Manual Validation Steps
- **ALWAYS** validate every built image before considering it complete.
- Test image functionality: `docker run --rm armck/<image>:<tag>-<suffix> echo "Image works!"`
- Verify installed tools work:
  - Ubuntu: `docker run --rm armck/ubuntu:24.04-dev bash -c "echo 'Ubuntu validation passed'"`
  - Python: `docker run --rm armck/python:3.12.3-dev python3 --version`
  - .NET: `docker run --rm armck/dotnet:8.0-dev dotnet --version`
  - Terraform: `docker run --rm armck/terraform:1.10.5-dev terraform version`

### CI/CD Validation
- **Dev builds**: Triggered on pull requests with Dockerfile changes
- **Release builds**: Triggered on main branch pushes with Dockerfile changes
- Both workflows build multi-platform images (linux/amd64, linux/arm64)
- **Build timeouts in CI**: 60-240 minutes depending on image complexity

### End-to-End Validation Scenarios
**ALWAYS** run these scenarios after making any changes to validate your work:

#### Scenario 1: Base Ubuntu Image Changes
1. Build Ubuntu image: `docker buildx build --no-cache -t "armck/ubuntu:24.04-test" -f "containers/ubuntu/24.04/Dockerfile.dev" .`
2. Test basic functionality: `docker run --rm armck/ubuntu:24.04-test bash -c "echo 'Ubuntu test passed'"`
3. Verify tools: `docker run --rm armck/ubuntu:24.04-test which curl git apt`
4. Test derived images still build (Python, .NET, Terraform)

#### Scenario 2: Python Image Changes  
1. Build Python image: `docker buildx build --no-cache -t "armck/python:3.12.3-test" -f "containers/python/3.12.3/Dockerfile.dev" .`
2. Test Python functionality: `docker run --rm armck/python:3.12.3-test python3 --version`
3. Test package management: `docker run --rm armck/python:3.12.3-test pipx --version`
4. Test Pyspark dependency builds correctly

#### Scenario 3: Build Script Validation
1. Test corrected build command: `docker buildx build --no-cache -t "armck/dotnet:8.0-test" -f "containers/dotnet/8.0/Dockerfile.dev" .`
2. Verify functionality: `docker run --rm armck/dotnet:8.0-test dotnet --version`
3. Confirm multi-platform capability (if supported): `docker buildx build --platform linux/amd64,linux/arm64 --no-cache -t "test-multi" -f "containers/ubuntu/24.04/Dockerfile.dev" .`

### Known Issues and Workarounds
- **Network dependencies**: Python builds download from python.org and may fail in restricted networks
  - Error: `curl: (6) Could not resolve host: www.python.org`
  - Workaround: Use pre-built Python images or ensure network access to python.org
- **Build script path**: Must use current directory (`.`) instead of hardcoded `/workspaces/containers`
  - Error: `path "/workspaces/containers" not found`
  - Fix: Use corrected Docker commands shown in this document
- **No traditional tests**: Validation is through successful Docker builds and basic functionality tests
- **Multi-platform builds**: May require buildx setup and additional build time for ARM64 support

## Repository Navigation

### Directory Structure
```
/
├── .devcontainer/          # VS Code dev container configuration
├── .github/workflows/      # CI/CD workflows for automated builds
├── containers/            # All container definitions
│   ├── ubuntu/           # Ubuntu base images (20.04, 22.04, 24.04)
│   ├── python/           # Python images (3.9.5, 3.12.3)
│   ├── terraform/        # Terraform toolchain images
│   ├── terraform-azure/  # Terraform + Azure CLI images
│   ├── dotnet/          # .NET SDK images
│   ├── java/            # Java runtime images
│   └── pyspark/         # Python + Java + Pyspark images
├── scripts/              # Build automation scripts
│   └── build-image.sh   # Main build script (requires path fix)
├── docker-compose.yaml   # Development environment setup
└── README.md            # Repository documentation
```

### Container Organization
- Each container type has version subdirectories (e.g., `containers/ubuntu/24.04/`)
- Each version has two Dockerfiles:
  - `Dockerfile` - Production release version
  - `Dockerfile.dev` - Development version (typically identical)

## Common Tasks

### Adding New Images
1. Create directory structure: `containers/<image>/<version>/`
2. Add both `Dockerfile` and `Dockerfile.dev`
3. Update GitHub workflows to include new image in build matrix
4. Add documentation entry in `containers/README.md`
5. Test build locally before committing

### Modifying Existing Images
1. **ALWAYS** build and test the image locally first
2. Understand dependency chain - changes to base images affect dependent images
3. Test functionality with real scenarios, not just build success
4. Update version numbers if making significant changes

### Build Script Usage
```bash
# Original script (requires path fix):
scripts/build-image.sh -i ubuntu -t 24.04 -s dev

# Corrected direct docker command:
docker buildx build --no-cache -t "armck/ubuntu:24.04-dev" -f "containers/ubuntu/24.04/Dockerfile.dev" .

# Multi-platform build:
docker buildx build --platform linux/amd64,linux/arm64 --no-cache -t "armck/ubuntu:24.04-dev" -f "containers/ubuntu/24.04/Dockerfile.dev" .
```

### Development Environment
- Use VS Code with Docker extension for best experience
- Dev container configured in `.devcontainer/` for consistent environment
- Docker-in-Docker support for building images from within dev container

## Critical Reminders

- **NEVER CANCEL long-running builds** - Builds can take 5-30 minutes or more
- **ALWAYS validate functionality** after building, not just build success
- **Build in dependency order** when working with multiple images
- **Network constraints** may cause builds to fail - document failures when they occur
- **Path corrections** required for build script usage
- **Multi-platform considerations** for production releases (linux/amd64, linux/arm64)

## Timing Reference (Actual Measured Times)
- Ubuntu 24.04 dev build: 19.7 seconds (add 50% buffer = 30 second timeout minimum)
- .NET 8.0 dev build: 16.7 seconds (add 50% buffer = 25 second timeout minimum)
- Python builds: May fail due to network constraints downloading source from python.org
- Complex builds with compilation: Allow 10-30 minutes minimum
- **CRITICAL**: Always set Docker build timeouts to 60+ minutes for safety