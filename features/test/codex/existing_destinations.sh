#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Create configured sources and pre-existing destinations. One target is a
# regular file; the other is a dangling symlink (which -e alone misses).
mkdir -p docs/agents/rules docs/agents/skills .agents .codex
echo "# Central Agent Configuration" > docs/agents/AGENTS.md
mkdir -p docs/agents/skills/example-skill
echo "# Existing workspace instructions" > AGENTS.md
ln -s "keep-this-target" .agents/skills
ln -s "keep-this-target" .codex/rules

# Existing destinations must be preserved when the setup hook runs.
/usr/local/share/codex/setup-symlinks.sh

check "Existing AGENTS.md remains a regular file" [ -f "AGENTS.md" ]
check "Existing AGENTS.md remains a regular file, not a symlink" [ ! -L "AGENTS.md" ]
check "Existing AGENTS.md content is preserved" [ "$(cat AGENTS.md)" = "# Existing workspace instructions" ]
check "Dangling skills symlink is preserved" [ -L ".agents/skills" ]
check "Dangling skills symlink target is preserved" [ "$(readlink .agents/skills)" = "keep-this-target" ]
check "Dangling Codex rules symlink is preserved" [ -L ".codex/rules" ]
check "Dangling Codex rules symlink target is preserved" [ "$(readlink .codex/rules)" = "keep-this-target" ]

# Report results
reportResults
