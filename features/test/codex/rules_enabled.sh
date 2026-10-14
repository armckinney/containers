#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Setup central instructions and a project skill
mkdir -p docs/agents/rules docs/agents/skills/example-skill
echo "# Agent Configuration" > docs/agents/AGENTS.md
cat > docs/agents/skills/example-skill/SKILL.md <<'EOF'
---
name: example-skill
description: Test skill for Codex feature symlink setup.
---

# Example Skill
EOF

# Re-execute setup-symlinks.sh to create links
/usr/local/share/codex/setup-symlinks.sh

check "Codex AGENTS.md symlink exists when configured" [ -L "AGENTS.md" ]
check "Codex AGENTS.md content is accessible" [ "$(cat AGENTS.md)" = "# Agent Configuration" ]
check "Codex rules directory symlink exists when configured" [ -L ".codex/rules" ]
check "Codex rules directory is accessible through symlink" [ -d ".codex/rules" ]
check "Codex skills directory symlink exists when configured" [ -L ".agents/skills" ]
check "Codex skill file is accessible through symlink" [ -f ".agents/skills/example-skill/SKILL.md" ]

# Report results
reportResults
