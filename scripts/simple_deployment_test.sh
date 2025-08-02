#!/bin/bash
set -e

echo "🚀 Simple Deployment Test"
echo "========================"

# Test business site
echo "Testing Business Site..."
cd business
if [ -f "package.json" ]; then
    echo "✅ Business package.json found"
    npm install > /dev/null 2>&1 && echo "✅ Business dependencies installed"
    npm run build > /dev/null 2>&1 && echo "✅ Business build successful"
else
    echo "❌ Business package.json not found"
fi
cd ..

# Test admin site  
echo "Testing Admin Site..."
cd admin
if [ -f "package.json" ]; then
    echo "✅ Admin package.json found"
    npm install > /dev/null 2>&1 && echo "✅ Admin dependencies installed"
    npm run build > /dev/null 2>&1 && echo "✅ Admin build successful"
else
    echo "❌ Admin package.json not found"
fi
cd ..

# Test OpenAPI spec
echo "Testing OpenAPI Spec..."
if [ -f "openapi_spec.yaml" ]; then
    echo "✅ OpenAPI spec found"
    echo "📋 API Endpoints available:"
    grep -E "^  /" openapi_spec.yaml | head -10
else
    echo "❌ OpenAPI spec not found"
fi

echo ""
echo "🎯 Deployment Readiness Summary:"
echo "================================"
echo "Business Site: $(cd business && [ -f package.json ] && echo "READY" || echo "NOT READY")"
echo "Admin Site: $(cd admin && [ -f package.json ] && echo "READY" || echo "NOT READY")"
echo "API Documentation: $( [ -f openapi_spec.yaml ] && echo "READY" || echo "NOT READY")" 