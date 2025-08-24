#!/usr/bin/env bash
set -euo pipefail

# ============================
# App-Oint – Auto-Fetch & Apply
# ============================
# Requirements: jq, vercel cli, firebase cli (logged in already)
# Never prints secret values; only shows set/unset statuses.

ROOT="/Users/a/Desktop/ga"
APPLY="$ROOT/ops/scripts/apply_prod.sh"
REQUIRED=(VERCEL_TOKEN VERCEL_TEAM_SLUG VERCEL_TEAM_ID NEXT_PUBLIC_SENTRY_DSN STRIPE_SECRET_KEY JWT_SECRET BUSINESS_API_KEY SENTRY_AUTH_TOKEN FUNCTIONS_API_KEY)
OPTIONAL=(NEXT_PUBLIC_API_BASE API_INTERNAL_BASE)
ALL_VARS=("${REQUIRED[@]}" "${OPTIONAL[@]}")

log() { printf "%s\n" "$*" >&2; }
ok()  { log "✔ $*"; }
warn(){ log "⚠ $*"; }
die() { log "✖ $*"; exit 1; }

# --- 0) Preflight tools
command -v jq >/dev/null 2>&1 || die "jq not found. macOS: brew install jq"
# Allow either global vercel or npx fallback
if command -v vercel >/dev/null 2>&1; then
  VZ_CMD="vercel"
elif command -v npx >/dev/null 2>&1; then
  VZ_CMD="npx -y vercel@latest"
else
  die "Neither vercel nor npx found. Install Node.js and npm; optionally: npm i -g vercel"
fi
command -v firebase >/dev/null 2>&1 || warn "firebase CLI not found. Skipping Firebase secrets."

# --- 1) Try to source local env.prod.json if present (no prints)
if [ -f "$ROOT/ops/secrets/env.prod.json" ]; then
  # Pull known keys from JSON (if present)
  val() { jq -r "$1 // empty" "$ROOT/ops/secrets/env.prod.json" 2>/dev/null || true; }
  export NEXT_PUBLIC_API_BASE="${NEXT_PUBLIC_API_BASE:-$(val '.vercel.NEXT_PUBLIC_API_BASE // .vercel.NEXT_PUBLIC_API_BASE_URL')}"
  export API_INTERNAL_BASE="${API_INTERNAL_BASE:-$(val '.vercel.API_INTERNAL_BASE')}"
fi

# --- 2) Resolve/obtain Vercel token
# Priority: env VERCEL_TOKEN -> ~/.vercel/auth.json -> error
if [ -z "${VERCEL_TOKEN:-}" ]; then
  AUTH_JSON="${HOME}/.vercel/auth.json"
  if [ -f "$AUTH_JSON" ]; then
    export VERCEL_TOKEN="$(jq -r '.token // empty' "$AUTH_JSON" 2>/dev/null || true)"
  fi
fi
[ -n "${VERCEL_TOKEN:-}" ] && ok "Loaded Vercel token from env or local login" || warn "No Vercel token yet (VERCEL_TOKEN). If you are logged in via 'vercel login', we tried to read ~/.vercel/auth.json."

# --- 3) Determine Vercel teamId / teamSlug
TEAM_ID="${VERCEL_TEAM_ID:-}"
TEAM_SLUG="${VERCEL_TEAM_SLUG:-}"

if [ -n "${VERCEL_TOKEN:-}" ]; then
  # If either missing, query teams
  if [ -z "$TEAM_ID" ] || [ -z "$TEAM_SLUG" ]; then
    TEAMS_JSON="$(curl -fsS "https://api.vercel.com/v2/teams" -H "Authorization: Bearer ${VERCEL_TOKEN}" || true)"
    # Prefer previously set one; else pick the first team
    if [ -z "$TEAM_ID" ] && [ -n "$TEAMS_JSON" ]; then
      TEAM_ID="$(echo "$TEAMS_JSON" | jq -r '.teams[0].id // empty')"
    fi
    if [ -z "$TEAM_SLUG" ] && [ -n "$TEAMS_JSON" ]; then
      TEAM_SLUG="$(echo "$TEAMS_JSON" | jq -r '.teams[0].slug // empty')"
    fi
  fi
fi

[ -n "$TEAM_ID" ]   && export VERCEL_TEAM_ID="$TEAM_ID"
[ -n "$TEAM_SLUG" ] && export VERCEL_TEAM_SLUG="$TEAM_SLUG"

