#!/usr/bin/env bash
set -Eeuo pipefail

URLS=(
  "https://app-oint.com"
  "https://www.app-oint.com"
  "https://business.app-oint.com"
  "https://enterprise.app-oint.com"
  "https://admin.app-oint.com"
  "https://personal.app-oint.com"
)

ok=0; fail=0

check() {
  local u="$1"
  # Collect headers following redirects
  local headers
  if ! headers="$(curl -sS -I -L --max-time 20 "$u")"; then
    printf "✗ %-33s -> connection error\n" "$u"; ((fail++)) || true; return
  fi

  # Last HTTP status
  local code
  code="$(printf '%s\n' "$headers" | awk '/^HTTP\//{c=$2} END{print c+0}')"

  # Header presence
  local hsts csp xfo
  hsts=$(printf '%s' "$headers" | grep -i -c '^strict-transport-security:')
  csp=$( printf '%s' "$headers" | grep -i -c '^content-security-policy:')
  xfo=$( printf '%s' "$headers" | grep -i -c '^x-frame-options:')

  # Decide pass/fail (200–399 treated as OK)
  if [[ "$code" -ge 200 && "$code" -lt 400 ]]; then
    printf "✓ %-33s -> %s  HSTS:%s  CSP:%s  XFO:%s\n" \
      "$u" "$code" "$([[ $hsts -gt 0 ]] && echo yes || echo no)" \
      "$([[ $csp  -gt 0 ]] && echo yes || echo no)" \
      "$([[ $xfo  -gt 0 ]] && echo yes || echo no)"
    ((ok++)) || true
  else
    printf "✗ %-33s -> %s  HSTS:%s  CSP:%s  XFO:%s\n" \
      "$u" "$code" "$([[ $hsts -gt 0 ]] && echo yes || echo no)" \
      "$([[ $csp  -gt 0 ]] && echo yes || echo no)" \
      "$([[ $xfo  -gt 0 ]] && echo yes || echo no)"
    ((fail++)) || true
  fi
}

echo "== App-Oint Health Check =="
for u in "${URLS[@]}"; do check "$u"; done
echo "REDACTED_TOKEN"
echo "PASS: $ok   FAIL: $fail"
exit $([[ $fail -eq 0 ]] && echo 0 || echo 1)
