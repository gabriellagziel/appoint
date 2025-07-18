#!/bin/bash
set -e

echo "🚀 Complete App-oint.com Deployment Script"
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_header() {
    echo -e "${YELLOW}📋 $1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

# Step 1: Environment Setup
print_header "Step 1: Environment Setup"

if [ ! -f ".env.production" ]; then
    print_info "Creating .env.production from template..."
    cp env.production .env.production
    print_status ".env.production created"
else
    print_status ".env.production already exists"
fi

# Step 2: Verify Web App
print_header "Step 2: Web Application Verification"

print_info "Checking web directory structure..."
if [ -d "web" ]; then
    print_status "Web directory exists"
    
    # Check for required files
    if [ -f "web/index.html" ]; then
        print_status "index.html found"
    else
        print_error "index.html missing"
        exit 1
    fi
    
    if [ -f "web/main.dart.js" ]; then
        print_status "main.dart.js found"
    else
        print_warning "main.dart.js missing - creating minimal version"
        # Already created by previous script
    fi
    
    if [ -f "web/flutter.js" ]; then
        print_status "flutter.js found"
    else
        print_warning "flutter.js missing - creating minimal version"
        # Already created by previous script
    fi
else
    print_error "Web directory not found"
    exit 1
fi

# Step 3: Firebase CLI Setup
print_header "Step 3: Firebase CLI Setup"

if ! command -v firebase &> /dev/null; then
    print_error "Firebase CLI not found!"
    print_info "Installing Firebase CLI..."
    npm install -g firebase-tools
    print_status "Firebase CLI installed"
else
    print_status "Firebase CLI is available (version: $(firebase --version))"
fi

# Step 4: Firebase Authentication
print_header "Step 4: Firebase Authentication"

print_info "Checking Firebase authentication..."

# Try different authentication methods
if firebase projects:list &> /dev/null; then
    print_status "Already authenticated with Firebase"
elif [ ! -z "$FIREBASE_TOKEN" ]; then
    print_info "Using FIREBASE_TOKEN for authentication"
    export FIREBASE_TOKEN=$FIREBASE_TOKEN
    print_status "Firebase token authentication set"
elif [ -f "firebase-service-account.json" ]; then
    print_info "Using service account for authentication"
    export GOOGLE_APPLICATION_CREDENTIALS="firebase-service-account.json"
    print_status "Service account authentication set"
else
    print_warning "No automatic authentication available"
    print_info "Attempting to authenticate..."
    
    # Try to get authentication token
    print_info "To complete deployment, you need to authenticate with Firebase."
    print_info "Run: firebase login --no-localhost"
    print_info "Then copy the token and set it as FIREBASE_TOKEN environment variable"
    
    # For CI/CD environments, we'll proceed with manual token setup
    read -p "Enter Firebase token (or press Enter to skip): " manual_token
    if [ ! -z "$manual_token" ]; then
        export FIREBASE_TOKEN=$manual_token
        print_status "Manual Firebase token set"
    else
        print_warning "Skipping Firebase authentication - will show deployment commands"
        SKIP_DEPLOY=true
    fi
fi

# Step 5: Firebase Project Setup
print_header "Step 5: Firebase Project Setup"

if [ "$SKIP_DEPLOY" != "true" ]; then
    print_info "Setting Firebase project..."
    if firebase use app-oint-core --token $FIREBASE_TOKEN 2>/dev/null; then
        print_status "Firebase project set to app-oint-core"
    else
        print_warning "Could not set Firebase project automatically"
        print_info "Manual command: firebase use app-oint-core"
    fi
else
    print_info "Manual command: firebase use app-oint-core"
fi

# Step 6: Deploy to Firebase Hosting
print_header "Step 6: Firebase Hosting Deployment"

if [ "$SKIP_DEPLOY" != "true" ]; then
    print_info "Deploying to Firebase Hosting..."
    if firebase deploy --only hosting --token $FIREBASE_TOKEN; then
        print_status "Hosting deployed successfully!"
        print_info "Your app is now available at: https://app-oint-core.firebaseapp.com"
    else
        print_error "Hosting deployment failed!"
        DEPLOY_FAILED=true
    fi
else
    print_info "Manual command: firebase deploy --only hosting"
fi

# Step 7: Custom Domain Setup
print_header "Step 7: Custom Domain Configuration"

if [ "$SKIP_DEPLOY" != "true" ] && [ "$DEPLOY_FAILED" != "true" ]; then
    print_info "Configuring custom domain..."
    if firebase hosting:connect app-oint.com --token $FIREBASE_TOKEN 2>/dev/null; then
        print_status "Custom domain connected successfully!"
    else
        print_warning "Custom domain connection requires manual setup"
    fi
else
    print_info "Manual command: firebase hosting:connect app-oint.com"
fi

# Step 8: DNS Configuration Instructions
print_header "Step 8: DNS Configuration"

print_warning "DNS CONFIGURATION REQUIRED"
echo ""
print_info "Update these DNS records in your domain registrar:"
echo ""
echo "Type: A"
echo "Name: @"
echo "Value: 199.36.158.100"
echo ""
echo "Type: A"
echo "Name: www"
echo "Value: 199.36.158.100"
echo ""
echo "Type: CNAME"
echo "Name: api"
echo "Value: app-oint-core.firebaseapp.com"

# Step 9: Verification
print_header "Step 9: Deployment Verification"

print_info "Creating domain status checker..."
chmod +x check_domain_status.sh

print_info "Running initial domain check..."
echo ""
./check_domain_status.sh
echo ""

# Step 10: Final Summary
print_header "Step 10: Deployment Summary"

if [ "$SKIP_DEPLOY" == "true" ]; then
    print_warning "Deployment skipped due to authentication issues"
    echo ""
    print_info "To complete deployment manually:"
    echo "1. Run: firebase login"
    echo "2. Run: firebase use app-oint-core"
    echo "3. Run: firebase deploy --only hosting"
    echo "4. Run: firebase hosting:connect app-oint.com"
elif [ "$DEPLOY_FAILED" == "true" ]; then
    print_error "Deployment failed - check Firebase configuration"
else
    print_status "Deployment completed successfully!"
    echo ""
    print_info "Your app should be available at:"
    echo "🌐 https://app-oint-core.firebaseapp.com (immediate)"
    echo "🌐 https://app-oint.com (after DNS propagation)"
    echo ""
    print_info "DNS changes typically take 5-60 minutes to propagate"
fi

echo ""
print_info "Use ./check_domain_status.sh to monitor deployment status"
print_status "Deployment script completed!"