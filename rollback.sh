#!/usr/bin/env bash
# Usage:
#   bash rollback.sh <project> <deployment-url> [domain1 domain2 ...]
# Example:
#   bash rollback.sh marketing https://marketing-abc123.vercel.app app-oint.com www.app-oint.com

set -euo pipefail
proj="${1:?project (vercel slug) required}"
target="${2:?deployment URL required}"; shift 2
domains=("$@")

VERCEL_ORG="${VERCEL_ORG:-gabriellagziels-projects}"
args=(--scope "$VERCEL_ORG")
[[ -n "${VERCEL_TOKEN:-}" ]] && args+=("--token" "$VERCEL_TOKEN")

alias_cmd() { npx -y vercel@latest alias set "$target" "$1" "${args[@]}"; }

if ((${#domains[@]}==0)); then
  # default mapping
  case "$proj" in
    marketing)      domains=(app-oint.com www.app-oint.com) ;;
    business)       domains=(business.app-oint.com) ;;
    enterprise-app) domains=(enterprise.app-oint.com) ;;
    admin)          domains=(admin.app-oint.com) ;;
    *) echo "Unknown project mapping; pass domains explicitly." >&2; exit 1 ;;
  esac
fi

for d in "${domains[@]}"; do
  echo "↩︎  $d -> $target"
  alias_cmd "$d" >/dev/null
done
echo "✅ Rollback aliases updated."
