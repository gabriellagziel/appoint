#!/bin/bash
set -euo pipefail

cd ~/Desktop/ga

# 0) אסוף מזהי פרויקטים + טוקן
MID=$(jq -r '.projectId' marketing/.vercel/project.json)
BID=$(jq -r '.projectId' business/.vercel/project.json)
EID=$(jq -r '.projectId' enterprise-app/.vercel/project.json)
TOKEN=$(jq -r '.token' ~/.vercel/auth.json)

api() { curl -sS -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" "$@"; }

echo "Projects: marketing=$MID  business=$BID  enterprise=$EID"

# 1) הסר app-oint.com מפרויקטים לא נכונים (idempotent)
echo "— removing app-oint.com from business & enterprise (if present)"
api -X DELETE "https://api.vercel.com/v9/projects/$BID/domains/app-oint.com" || true
api -X DELETE "https://api.vercel.com/v9/projects/$EID/domains/app-oint.com" || true

# 2) ודא ש marketing מחזיק apex+www
echo "— ensuring marketing has apex+www"
api -X POST "https://api.vercel.com/v9/projects/$MID/domains" -d '{"name":"app-oint.com"}' || true
api -X POST "https://api.vercel.com/v9/projects/$MID/domains" -d '{"name":"www.app-oint.com"}' || true
# הסר wildcard אם היה קיים
api -X DELETE "https://api.vercel.com/v9/projects/$MID/domains/%2A.app-oint.com" || true

# 3) צרף את הסאבדומיינים הנכונים
echo "— attaching business.app-oint.com to business"
api -X POST "https://api.vercel.com/v9/projects/$BID/domains" -d '{"name":"business.app-oint.com"}' || true

echo "— attaching enterprise.app-oint.com to enterprise-app"
api -X POST "https://api.vercel.com/v9/projects/$EID/domains" -d '{"name":"enterprise.app-oint.com"}' || true

# 4) הדפס תמונת מצב אחרי שינוי
echo "[marketing domains]"
api "https://api.vercel.com/v9/projects/$MID/domains" | jq -r '.domains[].name'

echo "[business domains]"
api "https://api.vercel.com/v9/projects/$BID/domains" | jq -r '.domains[].name'

echo "[enterprise-app domains]"
api "https://api.vercel.com/v9/projects/$EID/domains" | jq -r '.domains[].name'

