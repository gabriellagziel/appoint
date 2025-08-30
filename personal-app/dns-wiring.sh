#!/bin/bash

# === Final DNS Wiring: Choose Path A (keep provider) or Path B (switch NS to Vercel) ===
# Scope: app-oint.com + subdomains. Creates a verification script and runs live checks.
# No secrets printed. Safe to run multiple times.

set -euo pipefail

OUT="/tmp/app-oint-deploy"
mkdir -p "$OUT"

DOMAIN="app-oint.com"
SUBS=("personal" "business" "enterprise" "admin")

echo "=== 0) Detect current authoritative nameservers ==="
auth_ns=$(dig +short NS "$DOMAIN" | sed 's/\.$//' || true)
printf "Authoritative NS for %s:\n%s\n\n" "$DOMAIN" "${auth_ns:-<unknown>}"

cat > "$OUT/dns-wiring-options.md" <<'EOF'
# DNS Wiring Options for app-oint.com

## Path A — Keep current DNS provider
Add / confirm these records at your existing DNS host:

Apex (root) domain:
- Type: A
- Name: @
- Value: 76.76.21.21   # Vercel edge IP

Optional (recommended):
- Type: CNAME
- Name: www
- Value: cname.vercel-dns.com.

Subdomains (point each to Vercel):
- Type: CNAME
- Name: personal
- Value: cname.vercel-dns.com.

- Type: CNAME
- Name: business
- Value: cname.vercel-dns.com.

- Type: CNAME
- Name: enterprise
- Value: cname.vercel-dns.com.

- Type: CNAME
- Name: admin
- Value: cname.vercel-dns.com.

> Note: If your DNS supports ALIAS/ANAME for apex, you may instead set:
>  @ → ALIAS cname.vercel-dns.com.

## Path B — Switch nameservers to Vercel DNS
At your domain registrar, set nameservers to:
- ns1.vercel-dns.com
- ns2.vercel-dns.com

Then add the same subdomains inside Vercel's DNS (they'll auto-point).
EOF

echo "Wrote guidance → $OUT/dns-wiring-options.md"

# --- 1) Generate a reusable verification script ---
cat > "$OUT/verify-domain-fix.sh" << 'EOS'
#!/usr/bin/env bash
set -e
DOMAIN="app-oint.com"
SUBS=("personal" "business" "enterprise" "admin")

echo "=== Authoritative NS ==="
dig +short NS "$DOMAIN" | sed 's/\.$//'

echo; echo "=== Apex A & CNAME (flattened) ==="
echo "A @ :"  $(dig +short A "$DOMAIN" || true)
echo "CNAME @:" $(dig +short CNAME "$DOMAIN" || true)

echo; echo "=== Subdomain CNAMEs ==="
for s in "${SUBS[@]}"; do
  fqdn="$s.$DOMAIN"
  echo -n "$fqdn → "
  dig +short CNAME "$fqdn" || echo
done

echo; echo "=== HTTP checks (expect 200/301/302/308 + x-vercel-id) ==="
hosts=("$DOMAIN" "personal.$DOMAIN" "business.$DOMAIN" "enterprise.$DOMAIN" "admin.$DOMAIN")
for h in "${hosts[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://$h" || echo 000)
  vercel=$(curl -sI "https://$h" | tr -d '\r' | awk 'BEGIN{IGNORECASE=1}/^x-vercel-id:/{print "OK"}')
  printf "%-28s code=%-3s vercel=%s\n" "$h" "$code" "${vercel:-MISSING}"
done
EOS
chmod +x "$OUT/verify-domain-fix.sh"
echo "Wrote verifier → $OUT/verify-domain-fix.sh"

# --- 2) Quick, inline live verification now (same checks as script) ---
{
  echo "=== Inline DNS Snapshot ==="
  echo "Apex A:   $(dig +short A "$DOMAIN" || true)"
  echo "Apex CNAME: $(dig +short CNAME "$DOMAIN" || true)"
  for s in "${SUBS[@]}"; do
    fqdn="$s.$DOMAIN"
    echo "$fqdn CNAME: $(dig +short CNAME "$fqdn" || true)"
  done

  echo; echo "=== Inline HTTPS Snapshot ==="
  hosts=("$DOMAIN" "personal.$DOMAIN" "business.$DOMAIN" "enterprise.$DOMAIN" "admin.$DOMAIN")
  for h in "${hosts[@]}"; do
    code=$(curl -s -o /dev/null -w "%{http_code}" "https://$h" || echo 000)
    vercel=$(curl -sI "https://$h" | tr -d '\r' | awk 'BEGIN{IGNORECASE=1}/^x-vercel-id:/{print "OK"}')
    printf "%-28s code=%-3s vercel=%s\n" "$h" "$code" "${vercel:-MISSING}"
  done
} | tee "$OUT/verify-inline.out"

echo
echo "✅ DNS wiring guidance written to:  $OUT/dns-wiring-options.md"
echo "✅ Verifier script available at:    $OUT/verify-domain-fix.sh"
echo "📄 Inline verification snapshot:    $OUT/verify-inline.out"
echo
echo "Next:"
echo "- If you choose Path A, add/confirm records at your DNS host, then run:"
echo "    $OUT/verify-domain-fix.sh"
echo "- If you choose Path B, set NS to Vercel at your registrar, then run:"
echo "    $OUT/verify-domain-fix.sh"