# --- 4) Enumerate Vercel projects and pull envs (if token present)
FOUND_LOG=""
note_found() { local k="$1"; local src="$2"; FOUND_LOG="${FOUND_LOG}\n - $(printf '%-24s' "$k") <- ${src}"; }
pull_vercel_envs() {
  [ -n "${VERCEL_TOKEN:-}" ] || { warn "Skipping Vercel env fetch (no token)."; return; }
  local team_q=""
  if [ -n "$VERCEL_TEAM_ID" ]; then team_q="&teamId=${VERCEL_TEAM_ID}"; fi
  if [ -z "$team_q" ] && [ -n "$VERCEL_TEAM_SLUG" ]; then
    # Get teamId from slug
    local TI
    TI="$(curl -fsS "https://api.vercel.com/v2/teams?slug=${VERCEL_TEAM_SLUG}" -H "Authorization: Bearer ${VERCEL_TOKEN}" | jq -r '.team.id // empty' || true)"
    [ -n "$TI" ] && team_q="&teamId=${TI}" && export VERCEL_TEAM_ID="$TI"
  fi

  local page=0
  while : ; do
    PROJ_JSON="$(curl -fsS "https://api.vercel.com/v9/projects?limit=100&from=$((page*100))${team_q}" -H "Authorization: Bearer ${VERCEL_TOKEN}" || true)"
    [ -n "$PROJ_JSON" ] || break
    # Iterate id and name pairs without using mapfile (portable for macOS bash)
    while IFS=$'\t' read -r pid pname; do
      [ -n "$pid" ] || continue
      ENV_JSON="$(curl -fsS "https://api.vercel.com/v9/projects/${pid}/env?${team_q#&}" -H "Authorization: Bearer ${VERCEL_TOKEN}" || true)"
      for key in "${ALL_VARS[@]}"; do
        has=$(echo "$ENV_JSON" | jq --arg K "$key" -e '[.envs[] | select(.key==$K) | select(.targets|index("production"))] | length > 0' 2>/dev/null || echo "false")
        if [ "$has" = "true" ] && [ -z "${!key:-}" ]; then
          TMPD="$(mktemp -d)"
          (
            cd "$TMPD"
            if $VZ_CMD env pull .env.tmp --token="$VERCEL_TOKEN" --environment=production --yes --scope="${VERCEL_TEAM_ID:-${VERCEL_TEAM_SLUG:-}}" --project="$pname" >/dev/null 2>&1; then
              if grep -Eiq "^${key}=" .env.tmp; then
                val="$(grep -Ei "^${key}=" .env.tmp | tail -n1 | sed -E 's/^[^=]*=\s*//')"
                if [ -n "$val" ]; then export "$key"="$val"; note_found "$key" "Vercel: $pname"; fi
              fi
            fi
          )
          rm -rf "$TMPD"
        fi
      done
    done < <(echo "$PROJ_JSON" | jq -r '.projects[] | [.id, .name] | @tsv')
    # Break if fewer than 100 returned
    count=$(echo "$PROJ_JSON" | jq -r '.projects | length')
    [ "$count" -lt 100 ] && break
    page=$((page+1))
  done
}

pull_vercel_envs || true

# --- 5) Firebase Functions secrets (best-effort)
if command -v firebase >/dev/null 2>&1; then
  # Try listing and accessing known secret names
  KNOWN_FB=(FUNCTIONS_API_KEY BUSINESS_API_KEY JWT_SECRET STRIPE_SECRET_KEY SENTRY_AUTH_TOKEN NEXT_PUBLIC_SENTRY_DSN)
  if firebase functions:secrets:list >/dev/null 2>&1; then
    for sn in "${KNOWN_FB[@]}"; do
      # If env var still empty and secret exists, access value
      if [ -z "${!sn:-}" ] && firebase functions:secrets:versions:list "$sn" >/dev/null 2>&1; then
        val="$(firebase functions:secrets:access "$sn" 2>/dev/null || true)"
        if [ -n "$val" ]; then export "$sn"="$val"; note_found "$sn" "Firebase Functions secret"; fi
      fi
    done
  else
    warn "Not authorized to list Firebase secrets (run: firebase login). Skipping."
  fi
fi

# --- 6) Summary (no secret values printed)
log ""
log "Auto-discovery summary (no values shown):"
printf "%-26s %s\n" "VARIABLE" "STATUS"
printf "%-26s %s\n" "--------" "------"
for k in "${ALL_VARS[@]}"; do
  st="unset"; [ -n "${!k:-}" ] && st="set"
  printf "%-26s %s\n" "$k" "$st"
done

if [ -n "$FOUND_LOG" ]; then
  log ""
  log "Sources used:"
  # shellcheck disable=SC2059
  printf "%b\n" "$FOUND_LOG"
fi

# --- 7) Gate: ensure minimum set for APPLY
CORE=(VERCEL_TOKEN NEXT_PUBLIC_SENTRY_DSN STRIPE_SECRET_KEY JWT_SECRET BUSINESS_API_KEY SENTRY_AUTH_TOKEN FUNCTIONS_API_KEY)
MISSING=()
for k in "${CORE[@]}"; do
  [ -n "${!k:-}" ] || MISSING+=("$k")
done

# Ensure team scope is present via either ID or SLUG
if [ -z "${VERCEL_TEAM_ID:-}" ] && [ -z "${VERCEL_TEAM_SLUG:-}" ]; then
  MISSING+=("VERCEL_TEAM_ID/VERCEL_TEAM_SLUG")
fi

if [ ${#MISSING[@]} -gt 0 ]; then
  log ""
  warn "Missing after auto-fetch:"
  for m in "${MISSING[@]}"; do printf " - %s\n" "$m"; done
  die "Cannot run APPLY until the above are set. Provide them or ensure Vercel/Firebase access and re-run."
fi

# --- 8) Run APPLY (secrets redacted in output)
log ""
ok "All required vars present. Running APPLY..."
set +e
REDACT='s/(STRIPE_SECRET_KEY|JWT_SECRET|SENTRY_AUTH_TOKEN|BUSINESS_API_KEY|FUNCTIONS_API_KEY|NEXT_PUBLIC_SENTRY_DSN)=[^ ]+/\1=[REDACTED]/g'
/bin/bash "$APPLY" 2>&1 | sed -E "$REDACT"
rc=${PIPESTATUS[0]}
set -e

log ""
if [ $rc -eq 0 ]; then
  ok "APPLY completed."
else
  warn "APPLY exited with code $rc (check logs above)."
fi

# --- 9) List artifacts
log ""
log "Artifacts (if present):"
ls -l /tmp/app-oint-headers.txt /tmp/app-oint-smoke.txt /tmp/app-oint-final-audit.json /tmp/app-oint-post-verify.json 2>/dev/null || true


