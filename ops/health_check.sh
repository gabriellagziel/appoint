#!/usr/bin/env bash
set -euo pipefail

domains=(
  "app-oint.com"
  "business.app-oint.com"
  "enterprise.app-oint.com"
)

echo "=== HEALTH CHECK $(date -Iseconds) ==="
for d in "${domains[@]}"; do
  echo "--- $d ---"
  
  # Check HTTP status
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://$d/" || echo "FAILED")
  echo "HTTP: $code"
  
  # Check headers
  hdr=$(curl -sI "https://$d/" || echo "")
  hsts=$(grep -i "strict-transport-security" <<< "$hdr" || true)
  xfo=$(grep -i "x-frame-options" <<< "$hdr" || true)
  csp=$(grep -i "content-security-policy" <<< "$hdr" || true)
  
  echo "HSTS: ${hsts:+OK}"
  echo "XFO:  ${xfo:+OK}"
  echo "CSP:  ${csp:+OK}"
  
  # Check body for hotfix signatures
  body=$(curl -sL "https://$d/" | head -c 4000 || echo "")
  bad=$(grep -Ei "splash|placeholder|hotfix" <<< "$body" || true)
  if [ -n "$bad" ]; then 
    echo "WARN: hotfix signature found"
  else
    echo "Content: OK"
  fi
  
  echo ""
done

