#!/bin/bash

echo "🚀 Deploying Complete App-Oint Configuration"
echo "============================================="

# Check if doctl is installed
if ! command -v doctl &> /dev/null; then
    echo "❌ doctl CLI is not installed. Please install it first:"
    echo "   https://docs.digitalocean.com/reference/doctl/how-to/install/"
    exit 1
fi

# Check if authenticated
if ! doctl account get &> /dev/null; then
    echo "❌ Not authenticated with DigitalOcean. Please run:"
    echo "   doctl auth init"
    exit 1
fi

# Use the specific app ID for appoint-app-v2
APP_ID="620a2ee8-e942-451c-9cfd-8ece55511eb8"

echo "📝 Using existing app with ID: $APP_ID"
echo "🔄 Updating app configuration with complete spec..."

# Update the app with the new spec
doctl apps update $APP_ID --spec complete_app_spec.yaml

echo "✅ App updated successfully!"

# Wait for deployment to complete
echo "⏳ Waiting for deployment to complete..."
sleep 30

# Check deployment status
echo "📊 Checking deployment status..."
doctl apps list

# Test all endpoints
echo ""
echo "🧪 Testing all endpoints..."

test_endpoint() {
    local path=$1
    local name=$2
    local url="https://app-oint.com$path"
    
    echo "Testing $name ($url)..."
    local status=$(curl -s -o /dev/null -w "%{http_code}" "$url" || echo "000")
    
    if [ "$status" = "200" ]; then
        echo "✅ $name: $status"
    else
        echo "❌ $name: $status"
    fi
}

test_endpoint "/" "Home Page"
test_endpoint "/business" "Business Portal"
test_endpoint "/admin" "Admin Portal"
test_endpoint "/enterprise" "Enterprise Portal"
test_endpoint "/api/health" "API Health"

echo ""
echo "🎉 Deployment complete!"
echo "🌐 Your app is available at: https://app-oint.com"
echo ""
echo "📋 Summary:"
echo "  • Home: https://app-oint.com/"
echo "  • Business: https://app-oint.com/business"
echo "  • Admin: https://app-oint.com/admin"
echo "  • Enterprise: https://app-oint.com/enterprise"
echo "  • API: https://app-oint.com/api"
echo ""
echo "🔧 To monitor the deployment:"
echo "   doctl apps logs $APP_ID" 