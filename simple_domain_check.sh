#!/bin/bash

echo "🔍 Verifying Domain Configuration for app-oint.com"
echo "=================================================="

# Get the DigitalOcean App Platform endpoint
DO_APP_URL="https://app-oint-marketing-cqznb.ondigitalocean.app"

# Function to check DNS records
check_dns() {
    local domain=$1
    echo "Checking DNS for $domain..."
    
    # Get A records
    local a_records=$(dig +short $domain A 2>/dev/null | tr '\n' ' ')
    
    # Get CNAME records
    local cname_records=$(dig +short $domain CNAME 2>/dev/null | tr '\n' ' ')
    
    if [ -n "$a_records" ] || [ -n "$cname_records" ]; then
        echo "✅ DNS configured"
        echo "   A records: $a_records"
        echo "   CNAME records: $cname_records"
        return 0
    else
        echo "❌ DNS not configured"
        return 1
    fi
}

# Function to check SSL certificate
check_ssl() {
    local domain=$1
    echo "Checking SSL for $domain..."
    
    local cert_info=$(echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null | openssl x509 -noout -issuer -dates 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo "✅ SSL valid"
        echo "   $cert_info"
        return 0
    else
        echo "❌ SSL invalid or not configured"
        return 1
    fi
}

# Function to check HTTP status
check_http() {
    local url=$1
    local path=$2
    echo "Checking HTTP status for $url..."
    
    local status=$(curl -k -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
    echo "   Status: $status"
    
    if [ "$status" = "200" ]; then
        echo "✅ HTTP 200 OK"
        return 0
    else
        echo "❌ HTTP $status"
        return 1
    fi
}

# Check each path
paths=("/" "/business" "/admin" "/enterprise")

echo "📊 Results Summary:"
echo "==================="

for path in "${paths[@]}"; do
    echo ""
    echo "🔗 Path: $path"
    echo "   URL: https://app-oint.com$path"
    echo "   DO App URL: $DO_APP_URL$path"
    echo ""
    
    # Check DNS
    dns_configured=false
    if check_dns "app-oint.com"; then
        dns_configured=true
    fi
    
    # Check SSL
    ssl_valid=false
    if check_ssl "app-oint.com"; then
        ssl_valid=true
    fi
    
    # Check HTTP status
    http_status=$(curl -k -s -o /dev/null -w "%{http_code}" "https://app-oint.com$path" 2>/dev/null || echo "000")
    
    # Check DO App status
    do_status=$(curl -k -s -o /dev/null -w "%{http_code}" "$DO_APP_URL$path" 2>/dev/null || echo "000")
    
    echo ""
    echo "📋 Summary for $path:"
    echo "   Domain configured: $dns_configured"
    echo "   SSL valid: $ssl_valid"
    echo "   Custom domain status: $http_status"
    echo "   DO App status: $do_status"
    echo "   DO App endpoint: $DO_APP_URL"
    echo "---"
done

echo ""
echo "🎯 Final Analysis:"
echo "=================="

# Check if custom domain points to DO app
custom_domain_ip=$(dig +short app-oint.com A 2>/dev/null | head -1)
do_app_ip=$(dig +short app-oint-marketing-cqznb.ondigitalocean.app A 2>/dev/null | head -1)

echo "Custom domain IP: $custom_domain_ip"
echo "DO App IP: $do_app_ip"

if [ "$custom_domain_ip" = "$do_app_ip" ]; then
    echo "✅ Custom domain points to DO App"
else
    echo "❌ Custom domain does NOT point to DO App"
    echo "   Custom domain needs to be configured in DO App Platform"
fi 