#!/usr/bin/env bash
set -euo pipefail

domains=("app-oint.com" "www.app-oint.com" "business.app-oint.com" "enterprise.app-oint.com")

echo "=== HEALTH $(date -Iseconds) ==="
for d in "${domains[@]}"; do
  echo "--- $d ---"
  
  # HTTP status
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://$d/")
  echo "HTTP: $code"
  
  # Headers
  hdr=$(curl -sI "https://$d/")
  
  # Security headers check
  hsts=$([[ "$hdr" =~ [Ss]trict-Transport-Security ]] && echo "OK" || echo "MISSING")
  xfo=$([[ "$hdr" =~ [Xx]-[Ff]rame-[Oo]ptions ]] && echo "OK" || echo "MISSING")
  csp=$([[ "$hdr" =~ [Cc]ontent-[Ss]ecurity-[Pp]olicy ]] && echo "OK" || echo "MISSING")
  vercel=$([[ "$hdr" =~ [Xx]-[Vv]ercel-[Ii]d ]] && echo "OK" || echo "UNKNOWN")
  
  echo "HSTS: $hsts  | XFO: $xfo  | CSP: $csp  | x-vercel-id: $vercel"
  
  # Content check (avoid hotfix signatures)
  body=$(curl -sL "https://$d/" | head -c 8000)
  sig=$([ -z "$(grep -Ei "splash|placeholder" <<< "$body" || true)" ] && echo "CLEAN" || echo "HOTFIX")
  echo "CONTENT: $sig"
  echo ""
done
