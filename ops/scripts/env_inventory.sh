#!/usr/bin/env bash
set -euo pipefail
OUT=ops/audit/vercel
apps=(marketing business enterprise-app dashboard)

for app in "${apps[@]}"; do
  [ -d "$app" ] || continue
  FN="$OUT/envs_${app}.md"
  echo "# ${app} – Environment Variables" > "$FN"
  echo >> "$FN"

  echo "## Detected via process.env" >> "$FN"
  grep -RhoE 'process\.env\.[A-Z0-9_]+' "$app" 2>/dev/null \
    | sed 's/.*process\.env\.//' | sort -u | sed 's/^/- /' >> "$FN" || true

  echo -e "\n## From next.config.* (if any)" >> "$FN"
  grep -RhoE '(publicRuntimeConfig|serverRuntimeConfig|env:\s*\{[^}]*\})' "$app/next.config."* 2>/dev/null \
    | sed 's/^/- /' >> "$FN" || echo "- (none)" >> "$FN"

  echo -e "\n## From .env.* examples (if any)" >> "$FN"
  grep -RhoE '^[A-Z0-9_]+=' "$app"/.env* 2>/dev/null | cut -d= -f1 | sort -u | sed 's/^/- /' >> "$FN" || echo "- (none)" >> "$FN"

  echo -e "\n## Notes" >> "$FN"
  echo "- Any **NEXT_PUBLIC_*** must exist in both Preview & Production in Vercel." >> "$FN"
  echo "- Non-NEXT_PUBLIC keys are server-only; set in Vercel env (not exposed to browser)." >> "$FN"
  echo "- If empty above, this app likely relies on defaults only." >> "$FN"

done

echo "Wrote inventories under $OUT/"
