#!/bin/bash
set -e

echo "🚀 App-oint.com Domain Fix - Deployment Script"
echo "==============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    print_error "Firebase CLI not found!"
    exit 1
fi

print_status "Firebase CLI is available (version: $(firebase --version))"

# Check if user is authenticated
echo ""
print_info "Checking Firebase authentication..."
if firebase projects:list &> /dev/null; then
    print_status "Already authenticated with Firebase"
else
    print_warning "Not authenticated with Firebase"
    echo ""
    echo "Please run: firebase login"
    echo "Then run this script again."
    exit 1
fi

# Show current project
echo ""
print_info "Current Firebase project:"
firebase use --current

# Deploy hosting
echo ""
print_info "Deploying to Firebase Hosting..."
if firebase deploy --only hosting; then
    print_status "Hosting deployed successfully!"
    echo ""
    print_info "Your app is now available at:"
    echo "🌐 https://app-oint-core.firebaseapp.com"
else
    print_error "Hosting deployment failed!"
    exit 1
fi

# Try to connect custom domain (this might require additional setup)
echo ""
print_info "Attempting to connect custom domain..."
print_warning "This step might require additional verification in Firebase Console"

if firebase hosting:connect app-oint.com --confirm; then
    print_status "Custom domain connected!"
else
    print_warning "Custom domain connection needs manual setup"
    echo ""
    print_info "Manual steps for custom domain:"
    echo "1. Go to Firebase Console: https://console.firebase.google.com"
    echo "2. Select project: app-oint-core"
    echo "3. Go to Hosting → Add custom domain"
    echo "4. Enter: app-oint.com"
    echo "5. Follow the verification steps"
fi

echo ""
echo "🌐 DNS CONFIGURATION REQUIRED"
echo "============================="
print_warning "You need to update DNS records in your domain registrar/DigitalOcean:"

echo ""
echo "Current nameservers (DigitalOcean): ns1.digitalocean.com, ns2.digitalocean.com, ns3.digitalocean.com"
echo ""
echo "ADD THESE DNS RECORDS in DigitalOcean DNS:"
echo "Type: A"
echo "Name: @"
echo "Value: 199.36.158.100"
echo ""
echo "Type: A"
echo "Name: www"
echo "Value: 199.36.158.100"
echo ""
echo "Type: CNAME (for API subdomain)"
echo "Name: api"
echo "Value: app-oint-core.firebaseapp.com"

echo ""
echo "📊 TESTING"
echo "=========="
echo "After DNS changes (takes 5-60 minutes), test with:"
echo "curl -I https://app-oint.com"
echo ""
echo "Expected result: HTTP/2 200"

echo ""
print_status "Deployment script completed!"
print_info "Complete the DNS changes above and your domain will work!"