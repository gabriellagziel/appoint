#!/bin/bash

# App-Oint Infrastructure Verification Script
# Tests all infrastructure components to ensure they're working correctly

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    log_info "Running test: $test_name"
    
    if eval "$test_command" > /dev/null 2>&1; then
        log_success "$test_name passed"
        ((TESTS_PASSED++))
    else
        log_error "$test_name failed"
        ((TESTS_FAILED++))
    fi
}

# Main verification function
verify_infrastructure() {
    echo "🚀 App-Oint Infrastructure Verification"
    echo "======================================"
    echo ""
    
    # Test 1: Check if CLI tool exists and is executable
    run_test "CLI Tool Accessibility" "[ -x './tools/appoint-cli.sh' ]"
    
    # Test 2: Check if Dockerfile exists
    run_test "Dockerfile Exists" "[ -f 'Dockerfile' ]"
    
    # Test 3: Check if build script exists and is executable
    run_test "Build Script Accessibility" "[ -x './scripts/build-docker-image.sh' ]"
    
    # Test 4: Check if translation validation script exists
    run_test "Translation Validator Exists" "[ -f 'scripts/validate_translations.py' ]"
    
    # Test 5: Check if CI workflows exist
    run_test "Main CI Workflow Exists" "[ -f '.github/workflows/main_ci.yml' ]"
    run_test "Auto Merge Workflow Exists" "[ -f '.github/workflows/auto-merge.yml' ]"
    run_test "Staging Deploy Workflow Exists" "[ -f '.github/workflows/staging-deploy.yml' ]"
    run_test "Watchdog Workflow Exists" "[ -f '.github/workflows/watchdog.yml' ]"
    run_test "Translation Sync Workflow Exists" "[ -f '.github/workflows/translation-sync.yml' ]"
    
    # Test 6: Check if DigitalOcean App Platform config exists
    run_test "DO App Platform Config Exists" "[ -f 'do-app.yaml' ]"
    
    # Test 7: Check if pubspec.yaml exists and is valid
    run_test "pubspec.yaml Exists" "[ -f 'pubspec.yaml' ]"
    
    # Test 8: Check if l10n.yaml exists
    run_test "l10n.yaml Exists" "[ -f 'l10n.yaml' ]"
    
    # Test 9: Check if ARB files exist
    run_test "ARB Files Directory Exists" "[ -d 'lib/l10n' ]"
    
    # Test 10: Check if CLI tool help works
    run_test "CLI Tool Help Command" "./tools/appoint-cli.sh help > /dev/null"
    
    # Test 11: Check if Python validation script is executable
    run_test "Python Validation Script Executable" "[ -x 'scripts/validate_translations.py' ]"
    
    # Test 12: Check if documentation exists
    run_test "Infrastructure Documentation Exists" "[ -f 'INFRASTRUCTURE_UPGRADE.md' ]"
    
    # Test 13: Check if Docker image can be built (if Docker is available)
    if command -v docker &> /dev/null; then
        run_test "Docker Build Test" "docker build -t test-appoint-ci . > /dev/null 2>&1"
        # Clean up test image
        docker rmi test-appoint-ci > /dev/null 2>&1 || true
    else
        log_warning "Docker not available - skipping Docker build test"
    fi
    
    # Test 14: Check if GitHub CLI is available (for CI workflows)
    if command -v gh &> /dev/null; then
        run_test "GitHub CLI Available" "gh --version > /dev/null"
    else
        log_warning "GitHub CLI not available - some CI features may not work"
    fi
    
    # Test 15: Check if DigitalOcean CLI is available
    if command -v doctl &> /dev/null; then
        run_test "DigitalOcean CLI Available" "doctl version > /dev/null"
    else
        log_warning "DigitalOcean CLI not available - deployment features may not work"
    fi
    
    # Test 16: Validate pubspec.yaml structure
    run_test "pubspec.yaml Structure" "grep -q 'name: appoint' pubspec.yaml"
    run_test "Flutter SDK Version" "grep -q 'sdk:.*>=3.8.1' pubspec.yaml"
    
    # Test 17: Check if CI workflow has Docker container configuration
    run_test "CI Uses Docker Container" "grep -q 'registry.digitalocean.com/appoint/flutter-ci' .github/workflows/main_ci.yml"
    
    # Test 18: Check if caching is configured in CI
    run_test "CI Caching Configured" "grep -q 'actions/cache' .github/workflows/main_ci.yml"
    
    # Test 19: Check if staging deployment is configured
    run_test "Staging Domain Configured" "grep -q 'staging.app-oint.com' .github/workflows/staging-deploy.yml"
    
    # Test 20: Check if watchdog monitoring is configured
    run_test "Watchdog Monitoring Configured" "grep -q 'cron.*\*/5' .github/workflows/watchdog.yml"
    
    echo ""
    echo "📊 Test Results Summary"
    echo "======================"
    echo "✅ Tests Passed: $TESTS_PASSED"
    echo "❌ Tests Failed: $TESTS_FAILED"
    echo "📈 Success Rate: $(( (TESTS_PASSED * 100) / (TESTS_PASSED + TESTS_FAILED) ))%"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo ""
        log_success "🎉 All infrastructure tests passed!"
        echo ""
        echo "🚀 Infrastructure is ready for use!"
        echo ""
        echo "Next steps:"
        echo "1. Build and push Docker image: ./scripts/build-docker-image.sh"
        echo "2. Configure GitHub secrets for full functionality"
        echo "3. Test staging deployment with a push to develop branch"
        echo "4. Use CLI tool for development: ./tools/appoint-cli.sh help"
        return 0
    else
        echo ""
        log_error "⚠️  Some infrastructure tests failed!"
        echo ""
        echo "Please fix the failed tests before proceeding."
        return 1
    fi
}

# Check for required files
check_requirements() {
    log_info "Checking requirements..."
    
    local missing_files=()
    
    # Check for essential files
    [[ ! -f "pubspec.yaml" ]] && missing_files+=("pubspec.yaml")
    [[ ! -f "Dockerfile" ]] && missing_files+=("Dockerfile")
    [[ ! -f "do-app.yaml" ]] && missing_files+=("do-app.yaml")
    [[ ! -f "tools/appoint-cli.sh" ]] && missing_files+=("tools/appoint-cli.sh")
    [[ ! -f ".github/workflows/main_ci.yml" ]] && missing_files+=("main_ci.yml")
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        log_error "Missing required files:"
        for file in "${missing_files[@]}"; do
            echo "  - $file"
        done
        return 1
    fi
    
    log_success "All required files present"
    return 0
}

# Main execution
main() {
    if ! check_requirements; then
        log_error "Requirements check failed. Please ensure all files are present."
        exit 1
    fi
    
    verify_infrastructure
}

# Run main function
main "$@"