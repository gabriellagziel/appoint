#!/bin/bash

echo "🚀 Quick Start - Perfect Readiness QA Kit"
echo "=========================================="

# Step 1: Copy environment files
echo ""
echo "📝 Step 1: Setting up environment files..."
for app in marketing business enterprise-app admin; do
  if [ -f "$app/env.local.example" ]; then
    cp "$app/env.local.example" "$app/.env.local"
    echo "✅ Created $app/.env.local"
  else
    echo "⚠️  $app/env.local.example not found"
  fi
done

# Step 2: Verify health endpoints
echo ""
echo "🏥 Step 2: Verifying health endpoints..."
for app in marketing business enterprise-app admin; do
  if [ -f "$app/pages/api/health.js" ]; then
    echo "✅ $app health endpoint exists"
  else
    echo "❌ $app health endpoint missing"
  fi
done

# Step 3: Check Flutter build
echo ""
echo "📱 Step 3: Checking Flutter build..."
if [ -f "appoint/build/web/health.txt" ]; then
  echo "✅ Flutter web build exists with health.txt"
else
  echo "⚠️  Flutter build missing - will build during QA"
fi

# Step 4: Verify ports are free
echo ""
echo "🔌 Step 4: Checking port availability..."
for port in 3000 3001 3002 3003 3020; do
  if lsof -i :$port >/dev/null 2>&1; then
    echo "❌ Port $port is in use"
  else
    echo "✅ Port $port is free"
  fi
done

# Step 5: Ready to run
echo ""
echo "🎯 Ready to run the complete QA suite!"
echo ""
echo "Next command:"
echo "npm run qa:all"
echo ""
echo "This will:"
echo "- Build all applications"
echo "- Start servers on configured ports"
echo "- Run comprehensive tests"
echo "- Generate detailed reports"
echo ""
echo "Expected duration: 5-10 minutes"
echo "Artifacts: qa/output/ and qa/FINAL_UI_UX_QA_REPORT.md"
