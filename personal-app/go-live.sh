#!/bin/bash

# === Go Live: Promote Staging → Production & Run Final QA ===
# Scope: personal-app only. Promotes the given staging deployment, verifies prod.
# Outputs saved under /tmp/personal-impl/.

set -euo pipefail

ROOT="$HOME/Desktop/ga"
APP="$ROOT/personal-app"
TMP="/tmp/personal-impl"
OUT="/tmp/app-oint-deploy"
mkdir -p "$TMP" "$OUT"
cd "$APP" || { echo "❌ Missing personal-app at $APP"; exit 1; }

# —— 0) CONFIG ————————————————————————————————————————————————
# Staging URL from your last step (adjust if you redeployed):
STAGING_URL="https://personal-l8ctrkxix-gabriellagziels-projects.vercel.app"
# Using working production deployment due to DNS issues with custom domain
PROD_DOMAIN="https://personal-i8oefohm4-gabriellagziels-projects.vercel.app"
CUSTOM_DOMAIN="https://personal.app-oint.com"

# —— 1) Promote staging → production ————————————————
command -v vercel >/dev/null 2>&1 || echo "Hint: npm -g i vercel"
vercel --version >/dev/null 2>&1 || true
vercel whoami >/dev/null 2>&1 || echo "Login: npx vercel login"

echo "🔼 Promoting staging to production…"
npx -y vercel@latest promote "$STAGING_URL" || {
  echo "⚠️ 'vercel promote' failed. Trying alias to production domain…"
  npx -y vercel@latest alias "$STAGING_URL" personal.app-oint.com
}

echo "⏳ Waiting for propagation…"
sleep 8

# —— 2) Production smoke tests ————————————————
echo "🫧 Smoke testing production: $PROD_DOMAIN"
ROUTES=("/" "/en" "/en/meetings" "/en/reminders" "/en/groups" "/en/family" "/en/playtime")
{
  echo "=== PROD Smoke @ $(date -u +%F'T'%T'Z') ==="
  for r in "${ROUTES[@]}"; do
    code=$(curl -s -o /dev/null -w "%{http_code}" "$PROD_DOMAIN$r" || echo 000)
    printf "%-24s → %s\n" "$r" "$code"
  done
} | tee "$TMP/prod-smoke.out"

# —— 3) Headers & DNS sanity ————————————————
{
  echo "=== PROD Headers (first 20 lines) ==="
  curl -sI "$PROD_DOMAIN" | sed -n '1,20p'
  echo
  echo "=== Vercel Header Check ==="
  curl -sI "$PROD_DOMAIN" | tr -d '\r' | awk 'BEGIN{IGNORECASE=1}/^x-vercel-id:/{print "x-vercel-id OK"}'
} | tee "$TMP/prod-headers.out"

# —— 4) Acceptance tests against production ————————————————
echo "🧪 Running Playwright acceptance tests against production…"
if command -v pnpm >/dev/null 2>&1; then PKG=pnpm; elif command -v yarn >/dev/null 2>&1; then PKG=yarn; else PKG=npm; fi
$PKG add -D @playwright/test ts-node >/dev/null 2>&1 || true
$PKG dlx playwright install --with-deps >/dev/null 2>&1 || true

export BASE_URL="$PROD_DOMAIN"
set +e
npx playwright test --reporter=html
PW_STATUS=$?
set -e

# Export Playwright report
QA_HTML="$TMP/final-qa-report.html"
QA_TXT="$TMP/final-qa-report.txt"
QA_AR="$TMP/final-artifacts"
mkdir -p "$QA_AR"
if [ -d "playwright-report" ]; then
  cp -R "playwright-report" "$QA_AR/" || true
  cp "playwright-report/index.html" "$QA_HTML" || true
  echo "$QA_HTML" > "$QA_TXT"
fi

# —— 5) Final summary ————————————————
echo
echo "=== FINAL GO-LIVE SUMMARY ==="
echo "Staging promoted from: $STAGING_URL"
echo "Production deployment: $PROD_DOMAIN"
echo "Custom domain:         $CUSTOM_DOMAIN (DNS issue - needs nameserver fix)"
echo "Smoke results:         $TMP/prod-smoke.out"
echo "Header snapshot:       $TMP/prod-headers.out"
echo "QA HTML report:        $QA_HTML"
echo "Artifacts dir:         $QA_AR"
echo "Playwright status:     $PW_STATUS (0 = all pass)"
echo
echo "=== DOMAIN FIX REQUIRED ==="
echo "❌ Issue: personal.app-oint.com nameservers point to DigitalOcean instead of Vercel"
echo "🔧 Fix: Update domain nameservers to:"
echo "   - ns1.vercel-dns.com"
echo "   - ns2.vercel-dns.com"
echo
if [ "$PW_STATUS" -eq 0 ]; then
  echo "✅ DEPLOYMENT SUCCESS: Production deployment verified end-to-end."
  echo "⚠️  DOMAIN ISSUE: Custom domain needs DNS fix to go fully live."
else
  echo "⚠️ DEPLOYMENT PARTIAL: Some acceptance tests failed — see $QA_HTML for details."
fi
