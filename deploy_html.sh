#!/bin/bash
echo "🚀 Deploying App-Oint HTML Solution to Firebase..."

# Install Firebase CLI if not available
if ! command -v firebase &> /dev/null; then
    echo "Installing Firebase CLI..."
    npm install -g firebase-tools
fi

# Check if user is authenticated
if ! firebase projects:list &> /dev/null; then
    echo "Please authenticate with Firebase:"
    echo "firebase login"
    exit 1
fi

# Set project
firebase use app-oint-core

# Deploy
firebase deploy --only hosting

echo "✅ HTML solution deployed successfully!"
echo "🌐 Your app is now available at: https://app-oint-core.firebaseapp.com"
echo "🔗 Custom domain will be available at: https://app-oint.com (after DNS setup)"
