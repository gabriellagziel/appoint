#!/usr/bin/env bash
set -euo pipefail

DOMAIN="app-oint.com"
TTL=300

echo "Current DNS records:"
doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | "\(.type)\t\(.name)\t->\t\(.data)"'

echo -e "\nFixing DNS records..."

# Remove duplicate A record (keep the first one)
A_RECORDS=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="A" and .name=="@") | .id')
A_COUNT=$(echo "$A_RECORDS" | wc -l)
if [[ $A_COUNT -gt 1 ]]; then
    echo "Found $A_COUNT A records, removing duplicates..."
    echo "$A_RECORDS" | tail -n +2 | xargs -r -n1 doctl compute domain records delete "$DOMAIN" -f
fi

# Ensure correct A record
CURRENT_A=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="A" and .name=="@") | .data' | head -n1)
if [[ "$CURRENT_A" != "76.76.21.21" ]]; then
    echo "Updating A record to 76.76.21.21"
    A_ID=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="A" and .name=="@") | .id' | head -n1)
    doctl compute domain records update "$DOMAIN" "$A_ID" --record-data "76.76.21.21" --record-ttl "$TTL"
else
    echo "A record already correct: $CURRENT_A"
fi

# Ensure CNAME records
echo "Ensuring CNAME records..."

# www -> cname.vercel-dns.com
CURRENT_WWW=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="CNAME" and .name=="www") | .data' | head -n1)
if [[ "$CURRENT_WWW" != "cname.vercel-dns.com" ]]; then
    if [[ -n "$CURRENT_WWW" ]]; then
        WWW_ID=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="CNAME" and .name=="www") | .id' | head -n1)
        doctl compute domain records update "$DOMAIN" "$WWW_ID" --record-data "cname.vercel-dns.com" --record-ttl "$TTL"
    else
        doctl compute domain records create "$DOMAIN" --record-type "CNAME" --record-name "www" --record-data "cname.vercel-dns.com" --record-ttl "$TTL"
    fi
    echo "Updated www CNAME"
else
    echo "www CNAME already correct"
fi

# business -> cname.vercel-dns.com
CURRENT_BUSINESS=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="CNAME" and .name=="business") | .data' | head -n1)
if [[ "$CURRENT_BUSINESS" != "cname.vercel-dns.com" ]]; then
    if [[ -n "$CURRENT_BUSINESS" ]]; then
        BUSINESS_ID=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="CNAME" and .name=="business") | .id' | head -n1)
        doctl compute domain records update "$DOMAIN" "$BUSINESS_ID" --record-data "cname.vercel-dns.com" --record-ttl "$TTL"
    else
        doctl compute domain records create "$DOMAIN" --record-type "CNAME" --record-name "business" --record-data "cname.vercel-dns.com" --record-ttl "$TTL"
    fi
    echo "Updated business CNAME"
else
    echo "business CNAME already correct"
fi

# enterprise -> cname.vercel-dns.com
CURRENT_ENTERPRISE=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="CNAME" and .name=="enterprise") | .data' | head -n1)
if [[ "$CURRENT_ENTERPRISE" != "cname.vercel-dns.com" ]]; then
    if [[ -n "$CURRENT_ENTERPRISE" ]]; then
        ENTERPRISE_ID=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="CNAME" and .name=="enterprise") | .id' | head -n1)
        doctl compute domain records update "$DOMAIN" "$ENTERPRISE_ID" --record-data "cname.vercel-dns.com" --record-ttl "$TTL"
    else
        doctl compute domain records create "$DOMAIN" --record-type "CNAME" --record-name "enterprise" --record-data "cname.vercel-dns.com" --record-ttl "$TTL"
    fi
    echo "Updated enterprise CNAME"
else
    echo "enterprise CNAME already correct"
fi

# admin -> cname.vercel-dns.com
CURRENT_ADMIN=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="CNAME" and .name=="admin") | .data' | head -n1)
if [[ "$CURRENT_ADMIN" != "cname.vercel-dns.com" ]]; then
    if [[ -n "$CURRENT_ADMIN" ]]; then
        ADMIN_ID=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="CNAME" and .name=="admin") | .id' | head -n1)
        doctl compute domain records update "$DOMAIN" "$ADMIN_ID" --record-data "cname.vercel-dns.com" --record-ttl "$TTL"
    else
        doctl compute domain records create "$DOMAIN" --record-type "CNAME" --record-name "admin" --record-data "cname.vercel-dns.com" --record-ttl "$TTL"
    fi
    echo "Updated admin CNAME"
else
    echo "admin CNAME already correct"
fi

# personal -> ghs.googlehosted.com (Firebase)
CURRENT_PERSONAL=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="CNAME" and .name=="personal") | .data' | head -n1)
if [[ "$CURRENT_PERSONAL" != "ghs.googlehosted.com" ]]; then
    if [[ -n "$CURRENT_PERSONAL" ]]; then
        PERSONAL_ID=$(doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | select(.type=="CNAME" and .name=="personal") | .id' | head -n1)
        doctl compute domain records update "$DOMAIN" "$PERSONAL_ID" --record-data "ghs.googlehosted.com" --record-ttl "$TTL"
    else
        doctl compute domain records create "$DOMAIN" --record-type "CNAME" --record-name "personal" --record-data "ghs.googlehosted.com" --record-ttl "$TTL"
    fi
    echo "Updated personal CNAME"
else
    echo "personal CNAME already correct"
fi

echo -e "\nFinal DNS records:"
doctl compute domain records list "$DOMAIN" --output json | jq -r '.[] | "\(.type)\t\(.name)\t->\t\(.data)"'
