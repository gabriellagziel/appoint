#!/bin/bash
echo "=== DNS Debug After Changes ==="
echo "Run this after making DNS changes at your provider"
echo ""

echo "1. Check apex A record (should be 76.76.21.21):"
dig +short A app-oint.com

echo ""
echo "2. Check apex CNAME (should be empty):"
dig +short CNAME app-oint.com

echo ""
echo "3. Check wildcard subdomain A record (should resolve via CNAME):"
dig +short A test123.app-oint.com

echo ""
echo "4. Check wildcard subdomain CNAME (should show Vercel):"
dig +short CNAME test123.app-oint.com

echo ""
echo "5. Full wildcard verification:"
bash ops/scripts/verify_user_subdomains.sh app-oint.com

echo ""
echo "=== Expected Results ==="
echo "1. A record: 76.76.21.21"
echo "2. CNAME: (empty)"
echo "3. Wildcard A: 76.76.21.21 (or Vercel IPs)"
echo "4. Wildcard CNAME: cname.vercel-dns.com"
echo "5. Verification: ✅ for both apex and random subdomain"
