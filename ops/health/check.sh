#!/usr/bin/env bash
set -euo pipefail

# Daily health check script - run via cron for monitoring
# Usage: ./ops/health/check.sh

ts="$(date +%F_%H%M%S)"
out="ops/health/$ts"
mkdir -p "$out"

health="$out/daily_health.txt"
echo "=== DAILY HEALTH CHECK $(date -Iseconds) ===" | tee "$health"

check_domain() {
  local domain="$1"
  local code=$(curl -s -o /dev/null -w "%{http_code}" "https://$domain/")
  local hdr=$(curl -sI "https://$domain/")
  
  local hsts=$([[ "$hdr" =~ [Ss]trict-Transport-Security ]] && echo OK || echo MISSING)
  local xfo=$([[ "$hdr" =~ [Xx]-[Ff]rame-[Oo]ptions ]] && echo OK || echo MISSING)
  local csp=$([[ "$hdr" =~ [Cc]ontent-[Ss]ecurity-[Pp]olicy ]] && echo OK || echo MISSING)
  
  echo "$domain  HTTP:$code  HSTS:$hsts  XFO:$xfo  CSP:$csp" | tee -a "$health"
  
  # Alert if not 200/308
  if [[ "$code" != "200" && "$code" != "308" ]]; then
    echo "⚠️  ALERT: $domain returned HTTP $code" | tee -a "$health"
  fi
}

check_domain "app-oint.com"
check_domain "www.app-oint.com"
check_domain "business.app-oint.com"
check_domain "enterprise.app-oint.com"

echo "" | tee -a "$health"
echo "Health check completed at $(date)" | tee -a "$health"
echo "Results written to: $health"

# Exit with error if any domain is down
if grep -q "⚠️  ALERT" "$health"; then
  exit 1
fi
