#!/bin/bash
set -euo pipefail

### === CONFIG ===
ENV_JSON_PATH="/Users/a/Desktop/ga/ops/secrets/env.prod.json"
ROOT="/Users/a/Desktop/ga"
# Define a shell function for Vercel CLI to ensure availability in non-interactive shells
vz() { npx --yes vercel@latest "$@"; }
SCOPE="${VERCEL_TEAM_ID:-${VERCEL_TEAM_SLUG:-}}"
PLAN_ONLY="${PLAN_ONLY:-0}"
QA_TAIL="${QA_TAIL:-1}"

### === PREFLIGHT ===
echo "🔍 Preflight checks..."
command -v jq >/dev/null || { echo "❌ jq missing"; exit 1; }
command -v firebase >/dev/null || { echo "❌ Firebase CLI missing"; exit 1; }
if [ "${PLAN_ONLY}" -eq 0 ]; then
  [ -n "${VERCEL_TOKEN:-}" ] || { echo "❌ Missing VERCEL_TOKEN"; exit 1; }
  [ -n "$SCOPE" ] || { echo "❌ Missing Vercel team ID/slug"; exit 1; }
  command -v doctl >/dev/null || { echo "❌ DigitalOcean CLI missing"; exit 1; }
  echo "🔎 Running preflight sanity before APPLY..."
  ENV_JSON_PATH="$ENV_JSON_PATH" "$ROOT/ops/scripts/preflight_sanity.sh" || { echo "❌ Preflight failed. Fix issues and retry."; exit 1; }
else
  [ -n "${VERCEL_TOKEN:-}" ] || echo "ℹ️  PLAN mode: Vercel token not set; Vercel audits may be limited."
  [ -n "$SCOPE" ] || echo "ℹ️  PLAN mode: Vercel team not set; Vercel audits may be limited."
fi

### === 1. PLAN/APPLY: ENV VARS TO VERCEL + FIREBASE ===
ENV_JSON="$(cat "$ENV_JSON_PATH")"

if [ "${PLAN_ONLY}" -ne 0 ]; then
  echo "📝 PLAN mode: building diff plan (no changes applied)"
  cd "$ROOT"
  GOT_FN="$(firebase functions:config:get 2>/dev/null || echo '{}')"
  PL_FN="$(jq -r '.functions // {}' <<<"$ENV_JSON")"
  PL_VZ="$(jq -r '.vercel // {}' <<<"$ENV_JSON")"
  jq -n \
    --argjson want_functions "$PL_FN" \
    --argjson want_vercel "$PL_VZ" \
    --argjson have_functions "$GOT_FN" \
    '{ firebase: { want: $want_functions, have: $have_functions }, vercel: { want: $want_vercel } }' \
    | tee /tmp/app-oint-env-plan.json >/dev/null
  echo "📄 Wrote plan → /tmp/app-oint-env-plan.json"
else
  echo "⚙️ Syncing env vars (APPLY) ..."
  # Push Firebase functions config
  cd "$ROOT"
  firebase functions:config:set $(jq -r 'to_entries | map(.key + "=" + (.value|tostring)) | join(" ")' <<<"$(jq '.functions' <<<"$ENV_JSON")") || true

  # === map Vercel project slugs + deploy by project (not cwd) ===
  VZ_PROJECTS=("app-oint-marketing" "app-oint-business" "app-oint-admin")

  # push Vercel env vars
  for prj in "${VZ_PROJECTS[@]}"; do
    echo "🔄 Updating Vercel env for $prj..."
    for k in $(jq -r '.vercel | keys[]' <<<"$ENV_JSON"); do
      v=$(jq -r ".vercel[\"$k\"]" <<<"$ENV_JSON")
      # Rule: NEXT_PUBLIC_* -> preview + production; secrets -> production only
      if [[ "$k" == NEXT_PUBLIC_* ]]; then
        printf "%s" "$v" | vz env add "$k" preview    --token "$VERCEL_TOKEN" --scope "$SCOPE" "$prj" || true
        printf "%s" "$v" | vz env add "$k" production --token "$VERCEL_TOKEN" --scope "$SCOPE" "$prj" || true
      else
        printf "%s" "$v" | vz env add "$k" production --token "$VERCEL_TOKEN" --scope "$SCOPE" "$prj" || true
      fi
    done
  done
fi

### === 2. REDEPLOY VERCEL PROJECTS ===
if [ "${PLAN_ONLY}" -eq 0 ]; then
  echo "🚀 Redeploying Vercel apps..."
  for prj in "${VZ_PROJECTS[@]}"; do
    echo "▶️ Deploying $prj..."
    vz deploy --prebuilt --token "$VERCEL_TOKEN" --scope "$SCOPE" "$prj" || true
  done

  echo "🌐 Ensure domains are attached to correct projects"
  for d in app-oint.com business.app-oint.com admin.app-oint.com; do vz domains add "$d" "app-oint-marketing" --token "$VERCEL_TOKEN" --scope "$SCOPE" || true; done
  vz domains move app-oint.com          app-oint-marketing --token "$VERCEL_TOKEN" --scope "$SCOPE" || true
  vz domains move business.app-oint.com app-oint-business  --token "$VERCEL_TOKEN" --scope "$SCOPE" || true
  vz domains move admin.app-oint.com    app-oint-admin     --token "$VERCEL_TOKEN" --scope "$SCOPE" || true

  echo "🔒 TLS status:"
  for d in app-oint.com business.app-oint.com admin.app-oint.com; do
    echo "=== $d ==="
    # Make this resilient to failures in any part of the pipeline
    set +o pipefail
    vz domains inspect "$d" --token "$VERCEL_TOKEN" --scope "$SCOPE" 2>/dev/null \
      | egrep -i 'serviceType|projectId|verified|certificate' \
      | sed 's/\r$//' \
      || true
    set -o pipefail
  done
