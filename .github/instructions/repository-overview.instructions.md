---
applyTo: "**"
---

# Repository Overview

This repository contains standardized Dockerfiles that are built into layered container images and hosted on DockerHub. Images build on top of each other (Ubuntu → Python → Pyspark).

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Repository Structure

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

## Container Organization

- Each container type has version subdirectories (e.g., `containers/ubuntu/24.04/`)
- Each version has two Dockerfiles:
  - `Dockerfile` - Production release version
  - `Dockerfile.dev` - Development version (typically identical)

## Image Structure and Dependencies

- **Base layer**: Ubuntu (20.04, 22.04, 24.04)
- **Python layer**: Built from Ubuntu, adds Python + development tools
- **Pyspark layer**: Built from Python, adds Java + Pyspark
- **Terraform layer**: Built from Ubuntu, adds Terraform toolchain
- **Terraform-Azure layer**: Built from Terraform, adds Azure CLI
- **.NET layer**: Built from Ubuntu, adds .NET SDK
- **Java layer**: Built from Ubuntu, adds Java runtime
