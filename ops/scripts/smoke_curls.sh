#!/usr/bin/env bash
set -euo pipefail
API_HEALTH="${API_HEALTH:-https://your-api.example.com/api/status}"
URLS=(
  "${MARKETING_URL:-https://marketing.example.com}"
  "${BUSINESS_URL:-https://business.example.com}"
  "${ENTERPRISE_URL:-https://enterprise.example.com}"
  "${DASHBOARD_URL:-https://dashboard.example.com}"
)
echo "API: $API_HEALTH"
curl -s -o /dev/null -w "%{http_code}  ${API_HEALTH}\n" "$API_HEALTH"
for U in "${URLS[@]}"; do
  [ -z "$U" ] && continue
  curl -s -o /dev/null -w "%{http_code}  ${U}\n" "$U"
done
