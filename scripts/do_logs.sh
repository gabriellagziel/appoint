#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${DO_TOKEN-}" ]]; then
  echo "❌ Please export DO_TOKEN before running."
  exit 1
fi

LOGFILE="./do_api_calls.log"
echo "=== DO API Call Log started at $(date -u +"%Y-%m-%dT%H:%M:%SZ") ===" >> "$LOGFILE"

call_endpoint() {
  local ep="$1"
  local method="${2:-GET}"
  ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo -e "\n[$ts] ➤ $method https://api.digitalocean.com$ep" | tee -a "$LOGFILE"

  echo "--- doctl output ---" | tee -a "$LOGFILE"
  DOCTL_OUTPUT=$(DOCTL_ACCESS_TOKEN="$DO_TOKEN" doctl compute droplet list --no-header --output json 2>&1)
  echo "$DOCTL_OUTPUT" | tee -a "$LOGFILE"

  echo "--- curl output ---" | tee -a "$LOGFILE"
  curl -sS -X "$method" \
    -H "Authorization: Bearer $DO_TOKEN" \
    -H "Content-Type: application/json" \
    "https://api.digitalocean.com$ep" \
    | tee -a "$LOGFILE"
}

# Example endpoints (adjust as needed):
call_endpoint "/v2/account"
call_endpoint "/v2/droplets"

echo -e "\n=== DO API Call Log ended at $(date -u +"%Y-%m-%dT%H:%M:%SZ") ===" >> "$LOGFILE"
echo "✅ Logged all calls to $LOGFILE"
