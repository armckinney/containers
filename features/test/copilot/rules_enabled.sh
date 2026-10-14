#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Setup dummy workspace files for testing
mkdir -p docs/agents
echo "# Agent Configuration" > docs/agents/AGENTS.md
mkdir -p docs/agents/skills/docker-build
mkdir -p docs/agents/rules
echo "# Build instructions" > docs/agents/rules/docker-build.md
echo -e "---\nname: Docker Build\n---\n# Docker Build\nRules..." > docs/agents/skills/docker-build/SKILL.md

# Re-execute setup-symlinks.sh to create symlinks
/usr/local/share/copilot/setup-symlinks.sh

# Verify Copilot central instructions symlink exists
check "Copilot central rules symlink exists when configured" [ -L ".github/copilot-instructions.md" ]
check "Copilot path-specific instruction file is symlinked with required suffix" [ -L ".github/instructions/docker-build.instructions.md" ]
check "Copilot path-specific instruction file is accessible" [ -f ".github/instructions/docker-build.instructions.md" ]
check "Copilot instruction link points to source Markdown file" [ "$(readlink .github/instructions/docker-build.instructions.md)" = "../../docs/agents/rules/docker-build.md" ]

# Verify project skills are exposed at Copilot's supported location
check "Copilot skills directory symlink exists when configured" [ -L ".agents/skills" ]
check "Copilot skill is accessible through the symlink" [ -f ".agents/skills/docker-build/SKILL.md" ]
check "Copilot skills link points to source directory" [ "$(readlink .agents/skills)" = "../docs/agents/skills" ]

# Report results
reportResults
