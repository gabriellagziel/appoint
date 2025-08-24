#!/bin/bash
set -euo pipefail

ROOT="/Users/a/Desktop/ga"
ENV_JSON_PATH="$ROOT/ops/secrets/env.prod.json"
PREFLIGHT_SCRIPT="$ROOT/ops/scripts/preflight_sanity.sh"
DEPLOY_SCRIPT="$ROOT/ops/scripts/env_audit_apply.sh"
PREFLIGHT_OUT="/tmp/app-oint-preflight.json"

cd "$ROOT"

echo "🚀 Starting Smart Preflight + APPLY one-shot"
echo "ENV_JSON_PATH=$ENV_JSON_PATH"
echo "REDACTED_TOKEN"

# Step 1 — Check if env file exists
if [[ ! -f "$ENV_JSON_PATH" ]]; then
  echo "❌ Missing env file: $ENV_JSON_PATH"
  exit 1
fi

# Step 2 — Run preflight sanity check
echo "🔍 Running preflight sanity check..."
ENV_JSON_PATH="$ENV_JSON_PATH" "$PREFLIGHT_SCRIPT" || {
  echo "❌ Preflight script failed unexpectedly"
  exit 1
}

# Step 3 — Verify preflight results
if [[ ! -f "$PREFLIGHT_OUT" ]]; then
  echo "❌ Preflight output not found: $PREFLIGHT_OUT"
  exit 1
fi

# Step 4 — Evaluate preflight JSON
STATUS=$(jq -r '
  (.vercel.token_set == "set") as $tok
  | (.vercel.scope | length > 0) as $sc
  | (.vercel.required_keys == "OK") as $req
  | if ($tok and $sc and $req) then "OK" else "FAIL" end
' "$PREFLIGHT_OUT")

if [[ "$STATUS" != "OK" ]]; then
  echo "❌ Preflight NOT OK. See details below:"
  echo "REDACTED_TOKEN"

  # Missing Vercel token?
  TOKEN=$(jq -r '.vercel.token_set' "$PREFLIGHT_OUT")
  if [[ "$TOKEN" != "set" ]]; then
    echo "⚠️  Missing Vercel token → run:"
    echo "   export VERCEL_TOKEN=\"YOUR_VERCEL_TOKEN\""
  fi

  # Missing Vercel team?
  SCOPE=$(jq -r '.vercel.scope' "$PREFLIGHT_OUT")
  if [[ -z "$SCOPE" || "$SCOPE" == "null" ]]; then
    echo "⚠️  Missing Vercel team → run:"
    echo "   export VERCEL_TEAM_SLUG=\"YOUR_TEAM_SLUG\""
  fi

  # Missing required keys?
  jq -r '
    .vercel as $v
    | ["NEXT_PUBLIC_API_BASE","API_INTERNAL_BASE","STRIPE_SECRET_KEY","NEXT_PUBLIC_SENTRY_DSN","JWT_SECRET"]
    | map(select($v[.] == null)) | if length > 0 then
        "⚠️  Missing keys: " + (join(", "))
      else "✅ All required env keys exist"
      end
  ' "$ENV_JSON_PATH"

  # Check for placeholders inside env file
  PLACEHOLDERS=$(grep -Ei 'placeholder|your-api|example\.com' "$ENV_JSON_PATH" || true)
  if [[ -n "$PLACEHOLDERS" ]]; then
    echo "⚠️  Placeholders detected in env file:"
    echo "$PLACEHOLDERS"
    echo "   → Replace these with real production values."
  fi

  echo "REDACTED_TOKEN"
  echo "❌ Fix the issues above, then re-run this script."
  exit 1
fi

echo "✅ Preflight passed! Proceeding to APPLY..."
echo "REDACTED_TOKEN"

# Step 5 — Run APPLY (full deploy + QA)
PLAN_ONLY=0 REDEPLOY_VERCEL=1 QA_TAIL=1 \
ENV_JSON_PATH="$ENV_JSON_PATH" \
/bin/bash -lc "$DEPLOY_SCRIPT"

echo "REDACTED_TOKEN"
echo "🎉 APPLY finished. Artifacts generated:"
ls -lh /tmp/app-oint-headers.txt /tmp/app-oint-smoke.txt /tmp/app-oint-final-audit.json /tmp/app-oint-post-verify.json || true

echo
echo "✅ Done. Review the artifacts above."


