#!/bin/bash

# DigitalOcean Environment Setup Script
# This script helps you set up the DigitalOcean API token as an environment variable

echo "🔐 Setting up DigitalOcean environment..."

# Prompt for DigitalOcean API token
echo "Please enter your DigitalOcean API token:"
read -s DO_API_TOKEN

if [ -z "$DO_API_TOKEN" ]; then
    echo "❌ DigitalOcean API token is required"
    exit 1
fi

# Add to shell profile
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_PROFILE="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_PROFILE="$HOME/.bashrc"
else
    SHELL_PROFILE="$HOME/.profile"
fi

# Check if already exists
if grep -q "DO_API_TOKEN" "$SHELL_PROFILE"; then
    echo "✅ DigitalOcean API token already configured in $SHELL_PROFILE"
else
    echo "📝 Adding DigitalOcean API token to $SHELL_PROFILE"
    echo "" >> "$SHELL_PROFILE"
    echo "# DigitalOcean API Token" >> "$SHELL_PROFILE"
    echo "export DO_API_TOKEN='$DO_API_TOKEN'" >> "$SHELL_PROFILE"
fi

# Set for current session
export DO_API_TOKEN="$DO_API_TOKEN"

echo "✅ DigitalOcean environment setup complete!"
echo "🔑 API Token: ${DO_API_TOKEN:0:10}..."
echo ""
echo "🚀 You can now run: ./scripts/deploy_digitalocean.sh"
echo "💡 Or restart your terminal to load the environment variable automatically" 