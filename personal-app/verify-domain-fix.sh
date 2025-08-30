#!/bin/bash

# === Verify Domain Fix ===
# Run this after updating DNS nameservers to check if personal.app-oint.com is working

echo "🔍 Checking domain configuration..."
echo

# Check nameservers
echo "=== Current Nameservers ==="
dig NS app-oint.com +short

echo
echo "=== Testing Custom Domain ==="
curl -s -o /dev/null -w "https://personal.app-oint.com: %{http_code}\n" https://personal.app-oint.com

echo
echo "=== Testing Routes ==="
ROUTES=("/" "/en" "/en/meetings" "/en/reminders" "/en/groups" "/en/family" "/en/playtime")
for route in "${ROUTES[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://personal.app-oint.com$route")
  printf "%-24s → %s\n" "$route" "$code"
done

echo
echo "=== Expected Results ==="
echo "✅ Nameservers should be: ns1.vercel-dns.com, ns2.vercel-dns.com"
echo "✅ All routes should return: 200 (not 308)"
echo
echo "If you see 200 responses for all routes, the domain is fixed! 🎉"
