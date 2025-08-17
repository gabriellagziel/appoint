#!/bin/bash

echo "🧪 Testing QA Kit Setup..."

# Check if required files exist
echo "📁 Checking file structure..."
required_files=(
  "qa/apps.json"
  "qa/scripts/serve-all.mjs"
  "qa/scripts/health.mjs"
  "qa/scripts/lighthouse.mjs"
  "qa/scripts/axe-scan.mjs"
  "qa/scripts/i18n-audit.mjs"
  "qa/scripts/link-crawl.mjs"
  "qa/scripts/final-report.mjs"
  "qa/tests/personal.spec.ts"
  "qa/tests/marketing.spec.ts"
  "qa/tests/business.spec.ts"
  "qa/tests/enterprise.spec.ts"
  "qa/tests/admin.spec.ts"
  ".github/workflows/perfect-readiness.yml"
)

for file in "${required_files[@]}"; do
  if [ -f "$file" ]; then
    echo "✅ $file"
  else
    echo "❌ $file (missing)"
    exit 1
  fi
done

# Check if package.json has QA scripts
echo "📦 Checking package.json scripts..."
if grep -q "qa:" package.json; then
  echo "✅ QA scripts found in package.json"
else
  echo "❌ QA scripts missing from package.json"
  exit 1
fi

# Check if dependencies are installed
echo "🔧 Checking dependencies..."
if [ -d "node_modules" ]; then
  echo "✅ node_modules exists"
else
  echo "⚠️  node_modules not found - run 'npm install' first"
fi

echo ""
echo "🎉 QA Kit setup verification complete!"
echo ""
echo "Next steps:"
echo "1. Run 'npm install' to install dependencies"
echo "2. Add health endpoints to your apps"
echo "3. Test with 'npm run qa:health'"
echo "4. Run full suite with 'npm run qa:all'"
