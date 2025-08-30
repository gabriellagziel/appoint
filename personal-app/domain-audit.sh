#!/bin/bash

# === App-Oint Full Domain & Deployment Audit ===
# Goal: Understand exactly what's live, which Vercel project owns which domain,
# where the conflicts are, and why personal.app-oint.com shows wrong content.
# ⚠️ READ-ONLY — No changes made.

set -euo pipefail

OUT="/tmp/app-oint-audit"
mkdir -p "$OUT"

DOMAIN="app-oint.com"
SUBS=("personal" "business" "enterprise" "admin")

echo "=== 1) ACTIVE DEPLOYMENTS ===" | tee "$OUT/deployments.txt"
npx vercel ls | tee -a "$OUT/deployments.txt"

echo; echo "=== 2) DOMAIN ATTACHMENTS (Global) ===" | tee "$OUT/domains.txt"
npx vercel domains ls | tee -a "$OUT/domains.txt"

echo; echo "=== 3) INSPECT CUSTOM DOMAIN (personal.app-oint.com) ===" | tee "$OUT/personal-inspect.txt"
npx vercel domains inspect personal.app-oint.com | tee -a "$OUT/personal-inspect.txt"

echo; echo "=== 4) DNS STATUS (Public) ===" | tee "$OUT/dns.txt"
dig +short CNAME personal.app-oint.com | tee -a "$OUT/dns.txt"
dig +short A personal.app-oint.com | tee -a "$OUT/dns.txt"

echo; echo "=== 5) LIVE HTTP HEADERS ===" | tee "$OUT/headers.txt"
curl -sI https://personal.app-oint.com | tee -a "$OUT/headers.txt"

echo; echo "=== 6) ROUTES TEST (Personal) ===" | tee "$OUT/routes.txt"
ROUTES=("/" "/en" "/en/meetings" "/en/reminders" "/en/groups" "/en/family" "/en/playtime")
for r in "${ROUTES[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://personal.app-oint.com$r" || echo 000)
  printf "%-20s → %s\n" "$r" "$code"
done | tee -a "$OUT/routes.txt"

echo; echo "=== 7) STAGING DEPLOYMENTS ===" | tee "$OUT/staging.txt"
npx vercel ls --confirm | grep personal | tee -a "$OUT/staging.txt"

echo
echo "✅ AUDIT COMPLETE — RESULTS SAVED:"
echo "  Deployments:   $OUT/deployments.txt"
echo "  Domains list:  $OUT/domains.txt"
echo "  Domain inspect: $OUT/personal-inspect.txt"
echo "  DNS snapshot:  $OUT/dns.txt"
echo "  Headers:       $OUT/headers.txt"
echo "  Routes check:  $OUT/routes.txt"
echo "  Staging refs:  $OUT/staging.txt"

echo; echo "📌 NEXT STEP:"
echo "We'll read the results to see:"
echo "  - Which project owns personal.app-oint.com"
echo "  - Where it's attached or conflicting"
echo "  - Which deployment is actually live"
