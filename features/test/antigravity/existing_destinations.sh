#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Create configured sources and pre-existing destinations. One target is a
# regular file; the other is a dangling symlink (which -e alone misses).
mkdir -p docs/agents/rules docs/agents/skills .agents
echo "# Central Agent Configuration" > docs/agents/AGENTS.md
mkdir -p docs/agents/skills/example-skill
echo "# Existing workspace instructions" > .agents/AGENTS.md
ln -s "keep-this-target" .agents/skills
echo "# Existing rule" > .agents/rules

# Existing destinations must be preserved when the setup hook runs.
/usr/local/share/antigravity/setup-symlinks.sh

check "Existing Antigravity AGENTS.md remains a regular file" [ -f ".agents/AGENTS.md" ]
check "Existing Antigravity AGENTS.md remains a regular file, not a symlink" [ ! -L ".agents/AGENTS.md" ]
check "Existing Antigravity AGENTS.md content is preserved" [ "$(cat .agents/AGENTS.md)" = "# Existing workspace instructions" ]
check "Dangling Antigravity skills symlink is preserved" [ -L ".agents/skills" ]
check "Dangling Antigravity skills symlink target is preserved" [ "$(readlink .agents/skills)" = "keep-this-target" ]
check "Existing Antigravity rules file is preserved" [ -f ".agents/rules" ]
check "Existing Antigravity rules file is not replaced by a symlink" [ ! -L ".agents/rules" ]

# Report results
reportResults
