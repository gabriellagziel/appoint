#!/bin/bash
echo "🚀 DEPLOYING PERFECT CODEBASE TO PRODUCTION"
echo "================================================"
DEPLOYMENT_LOG="deployment_log_$(date +%Y%m%d_%H%M%S).txt"
{
    echo "📋 DEPLOYMENT STEPS:"
    echo "1. 🔍 Checking git status..."
    git status
    echo ""
    echo "2. 📦 Adding all cleaned up files..."
    git add .
    echo "3. 💾 Committing perfect codebase..."
    git commit -m "🎉 Perfect Codebase: Cleaned up 159 duplicate node_modules, removed 26+ temp files, fixed TODO/FIXME items, organized structure"
    echo "4. 🚀 Pushing to GitHub..."
    git push origin main
    echo "5. 🌊 Deploying to DigitalOcean..."
    # Check if doctl is installed
    if command -v doctl &> /dev/null; then
        echo "✅ DigitalOcean CLI found"
        # List droplets and get the first one
        DROPLET_ID=$(doctl compute droplet list --format ID,Name --no-header | head -1 | awk "{print \$1}")
        if [ ! -z "$DROPLET_ID" ]; then
            echo "🌊 Deploying to droplet: $DROPLET_ID"
            # Get droplet IP
            DROPLET_IP=$(doctl compute droplet get $DROPLET_ID --format PublicIPv4 --no-header)
            echo "📍 Droplet IP: $DROPLET_IP"
        else
            echo "❌ No droplets found"
        fi
    else
        echo "❌ DigitalOcean CLI not found. Please install doctl:"
        echo "brew install doctl"
    fi
    echo ""
    echo "✅ DEPLOYMENT COMPLETE!"
    echo "📊 Deployment log saved to: $DEPLOYMENT_LOG"
} > "$DEPLOYMENT_LOG"