else
  echo "🛑 PLAN mode: skipping redeploy and domain attach/move"
fi

### === 3. DEPLOY PERSONAL.APP-OINT.COM TO FIREBASE ===
if [ "${PLAN_ONLY}" -eq 0 ]; then
  echo "🔥 Deploying personal.app-oint.com..."
  cd "$ROOT/appoint"
  firebase deploy --only hosting
  # Map custom domain if needed
  # Map custom domain if needed (command name is 'domains', not 'domain')
  firebase hosting:domains:add personal.app-oint.com --project app-oint-core || true
else
  echo "🛑 PLAN mode: skipping Firebase hosting deploy"
fi

### === 4. VERIFY DIGITALOCEAN DNS ===
if [ "${PLAN_ONLY}" -eq 0 ]; then
  echo "🌐 Checking DNS..."
  doctl apps list || true
  doctl domains records list app-oint.com || true
else
  echo "🛑 PLAN mode: skipping DigitalOcean DNS checks"
fi

### === 5. VERIFY TLS HEADERS + SMOKE TESTS ===
if [ "${QA_TAIL}" = "1" ]; then
  echo "🔎 Running smoke tests..."
  cd "$ROOT"
  for d in app-oint.com business.app-oint.com admin.app-oint.com enterprise.app-oint.com personal.app-oint.com; do
    echo "=== $d ==="
    curl -sS -D - -o /dev/null "https://$d" | tr -d '\r' | egrep -i 'HTTP/|server:|x-vercel-id|firebase|cf-ray' || true
    echo
  done | tee /tmp/app-oint-headers.txt

  bash ops/scripts/smoke_curls.sh | tee /tmp/app-oint-smoke.txt
fi

### === 6. FINAL JSON AUDIT ===
echo "📦 Generating final audit..."
DNS_SNAP="$(for d in app-oint.com business.app-oint.com admin.app-oint.com enterprise.app-oint.com personal.app-oint.com; do echo \"=== $d ===\"; dig +short $d; done)"
VZ_PROJ="$( [ -n "${VERCEL_TOKEN:-}" ] && [ -n "$SCOPE" ] && vz projects ls --token "$VERCEL_TOKEN" --scope "$SCOPE" || true)"
VZ_DOMS="$( [ -n "${VERCEL_TOKEN:-}" ] && [ -n "$SCOPE" ] && vz domains ls --token "$VERCEL_TOKEN" --scope "$SCOPE" || true)"

jq -n \
  --arg dns "$DNS_SNAP" \
  --arg headers "$(cat /tmp/app-oint-headers.txt 2>/dev/null || echo '')" \
  --arg projects "$VZ_PROJ" \
  --arg domains "$VZ_DOMS" \
  --arg smoke "$(cat /tmp/app-oint-smoke.txt 2>/dev/null || echo '')" \
  '{dns:$dns, headers:$headers, vercel:{projects:$projects, domains:$domains}, smoke:$smoke}' \
  | tee /tmp/app-oint-final-audit.json >/dev/null

### === 7. POST-DEPLOY VERIFIER (APPLY only) ===
if [ "${PLAN_ONLY}" -eq 0 ]; then
  echo "🔎 Building post-deploy verification snapshot..."
  PD_DNS="$(for d in app-oint.com business.app-oint.com admin.app-oint.com enterprise.app-oint.com personal.app-oint.com; do echo \"=== $d ===\"; dig +short $d; done)"
  PD_HEADERS="$(cat /tmp/app-oint-headers.txt 2>/dev/null || echo '')"
  PD_SMOKE="$(cat /tmp/app-oint-smoke.txt 2>/dev/null || echo '')"
  PD_INSPECT="{}"
  if [ -n "${VERCEL_TOKEN:-}" ] && [ -n "$SCOPE" ]; then
    INSPECT_JSON="{}"
    for d in app-oint.com business.app-oint.com admin.app-oint.com; do
      set +o pipefail
      INS=$(vz domains inspect "$d" --token "$VERCEL_TOKEN" --scope "$SCOPE" 2>/dev/null \
        | egrep -i "serviceType|projectId|verified|certificate" \
        | sed 's/\"/\\\"/g' \
        || true)
      set -o pipefail
      INSPECT_JSON="$(jq -c --arg k "$d" --arg v "$INS" '. + {($k): $v}' <<<"$INSPECT_JSON")"
    done
    PD_INSPECT="$INSPECT_JSON"
  fi
  jq -n \
    --arg dns "$PD_DNS" \
    --arg headers "$PD_HEADERS" \
    --arg smoke "$PD_SMOKE" \
    --argjson inspect "$PD_INSPECT" \
    '{dns:$dns, headers:$headers, smoke:$smoke, vercel:{inspect:$inspect}}' \
    | tee /tmp/app-oint-post-verify.json >/dev/null
  echo "✅ Wrote post-verify snapshot → /tmp/app-oint-post-verify.json"
fi

echo "✅ PLAN complete. Artifacts:"
echo " - /tmp/app-oint-headers.txt"
echo " - /tmp/app-oint-smoke.txt"
echo " - /tmp/app-oint-final-audit.json"


