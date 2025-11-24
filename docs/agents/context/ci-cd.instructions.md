---
applyTo: ".github/workflows/**"
---

# CI/CD and Workflows Instructions

## CI/CD Validation

- **Dev builds**: Triggered on pull requests with Dockerfile changes
- **Release builds**: Triggered on main branch pushes with Dockerfile changes
- Both workflows build multi-platform images (linux/amd64, linux/arm64)
- **Build timeouts in CI**: 60-240 minutes depending on image complexity

## Development Environment

- Use VS Code with Docker extension for best experience
- Dev container configured in `.devcontainer/` for consistent environment
- Docker-in-Docker support for building images from within dev container
