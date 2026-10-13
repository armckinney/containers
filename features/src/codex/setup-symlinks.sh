#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/config.env" ]]; then
  # shellcheck disable=SC1091
  source "${SCRIPT_DIR}/config.env"
fi

WORKSPACE_ROOT="$(pwd -P)"
RULEFILE_PATH="${RULEFILE_PATH:-}"
SKILLS_PATH="${SKILLS_PATH:-}"

link_if_missing() {
  local source="$1"
  local destination="$2"

  # -L also catches dangling symlinks, which -e alone does not detect.
  if [[ ! -e "${destination}" && ! -L "${destination}" ]]; then
    mkdir -p "$(dirname "${destination}")"
    ln -s "${source}" "${destination}"
  fi
}

# Only create links when the configured source exists. Existing destinations
# may have been created by the workspace or another tool, so preserve them.
if [[ -n "${RULEFILE_PATH}" && -f "${WORKSPACE_ROOT}/${RULEFILE_PATH}" \
  && "${RULEFILE_PATH}" != "AGENTS.md" ]]; then
  link_if_missing "${RULEFILE_PATH}" "${WORKSPACE_ROOT}/AGENTS.md"
fi

if [[ -n "${SKILLS_PATH}" && -d "${WORKSPACE_ROOT}/${SKILLS_PATH}" \
  && "${SKILLS_PATH}" != ".agents/skills" ]]; then
  link_if_missing "../${SKILLS_PATH}" "${WORKSPACE_ROOT}/.agents/skills"
fi
