#!/usr/bin/env bash
set -euo pipefail

: "${WWW_TARGET:?set WWW_TARGET}"
: "${APP_TARGET:?set APP_TARGET}"
: "${BUSINESS_TARGET:?set BUSINESS_TARGET}"
: "${ENTERPRISE_TARGET:?set ENTERPRISE_TARGET}"
: "${API_TARGET:?set API_TARGET}"
: "${ADMIN_TARGET:?set ADMIN_TARGET}"

OUT="qa/dns/dns_records_do.csv"
cat > "$OUT" <<CSV
host,type,value,ttl
@,A,REDACTED_TOKEN,300
www,CNAME,${WWW_TARGET}.,300
app,CNAME,${APP_TARGET}.,300
business,CNAME,${BUSINESS_TARGET}.,300
enterprise,CNAME,${ENTERPRISE_TARGET}.,300
api,CNAME,${API_TARGET}.,300
admin,CNAME,${ADMIN_TARGET}.,300
CSV
echo "Wrote $OUT"


