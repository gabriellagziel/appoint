#!/bin/bash

echo "🔍 Verifying App-Oint Deployment"
echo "================================"

# Function to test an endpoint and extract information
test_endpoint() {
    local path=$1
    local name=$2
    local url="https://app-oint.com$path"
    
    echo "Testing $name..."
    echo "URL: $url"
    
    # Get HTTP status
    local status=$(curl -k -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
    echo "Status: $status"
    
    # Get content if status is 200
    if [ "$status" = "200" ]; then
        local content=$(curl -k -s -L "$url" 2>/dev/null)
        
        # Extract title
        local title=$(echo "$content" | grep -o '<title[^>]*>[^<]*</title>' | sed 's/<[^>]*>//g' | head -1)
        if [ -n "$title" ]; then
            echo "Title: $title"
        fi
        
        # Extract first heading
        local heading=$(echo "$content" | grep -o '<h[123][^>]*>[^<]*</h[123]>' | sed 's/<[^>]*>//g' | head -1)
        if [ -n "$heading" ]; then
            echo "Heading: $heading"
        fi
        
        echo "✅ $name is working correctly"
    else
        echo "❌ $name returned status $status"
    fi
    
    echo "---"
}

# Test all endpoints
test_endpoint "/" "Home Page"
test_endpoint "/business" "Business Portal"
test_endpoint "/admin" "Admin Portal"
test_endpoint "/enterprise" "Enterprise Portal"
test_endpoint "/api/health" "API Health"

echo "🎯 Verification complete!"
echo ""
echo "📊 Summary:"
echo "  • All paths should return 200 OK"
echo "  • Each should have appropriate title and heading"
echo "  • SSL certificate should be valid"
echo ""
echo "🔧 If any paths are failing, check:"
echo "   • DigitalOcean App Platform logs"
echo "   • Build status in the DO dashboard"
echo "   • Route configuration in app spec" 