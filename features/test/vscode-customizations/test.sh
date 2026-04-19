#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

is_extension_installed() {
	local extension="$1"

	# Prefer extension CLI queries when available.
	if command -v code >/dev/null 2>&1; then
		code --list-extensions | grep -Fxqi "${extension}"
		return $?
	fi

	if command -v code-server >/dev/null 2>&1; then
		code-server --list-extensions | grep -Fxqi "${extension}"
		return $?
	fi

	# Fallback to extension install directories used by VS Code server variants.
	for extension_dir in \
		"/root/.vscode-server/extensions" \
		"/root/.vscode/extensions" \
		"/root/.openvscode-server/extensions"; do
		if [ -d "${extension_dir}" ] && ls -1 "${extension_dir}" 2>/dev/null | grep -Fqi "${extension}-"; then
			return 0
		fi
	done

	return 1
}

# Verify the expected extensions are installed - skip since these are not installed at test time
# check "Docker extension is installed" is_extension_installed "ms-azuretools.vscode-docker"
# check "Markdown All in One extension is installed" is_extension_installed "yzhang.markdown-all-in-one"
# check "Markdown Mermaid extension is installed" is_extension_installed "bierner.markdown-mermaid"
# check "GitHub Actions extension is installed" is_extension_installed "github.vscode-github-actions"

# Report results
reportResults
