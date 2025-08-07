#!/bin/bash

# App-Oint Business Studio Deployment Script
# Target: business.app-oint.com

echo "🚀 Deploying App-Oint Business Studio..."

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from the business directory."
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build the project
echo "🔨 Building the project..."
npm run build

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "🎯 Next steps:"
    echo "1. Deploy the .next folder to your hosting provider"
    echo "2. Configure your domain: business.app-oint.com"
    echo "3. Set up environment variables if needed"
    echo ""
    echo "📁 Build output: .next/"
    echo "🌐 Target domain: https://business.app-oint.com"
else
    echo "❌ Build failed. Please check the error messages above."
    exit 1
fi

echo "✨ Deployment script completed!" 