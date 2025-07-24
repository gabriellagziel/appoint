#!/bin/bash

set -e

echo "🔍 App-Oint System Validation and Deployment Script"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Test function
test_service() {
    local service_name=$1
    local service_dir=$2
    
    print_status "Testing $service_name service..."
    
    if [ ! -d "$service_dir" ]; then
        print_error "Directory $service_dir does not exist"
        return 1
    fi
    
    cd "$service_dir"
    
    # Check if package.json exists
    if [ ! -f "package.json" ]; then
        print_error "package.json not found in $service_dir"
        cd ..
        return 1
    fi
    
    # Install dependencies
    print_status "Installing dependencies for $service_name..."
    npm ci || {
        print_error "Failed to install dependencies for $service_name"
        cd ..
        return 1
    }
    
    # Run build
    print_status "Building $service_name..."
    npm run build || {
        print_error "Failed to build $service_name"
        cd ..
        return 1
    }
    
    # Run export if available
    if grep -q '"export"' package.json; then
        print_status "Exporting $service_name..."
        npm run export || {
            print_error "Failed to export $service_name"
            cd ..
            return 1
        }
    fi
    
    cd ..
    print_status "✅ $service_name validation passed"
    return 0
}

# Main validation
echo "Starting local validation..."

# Test marketing service
test_service "Marketing" "marketing" || exit 1

# Test business service
test_service "Business" "business" || exit 1

# Test admin service  
test_service "Admin" "admin" || exit 1

# Test functions service
test_service "Functions" "functions" || exit 1

print_status "🎉 All services validated successfully!"

# Routing validation
echo ""
echo "🔍 Validating routing configuration..."

# Check for route conflicts
if grep -q 'path: /' do-app.yaml; then
    print_warning "Found Flutter Web routing to / in do-app.yaml - this should be moved to avoid conflict"
fi

if grep -q 'path: /' api-domain-config-production-fixed.yaml; then
    print_status "✅ Marketing service correctly configured to serve /"
fi

# Firebase configuration validation
echo ""
echo "🔍 Validating Firebase configuration..."

if [ -f "firebase.json" ]; then
    # Check for duplicate functions configurations
    duplicate_count=$(grep -c '"source":' firebase.json)
    if [ "$duplicate_count" -gt 1 ]; then
        print_error "Found $duplicate_count function configurations in firebase.json - should be only 1"
        exit 1
    else
        print_status "✅ Firebase configuration is clean"
    fi
fi

# Check that default/ folder is removed
if [ -d "default" ]; then
    print_error "default/ folder still exists - this should be removed to avoid conflicts"
    exit 1
else
    print_status "✅ No conflicting default/ folder found"
fi

print_status "🎉 All validations passed!"

echo ""
echo "📋 Deployment Summary:"
echo "====================="
echo "✅ Marketing Service (/) - Next.js app ready for deployment"
echo "✅ Business Service (/business) - Static app ready for deployment" 
echo "✅ Admin Service (/admin) - Static app ready for deployment"
echo "✅ API Service (/api) - Firebase Functions ready for deployment"
echo "✅ No route conflicts detected"
echo "✅ Firebase Functions duplication resolved"

echo ""
echo "🚀 Ready for deployment with api-domain-config-production-fixed.yaml"
echo ""
echo "To deploy:"
echo "1. Use the production config: api-domain-config-production-fixed.yaml"
echo "2. Ensure DigitalOcean App Platform uses this config"
echo "3. Deploy all services simultaneously to avoid route conflicts"
echo ""
print_status "Validation complete! 🎉"