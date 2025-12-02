#!/usr/bin/env bash
# Usage: ./git_push.sh GITHUB_REPO_NAME (e.g. youruser/cloudzenia-submission)
set -euo pipefail
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 GITHUB_REPO_NAME"
  exit 1
fi
REPO=$1
BRANCH=${2:-main}

echo "Initializing git repository (if not already)"
if [ ! -d .git ]; then
  git init
  git checkout -b ${BRANCH}
fi

git add .
git commit -m "Initial commit: CloudZenia submission files" || true

# Try to create repo using gh if available
if command -v gh >/dev/null 2>&1; then
  echo "Creating repo via gh: $REPO"
  gh repo create $REPO --public --source=. --remote=origin --push || true
else
  echo "gh CLI not found. Please create repository '$REPO' manually on GitHub and then run:"
  echo "  git remote add origin https://github.com/${REPO}.git"
  echo "  git branch -M ${BRANCH}"
  echo "  git push -u origin ${BRANCH}"
fi
