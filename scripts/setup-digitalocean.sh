#!/bin/bash

# DigitalOcean App Platform Setup Script
# This script helps set up the DigitalOcean App Platform deployment

set -e

echo "🌊 Setting up DigitalOcean App Platform deployment..."

# Check if doctl is installed
if ! command -v doctl &> /dev/null; then
    echo "📦 Installing doctl..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install doctl
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -sL https://github.com/digitalocean/doctl/releases/latest/download/doctl-$(uname -s)-$(uname -m).tar.gz | tar -xzv
        sudo mv doctl /usr/local/bin
    else
        echo "❌ Unsupported OS. Please install doctl manually: https://github.com/digitalocean/doctl"
        exit 1
    fi
fi

# Set the DigitalOcean token
# DIGITALOCEAN_ACCESS_TOKEN should be set as environment variable
if [ -z "$DIGITALOCEAN_ACCESS_TOKEN" ]; then
    echo "❌ Error: DIGITALOCEAN_ACCESS_TOKEN environment variable is required"
    echo "Please set it before running this script"
    exit 1
fi

echo "🔑 Authenticating with DigitalOcean..."
doctl auth init --access-token $DIGITALOCEAN_ACCESS_TOKEN

echo "📋 Available regions:"
doctl apps list-regions

echo "🏗️ Creating DigitalOcean App Platform app..."
APP_ID=$(doctl apps create --spec do-app.yaml --format ID --no-header)

if [ -n "$APP_ID" ]; then
    echo "✅ App created successfully with ID: $APP_ID"
    echo "🔗 App URL: https://$APP_ID.ondigitalocean.app"
    
    # Save the app ID to a file for GitHub secrets
    echo "$APP_ID" > .do-app-id
    echo "📝 App ID saved to .do-app-id"
    echo ""
    echo "🔧 Next steps:"
    echo "1. Add DIGITALOCEAN_APP_ID=$APP_ID to your GitHub repository secrets"
    echo "2. Push to main branch to trigger deployment"
    echo "3. Monitor deployment at: https://cloud.digitalocean.com/apps/$APP_ID"
else
    echo "❌ Failed to create app"
    exit 1
fi

echo ""
echo "🎉 DigitalOcean App Platform setup complete!"
echo "📊 Monitor your app at: https://cloud.digitalocean.com/apps"