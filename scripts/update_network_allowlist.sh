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

DOMAINS=(
  storage.googleapis.com
  firebase-public.firebaseio.com
  metadata.google.internal
  169.254.169.254
  raw.githubusercontent.com
  pub.dev
  dart.dev
)

DOMAINS_JSON=$(printf '"%s",' "${DOMAINS[@]}" | sed 's/,$//')
BODY="{\"domains\":[${DOMAINS_JSON}]}"

curl -sSL -X PUT \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -d "$BODY" \
  "https://api.github.com/enterprises/${ENTERPRISE}/actions/allowed-domains"

echo "Updated network allowlist for ${ENTERPRISE}."
