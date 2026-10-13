#!/usr/bin/env bash
set -euo pipefail

# Source the configuration generated during installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/config.env" ]]; then
  # shellcheck disable=SC1091
  source "${SCRIPT_DIR}/config.env"
fi

WORKSPACE_ROOT="$(pwd -P)"
RULEFILE_PATH="${RULEFILE_PATH:-}"
SKILLS_PATH="${SKILLS_PATH:-}"
TARGET_SUBDIR="${TARGET_SUBDIR:-.github}"
TARGET_FILENAME="${TARGET_FILENAME:-copilot-instructions.md}"

link_if_missing() {
  local source="$1"
  local destination="$2"

  # Preserve files, directories, and symlinks already present in the workspace.
  if [[ ! -e "${destination}" && ! -L "${destination}" ]]; then
    mkdir -p "$(dirname "${destination}")"
    ln -s "${source}" "${destination}"
  fi
}

# 1. Setup Copilot central instructions (rules) if configured
if [[ -n "${RULEFILE_PATH}" && -f "${WORKSPACE_ROOT}/${RULEFILE_PATH}" ]]; then
  link_if_missing "../${RULEFILE_PATH}" \
    "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/${TARGET_FILENAME}"
elif [[ -n "${RULEFILE_PATH}" ]]; then
  echo "Rule file ${RULEFILE_PATH} not found. Skipping Copilot central instructions."
fi

# 2. Map each skill's SKILL.md to a Copilot prompt if configured
if [[ -n "${SKILLS_PATH}" && -d "${WORKSPACE_ROOT}/${SKILLS_PATH}" ]]; then
  for skill_dir in "${WORKSPACE_ROOT}/${SKILLS_PATH}"/*; do
    [[ -d "${skill_dir}" && -f "${skill_dir}/SKILL.md" ]] || continue

    skill_name="$(basename "${skill_dir}")"
    link_if_missing "../../${SKILLS_PATH}/${skill_name}/SKILL.md" \
      "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/prompts/${skill_name}.prompt.md"
  done
fi

echo "AI agent symlinks initialized successfully!"
