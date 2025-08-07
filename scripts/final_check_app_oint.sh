#!/bin/bash

# Function to get SSL certificate info
get_ssl_info() {
    local hostname=$1
    local cert_info=$(echo | openssl s_client -servername "$hostname" -connect "$hostname:443" 2>/dev/null | openssl x509 -noout -issuer -dates 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        local issuer=$(echo "$cert_info" | grep "issuer=" | sed 's/issuer=//')
        local not_before=$(echo "$cert_info" | grep "notBefore=" | sed 's/notBefore=//')
        local not_after=$(echo "$cert_info" | grep "notAfter=" | sed 's/notAfter=//')
        
        echo "{\"issuer\":\"$issuer\",\"valid_from\":\"$not_before\",\"valid_until\":\"$not_after\"}"
    else
        echo "{\"error\":\"Failed to get SSL certificate\"}"
    fi
}

# Function to check a single path
check_path() {
    local path=$1
    local url="https://app-oint.com$path"
    
    echo "Checking $url..." >&2
    
    # Get HTTP status with SSL verification disabled
    local status_code=$(curl -k -s -w "%{http_code}" -o /dev/null "$url" 2>/dev/null)
    
    # Get page content
    local content=$(curl -k -s -L "$url" 2>/dev/null)
    
    # Extract title
    local title=$(echo "$content" | grep -o '<title[^>]*>[^<]*</title>' | sed 's/<[^>]*>//g' | head -1)
    if [ -z "$title" ]; then
        title="No title found"
    fi
    
    # Extract first heading (h1, h2, h3)
    local heading=$(echo "$content" | grep -o '<h[123][^>]*>[^<]*</h[123]>' | sed 's/<[^>]*>//g' | head -1)
    if [ -z "$heading" ]; then
        heading="No heading found"
    fi
    
    # Get SSL info
    local ssl_info=$(get_ssl_info "app-oint.com")
    
    # Create JSON output
    cat <<EOF
{
  "url": "$url",
  "http_status": $status_code,
  "redirects_to": null,
  "title": "$title",
  "heading": "$heading",
  "ssl": $ssl_info
}
EOF
}

# Check all paths concurrently
echo "Checking all app-oint.com paths concurrently..."

# Create temporary files for each path
check_path "/" > /tmp/root.json &
check_path "/business" > /tmp/business.json &
check_path "/admin" > /tmp/admin.json &
check_path "/enterprise" > /tmp/enterprise.json &

# Wait for all background processes to complete
wait

# Combine results
echo "{"
echo "  \"/\": $(cat /tmp/root.json),"
echo "  \"/business\": $(cat /tmp/business.json),"
echo "  \"/admin\": $(cat /tmp/admin.json),"
echo "  \"/enterprise\": $(cat /tmp/enterprise.json)"
echo "}"

# Clean up
rm -f /tmp/root.json /tmp/business.json /tmp/admin.json /tmp/enterprise.json 