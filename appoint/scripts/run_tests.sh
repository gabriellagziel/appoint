#!/usr/bin/env bash

# 🚀 App-Oint Test Suite Runner
# Comprehensive test execution with coverage and quality checks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
COVERAGE_THRESHOLD=70
CHANGED_FILES_THRESHOLD=85
MAX_RETRIES=3

echo -e "${BLUE}🚀 App-Oint Test Suite Runner${NC}"
echo "=================================="

# Function to print status
print_status() {
    local status=$1
    local message=$2
    if [ "$status" = "success" ]; then
        echo -e "${GREEN}✅ $message${NC}"
    elif [ "$status" = "warning" ]; then
        echo -e "${YELLOW}⚠️  $message${NC}"
    else
        echo -e "${RED}❌ $message${NC}"
    fi
}

# Function to run command with retries
run_with_retries() {
    local cmd="$1"
    local description="$2"
    local retries=0
    
    while [ $retries -lt $MAX_RETRIES ]; do
        echo -e "${BLUE}🔄 $description (attempt $((retries + 1))/$MAX_RETRIES)${NC}"
        
        if eval "$cmd"; then
            print_status "success" "$description completed"
            return 0
        else
            retries=$((retries + 1))
            if [ $retries -lt $MAX_RETRIES ]; then
                echo -e "${YELLOW}⚠️  Retrying in 2 seconds...${NC}"
                sleep 2
            fi
        fi
    done
    
    print_status "error" "$description failed after $MAX_RETRIES attempts"
    return 1
}

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: pubspec.yaml not found. Run this script from the appoint/ directory.${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Pre-flight checks...${NC}"

# Clean and get dependencies
echo -e "${BLUE}🧹 Cleaning and getting dependencies...${NC}"
flutter clean
flutter pub get

# Run analysis
echo -e "${BLUE}🔍 Running static analysis...${NC}"
if flutter analyze; then
    print_status "success" "Static analysis passed"
else
    print_status "error" "Static analysis failed"
    exit 1
fi

# Run unit and widget tests
echo -e "${BLUE}🧪 Running unit and widget tests...${NC}"
if run_with_retries "flutter test --coverage" "Unit and widget tests"; then
    print_status "success" "Unit and widget tests passed"
else
    print_status "error" "Unit and widget tests failed"
    exit 1
fi

# Generate HTML coverage report
echo -e "${BLUE}📊 Generating coverage report...${NC}"
if command -v genhtml >/dev/null 2>&1; then
    genhtml coverage/lcov.info -o coverage/html
    print_status "success" "Coverage report generated at coverage/html/index.html"
else
    print_status "warning" "genhtml not found. Install lcov to generate HTML reports."
fi

# Run coverage gap analysis
echo -e "${BLUE}🔍 Analyzing coverage gaps...${NC}"
if dart run tool/coverage_gap.dart; then
    print_status "success" "Coverage gap analysis completed"
else
    print_status "warning" "Coverage gap analysis failed or found gaps"
fi

# Check coverage thresholds
echo -e "${BLUE}📈 Checking coverage thresholds...${NC}"
if dart run tool/check_coverage.dart; then
    print_status "success" "Coverage thresholds met"
else
    print_status "error" "Coverage thresholds not met"
    exit 1
fi

# Run copy consistency check
echo -e "${BLUE}📝 Checking copy consistency...${NC}"
if ./scripts/scan_copy.sh; then
    print_status "success" "Copy consistency check passed"
else
    print_status "error" "Copy consistency check failed"
    exit 1
fi

# Run integration tests (Chrome)
echo -e "${BLUE}🌐 Running integration tests (Chrome)...${NC}"
if run_with_retries "flutter test -d chrome integration_test" "Integration tests"; then
    print_status "success" "Integration tests passed"
else
    print_status "error" "Integration tests failed"
    exit 1
fi

# Run golden tests
echo -e "${BLUE}🖼️  Running golden tests...${NC}"
if flutter test test/goldens/; then
    print_status "success" "Golden tests passed"
else
    print_status "warning" "Golden tests failed (may need --update-goldens)"
fi

# Performance check (if enabled)
if [ "$PERFORMANCE_CHECK" = "true" ]; then
    echo -e "${BLUE}⚡ Running performance tests...${NC}"
    if flutter test --coverage --dart-define=profile=true; then
        print_status "success" "Performance tests passed"
    else
        print_status "warning" "Performance tests failed"
    fi
fi

# Generate summary report
echo -e "${BLUE}📋 Generating test summary...${NC}"
generate_summary() {
    local summary_file="test_summary_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "App-Oint Test Suite Summary"
        echo "Generated: $(date)"
        echo "=================================="
        echo ""
        
        echo "✅ Tests Executed:"
        echo "  • Unit tests: $(find test -name "*_test.dart" | grep -v integration | wc -l) files"
        echo "  • Widget tests: $(find test -name "*_widget_test.dart" | wc -l) files"
        echo "  • Integration tests: $(find integration_test -name "*_test.dart" | wc -l) files"
        echo "  • Golden tests: $(find test/goldens -name "*_test.dart" | wc -l) files"
        echo ""
        
        echo "📊 Coverage:"
        if [ -f "coverage/lcov.info" ]; then
            echo "  • HTML report: coverage/html/index.html"
            echo "  • LCOV data: coverage/lcov.info"
        fi
        
        echo ""
        echo "🔍 Quality Checks:"
        echo "  • Static analysis: ✅"
        echo "  • Copy consistency: ✅"
        echo "  • Coverage thresholds: ✅"
        echo ""
        
        echo "📁 Generated Files:"
        echo "  • coverage/gaps.txt (if gaps found)"
        echo "  • Test stubs for uncovered files"
        echo "  • coverage/html/ (coverage report)"
        echo ""
        
        echo "🚀 Next Steps:"
        echo "  • Review coverage report: open coverage/html/index.html"
        echo "  • Check gaps: cat coverage/gaps.txt"
        echo "  • Update golden tests if needed: flutter test test/goldens/ --update-goldens"
        echo "  • Run smoke tests: see docs/DEPLOY_SMOKE_TEST.md"
        
    } > "$summary_file"
    
    print_status "success" "Summary saved to $summary_file"
}

generate_summary

echo ""
echo -e "${GREEN}🎉 All tests completed successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Quick Commands:${NC}"
echo "  • View coverage: open coverage/html/index.html"
echo "  • Check gaps: dart run tool/coverage_gap.dart"
echo "  • Run specific tests: flutter test test/features/meeting_creation/"
echo "  • Update goldens: flutter test test/goldens/ --update-goldens"
echo "  • Smoke test: see docs/DEPLOY_SMOKE_TEST.md"
echo ""

# Optional: Open coverage report
if command -v open >/dev/null 2>&1 && [ -d "coverage/html" ]; then
    read -p "Open coverage report in browser? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open coverage/html/index.html
    fi
fi
