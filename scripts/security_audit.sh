#!/bin/bash

# APP-OINT Security Audit Script
# This script performs a comprehensive security audit of the codebase

set -e

echo "🔒 Running APP-OINT Security Audit..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_header() {
    echo -e "${BLUE}[AUDIT]${NC} $1"
}

# Initialize counters
ERRORS=0
WARNINGS=0
INFO=0

# Function to count issues
count_error() {
    ((ERRORS++))
}

count_warning() {
    ((WARNINGS++))
}

count_info() {
    ((INFO++))
}

# Check for hardcoded API keys
check_hardcoded_keys() {
    print_header "Checking for hardcoded API keys..."
    
    # Check for common API key patterns
    local patterns=(
        "AIza[0-9A-Za-z_-]{35}"
        "sk_[0-9a-zA-Z]{24}"
        "pk_[0-9a-zA-Z]{24}"
        "[0-9]{12}:[a-zA-Z0-9_-]{35}"
        "firebase.*\.json"
        "google-services\.json"
    )
    
    for pattern in "${patterns[@]}"; do
        if grep -r "$pattern" . --exclude-dir={.git,node_modules,build,.dart_tool} --exclude="*.lock" --exclude="*.g.dart" --exclude="*.freezed.dart" > /dev/null 2>&1; then
            print_error "Hardcoded API key found with pattern: $pattern"
            grep -r "$pattern" . --exclude-dir={.git,node_modules,build,.dart_tool} --exclude="*.lock" --exclude="*.g.dart" --exclude="*.freezed.dart" | head -5
            count_error
        fi
    done
    
    # Check for Firebase config in web/index.html
    if grep -q "apiKey.*AIza" web/index.html 2>/dev/null; then
        print_error "Firebase API key found in web/index.html"
        count_error
    else
        print_status "No hardcoded Firebase keys found in web/index.html"
    fi
}

# Check for exposed secrets in git history
check_git_secrets() {
    print_header "Checking git history for secrets..."
    
    if command -v git-secrets &> /dev/null; then
        if git secrets --scan-history; then
            print_status "No secrets found in git history"
        else
            print_error "Secrets found in git history"
            count_error
        fi
    else
        print_warning "git-secrets not installed. Install with: brew install git-secrets"
        count_warning
    fi
}

# Check for insecure dependencies
check_dependencies() {
    print_header "Checking for insecure dependencies..."
    
    # Check Flutter dependencies
    if flutter pub deps | grep -q "unresolved"; then
        print_warning "Unresolved dependencies found"
        count_warning
    fi
    
    # Check for known vulnerable packages
    local vulnerable_packages=(
        "http: ^0.12.0"
        "crypto: ^2.1.0"
    )
    
    for package in "${vulnerable_packages[@]}"; do
        if grep -q "$package" pubspec.yaml; then
            print_warning "Potentially vulnerable package found: $package"
            count_warning
        fi
    done
}

