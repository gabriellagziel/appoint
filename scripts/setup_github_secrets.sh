#!/bin/bash

# GitHub Actions Secrets Setup Script for AppOint
# This script helps you set up the required secrets for the CI/CD workflow

set -e

echo "🔧 AppOint GitHub Actions Secrets Setup"
echo "======================================"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo "Please install it from: https://cli.github.com/"
    echo ""
    echo "On macOS: brew install gh"
    echo "On Ubuntu: sudo apt install gh"
    echo "On Windows: winget install GitHub.cli"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ You are not authenticated with GitHub CLI."
    echo "Please run: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI is installed and authenticated"
echo ""

# Get repository name
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
echo "📦 Repository: $REPO"
echo ""

echo "🔐 Setting up GitHub Secrets..."
echo ""

# Function to set secret
set_secret() {
    local secret_name=$1
    local description=$2
    local current_value=""
    
    echo "Setting up: $secret_name"
    echo "Description: $description"
    
    # Check if secret already exists
    if gh secret list | grep -q "$secret_name"; then
        echo "⚠️  Secret '$secret_name' already exists"
        read -p "Do you want to update it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "⏭️  Skipping $secret_name"
            echo ""
            return
        fi
    fi
    
    # Get secret value
    read -s -p "Enter value for $secret_name: " secret_value
    echo
    
    if [ -z "$secret_value" ]; then
        echo "⚠️  Empty value provided, skipping $secret_name"
        echo ""
        return
    fi
    
    # Set the secret
    echo "$secret_value" | gh secret set "$secret_name" --repo "$REPO"
    echo "✅ Secret '$secret_name' set successfully"
    echo ""
}

# Core secrets
echo "🔑 Core Secrets"
echo "---------------"
set_secret "GHE_ENTERPRISE" "GitHub Enterprise hostname (e.g., github.company.com) - leave empty if using github.com"
set_secret "GHE_TOKEN" "GitHub Enterprise personal access token - leave empty if using github.com"
set_secret "FIREBASE_TOKEN" "Firebase CLI token for deployment"

# Firebase App Distribution secrets
echo "📱 Firebase App Distribution Secrets"
echo "REDACTED_TOKEN"
set_secret "FIREBASE_APP_ID" "Firebase Android app ID"
set_secret "FIREBASE_IOS_APP_ID" "Firebase iOS app ID"

# Optional secrets
echo "📊 Optional Secrets"
echo "------------------"
set_secret "CODECOV_TOKEN" "Codecov token for coverage reporting (optional)"

echo "🎉 Secrets setup complete!"
echo ""
echo "📋 Summary of secrets to configure:"
echo ""

# Display summary
echo "Required secrets:"
if gh secret list | grep -q "FIREBASE_TOKEN"; then
    echo "  ✅ FIREBASE_TOKEN"
else
    echo "  ❌ FIREBASE_TOKEN"
fi

if gh secret list | grep -q "FIREBASE_APP_ID"; then
    echo "  ✅ FIREBASE_APP_ID"
else
    echo "  ❌ FIREBASE_APP_ID"
fi

if gh secret list | grep -q "FIREBASE_IOS_APP_ID"; then
    echo "  ✅ FIREBASE_IOS_APP_ID"
else
    echo "  ❌ FIREBASE_IOS_APP_ID"
fi

echo ""
echo "Optional secrets:"
if gh secret list | grep -q "GHE_ENTERPRISE"; then
    echo "  ✅ GHE_ENTERPRISE"
else
    echo "  ⚪ GHE_ENTERPRISE (optional)"
fi

if gh secret list | grep -q "GHE_TOKEN"; then
    echo "  ✅ GHE_TOKEN"
else
    echo "  ⚪ GHE_TOKEN (optional)"
fi

if gh secret list | grep -q "CODECOV_TOKEN"; then
    echo "  ✅ CODECOV_TOKEN"
else
    echo "  ⚪ CODECOV_TOKEN (optional)"
fi

echo ""
echo "📚 Next steps:"
echo "1. Push a commit to trigger the CI/CD workflow"
echo "2. Monitor the workflow in GitHub Actions tab"
echo "3. Check the workflow logs for any issues"
echo ""
echo "📖 For more information, see: .github/workflows/README.md" 