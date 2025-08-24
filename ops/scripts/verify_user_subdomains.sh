#!/usr/bin/env bash
set -euo pipefail
DOMAIN="${1:-app-oint.com}"
TENANT="${2:-tenant-$(date +%s)}"
SUB="${TENANT}.${DOMAIN}"

pass(){ printf "✅ %s\n" "$*"; }
fail(){ printf "❌ %s\n" "$*"; exit 1; }

echo "== DNS =="
APEX_A=$(dig +short A "$DOMAIN" 2>/dev/null | head -n1 || true)
APEX_C=$(dig +short CNAME "$DOMAIN" 2>/dev/null | head -n1 || true)
SUB_A=$(dig +short A "$SUB" 2>/dev/null | head -n1 || true)
SUB_C=$(dig +short CNAME "$SUB" 2>/dev/null | head -n1 || true)
echo "apex A:   ${APEX_A:-<none>}"; echo "apex CNAME: ${APEX_C:-<none>}"
echo "sub  A:   ${SUB_A:-<none>}";  echo "sub  CNAME: ${SUB_C:-<none>}"
[ -n "${SUB_A}${SUB_C}" ] || fail "Wildcard DNS is not resolving for ${SUB}"

echo; echo "== HTTPS =="
for HOST in "$DOMAIN" "$SUB"; do
  CODE=$(curl -sS -o /dev/null -w "%{http_code}" "https://${HOST}" || true)
  HDR=$(curl -sS -o /dev/null -D - "https://${HOST}" | tr -d '\r' | grep -iE '^(x-vercel-id|server|location):' || true)
  echo "--- ${HOST} ---"
  echo "HTTP ${CODE}"
  [ -n "$HDR" ] && echo "$HDR"
  [[ "$CODE" =~ ^2|3 ]] || fail "HTTPS check failed for ${HOST} (code ${CODE})"
done
pass "Wildcard subdomain ${SUB} resolves and serves over HTTPS"

echo; echo "== Optional health =="
for PATH in "/api/status" "/health" "/"; do
  CODE=$(curl -sS -o /dev/null -w "%{http_code}" "https://${SUB}${PATH}" || true)
  [[ "$CODE" =~ ^2|3 ]] && { echo "OK ${PATH} → ${CODE}"; exit 0; }
done
echo "No health endpoint detected (that’s fine if not used)."