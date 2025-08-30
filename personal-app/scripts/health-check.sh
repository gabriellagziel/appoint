#!/usr/bin/env bash
set -euo pipefail

echo "🏥 App-Oint Health Check Script"
echo "================================"

# Check if server is running
if ! curl -s http://localhost:3000/ > /dev/null 2>&1; then
    echo "❌ Server not running on port 3000"
    echo "   Start with: pnpm dev:personal"
    exit 1
fi

echo "✅ Server running on port 3000"
echo ""

# Test routes
echo "🔍 Testing Routes:"
echo "------------------"

# Test root redirect
echo -n "GET / → 307 → /en: "
if curl -sI http://localhost:3000/ | grep -q "307"; then
    echo "✅ OK"
else
    echo "❌ FAIL"
fi

# Test health redirect
echo -n "GET /health → 307 → /en/health: "
if curl -sI http://localhost:3000/health | grep -q "307"; then
    echo "✅ OK"
else
    echo "❌ FAIL"
fi

# Test locale health
echo -n "GET /en/health → 200: "
if curl -sI http://localhost:3000/en/health | grep -q "200"; then
    echo "✅ OK"
else
    echo "❌ FAIL"
    exit 1
fi

# Test main locale page
echo -n "GET /en → 200: "
if curl -sI http://localhost:3000/en | grep -q "200"; then
    echo "✅ OK"
else
    echo "❌ FAIL"
    exit 1
fi

# Test other routes
echo -n "GET /en/test → 200: "
if curl -sI http://localhost:3000/en/test | grep -q "200"; then
    echo "✅ OK"
else
    echo "❌ FAIL"
    exit 1
fi

echo -n "GET /en/settings → 200: "
if curl -sI http://localhost:3000/en/settings | grep -q "200"; then
    echo "✅ OK"
else
    echo "❌ FAIL"
    exit 1
fi

echo ""
echo "🎯 App Router Status:"
echo "---------------------"

# Check if App Router is active (no Pages Router references)
if curl -s http://localhost:3000/en/health | grep -q "app-pages-internals.js"; then
    echo "✅ App Router Active"
else
    echo "❌ App Router Not Active"
    exit 1
fi

# Check if Pages Router is disabled (no pages references)
if curl -s http://localhost:3000/en/health | grep -q "pages/_app.js"; then
    echo "❌ Pages Router Still Active"
    exit 1
else
    echo "✅ Pages Router Disabled"
fi

echo ""
echo "🚀 Health Check Complete!"
