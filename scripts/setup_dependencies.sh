#!/bin/bash

# APP-OINT Dependency Setup Script
# This script ensures all dependencies are properly installed and configured

set -e

echo "🚀 Setting up APP-OINT dependencies..."

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
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed. Please install Flutter first."
        exit 1
    fi
    
    FLUTTER_VERSION=$(flutter --version | grep -o 'Flutter [0-9.]*' | cut -d' ' -f2)
    print_status "Flutter version: $FLUTTER_VERSION"
    
    # Check if Flutter version is compatible
    if [[ ! "$FLUTTER_VERSION" =~ ^3\.[3-9]\. ]] && [[ ! "$FLUTTER_VERSION" =~ ^[4-9]\. ]]; then
        print_warning "Flutter version $FLUTTER_VERSION might not be compatible. Recommended: 3.32.0+"
    fi
}

# Check if Dart is installed
check_dart() {
    if ! command -v dart &> /dev/null; then
        print_error "Dart is not installed. Please install Dart first."
        exit 1
    fi
    
    DART_VERSION=$(dart --version | grep -o 'Dart [0-9.]*' | cut -d' ' -f2)
    print_status "Dart version: $DART_VERSION"
    
    # Check if Dart version is compatible
    if [[ ! "$DART_VERSION" =~ ^3\.[4-9]\. ]] && [[ ! "$DART_VERSION" =~ ^[4-9]\. ]]; then
        print_warning "Dart version $DART_VERSION might not be compatible. Recommended: 3.4.0+"
    fi
}

# Clean Flutter cache
clean_flutter_cache() {
    print_status "Cleaning Flutter cache..."
    flutter clean
    flutter pub cache clean
}

# Get Flutter dependencies
get_dependencies() {
    print_status "Getting Flutter dependencies..."
    flutter pub get
    
    if [ $? -ne 0 ]; then
        print_error "Failed to get dependencies. Trying with --verbose..."
        flutter pub get --verbose
        exit 1
    fi
}

# Check for dependency conflicts
check_dependency_conflicts() {
    print_status "Checking for dependency conflicts..."
    
    # Run pub deps to check for conflicts
    flutter pub deps > /tmp/pub_deps.txt 2>&1
    
    if grep -q "conflict" /tmp/pub_deps.txt; then
        print_warning "Dependency conflicts detected:"
        grep -A 5 -B 5 "conflict" /tmp/pub_deps.txt
    else
        print_status "No dependency conflicts found."
    fi
    
    rm -f /tmp/pub_deps.txt
}

# Run code generation
run_code_generation() {
    print_status "Running code generation..."
    
    # Generate Freezed models
    if grep -q "freezed" pubspec.yaml; then
        print_status "Generating Freezed models..."
        dart run build_runner build --delete-conflicting-outputs
    fi
    
    # Generate localization files
    if [ -d "lib/l10n" ]; then
        print_status "Generating localization files..."
        flutter gen-l10n
    fi
}

# Verify setup
verify_setup() {
    print_status "Verifying setup..."
    
    # Check if all dependencies are resolved
    if flutter pub deps | grep -q "unresolved"; then
        print_error "Unresolved dependencies found."
        exit 1
    fi
    
    # Check if generated files exist
    if [ -f "lib/models/admin_dashboard_stats.freezed.dart" ]; then
        print_status "Generated files are present."
    else
        print_warning "Some generated files might be missing. Run 'dart run build_runner build' if needed."
    fi
    
    # Check Flutter doctor
    print_status "Running Flutter doctor..."
    flutter doctor
}

# Setup platform-specific dependencies
setup_platform_deps() {
    print_status "Setting up platform-specific dependencies..."
    
    # iOS dependencies
    if [ -d "ios" ]; then
        print_status "Setting up iOS dependencies..."
        cd ios
        if [ -f "Podfile" ]; then
            pod install --repo-update
        fi
        cd ..
    fi
    
    # Android dependencies
    if [ -d "android" ]; then
        print_status "Setting up Android dependencies..."
        cd android
        ./gradlew clean
        cd ..
    fi
}

# Main execution
main() {
    print_status "Starting APP-OINT dependency setup..."
    
    # Check prerequisites
    check_flutter
    check_dart
    
    # Clean and setup
    clean_flutter_cache
    get_dependencies
    check_dependency_conflicts
    
    # Setup platform dependencies
    setup_platform_deps
    
    # Generate code
    run_code_generation
    
    # Verify setup
    verify_setup
    
    print_status "✅ APP-OINT dependency setup completed successfully!"
    print_status "You can now run 'flutter run' to start the app."
}

# Run main function
main "$@" 