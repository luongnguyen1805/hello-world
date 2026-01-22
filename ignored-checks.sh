#!/usr/bin/env bash
set -euo pipefail

# Ensure we are inside a Git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not inside a Git repository" >&2
  exit 1
fi

# Resolve git root
GIT_ROOT="$(git rev-parse --show-toplevel)"

cd "$GIT_ROOT"

# List all ignored files and directories, relative to git root
git ls-files \
  --others \
  --ignored \
  --exclude-standard
