#!/usr/bin/env bash
set -euo pipefail

: "${VERCEL_TOKEN:?set VERCEL_TOKEN}"
TEAM_QS=""
if [ -n "${VERCEL_TEAM_ID:-}" ]; then TEAM_QS="teamId=$VERCEL_TEAM_ID";
elif [ -n "${VERCEL_TEAM_SLUG:-}" ]; then TEAM_QS="teamSlug=$VERCEL_TEAM_SLUG";
else echo "Set VERCEL_TEAM_ID or VERCEL_TEAM_SLUG"; exit 1; fi

JQ(){ jq -r "$@" 2>/dev/null || true; }

echo "→ Listing projects..."
PROJ_JSON=$(curl -s -H "Authorization: Bearer $VERCEL_TOKEN" \
  "https://api.vercel.com/v9/projects?${TEAM_QS}&limit=200")

echo "Projects (id  name  rootDir):"
echo "$PROJ_JSON" | JQ '.projects[] | "\(.id)\t\(.name)\t\(.rootDirectory//"-")"'

# ⬇️ EDIT THESE names to match your Vercel project names exactly
MARKETING_NAME="marketing"
DASHBOARD_NAME="dashboard"
ENTERPRISE_NAME="enterprise-app"     # or your actual enterprise project name
PERSONAL_NAME="personal"             # your personal app project name
ADMIN_NAME="admin"

# Resolve IDs by name
ID_OF(){ echo "$PROJ_JSON" | JQ ".projects[] | select(.name==\"$1\") | .id"; }
MARKETING_ID=$(ID_OF "$MARKETING_NAME")
DASHBOARD_ID=$(ID_OF "$DASHBOARD_NAME")
ENTERPRISE_ID=$(ID_OF "$ENTERPRISE_NAME")
PERSONAL_ID=$(ID_OF "$PERSONAL_NAME")
ADMIN_ID=$(ID_OF "$ADMIN_NAME")

echo; echo "Resolved IDs:"
printf "marketing: %s\nbusiness/dashboard: %s\nenterprise: %s\npersonal: %s\nadmin: %s\n" \
  "$MARKETING_ID" "$DASHBOARD_ID" "$ENTERPRISE_ID" "$PERSONAL_ID" "$ADMIN_ID"

# Set correct root directories (critical)
echo; echo "→ Setting root directories…"
PATCH(){ curl -s -X PATCH -H "Authorization: Bearer $VERCEL_TOKEN" -H "Content-Type: application/json" \
  -d "$2" "https://api.vercel.com/v9/projects/$1?${TEAM_QS}" >/dev/null; }
[ -n "$MARKETING_ID" ]  && PATCH "$MARKETING_ID"  '{"rootDirectory":"marketing"}'
[ -n "$DASHBOARD_ID" ]  && PATCH "$DASHBOARD_ID"  '{"rootDirectory":"dashboard"}'
[ -n "$ENTERPRISE_ID" ] && PATCH "$ENTERPRISE_ID" '{"rootDirectory":"enterprise-app"}'
[ -n "$PERSONAL_ID" ]   && PATCH "$PERSONAL_ID"   '{"rootDirectory":"personal"}'
[ -n "$ADMIN_ID" ]      && PATCH "$ADMIN_ID"      '{"rootDirectory":"admin"}'
echo "Root directories patched."

# Attach domains to the right projects
attach(){
  local domain="$1" id="$2"
  [ -n "$id" ] || { echo "Skip $domain (project id missing)"; return; }
  curl -s -X POST -H "Authorization: Bearer $VERCEL_TOKEN" -H "Content-Type: application/json" \
    -d "{\"domain\":\"$domain\"}" \
    "https://api.vercel.com/v10/projects/$id/domains?${TEAM_QS}" \
  | JQ '{domain, projectId, verified, configured}'
}

echo; echo "→ Attaching domains…"
attach app-oint.com                  "$MARKETING_ID"
attach business.app-oint.com         "$DASHBOARD_ID"
attach enterprise.app-oint.com       "$ENTERPRISE_ID"
attach personal.app-oint.com         "$PERSONAL_ID"
attach admin.app-oint.com            "$ADMIN_ID"

# Show status per domain
inspect(){
  local d="$1"
  echo "=== $d ==="
  curl -s -H "Authorization: Bearer $VERCEL_TOKEN" \
    "https://api.vercel.com/v6/domains/$d?${TEAM_QS}" \
  | JQ '{name, verified, serviceType, projectId, certificate: .certificate.state}'
}
echo; echo "→ Inspecting domains…"
for d in app-oint.com business.app-oint.com enterprise.app-oint.com personal.app-oint.com admin.app-oint.com; do
  inspect "$d"
done

echo; echo "→ Header sanity (server/x-vercel-id)…"
for h in app-oint.com business.app-oint.com enterprise.app-oint.com personal.app-oint.com admin.app-oint.com; do
  echo "=== $h ==="
  curl -sS -D - -o /dev/null "https://$h" | tr -d '\r' | egrep -i 'HTTP/|location:|server:|x-vercel-id:' || true
done



