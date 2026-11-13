#!/usr/bin/env bash
# scripts/reset_windows.sh
# Usage:
#   - To do a safe recreate (preserve volumes): ./scripts/reset_windows.sh recreate
#   - To reset completely (remove volumes) and recreate: FORCE=1 ./scripts/reset_windows.sh reset
# This script is committed to the repo for convenience. Run it from the repository root in your Codespace/local shell.

set -euo pipefail

COMPOSE_FILE="windows10.yml"

function usage() {
  cat <<EOF
Usage:
  ./scripts/reset_windows.sh recreate       # recreate container (force-recreate) preserving volumes
  FORCE=1 ./scripts/reset_windows.sh reset  # remove volumes (data loss) and recreate container

Notes:
  - If you want the .env file applied, ensure .env exists in repo root before running.
  - reset (with FORCE=1) WILL DELETE the Docker volumes (windows-data) and any saved Windows data.
EOF
}

if [[ ${1-} == "" ]]; then
  usage
  exit 1
fi

cmd="$1"

if [[ "$cmd" == "recreate" ]]; then
  echo "Performing safe recreate (preserving volumes)..."
  docker-compose -f "$COMPOSE_FILE" down || true
  docker-compose -f "$COMPOSE_FILE" up -d --force-recreate
  echo "Done. Use: docker logs -f windows"
  exit 0
fi

if [[ "$cmd" == "reset" ]]; then
  if [[ "${FORCE-}" != "1" ]]; then
    echo "To perform a destructive reset (delete volumes) set FORCE=1 and re-run. Aborting."
    exit 2
  fi
  echo "Performing destructive reset: DOWN -v (will delete volumes)"
  docker-compose -f "$COMPOSE_FILE" down -v || true
  echo "Starting container fresh..."
  docker-compose -f "$COMPOSE_FILE" up -d
  echo "Done. Use: docker logs -f windows"
  exit 0
fi

usage
exit 1
