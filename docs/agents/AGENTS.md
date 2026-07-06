# Agent Configuration

This document serves as the configuration guide for AI agents working with this containerized development environment repository.

## Instructions Source

**All agents should reference the instruction files in `docs/agents/context/` as the single source of truth before making any changes.**

The following instruction files are available:

- **[Repository Overview](context/repository-overview.instructions.md)** - Complete repository structure and container organization
- **[Docker Build](context/docker-build.instructions.md)** - Docker build processes and image management
- **[CI/CD](context/ci-cd.instructions.md)** - Continuous integration and deployment workflows
- **[Development Tasks](context/development-tasks.instructions.md)** - Common development workflows and tasks
- **[Scripts](context/scripts.instructions.md)** - Build automation and utility scripts
- **[Testing & Validation](context/testing-validation.instructions.md)** - Testing procedures and validation steps

## System Message

You are working with a containerized development environment repository. Always reference the instruction files in `docs/agents/context/` before making changes. Follow the established patterns for Dockerfiles, build scripts, and CI/CD workflows.

## Key Principles

1. **Instructions First**: Always consult the relevant instruction files before making changes
2. **Pattern Consistency**: Follow established patterns for Dockerfiles, build scripts, and workflows
3. **Single Source of Truth**: The `docs/agents/context/` directory contains the authoritative information
4. **Fallback Strategy**: Only use search or bash commands when encountering unexpected information that doesn't match the instructions
