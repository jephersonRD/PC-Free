#!/usr/bin/env bash
# Simple helper to enforce following the upstream repo.
# Behavior:
# - If SKIP_CHECK is set to 1, the script exits 0 (allows CI/local runs)
# - Otherwise prints instructions and exits 1 so the user must manually follow

set -eu

if [ "${SKIP_CHECK:-0}" = "1" ]; then
  echo "SKIP_CHECK=1 detected — skipping follow check."
  exit 0
fi

echo "This project requires you to follow https://github.com/jephersonRD before starting."
echo "Please open the repo in your browser and click 'Follow'."
echo "When done, re-run this script or set SKIP_CHECK=1 to bypass (not recommended)."
exit 1
