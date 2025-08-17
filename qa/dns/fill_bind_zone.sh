#!/usr/bin/env bash
set -euo pipefail

: "${WWW_TARGET:?set WWW_TARGET}"
: "${APP_TARGET:?set APP_TARGET}"
: "${BUSINESS_TARGET:?set BUSINESS_TARGET}"
: "${ENTERPRISE_TARGET:?set ENTERPRISE_TARGET}"
: "${API_TARGET:?set API_TARGET}"
: "${ADMIN_TARGET:?set ADMIN_TARGET}"

SERIAL_DATE=$(date +%Y%m%d)
SERIAL="${SERIAL_DATE}01"
ZONE_OUT="qa/dns/app-oint.com.zone.gen"

{
cat <<HDR
$TTL 300
@   IN SOA ns1.example.net. admin.app-oint.com. ( ${SERIAL} 3600 900 1209600 300 )
    IN NS  ns1.example.net.
    IN NS  ns2.example.net.

; Apex (optional: set A to a server that returns 301 → https://www.app-oint.com/)
;@   IN A ${APEX_IP:-0.0.0.0} ; set APEX_IP env or remove this line if using DNS-provider HTTP redirect

; Canonical www
www         IN CNAME ${WWW_TARGET}.

; App (Personal)
app         IN CNAME ${APP_TARGET}.

; Business
business    IN CNAME ${BUSINESS_TARGET}.

; Enterprise
enterprise  IN CNAME ${ENTERPRISE_TARGET}.

; API Portal
api         IN CNAME ${API_TARGET}.

; Admin
admin       IN CNAME ${ADMIN_TARGET}.
HDR
} >"${ZONE_OUT}"

echo "Wrote ${ZONE_OUT}"


