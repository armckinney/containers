#!/bin/bash
set -e

source dev-container-features-test-lib

mkdir -p docs/agents/rules docs/agents/skills/example-skill
echo "# Claude Code instructions" > docs/agents/CLAUDE.md
echo "# Example rule" > docs/agents/rules/example.md
cat > docs/agents/skills/example-skill/SKILL.md <<'EOF'
---
name: example-skill
description: Test skill for Claude Code feature symlink setup.
---

# Example Skill
EOF

/usr/local/share/claude-code/setup-symlinks.sh

check "Workspace CLAUDE.md symlink exists when configured" [ -L "CLAUDE.md" ]
check "Workspace CLAUDE.md content is accessible" [ "$(cat CLAUDE.md)" = "# Claude Code instructions" ]
check "Workspace CLAUDE.md link points to source file" [ "$(readlink CLAUDE.md)" = "docs/agents/CLAUDE.md" ]
check "Claude Code rules directory symlink exists when configured" [ -L ".claude/rules" ]
check "Claude Code rule is accessible through symlink" [ -f ".claude/rules/example.md" ]
check "Claude Code rules link points to source directory" [ "$(readlink .claude/rules)" = "../docs/agents/rules" ]
check "Claude Code skills directory symlink exists when configured" [ -L ".claude/skills" ]
check "Claude Code skill is accessible through symlink" [ -f ".claude/skills/example-skill/SKILL.md" ]
check "Claude Code skills link points to source directory" [ "$(readlink .claude/skills)" = "../docs/agents/skills" ]

reportResults
