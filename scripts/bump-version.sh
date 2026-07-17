#!/usr/bin/env bash
# Bump the app version (semver) in sw.js and the index.html footer, and
# refresh the footer build date. Usage: scripts/bump-version.sh [major|minor|patch]
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

kind="${1:-patch}"
cur=$(grep -oP 'grok-v\K[0-9]+\.[0-9]+\.[0-9]+' sw.js)
IFS=. read -r major minor patch <<<"$cur"

case "$kind" in
  major) major=$((major + 1)); minor=0; patch=0 ;;
  minor) minor=$((minor + 1)); patch=0 ;;
  patch) patch=$((patch + 1)) ;;
  *) echo "usage: $0 [major|minor|patch]" >&2; exit 1 ;;
esac

new="$major.$minor.$patch"
today=$(date +%F)

sed -i "s/grok-v$cur/grok-v$new/" sw.js
sed -i "s/v$cur · built [0-9-]\+/v$new · built $today/" index.html

echo "v$cur -> v$new (built $today)"
