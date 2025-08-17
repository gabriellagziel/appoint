#!/usr/bin/env bash
set -uo pipefail

DOMAINS=(
  "https://www.app-oint.com"
  "https://app.app-oint.com"
  "https://business.app-oint.com"
  "https://enterprise.app-oint.com"
  "https://api.app-oint.com"
  "https://admin.app-oint.com"
)

echo "== TLS & Availability =="
for d in "${DOMAINS[@]}"; do
  echo "-- $d --"
  (curl -sS -I "$d" | sed -n '1,10p' | tr -d '\r') || echo "ERROR: unavailable"
  echo "HSTS: $( (curl -sS -I "$d" | tr -d '\r' | grep -i 'strict-transport-security') || true)"
done

echo "== Naked redirect check =="
(curl -sS -I https://app-oint.com | tr -d '\r' | sed -n '1,10p') || echo "ERROR: naked domain unreachable"

