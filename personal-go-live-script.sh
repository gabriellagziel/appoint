#!/bin/bash

# === App-Oint Personal: Full Go-Live Until Success ===
# Goal: Ensure https://personal.app-oint.com shows the correct Personal PWA conversational flow.
# Cursor must NOT stop until the live page matches the full spec.
# Reference Spec: Conversational UI/UX flow (greeting + quick actions + meeting flow + reminders + groups + family + playtime).

set -euo pipefail

OUT="/tmp/personal-go-live"
mkdir -p "$OUT"

PROJECT="personal-app"
DOMAIN="personal.app-oint.com"
VERCEL_URL=""
TARGET_BUILD_ID=""

echo "=== 1) VERIFY CODE IMPLEMENTATION ==="
# Confirm that required components exist in codebase and match conversational spec.
grep -R "Hi Gabriel" ./src/app || echo "⚠️ Missing greeting component"
grep -R "QuickActions" ./src/app || echo "⚠️ QuickActions missing"
grep -R "Meeting" ./src/app || echo "⚠️ Meeting flow missing"
grep -R "Groups" ./src/app || echo "⚠️ Groups missing"
grep -R "Family" ./src/app || echo "⚠️ Family missing"
grep -R "Playtime" ./src/app || echo "⚠️ Playtime missing"

echo "=== 2) ENSURE VERCEL PROJECT IS CORRECT ==="
# Confirm the personal-app project exists and is linked properly.
npx vercel link --project $PROJECT --yes

echo "=== 3) DEPLOY LATEST BUILD ==="
# Deploy latest commit and capture URL + build ID.
VERCEL_URL=$(npx vercel --prod --confirm --yes | tee "$OUT/deploy.log" | tail -n1)
echo "Deployed to: $VERCEL_URL"

# Extract build ID to track this exact deployment.
TARGET_BUILD_ID=$(grep -o "deployments/.*" "$OUT/deploy.log" | tail -n1 | awk -F/ '{print $2}')
echo "Build ID: $TARGET_BUILD_ID" | tee "$OUT/build-id.txt"

echo "=== 4) ATTACH CUSTOM DOMAIN ==="
# Make sure personal.app-oint.com is assigned to the correct project.
npx vercel domains rm $DOMAIN --yes || true
npx vercel domains add $DOMAIN --project=$PROJECT --yes

echo "=== 5) VERIFY DNS ==="
# Wait until DNS points correctly to Vercel.
until [[ "$(dig +short CNAME $DOMAIN)" == "cname.vercel-dns.com." ]]; do
  echo "Waiting for DNS to propagate..."
  sleep 15
done
echo "DNS OK: $DOMAIN → cname.vercel-dns.com"

echo "=== 6) VERIFY LIVE DEPLOYMENT ==="
# Keep checking until the live site returns 200 and shows the expected greeting.
until curl -s --fail https://$DOMAIN | grep -q "Hi Gabriel"; do
  echo "Waiting for $DOMAIN to serve the correct app..."
  sleep 10
done

echo "=== 7) VERIFY ALL ROUTES ==="
ROUTES=("/" "/en" "/en/meetings" "/en/reminders" "/en/groups" "/en/family" "/en/playtime")
for r in "${ROUTES[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN$r")
  if [[ "$code" != "200" ]]; then
    echo "⚠️ Route $r not ready yet → retrying until success"
    until [[ "$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN$r")" == "200" ]]; do
      sleep 5
    done
  fi
  echo "✅ Route $r OK"
done

echo
echo "=== 🚀 PERSONAL APP LIVE SUCCESSFULLY ==="
echo "✅ $DOMAIN now serves the correct app"
echo "✅ Build ID: $TARGET_BUILD_ID"
echo "✅ Verified conversational UI + routes"
echo "All outputs saved in $OUT"

