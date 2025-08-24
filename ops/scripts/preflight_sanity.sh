#!/bin/bash
set -euo pipefail

ROOT="/Users/a/Desktop/ga"
ENV_JSON_PATH="${ENV_JSON_PATH:-$ROOT/ops/secrets/env.prod.json}"
# Prefer team slug for scope checks (teams ls/projects ls show slugs)
SCOPE="${VERCEL_TEAM_SLUG:-${VERCEL_TEAM_ID:-}}"
AUTO_HEAL="${AUTO_HEAL:-1}"

cd "$ROOT"

echo "== App-Oint Preflight Sanity =="
echo "ROOT=$ROOT"
echo "ENV_JSON_PATH=$ENV_JSON_PATH"
echo "SCOPE=${SCOPE:-<unset>}"
echo

status_ok() { echo "✅ $1"; }
status_err() { echo "❌ $1"; }
note() { echo "ℹ️  $1"; }

# 1) Tooling present
command -v jq >/dev/null && status_ok "jq available" || { status_err "jq missing (brew install jq)"; exit 1; }
command -v firebase >/dev/null && status_ok "firebase CLI available" || status_err "firebase CLI missing (npm i -g firebase-tools)"
command -v doctl >/dev/null && status_ok "doctl available" || status_err "doctl missing (brew install doctl)"
command -v npx >/dev/null && status_ok "Node/npm (npx) available" || status_err "Node/npm missing"
echo

# 2) Env JSON checks
if [[ ! -s "$ENV_JSON_PATH" ]]; then
  status_err "Env file missing or empty: $ENV_JSON_PATH"; exit 1;
fi

# 2a) Auto-heal: mirror NEXT_PUBLIC_API_BASE_URL -> NEXT_PUBLIC_API_BASE if missing
if jq -e '.vercel|has("NEXT_PUBLIC_API_BASE")|not and (.vercel|has("NEXT_PUBLIC_API_BASE_URL"))' "$ENV_JSON_PATH" >/dev/null 2>&1; then
  if [[ "$AUTO_HEAL" = "1" ]]; then
    note "Auto-heal: adding .vercel.NEXT_PUBLIC_API_BASE from .vercel.NEXT_PUBLIC_API_BASE_URL"
    jq '
      .vercel as $v
      | .vercel = ($v + { NEXT_PUBLIC_API_BASE: $v.NEXT_PUBLIC_API_BASE_URL })
    ' "$ENV_JSON_PATH" | tee "${ENV_JSON_PATH}.tmp" >/dev/null && mv "${ENV_JSON_PATH}.tmp" "$ENV_JSON_PATH"
    status_ok "Mirrored NEXT_PUBLIC_API_BASE"
  else
    status_err "Missing .vercel.NEXT_PUBLIC_API_BASE; set AUTO_HEAL=1 to auto-mirror from NEXT_PUBLIC_API_BASE_URL"
  fi
fi

if grep -Ei 'placeholder|your-api|example\.com' "$ENV_JSON_PATH" >/dev/null; then
  status_err "Placeholders found in env file — replace with real values before APPLY"
else
  status_ok "No obvious placeholders in env file"
fi

# Robust required-keys check (avoids jq errors on older jq)
REQ_KEYS=(NEXT_PUBLIC_API_BASE API_INTERNAL_BASE STRIPE_SECRET_KEY NEXT_PUBLIC_SENTRY_DSN JWT_SECRET)
MISSING_KEYS=()
for k in "${REQ_KEYS[@]}"; do
  if ! jq -e --arg K "$k" '.vercel | has($K)' "$ENV_JSON_PATH" >/dev/null 2>&1; then
    MISSING_KEYS+=("$k")
  fi
done
if [[ ${#MISSING_KEYS[@]} -eq 0 ]]; then
  REQ_RESULT="OK"
else
  REQ_RESULT="MISS:$(IFS=,; echo "${MISSING_KEYS[*]}")"
fi

if [[ "$REQ_RESULT" == "OK" ]]; then
  status_ok "Required .vercel keys present"
else
  status_err "Missing .vercel keys: ${REQ_RESULT#MISS:}"
fi
echo

# 3) Vercel creds & visibility
if [[ -n "${VERCEL_TOKEN:-}" && -n "$SCOPE" ]]; then
  status_ok "Vercel token & scope set"
  TEAMS=$(npx --yes vercel@latest teams ls --token "$VERCEL_TOKEN" 2>/dev/null || true)
  echo "$TEAMS" | grep -qi "$SCOPE" && status_ok "Vercel scope visible" || status_err "Vercel scope not found in teams list"
  PROJECTS=$(npx --yes vercel@latest projects ls --token "$VERCEL_TOKEN" --scope "$SCOPE" 2>/dev/null || true)
  echo "$PROJECTS" | egrep -q "app-oint-(marketing|business|admin)" && status_ok "Expected Vercel projects visible" || status_err "Projects not visible in scope"
else
  note "Vercel creds not set; skipping Vercel API checks"
fi
echo

# 4) Firebase auth sanity
if command -v firebase >/dev/null; then
  if firebase projects:list >/dev/null 2>&1; then
    status_ok "Firebase auth OK"
  else
    status_err "Firebase auth not set (firebase login)"
  fi
fi

# 5) DigitalOcean auth sanity
if command -v doctl >/dev/null; then
  if doctl account get >/dev/null 2>&1; then
    status_ok "DigitalOcean auth OK"
  else
    status_err "DigitalOcean auth not set (doctl auth init)"
  fi
fi
echo

# 6) DNS quick snapshot
DNS_SNAP=$(for d in app-oint.com business.app-oint.com admin.app-oint.com enterprise.app-oint.com personal.app-oint.com; do echo "=== $d ==="; dig +short $d; done)
echo "$DNS_SNAP" | awk '{print}' | sed 's/^/dns: /'

# 7) Persist JSON summary
jq -n \
  --arg vercel_token_set "${VERCEL_TOKEN:+set}" \
  --arg scope "$SCOPE" \
  --arg req_result "$REQ_RESULT" \
  --arg dns "$DNS_SNAP" \
  '{vercel:{token_set:$vercel_token_set, scope:$scope, required_keys:$req_result}, dns:$dns}' \
  | tee /tmp/app-oint-preflight.json >/dev/null

echo
status_ok "Preflight complete → /tmp/app-oint-preflight.json"

