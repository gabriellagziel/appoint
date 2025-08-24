#!/bin/bash
set -euo pipefail

cd ~/Desktop/ga

echo "=== Fixing Domain Mapping via Vercel CLI ==="

# 1) הסר app-oint.com מפרויקטים לא נכונים
echo "— removing app-oint.com from business"
(cd business && npx vercel domains remove app-oint.com --yes) || true

echo "— removing app-oint.com from enterprise-app"
(cd enterprise-app && npx vercel domains remove app-oint.com --yes) || true

# 2) ודא ש marketing מחזיק apex+www
echo "— ensuring marketing has apex+www"
(cd marketing && npx vercel domains add app-oint.com --yes) || true
(cd marketing && npx vercel domains add www.app-oint.com --yes) || true

# 3) צרף את הסאבדומיינים הנכונים
echo "— attaching business.app-oint.com to business"
(cd business && npx vercel domains add business.app-oint.com --yes) || true

echo "— attaching enterprise.app-oint.com to enterprise-app"
(cd enterprise-app && npx vercel domains add enterprise.app-oint.com --yes) || true

# 4) הדפס תמונת מצב אחרי שינוי
echo "=== Final Domain Status ==="
echo "[marketing domains]"
(cd marketing && npx vercel domains ls) || true

echo "[business domains]"
(cd business && npx vercel domains ls) || true

echo "[enterprise-app domains]"
(cd enterprise-app && npx vercel domains ls) || true

