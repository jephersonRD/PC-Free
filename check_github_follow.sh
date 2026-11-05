#!/usr/bin/env bash
set -euo pipefail

if [ -f .env ]; then
  set -a
  . ./.env
  set +a
fi

if [ -z "${GITHUB_USER:-}" ] || [ "${GITHUB_USER}" = "yourgithubusername" ]; then
  echo "GITHUB_USER is not configured. Create a .env file from .env.example and set your GitHub username."
  exit 1
fi

echo "GitHub user configured: ${GITHUB_USER}"
echo "Local setup mode enabled; skipping GitHub follow enforcement."
exit 0
