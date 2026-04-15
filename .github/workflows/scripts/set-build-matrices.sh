#!/usr/bin/env bash
set -euo pipefail

changed_files_input="${CHANGED_FILES:-}"
dockerfile_regex="${DOCKERFILE_REGEX:-/Dockerfile$}"

images=(
  "ubuntu"
  "go"
  "python"
  "terraform"
  "java"
  "dotnet"
  "terraform-azure"
  "pyspark"
)

declare -A build_matrices

for image in "${images[@]}"; do
  build_matrices[$image]=''
done

if [[ -n "$changed_files_input" ]]; then
  read -r -a changed_files <<< "$changed_files_input"

  for file in "${changed_files[@]}"; do
    if [[ "$file" =~ $dockerfile_regex ]]; then
      image_tag="$(basename "$(dirname "$file")")"
      image_name="$(basename "$(dirname "$(dirname "$file")")")"
      entry="{\"dockerfile\":\"$file\",\"image_name\":\"$image_name\",\"image_tag\":\"$image_tag\"}"

      if [[ -v build_matrices[$image_name] ]]; then
        if [[ -n "${build_matrices[$image_name]}" ]]; then
          build_matrices[$image_name]+=",$entry"
        else
          build_matrices[$image_name]="$entry"
        fi
      fi
    fi
  done
fi

for image in "${images[@]}"; do
  matrix_value="${build_matrices[$image]}"
  output_name="build_matrix_${image//-/_}"

  if [[ -n "$matrix_value" ]]; then
    echo "$output_name={\"include\":[${matrix_value}]}" >> "$GITHUB_OUTPUT"
  else
    echo "$output_name={\"include\":[]}" >> "$GITHUB_OUTPUT"
  fi
done