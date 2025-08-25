#!/usr/bin/env bash
set -euo pipefail

# Fast rollback script - usage: ./ops/rollback.sh [marketing_url] [business_url] [enterprise_url]
# Defaults to last known good deployments if no args provided

M="${1:-https://REDACTED_TOKEN.vercel.app}"
B="${2:-https://REDACTED_TOKEN.vercel.app}"
E="${3:-https://REDACTED_TOKEN.vercel.app}"

echo "Rolling back to known good deployments..."
echo "Marketing: $M"
echo "Business: $B"
echo "Enterprise: $E"

npx -y vercel alias set "$M" app-oint.com
npx -y vercel alias set "$M" www.app-oint.com
npx -y vercel alias set "$B" business.app-oint.com
npx -y vercel alias set "$E" enterprise.app-oint.com

echo "✅ Rollback aliases applied successfully."
echo "Verifying domains..."

for d in app-oint.com www.app-oint.com business.app-oint.com enterprise.app-oint.com; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://$d/")
  echo "$d → HTTP $code"
done
