#!/bin/bash
set -euo pipefail

#######################################
#             CONFIG (edit)           #
#######################################
# Respect existing environment values provided by the caller.
# If any template placeholders are present ("__FILL_ME__..."), unset them so
# downstream prechecks fail fast rather than using bogus values.
for var in \
  VERCEL_TOKEN \
  VERCEL_TEAM_SLUG \
  VERCEL_TEAM_ID \
  NEXT_PUBLIC_SENTRY_DSN \
  STRIPE_SECRET_KEY \
  JWT_SECRET \
  BUSINESS_API_KEY \
  SENTRY_AUTH_TOKEN \
  FUNCTIONS_API_KEY
do
  val="${!var:-}"
  case "$val" in
    __FILL_ME__*) unset "$var" ;; 
  esac
done

# --- Optional overrides (leave empty to keep current) ---
export NEXT_PUBLIC_API_BASE="${NEXT_PUBLIC_API_BASE:-}"     # e.g. https://us-central1-app-oint-core.cloudfunctions.net
export API_INTERNAL_BASE="${API_INTERNAL_BASE:-}"           # e.g. https://us-central1-app-oint-core.cloudfunctions.net

# --- Modes ---
DO_PLAN_FIRST="${DO_PLAN_FIRST:-1}"   # 1 = run PLAN first (safe read-only)
AUTO_HEAL="${AUTO_HEAL:-1}"           # 1 = auto-mirror NEXT_PUBLIC_API_BASE_URL -> NEXT_PUBLIC_API_BASE if missing

#######################################
#           CONSTANTS (no edit)       #
#######################################
ROOT="/Users/a/Desktop/ga"
ENV_JSON="$ROOT/ops/secrets/env.prod.json"
ENV_JSON_TMP="$ENV_JSON.tmp"
PRECHECK_ERR=()

cd "$ROOT"

# ---------- Tooling checks ----------
need() { command -v "$1" >/dev/null 2>&1 || PRECHECK_ERR+=("$1"); }
need jq
need /bin/bash
need sed
need tr
need grep
# optional: firebase, doctl, npx are validated inside project scripts

# ---------- Secrets checks ----------
[ -n "${VERCEL_TOKEN:-}" ] || PRECHECK_ERR+=("VERCEL_TOKEN")
if [ -z "${VERCEL_TEAM_SLUG:-}" ] && [ -z "${VERCEL_TEAM_ID:-}" ]; then PRECHECK_ERR+=("VERCEL_TEAM_SLUG or VERCEL_TEAM_ID"); fi
[ -n "${NEXT_PUBLIC_SENTRY_DSN:-}" ] || PRECHECK_ERR+=("NEXT_PUBLIC_SENTRY_DSN")
[ -n "${STRIPE_SECRET_KEY:-}" ] || PRECHECK_ERR+=("STRIPE_SECRET_KEY")
[ -n "${JWT_SECRET:-}" ] || PRECHECK_ERR+=("JWT_SECRET")
[ -n "${BUSINESS_API_KEY:-}" ] || PRECHECK_ERR+=("BUSINESS_API_KEY")
[ -n "${SENTRY_AUTH_TOKEN:-}" ] || PRECHECK_ERR+=("SENTRY_AUTH_TOKEN")
[ -n "${FUNCTIONS_API_KEY:-}" ] || PRECHECK_ERR+=("FUNCTIONS_API_KEY")

