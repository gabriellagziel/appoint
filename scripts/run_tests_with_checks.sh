#!/bin/bash

# Comprehensive test runner with pre-flight checks
set -e

echo "🚀 Starting comprehensive test run..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Step 1: Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Please run this script from the project root."
    exit 1
fi

# Step 2: Get dependencies
print_status "📦 Getting dependencies..."
flutter pub get

# Step 3: Run analyzer
print_status "🔍 Running static analysis..."
if dart analyze --fatal-infos; then
    print_success "Static analysis passed!"
else
    print_warning "Static analysis found issues. Consider running: ./scripts/fix_linting_issues.sh"
fi

# Step 4: Format code
print_status "📝 Formatting code..."
if dart format . --set-exit-if-changed; then
    print_success "Code formatting is correct!"
else
    print_warning "Code formatting issues found. Running formatter..."
    dart format .
fi

# Step 5: Run tests with coverage
print_status "🧪 Running tests..."
if flutter test --coverage --reporter=compact; then
    print_success "All tests passed!"
else
    print_error "Some tests failed!"
    exit 1
fi

# Step 6: Generate coverage report
print_status "📊 Generating coverage report..."
if command -v genhtml &> /dev/null; then
    genhtml coverage/lcov.info -o coverage/html
    print_success "Coverage report generated at coverage/html/index.html"
else
    print_warning "genhtml not found. Install lcov to generate HTML coverage reports."
fi

# Step 7: Show test summary
print_status "📈 Test Summary:"
echo "  - Coverage report: coverage/lcov.info"
echo "  - HTML report: coverage/html/index.html (if genhtml available)"
echo "  - Static analysis: dart analyze"
echo "  - Code formatting: dart format ."

print_success "🎉 Test run completed successfully!" 