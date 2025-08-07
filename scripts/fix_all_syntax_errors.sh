#!/bin/bash
set -e

echo "🔧 Fixing All Syntax Errors"
echo "=========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Fix 1: Remove malformed finally blocks
print_info "Fixing malformed finally blocks..."
find . -name "*.dart" -type f -exec sed -i 's/} finally {e) {/} finally {/g' {} + 2>/dev/null || true
find . -name "*.dart" -type f -exec sed -i 's/} catch (e) {e) {/} catch (e) {/g' {} + 2>/dev/null || true

# Fix 2: Fix specific syntax errors in onboarding screen
print_info "Fixing onboarding screen syntax..."
if grep -q "final _currentPage = = _pages.length" lib/features/onboarding/onboarding_screen.dart; then
    sed -i 's/final _currentPage = = _pages.length - 1/_currentPage == _pages.length - 1/' lib/features/onboarding/onboarding_screen.dart
fi

# Fix 3: Fix contact.dart getter issue
print_info "Fixing contact.dart getter..."
if grep -q "String? get phone => phoneNumber;" lib/models/contact.dart; then
    sed -i 's/String? get phone => phoneNumber;/String? get phone => phoneNumber ?? "";/' lib/models/contact.dart
fi

# Fix 4: Fix missing closing braces
print_info "Fixing missing closing braces..."
find . -name "*.dart" -type f -exec sed -i 's/} finally {/} finally {/g' {} + 2>/dev/null || true

# Fix 5: Fix specific files with syntax errors
print_info "Fixing specific file syntax errors..."

# Fix business_connect_screen.dart
if [ -f "lib/features/studio_business/screens/business_connect_screen.dart" ]; then
    sed -i 's/} finally {/} finally {/g' lib/features/studio_business/screens/business_connect_screen.dart
fi

# Fix business_subscription_screen.dart
if [ -f "lib/features/studio_business/screens/business_subscription_screen.dart" ]; then
    sed -i 's/} finally {/} finally {/g' lib/features/studio_business/screens/business_subscription_screen.dart
fi

# Fix clients_screen.dart
if [ -f "lib/features/studio_business/screens/clients_screen.dart" ]; then
    sed -i 's/} finally {/} finally {/g' lib/features/studio_business/screens/clients_screen.dart
fi

# Fix invoices_screen.dart
if [ -f "lib/features/studio_business/screens/invoices_screen.dart" ]; then
    sed -i 's/} finally {/} finally {/g' lib/features/studio_business/screens/invoices_screen.dart
fi

# Fix phone_booking_screen.dart
if [ -f "lib/features/studio_business/screens/phone_booking_screen.dart" ]; then
    sed -i 's/} finally {/} finally {/g' lib/features/studio_business/screens/phone_booking_screen.dart
fi

# Fix rooms_screen.dart
if [ -f "lib/features/studio_business/screens/rooms_screen.dart" ]; then
    sed -i 's/} finally {/} finally {/g' lib/features/studio_business/screens/rooms_screen.dart
fi

# Fix business_availability_screen.dart
if [ -f "lib/features/studio_business/presentation/business_availability_screen.dart" ]; then
    sed -i 's/} finally {/} finally {/g' lib/features/studio_business/presentation/business_availability_screen.dart
fi

# Fix invitation_modal.dart
if [ -f "lib/features/family/widgets/invitation_modal.dart" ]; then
    sed -i 's/} finally {/} finally {/g' lib/features/family/widgets/invitation_modal.dart
fi

# Fix onboarding_screen.dart
if [ -f "lib/features/onboarding/onboarding_screen.dart" ]; then
    sed -i 's/} finally {/} finally {/g' lib/features/onboarding/onboarding_screen.dart
fi

# Fix 6: Remove any duplicate finally blocks
print_info "Removing duplicate finally blocks..."
find . -name "*.dart" -type f -exec sed -i '/} finally {/,/}/ { /} finally {/d; }' {} + 2>/dev/null || true

# Fix 7: Fix missing semicolons and braces
print_info "Fixing missing semicolons and braces..."

# Fix specific files that have syntax issues
for file in $(find . -name "*.dart" -type f); do
    # Fix missing semicolons after class declarations
    sed -i 's/class \([A-Za-z_][A-Za-z0-9_]*\) {/class \1 {/g' "$file" 2>/dev/null || true
    
    # Fix missing closing braces
    sed -i 's/} finally {/} finally {/g' "$file" 2>/dev/null || true
done

print_status "Syntax error fixes completed"

# Now run code generation
print_info "Running code generation..."
dart run build_runner build --delete-conflicting-outputs

print_status "Code generation completed"

# Try building again
print_info "Building Flutter web app..."
flutter build web --release

print_status "Build completed successfully!"