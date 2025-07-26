#!/bin/bash

# App-Oint Next.js Deployment Script
# This script builds and prepares both admin and marketing Next.js applications for production

set -e

echo "🚀 Starting App-Oint Next.js Deployment Build..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Build Admin Application
print_status "Building Admin Application..."
cd admin
npm ci --only=production
npm run build

if [ $? -eq 0 ]; then
    print_status "✅ Admin application built successfully"
    ADMIN_BUILD_SIZE=$(du -sh .next | cut -f1)
    print_status "Admin build size: $ADMIN_BUILD_SIZE"
else
    print_error "❌ Admin application build failed"
    exit 1
fi

cd ..

# Build Marketing Application  
print_status "Building Marketing Application..."
cd marketing
npm ci --only=production
npm run build

if [ $? -eq 0 ]; then
    print_status "✅ Marketing application built successfully"
    MARKETING_BUILD_SIZE=$(du -sh .next | cut -f1)
    print_status "Marketing build size: $MARKETING_BUILD_SIZE"
else
    print_error "❌ Marketing application build failed"
    exit 1
fi

cd ..

# Create deployment summary
print_status "📊 Deployment Summary:"
echo "REDACTED_TOKEN"
echo "✅ Admin App:      READY FOR DEPLOYMENT"
echo "   Build Size:     $ADMIN_BUILD_SIZE"
echo "   Output Mode:    Standalone"
echo ""
echo "✅ Marketing App:  READY FOR DEPLOYMENT" 
echo "   Build Size:     $MARKETING_BUILD_SIZE"
echo "   Output Mode:    Standalone"
echo "   i18n Support:   6 languages (en, es, fr, de, he, ar)"
echo "REDACTED_TOKEN"

print_status "🎉 Both Next.js applications are production-ready!"
print_status "Deploy using your preferred hosting platform (Vercel, DigitalOcean, AWS, etc.)"

# Create deployment artifacts
print_status "Creating deployment artifacts..."
mkdir -p deployment-artifacts

# Admin app
tar -czf deployment-artifacts/admin-app.tar.gz -C admin .next standalone.tar.gz 2>/dev/null || tar -czf deployment-artifacts/admin-app.tar.gz -C admin .next
print_status "Admin deployment artifact: deployment-artifacts/admin-app.tar.gz"

# Marketing app  
tar -czf deployment-artifacts/marketing-app.tar.gz -C marketing .next standalone.tar.gz 2>/dev/null || tar -czf deployment-artifacts/marketing-app.tar.gz -C marketing .next
print_status "Marketing deployment artifact: deployment-artifacts/marketing-app.tar.gz"

print_status "🚀 Deployment script completed successfully!"