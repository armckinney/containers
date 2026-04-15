#!/usr/bin/env bash
set -euo pipefail

features_dir="${FEATURES_DIR:-features/src}"
release_dir="${RELEASE_DIR:-feature-release}"

mkdir -p "$release_dir"

if [[ ! -d "$features_dir" ]]; then
  echo "No features directory found: $features_dir"
  exit 0
fi

shopt -s nullglob

for feature_path in "$features_dir"/*/; do
  if [[ ! -f "$feature_path/devcontainer-feature.json" ]]; then
    continue
  fi

  feature_id="$(basename "$feature_path")"

  echo "Packaging feature: $feature_id"
  tar -czf "$release_dir/devcontainer-feature-$feature_id.tgz" -C "$feature_path" .
  echo "Packaged $feature_id to $release_dir/devcontainer-feature-$feature_id.tgz"
done

echo
echo "Packaged features:"
ls -lh "$release_dir"