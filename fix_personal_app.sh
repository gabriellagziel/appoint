#!/bin/bash
set -Eeuo pipefail

################################################################################
# 0) Preflight + paths
################################################################################
ROOT="${HOME}/Desktop/ga"
APP_DIR="${ROOT}/personal-app"
TS="$(date +%F_%H%M%S)"
OUTDIR="${ROOT}/ops/health/${TS}"
mkdir -p "${OUTDIR}"

[ -d "${APP_DIR}" ] || { echo "ERROR: ${APP_DIR} not found"; exit 1; }
cd "${APP_DIR}"

echo "=== CONTEXT ==="
npx -y vercel whoami || { echo "ERROR: vercel auth"; exit 1; }
# Ensure correct team
npx -y vercel switch <<< $'gabriellagziels-projects\n' >/dev/null 2>&1 || true

# Link project (idempotent)
npx -y vercel link --yes >/dev/null 2>&1 || true

################################################################################
# 1) Ensure domain is attached to the *personal-app* project
################################################################################
DOMAIN="personal-app.app-oint.com"

echo "=== Add/ensure domain in this project ==="
npx -y vercel domains add "${DOMAIN}" >/dev/null 2>&1 || true

echo "=== Inspect domain in this project ===" | tee "${OUTDIR}/domain_inspect.txt"
npx -y vercel domains inspect "${DOMAIN}" 2>&1 | tee -a "${OUTDIR}/domain_inspect.txt" || true

# If nameservers are 3rd-party (DigitalOcean), we will NOT change them.
# Instead, we emit exact DNS instructions (CNAME → cname.vercel-dns.com.)
echo "=== DNS INSTRUCTIONS (write to file) ==="
cat > "${OUTDIR}/dns_instructions.txt" <<'DNS'
Create this DNS record at your DNS provider (DigitalOcean):
Type: CNAME
Name/Host: personal-app
Value/Target: cname.vercel-dns.com.
TTL: default

If any A/AAAA/CNAME already exists for "personal-app", delete it first.
After saving, propagation normally takes a few minutes.
DNS

cat "${OUTDIR}/dns_instructions.txt"

################################################################################
# 2) Poll DNS until CNAME resolves (do not modify nameservers)
################################################################################
echo "=== Poll DNS for CNAME personal-app.app-oint.com → cname.vercel-dns.com. ==="
DNS_OK=0
for i in {1..60}; do
  CNAME=$(dig +short CNAME "${DOMAIN}" || true)
  echo "Try $i: ${CNAME:-<none>}"
  if [ "${CNAME}" = "cname.vercel-dns.com." ]; then DNS_OK=1; break; fi
  sleep 5
done
if [ $DNS_OK -ne 1 ]; then
  echo "WARN: CNAME not visible yet. Continuing, but alias may fail until DNS propagates."
fi

################################################################################
# 3) Production deploy (never alias a preview)
################################################################################
echo "=== Deploy --prod ==="
DEPLOY_OUT="$(npx -y vercel --prod --confirm 2>&1 | tee /dev/stderr || true)"
DEPLOY_URL="$(printf "%s\n" "${DEPLOY_OUT}" | grep -Eo 'https://[a-z0-9.-]+\.vercel\.app' | tail -1 || true)"
[ -n "${DEPLOY_URL}" ] || { echo "ERROR: could not parse DEPLOY_URL"; exit 1; }
echo "DEPLOY_URL=${DEPLOY_URL}"

# Poll deployment URL until 200 (handle 401 preview protection edge cases just in case)
echo "=== Poll deploy readiness: ${DEPLOY_URL} ==="
OK=0
for i in {1..48}; do
  CODE=$(curl -sk -o /dev/null -w '%{http_code}' "${DEPLOY_URL}/")
  echo "Try $i → ${CODE}"
  if [ "${CODE}" = "200" ]; then OK=1; break; fi
  sleep 5
done
[ $OK -eq 1 ] || echo "WARN: Deployment URL not returning 200 yet; will still attempt alias."

################################################################################
# 4) Alias the production deploy to the domain (with retries)
################################################################################
echo "=== Set alias ${DOMAIN} → ${DEPLOY_URL} ==="
ALIASED=0
for i in {1..12}; do
  if npx -y vercel alias set "${DEPLOY_URL}" "${DOMAIN}"; then
    ALIASED=1; break
  fi
  echo "Alias attempt $i failed — retrying..."
  sleep 10
done
[ $ALIASED -eq 1 ] || echo "WARN: alias set did not succeed yet; will verify anyway."

################################################################################
# 5) Verify live domain: status, headers, UI tokens, PWA assets
################################################################################
echo "=== Verify ${DOMAIN} ==="
HEALTH="${OUTDIR}/personal-app_proof.txt"
echo "=== PERSONAL-APP PROOF $(date -Iseconds) ===" | tee "${HEALTH}"

status_line () {
  local url="$1"
  local code hdr
  code=$(curl -s -o /dev/null -w '%{http_code}' "${url}")
  hdr=$(curl -sI "${url}" | tr -d '\r' | awk 'BEGIN{IGNORECASE=1}/^(strict-transport-security|x-frame-options|content-security-policy|cache-control):/{print}')
  printf "%s  HTTP:%s\n%s\n\n" "${url}" "${code}" "${hdr}"
}

# 5a) Status + headers
status_line "https://${DOMAIN}/" | tee -a "${HEALTH}"

# 5b) UI token check (Hebrew home headline & quick actions)
BODY="$(curl -sL "https://${DOMAIN}/" | head -c 12000)"
echo "HOME_UI_TOKENS:" | tee -a "${HEALTH}"
echo "${BODY}" | egrep -q "שלום|מה נעשה היום|Create Meeting" && echo "OK: UI tokens found" | tee -a "${HEALTH}" || echo "MISS: UI tokens not found" | tee -a "${HEALTH}"

# 5c) Key routes (should be 200/OK)
echo "ROUTE_STATUS:" | tee -a "${HEALTH}"
for p in /agenda /create/meeting /create/reminder /groups /family /playtime /settings ; do
  code=$(curl -s -o /dev/null -w '%{http_code}' "https://${DOMAIN}${p}")
  printf "%-18s → %s\n" "${p}" "${code}" | tee -a "${HEALTH}"
done

# 5d) PWA presence
echo "PWA:" | tee -a "${HEALTH}"
status_line "https://${DOMAIN}/manifest.json" | tee -a "${HEALTH}" >/dev/null

# 5e) Body hash for forensic match
SIG=$(printf "%s" "${BODY}" | head -c 8192 | shasum -a 256 | awk '{print $1}')
echo "BODY_HASH_8KB: ${SIG}" | tee -a "${HEALTH}"

echo "Proof written: ${HEALTH}"
echo "Output dir: ${OUTDIR}"
