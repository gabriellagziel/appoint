#!/bin/bash

# App-Oint CLI Tool
# CI-safe and DigitalOcean-compatible development utilities

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
FLUTTER_VERSION="3.32.5"
DART_VERSION="3.5.4"
PROJECT_NAME="appoint"

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if running in CI
is_ci() {
    [ -n "$CI" ] || [ -n "$GITHUB_ACTIONS" ]
}

# Check if running in DigitalOcean environment
is_digitalocean() {
    [ -n "$DIGITALOCEAN_ACCESS_TOKEN" ] || [ -f "/.dockerenv" ]
}

# Setup local development environment
setup_local() {
    log_info "Setting up local development environment..."
    
    # Check if Flutter is installed
    if ! command -v flutter &> /dev/null; then
        log_warning "Flutter not found. Installing Flutter $FLUTTER_VERSION..."
        
        if is_ci; then
            log_error "Cannot install Flutter in CI environment"
            exit 1
        fi
        
        # Install Flutter (platform-specific)
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            git clone https://github.com/flutter/flutter.git ~/flutter
            export PATH="$PATH:~/flutter/bin"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install --cask flutter
        else
            log_error "Unsupported platform for Flutter installation"
            exit 1
        fi
    fi
    
    # Verify Flutter version
    FLUTTER_CURRENT=$(flutter --version | grep -oP 'Flutter \K[0-9]+\.[0-9]+\.[0-9]+')
    if [ "$FLUTTER_CURRENT" != "$FLUTTER_VERSION" ]; then
        log_warning "Flutter version mismatch. Expected: $FLUTTER_VERSION, Found: $FLUTTER_CURRENT"
        if ! is_ci; then
            flutter upgrade
        fi
    fi
    
    # Install dependencies
    log_info "Installing Flutter dependencies..."
    flutter pub get
    
    log_info "Installing Node.js dependencies..."
    npm install
    
    # Run code generation
    log_info "Running code generation..."
    dart run build_runner build --delete-conflicting-outputs
    
    log_success "Local development environment setup complete!"
}

# Translate ARB files
translate_arb() {
    log_info "Processing ARB translation files..."
    
    # Check if ARB files exist
    if [ ! -f "lib/l10n/app_en.arb" ]; then
        log_error "No ARB files found. Please ensure lib/l10n/app_en.arb exists."
        exit 1
    fi
    
    # Generate translations
    log_info "Generating translations..."
    flutter gen-l10n
    
    # Validate translation keys
    log_info "Validating translation keys..."
    python3 scripts/validate_translations.py
    
    # Count keys per language
    for arb_file in lib/l10n/*.arb; do
        if [ -f "$arb_file" ]; then
            key_count=$(grep -c '^  "' "$arb_file" || echo "0")
            log_info "$(basename "$arb_file"): $key_count keys"
        fi
    done
    
    log_success "ARB translation processing complete!"
}

# Reset Firebase emulator
reset_emulator() {
    log_info "Resetting Firebase emulator..."
    
    # Stop existing emulator
    pkill -f "firebase emulators" || true
    
    # Start fresh emulator
    firebase emulators:start --only firestore,auth,functions --import=./emulator-data --export-on-exit=./emulator-data &
    
    # Wait for emulator to start
    sleep 10
    
    # Verify emulator is running
    if curl -f -s "http://localhost:4000" > /dev/null; then
        log_success "Firebase emulator is running on http://localhost:4000"
    else
        log_error "Failed to start Firebase emulator"
        exit 1
    fi
}

# Run tests
run_tests() {
    log_info "Running tests..."
    
    # Run Flutter tests
    flutter test
    
    # Run integration tests if not in CI
    if ! is_ci; then
        log_info "Running integration tests..."
        flutter test integration_test/
    fi
    
    log_success "All tests passed!"
}

# Build for different platforms
build_app() {
    local platform=$1
    
    case $platform in
        "web")
            log_info "Building for web..."
            flutter build web --release --web-renderer html
            log_success "Web build complete!"
            ;;
        "android")
            log_info "Building for Android..."
            flutter build apk --release
            log_success "Android build complete!"
            ;;
        "ios")
            log_info "Building for iOS..."
            flutter build ios --release --no-codesign
            log_success "iOS build complete!"
            ;;
        "all")
            build_app "web"
            build_app "android"
            build_app "ios"
            ;;
        *)
            log_error "Unknown platform: $platform"
            echo "Supported platforms: web, android, ios, all"
            exit 1
            ;;
    esac
}

# Deploy to staging
deploy_staging() {
    log_info "Deploying to staging..."
    
    if ! is_digitalocean; then
        log_error "DigitalOcean environment not detected"
        exit 1
    fi
    
    # Build web app
    build_app "web"
    
    # Deploy using DigitalOcean CLI
    doctl apps create-deployment $DIGITALOCEAN_APP_ID --wait
    
    log_success "Staging deployment complete!"
}

# Deploy to production
deploy_production() {
    log_info "Deploying to production..."
    
    if ! is_digitalocean; then
        log_error "DigitalOcean environment not detected"
        exit 1
    fi
    
    # Build web app
    build_app "web"
    
    # Deploy using DigitalOcean CLI
    doctl apps create-deployment $DIGITALOCEAN_APP_ID --wait
    
    log_success "Production deployment complete!"
}

# Clean build artifacts
clean_build() {
    log_info "Cleaning build artifacts..."
    
    # Clean Flutter build
    flutter clean
    
    # Clean generated files
    find . -name "*.g.dart" -delete
    find . -name "*.freezed.dart" -delete
    
    # Clean node modules (if exists)
    if [ -d "node_modules" ]; then
        rm -rf node_modules
    fi
    
    log_success "Build artifacts cleaned!"
}

# Analyze code
analyze_code() {
    log_info "Analyzing code..."
    
    # Flutter analyze
    flutter analyze --no-fatal-infos
    
    # Check formatting
    dart format --set-exit-if-changed .
    
    # Run linter
    flutter analyze --fatal-infos
    
    log_success "Code analysis complete!"
}

# Show help
show_help() {
    echo "App-Oint CLI Tool"
    echo ""
    echo "Usage: ./tools/appoint-cli.sh <command> [options]"
    echo ""
    echo "Commands:"
    echo "  setup-local          Setup local development environment"
    echo "  translate-arb        Process ARB translation files"
    echo "  reset-emulator       Reset Firebase emulator"
    echo "  test                 Run all tests"
    echo "  build <platform>     Build app for platform (web/android/ios/all)"
    echo "  deploy-staging       Deploy to staging environment"
    echo "  deploy-production    Deploy to production environment"
    echo "  clean                Clean build artifacts"
    echo "  analyze              Analyze code quality"
    echo "  help                 Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./tools/appoint-cli.sh setup-local"
    echo "  ./tools/appoint-cli.sh build web"
    echo "  ./tools/appoint-cli.sh deploy-staging"
}

# Main script logic
main() {
    local command=$1
    local arg=$2
    
    case $command in
        "setup-local")
            setup_local
            ;;
        "translate-arb")
            translate_arb
            ;;
        "reset-emulator")
            reset_emulator
            ;;
        "test")
            run_tests
            ;;
        "build")
            if [ -z "$arg" ]; then
                log_error "Platform required for build command"
                echo "Usage: ./tools/appoint-cli.sh build <platform>"
                exit 1
            fi
            build_app "$arg"
            ;;
        "deploy-staging")
            deploy_staging
            ;;
        "deploy-production")
            deploy_production
            ;;
        "clean")
            clean_build
            ;;
        "analyze")
            analyze_code
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        "")
            show_help
            ;;
        *)
            log_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"