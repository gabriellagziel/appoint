#!/bin/bash

echo "🚀 Deploying App-Oint White Screen Fix"
echo "======================================="

# Check if we're on the right branch
current_branch=$(git branch --show-current)
echo "Current branch: $current_branch"

# Add all changes
echo "📦 Adding changes..."
git add .

# Commit the fix
echo "💾 Committing fix..."
git commit -m "Fix web build: Add proper Flutter build and Firebase config - Resolves white screen issue"

# Push to main branch
echo "🚀 Pushing to main branch..."
git push origin main

echo ""
echo "✅ Deployment initiated!"
echo ""
echo "📋 Next steps:"
echo "1. Check DigitalOcean App Platform for deployment status"
echo "2. Visit www.app-oint.com to verify the fix"
echo "3. Monitor logs for any issues"
echo ""
echo "🔗 DigitalOcean App Platform: https://cloud.digitalocean.com/apps"
echo "🌐 Website: https://www.app-oint.com"