# ---------- Fail early if missing ----------
if [ ${#PRECHECK_ERR[@]} -ne 0 ]; then
  echo "❌ Missing requirements:"
  printf ' - %s\n' "${PRECHECK_ERR[@]}"
  echo "Fix the above and rerun."
  exit 1
fi

# ---------- Ensure env file exists ----------
mkdir -p "$(dirname "$ENV_JSON")"
[ -s "$ENV_JSON" ] || echo '{}' > "$ENV_JSON"

# ---------- Seed JSON structure if needed ----------
jq '
  .vercel = (.vercel // {}) |
  .functions = (.functions // {})
' "$ENV_JSON" > "$ENV_JSON_TMP" && mv "$ENV_JSON_TMP" "$ENV_JSON"

# ---------- Optional heal for base key ----------
if [ "$AUTO_HEAL" = "1" ]; then
  jq '
    .vercel as $v
    | .vercel = ($v + (
        if (($v|has("NEXT_PUBLIC_API_BASE")|not) and ($v|has("NEXT_PUBLIC_API_BASE_URL")))
        then { NEXT_PUBLIC_API_BASE: $v.NEXT_PUBLIC_API_BASE_URL }
        else {} end))
  ' "$ENV_JSON" > "$ENV_JSON_TMP" && mv "$ENV_JSON_TMP" "$ENV_JSON"
fi

# ---------- Sync required secrets into env JSON ----------
jq --arg d "$NEXT_PUBLIC_SENTRY_DSN" \
   --arg sk "$STRIPE_SECRET_KEY" \
   --arg jwt "$JWT_SECRET" \
   --arg bap "$BUSINESS_API_KEY" \
   --arg sat "$SENTRY_AUTH_TOKEN" \
   --arg fak "$FUNCTIONS_API_KEY" \
   '.vercel.NEXT_PUBLIC_SENTRY_DSN = $d
    | .vercel.STRIPE_SECRET_KEY   = $sk
    | .vercel.JWT_SECRET          = $jwt
    | .functions.stripe.secret    = $sk
    | .functions.jwt.secret       = $jwt
    | .functions.api.key          = $fak
    | .vercel.BUSINESS_API_KEY    = $bap
    | .vercel.SENTRY_AUTH_TOKEN   = $sat' \
   "$ENV_JSON" > "$ENV_JSON_TMP" && mv "$ENV_JSON_TMP" "$ENV_JSON"

# ---------- Optional overrides ----------
if [ -n "${NEXT_PUBLIC_API_BASE:-}" ]; then
  jq --arg u "$NEXT_PUBLIC_API_BASE"  '.vercel.NEXT_PUBLIC_API_BASE = $u' -S "$ENV_JSON" > "$ENV_JSON_TMP" && mv "$ENV_JSON_TMP" "$ENV_JSON"
fi
if [ -n "${API_INTERNAL_BASE:-}" ]; then
  jq --arg u "$API_INTERNAL_BASE" '.vercel.API_INTERNAL_BASE = $u' -S "$ENV_JSON" > "$ENV_JSON_TMP" && mv "$ENV_JSON_TMP" "$ENV_JSON"
fi

# ---------- Safety scan (block if placeholders) ----------
if grep -Ei 'placeholder|your-api|example\.com' "$ENV_JSON" >/dev/null; then
  echo "❌ Placeholder values detected in $ENV_JSON — replace with real production values and rerun."
  exit 1
fi

# ---------- Show minimal summary (redacted) ----------
echo "== Secrets summary (redacted) =="
jq -r '
  {
    NEXT_PUBLIC_SENTRY_DSN: (.vercel.NEXT_PUBLIC_SENTRY_DSN|tostring|sub("://.*";"://[REDACTED]")),
    STRIPE_SECRET_KEY:      "[REDACTED]",
    JWT_SECRET:             "[REDACTED]",
    NEXT_PUBLIC_API_BASE:   (.vercel.NEXT_PUBLIC_API_BASE // "<unchanged>"),
    API_INTERNAL_BASE:      (.vercel.API_INTERNAL_BASE   // "<unchanged>")
  }
' "$ENV_JSON"

# ---------- PLAN (safe) ----------
if [ "$DO_PLAN_FIRST" = "1" ]; then
  echo; echo "== PLAN (read-only) =="
  PLAN_ONLY=1 QA_TAIL=1 ENV_JSON_PATH="$ENV_JSON" \
  /bin/bash -lc 'ops/scripts/env_audit_apply.sh' || true

  echo; echo "PLAN artifacts:"
  echo " - /tmp/app-oint-headers.txt"
  echo " - /tmp/app-oint-smoke.txt"
  echo " - /tmp/app-oint-final-audit.json"
fi

# ---------- APPLY (preflight → deploy → QA → post-verify) ----------
echo; echo "== APPLY (preflight → deploy → QA) =="
/Users/a/Desktop/ga/ops/scripts/preflight_apply.sh

# ---------- Print artifacts ----------
echo; echo "== Artifacts =="
for f in \
  /tmp/app-oint-headers.txt \
  /tmp/app-oint-smoke.txt \
  /tmp/app-oint-final-audit.json \
  /tmp/app-oint-post-verify.json
do
  echo "--- $f ---"
  if [ -f "$f" ]; then
    # pretty-print json files, cat text
    case "$f" in
      *.json) jq . "$f" 2>/dev/null || cat "$f" ;;
      *)      cat "$f" ;;
    esac
  else
    echo "(missing)"
  fi
done

echo; echo "✅ Done."


