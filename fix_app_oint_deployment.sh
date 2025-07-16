#!/bin/bash
set -e

echo "🔧 App-oint.com Deployment Fix Script"
echo "====================================="

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

# Step 1: Fix Flutter syntax errors
echo ""
print_info "Step 1: Fixing Flutter syntax errors..."

# Fix the onboarding screen syntax error
if grep -q "final _currentPage = = _pages.length" lib/features/onboarding/onboarding_screen.dart; then
    sed -i 's/final _currentPage = = _pages.length - 1/_currentPage == _pages.length - 1/' lib/features/onboarding/onboarding_screen.dart
    print_status "Fixed syntax error in onboarding_screen.dart"
fi

# Fix other common syntax errors
find . -name "*.dart" -type f -exec sed -i 's/} catch (e) {e) {/} catch (e) {/g' {} + 2>/dev/null || true
find . -name "*.dart" -type f -exec sed -i 's/} finally {e) {/} finally {/g' {} + 2>/dev/null || true

print_status "Flutter syntax errors fixed"

# Step 2: Install Flutter if not available
echo ""
print_info "Step 2: Checking Flutter installation..."

if ! command -v flutter &> /dev/null; then
    print_warning "Flutter not found. Installing Flutter..."
    
    # Install Flutter
    git clone https://github.com/flutter/flutter.git -b stable ./flutter
    export PATH="$PATH:$(pwd)/flutter/bin"
    echo 'export PATH="$PATH:$(pwd)/flutter/bin"' >> ~/.bashrc
    
    # Verify installation
    flutter doctor
    print_status "Flutter installed successfully"
else
    print_status "Flutter is already installed"
fi

# Step 3: Build the Flutter web app
echo ""
print_info "Step 3: Building Flutter web app..."

# Clean previous builds
rm -rf build/ 2>/dev/null || true

# Get dependencies
flutter pub get

# Build web app
flutter build web --release

# Verify build
if [ -f "build/web/index.html" ] && [ -f "build/web/main.dart.js" ]; then
    print_status "Flutter web build completed successfully"
else
    print_error "Flutter build failed. Check the errors above."
    exit 1
fi

# Step 4: Install Firebase CLI
echo ""
print_info "Step 4: Installing Firebase CLI..."

if ! command -v firebase &> /dev/null; then
    print_warning "Firebase CLI not found. Installing..."
    npm install -g firebase-tools
    print_status "Firebase CLI installed"
else
    print_status "Firebase CLI is already installed"
fi

# Step 5: Deploy to Firebase
echo ""
print_info "Step 5: Deploying to Firebase..."

# Check if user is authenticated
if ! firebase projects:list &> /dev/null; then
    print_warning "Firebase authentication required"
    echo ""
    echo "Please run: firebase login"
    echo "Then run this script again."
    echo ""
    print_info "Or use a token: export FIREBASE_TOKEN=your_token"
    exit 1
fi

# Set project and deploy
firebase use app-oint-core
firebase deploy --only hosting

print_status "Firebase deployment completed"

# Step 6: Fix domain issues
echo ""
print_info "Step 6: Fixing domain configuration..."

# Check current domain status
print_info "Current domain status:"
curl -I https://app-oint-core.firebaseapp.com 2>/dev/null | head -1 || print_warning "Firebase hosting not accessible"

# Connect custom domain
print_info "Connecting custom domain..."
if firebase hosting:connect app-oint.com --confirm 2>/dev/null; then
    print_status "Custom domain connected successfully"
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

# Step 7: DNS Configuration
echo ""
print_info "Step 7: DNS Configuration Required"
echo "======================================"
print_warning "You need to update DNS records in your domain registrar:"

echo ""
echo "Current nameservers (DigitalOcean):"
echo "ns1.digitalocean.com, ns2.digitalocean.com, ns3.digitalocean.com"
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

# Step 8: Testing
echo ""
print_info "Step 8: Testing deployment"
echo "=============================="

echo "Testing Firebase hosting..."
if curl -s https://app-oint-core.firebaseapp.com > /dev/null; then
    print_status "Firebase hosting is working"
else
    print_error "Firebase hosting is not accessible"
fi

echo ""
print_info "After DNS changes (takes 5-60 minutes), test with:"
echo "curl -I https://app-oint.com"
echo ""
echo "Expected result: HTTP/2 200"

echo ""
print_status "🎉 Deployment fix script completed!"
print_info "Complete the DNS changes above and your domain will work!"
print_info "Your app is now available at: https://app-oint-core.firebaseapp.com"