#!/usr/bin/env bash
# Update enterprise network allowlist for GitHub Actions
# Usage: ./scripts/update_network_allowlist.sh <enterprise> <token>
# <token> must have admin:enterprise scope.
set -euo pipefail

ENTERPRISE="${1:-}"
TOKEN="${2:-${GITHUB_TOKEN:-}}"

if [[ -z "$ENTERPRISE" || -z "$TOKEN" ]]; then
  echo "Usage: $0 <enterprise> <token>" >&2
  exit 1
fi

BODY='{"domains":["storage.googleapis.com","pub.dev"]}'

curl -sSL -X PUT \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -d "$BODY" \
  "https://api.github.com/enterprises/${ENTERPRISE}/actions/allowed-domains"

echo "Updated network allowlist for ${ENTERPRISE}."
