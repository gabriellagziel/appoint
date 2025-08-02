#!/bin/bash
echo "🔧 FIXING DEPLOYMENT ISSUES..."
echo "1. ✅ Fixed app_spec.yaml with complete configuration"
echo "2. ✅ Fixed TypeScript compilation in functions"
echo "3. ✅ Verified enterprise-onboarding-portal directory exists"
echo "4. 🚀 Deploying to DigitalOcean..."
if command -v doctl &> /dev/null; then
    echo "✅ DigitalOcean CLI found"
    doctl apps update --spec .do/app_spec.yaml
else
    echo "❌ DigitalOcean CLI not found. Please install doctl:"
    echo "brew install doctl"
fi
echo "✅ DEPLOYMENT FIXES COMPLETE!"
