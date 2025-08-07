#!/bin/bash

echo "🏗️ Building Enterprise Portal for Production"
echo "=========================================="

# Load environment variables
if [ -f .env.production ]; then
    export $(cat .env.production | grep -v '^#' | xargs)
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install --production

# Security checks
echo "🔍 Running security checks..."
npm audit --audit-level moderate

# Build process
echo "🔨 Building application..."
npm run build

# Create production directory
echo "📁 Creating production directory..."
mkdir -p dist
cp -r *.html dist/
cp -r *.js dist/
cp -r *.css dist/
cp -r assets dist/ 2>/dev/null || true

# Security hardening
echo "🛡️ Applying security hardening..."
# Remove development files
rm -rf dist/node_modules
rm -rf dist/.env
rm -rf dist/*.log

echo "✅ Production build complete!"
echo "📁 Output: dist/"
echo "🚀 To run: cd dist && node server.js"
