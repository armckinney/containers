# Agent Configuration

This document serves as the configuration guide for AI agents working with this containerized development environment repository.

## Instructions Source

**All agents should reference the instruction files in `.github/instructions/` as the single source of truth before making any changes.**

The following instruction files are available:

- **[Repository Overview](.github/instructions/repository-overview.instructions.md)** - Complete repository structure and container organization
- **[Docker Build](.github/instructions/docker-build.instructions.md)** - Docker build processes and image management
- **[CI/CD](.github/instructions/ci-cd.instructions.md)** - Continuous integration and deployment workflows
- **[Development Tasks](.github/instructions/development-tasks.instructions.md)** - Common development workflows and tasks
- **[Scripts](.github/instructions/scripts.instructions.md)** - Build automation and utility scripts
- **[Testing & Validation](.github/instructions/testing-validation.instructions.md)** - Testing procedures and validation steps

## System Message

You are working with a containerized development environment repository. Always reference the instruction files in `.github/instructions/` before making changes. Follow the established patterns for Dockerfiles, build scripts, and CI/CD workflows.

## Key Principles

1. **Instructions First**: Always consult the relevant instruction files before making changes
2. **Pattern Consistency**: Follow established patterns for Dockerfiles, build scripts, and workflows
3. **Single Source of Truth**: The `.github/instructions/` directory contains the authoritative information
4. **Fallback Strategy**: Only use search or bash commands when encountering unexpected information that doesn't match the instructions

## Usage for Different AI Agents

### Cursor IDE
- Configuration: `.cursor/config.json` 
- Includes: `.github/instructions/*.md`

### Windsurf IDE  
- Configuration: `.windsurf/rules.json`
- Includes: `.github/instructions/*.md`

### Other Agents
- Reference this AGENTS.md file
- Include all instruction files from `.github/instructions/`
- Use the system message above as context

## Quick Reference

- **Repository Structure**: See [repository-overview.instructions.md](.github/instructions/repository-overview.instructions.md)
- **Build Images**: See [docker-build.instructions.md](.github/instructions/docker-build.instructions.md)
- **Run Scripts**: See [scripts.instructions.md](.github/instructions/scripts.instructions.md)
- **CI/CD Workflows**: See [ci-cd.instructions.md](.github/instructions/ci-cd.instructions.md)
- **Development**: See [development-tasks.instructions.md](.github/instructions/development-tasks.instructions.md)
- **Testing**: See [testing-validation.instructions.md](.github/instructions/testing-validation.instructions.md)
