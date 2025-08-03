#!/bin/bash

set -e

echo "🚀 Deploying Admin Panel to DigitalOcean..."

# Navigate to admin directory
cd /Users/a/Desktop/ga/appoint/admin

echo "📦 Building production version..."
npm run build

echo "✅ Build completed successfully"

echo "🔧 Updating package.json for production..."
# Ensure we're using the standalone server
sed -i '' 's/"start": "next start -p 8082"/"start": "node .next\/standalone\/server.js"/' package.json

echo "📝 Committing changes..."
git add .
git commit -m "🚀 DEPLOY: Admin Panel Production Ready - Standalone Server"

echo "📤 Pushing to repository..."
git push origin main

echo "✅ Code pushed to repository"

echo "🌐 Deploying to DigitalOcean App Platform..."
echo "Note: You'll need to run this command manually:"
echo "doctl apps create --spec do-app-spec.yaml"

echo "✅ Deployment script completed!"
echo ""
echo "📋 Next steps:"
echo "1. Run: doctl apps create --spec do-app-spec.yaml"
echo "2. Configure environment variables in DigitalOcean dashboard"
echo "3. Set up custom domain: admin.app-oint.com"
echo "4. Test authentication and all admin features"
