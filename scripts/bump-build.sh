#!/usr/bin/env bash
# Increment CFBundleVersion in project.yml and regenerate the Xcode project.
# Run this before each TestFlight upload — TF rejects builds with a build
# number ≤ any previously uploaded build for the same version.
#
# Usage:
#   ./scripts/bump-build.sh

set -euo pipefail

PROJECT_YML="$(dirname "$0")/../project.yml"

# Read current build number.
current=$(grep -E '^\s*CFBundleVersion:' "$PROJECT_YML" | grep -oE '"[0-9]+"' | tr -d '"')
if [ -z "$current" ]; then
  echo "Could not find CFBundleVersion in project.yml" >&2
  exit 1
fi

next=$((current + 1))

# In-place rewrite. macOS sed needs '' after -i.
if [[ "$(uname)" == "Darwin" ]]; then
  sed -i '' -E "s/(CFBundleVersion: )\"[0-9]+\"/\1\"${next}\"/" "$PROJECT_YML"
else
  sed -i -E "s/(CFBundleVersion: )\"[0-9]+\"/\1\"${next}\"/" "$PROJECT_YML"
fi

echo "→ CFBundleVersion: ${current} → ${next}"

# Regenerate Xcode project so the change takes effect.
if command -v xcodegen >/dev/null 2>&1; then
  xcodegen generate
  echo "→ regenerated Mycelia.xcodeproj"
else
  echo "(xcodegen not found on PATH; run 'xcodegen generate' yourself)"
fi