# Check for proper HTTPS usage
check_https_usage() {
    print_header "Checking for HTTPS usage..."
    
    # Check for HTTP URLs in code
    if grep -r "http://" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" | grep -v "localhost" | grep -v "127.0.0.1" > /dev/null 2>&1; then
        print_warning "HTTP URLs found in code (excluding localhost)"
        grep -r "http://" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" | grep -v "localhost" | grep -v "127.0.0.1" | head -3
        count_warning
    fi
    
    # Check for HTTPS URLs
    local https_count=$(grep -r "https://" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" | wc -l)
    print_status "Found $https_count HTTPS URLs in code"
}

# Check for proper error handling
check_error_handling() {
    print_header "Checking for proper error handling..."
    
    # Check for unhandled exceptions
    local unhandled_exceptions=$(grep -r "throw" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" | grep -v "//" | wc -l)
    local try_catch_blocks=$(grep -r "try" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" | wc -l)
    
    print_status "Found $unhandled_exceptions throw statements"
    print_status "Found $try_catch_blocks try-catch blocks"
    
    if [ "$unhandled_exceptions" -gt "$((try_catch_blocks * 2))" ]; then
        print_warning "High number of unhandled exceptions compared to try-catch blocks"
        count_warning
    fi
}

# Check for input validation
check_input_validation() {
    print_header "Checking for input validation..."
    
    # Check for user input handling
    local input_handlers=$(grep -r "TextEditingController\|TextField\|TextFormField" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" | wc -l)
    local validators=$(grep -r "validator\|validate" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" | wc -l)
    
    print_status "Found $input_handlers input handlers"
    print_status "Found $validators validators"
    
    if [ "$input_handlers" -gt "$((validators * 2))" ]; then
        print_warning "Many input handlers without corresponding validators"
        count_warning
    fi
}

# Check for proper authentication
check_authentication() {
    print_header "Checking authentication implementation..."
    
    # Check for Firebase Auth usage
    if grep -q "firebase_auth" pubspec.yaml; then
        print_status "Firebase Auth is configured"
        
        # Check for proper auth state handling
        if grep -r "AuthStateChanges\|UserChanges" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" > /dev/null 2>&1; then
            print_status "Auth state changes are properly handled"
        else
            print_warning "Auth state changes might not be properly handled"
            count_warning
        fi
    else
        print_warning "No authentication package found"
        count_warning
    fi
}

# Check for proper authorization
check_authorization() {
    print_header "Checking authorization implementation..."
    
    # Check for role-based access control
    if grep -r "role\|permission\|admin\|user" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" | grep -v "//" > /dev/null 2>&1; then
        print_status "Role-based access control patterns found"
    else
        print_warning "No clear authorization patterns found"
        count_warning
    fi
}

# Check for secure storage usage
check_secure_storage() {
    print_header "Checking secure storage usage..."
    
    # Check for flutter_secure_storage usage
    if grep -q "flutter_secure_storage" pubspec.yaml; then
        print_status "Secure storage package is configured"
        
        # Check for sensitive data storage
        if grep -r "flutter_secure_storage" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" > /dev/null 2>&1; then
            print_status "Secure storage is being used"
        else
            print_warning "Secure storage package configured but not used"
            count_warning
        fi
    else
        print_warning "No secure storage package found"
        count_warning
    fi
}

# Check for proper logging
check_logging() {
    print_header "Checking logging implementation..."
    
    # Check for debug prints
    local debug_prints=$(grep -r "print(" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" | wc -l)
    
    if [ "$debug_prints" -gt 0 ]; then
        print_warning "Found $debug_prints debug print statements"
        count_warning
    fi
    
    # Check for proper logging
    if grep -r "logger\|logging" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" > /dev/null 2>&1; then
        print_status "Proper logging implementation found"
    else
        print_warning "No proper logging implementation found"
        count_warning
    fi
}

# Check for network security
check_network_security() {
    print_header "Checking network security..."
    
    # Check for certificate pinning
    if grep -r "certificate\|pinning\|ssl" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" > /dev/null 2>&1; then
        print_status "Certificate pinning patterns found"
    else
        print_warning "No certificate pinning implementation found"
        count_warning
    fi
    
    # Check for proper HTTP client configuration
    if grep -r "HttpClient\|dio\|http" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" > /dev/null 2>&1; then
        print_status "HTTP client usage found"
    else
        print_warning "No HTTP client usage found"
        count_warning
    fi
}

# Check for data encryption
check_encryption() {
    print_header "Checking data encryption..."
    
    # Check for encryption packages
    if grep -q "encrypt\|crypto" pubspec.yaml; then
        print_status "Encryption package is configured"
        
        # Check for encryption usage
        if grep -r "encrypt\|Encrypter\|AES" lib/ --exclude="*.g.dart" --exclude="*.freezed.dart" > /dev/null 2>&1; then
            print_status "Encryption is being used"
        else
            print_warning "Encryption package configured but not used"
            count_warning
        fi
    else
        print_warning "No encryption package found"
        count_warning
    fi
}

# Generate security report
generate_report() {
    print_header "Generating Security Report..."
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    cat > security_audit_report.md << EOF
# APP-OINT Security Audit Report

**Generated:** $timestamp

## Summary
- **Errors:** $ERRORS
- **Warnings:** $WARNINGS
- **Info:** $INFO

## Recommendations

### Critical Issues (Errors)
EOF

    if [ $ERRORS -eq 0 ]; then
        echo "- No critical security issues found" >> security_audit_report.md
    else
        echo "- Address hardcoded API keys immediately" >> security_audit_report.md
        echo "- Review and fix exposed secrets" >> security_audit_report.md
    fi

    cat >> security_audit_report.md << EOF

### Important Issues (Warnings)
EOF

    if [ $WARNINGS -eq 0 ]; then
        echo "- No important security issues found" >> security_audit_report.md
    else
        echo "- Implement proper input validation" >> security_audit_report.md
        echo "- Add certificate pinning for network requests" >> security_audit_report.md
        echo "- Implement proper logging" >> security_audit_report.md
        echo "- Use secure storage for sensitive data" >> security_audit_report.md
    fi

    cat >> security_audit_report.md << EOF

### Best Practices
- Regularly update dependencies
- Implement proper error handling
- Use HTTPS for all network requests
- Implement proper authentication and authorization
- Use encryption for sensitive data
- Implement proper logging
- Regular security audits

## Next Steps
1. Address all critical issues immediately
2. Review and fix important issues within 2 weeks
3. Implement security best practices
4. Schedule regular security audits
5. Train team on security best practices

EOF

    print_status "Security report generated: security_audit_report.md"
}

# Main execution
main() {
    print_status "Starting comprehensive security audit..."
    
    # Run all security checks
    check_hardcoded_keys
    check_git_secrets
    check_dependencies
    check_https_usage
    check_error_handling
    check_input_validation
    check_authentication
    check_authorization
    check_secure_storage
    check_logging
    check_network_security
    check_encryption
    
    # Generate report
    generate_report
    
    # Print summary
    echo ""
    print_header "Security Audit Summary"
    echo "Errors: $ERRORS"
    echo "Warnings: $WARNINGS"
    echo "Info: $INFO"
    
    if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        print_status "✅ Security audit passed! No issues found."
    elif [ $ERRORS -eq 0 ]; then
        print_warning "⚠️  Security audit completed with warnings. Review the report."
    else
        print_error "❌ Security audit failed! Critical issues found."
        exit 1
    fi
}

# Run main function
main "$@" 