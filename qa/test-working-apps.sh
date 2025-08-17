#!/bin/bash

echo "🧪 Testing Working Apps (Marketing, Business, Admin, Personal)"

# Start the working apps
echo "Starting apps..."
npm run qa:serve &
SERVE_PID=$!

echo "Waiting for apps to start..."
sleep 20

echo "Testing health endpoints..."
npm run qa:health

echo "Testing E2E for working apps..."
# Only test the working apps
npx playwright test qa/tests/marketing.spec.ts qa/tests/business.spec.ts qa/tests/admin.spec.ts qa/tests/personal.spec.ts --config=qa/playwright.config.ts

echo "Running Lighthouse on working apps..."
npm run qa:lighthouse

echo "Running accessibility scan..."
npm run qa:axe

echo "Running i18n audit..."
npm run qa:i18n

echo "Running link crawl..."
npm run qa:links

echo "Generating report..."
npm run qa:report

# Cleanup
kill $SERVE_PID 2>/dev/null
echo "Test complete!"
