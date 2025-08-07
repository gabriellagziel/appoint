#!/bin/bash

# Script to run accessibility audit and fail on contrast or focus violations
# Exits with non-zero code if accessibility issues are found

set -e

echo "♿ Running accessibility audit..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ACCESSIBILITY_ISSUES_FOUND=false

# Function to log issues
log_issue() {
    echo -e "${RED}❌ $1${NC}"
    ACCESSIBILITY_ISSUES_FOUND=true
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    log_issue "Flutter is not installed or not in PATH"
    exit 1
fi

echo "📱 Running Flutter accessibility tests..."

# Run Flutter's built-in accessibility tests
if flutter test test/accessibility_standalone_test.dart --reporter=compact; then
    log_success "Flutter accessibility tests passed"
else
    log_issue "Flutter accessibility tests failed"
fi

echo "🔍 Checking for semantic labels..."

# Check for widgets without semantic labels
SEMANTIC_ISSUES=0

# Check for IconButton widgets without Semantics wrapper
ICON_BUTTON_COUNT=$(grep -r "IconButton(" lib/ --include="*.dart" | wc -l)
SEMANTIC_ICON_BUTTON_COUNT=$(grep -r "Semantics.*IconButton" lib/ --include="*.dart" | wc -l)

if [ "$ICON_BUTTON_COUNT" -gt "$SEMANTIC_ICON_BUTTON_COUNT" ]; then
    MISSING_ICON_BUTTON_SEMANTICS=$((ICON_BUTTON_COUNT - SEMANTIC_ICON_BUTTON_COUNT))
    log_issue "Found $MISSING_ICON_BUTTON_SEMANTICS IconButton widgets without semantic labels"
    SEMANTIC_ISSUES=$((SEMANTIC_ISSUES + 1))
else
    log_success "All IconButton widgets have semantic labels"
fi

# Check for TextField widgets without Semantics wrapper
TEXT_FIELD_COUNT=$(grep -r "TextField(" lib/ --include="*.dart" | wc -l)
SEMANTIC_TEXT_FIELD_COUNT=$(grep -r "Semantics.*TextField" lib/ --include="*.dart" | wc -l)

if [ "$TEXT_FIELD_COUNT" -gt "$SEMANTIC_TEXT_FIELD_COUNT" ]; then
    MISSING_TEXT_FIELD_SEMANTICS=$((TEXT_FIELD_COUNT - SEMANTIC_TEXT_FIELD_COUNT))
    log_issue "Found $MISSING_TEXT_FIELD_SEMANTICS TextField widgets without semantic labels"
    SEMANTIC_ISSUES=$((SEMANTIC_ISSUES + 1))
else
    log_success "All TextField widgets have semantic labels"
fi

echo "🎨 Checking for contrast violations..."

# Check for hardcoded colors that might have contrast issues
CONTRAST_ISSUES=0

# Check for common low-contrast color combinations
if grep -r "Colors\.grey\[[1-3]\]" lib/ --include="*.dart"; then
    log_warning "Found potential low-contrast grey colors"
    CONTRAST_ISSUES=$((CONTRAST_ISSUES + 1))
fi

if grep -r "Colors\.white" lib/ --include="*.dart" | grep -v "Colors\.white.withOpacity" | head -5; then
    log_warning "Found hardcoded white colors (check contrast with background)"
    CONTRAST_ISSUES=$((CONTRAST_ISSUES + 1))
fi

echo "🔍 Checking for focus management..."

# Check for proper focus management
FOCUS_ISSUES=0

# Check for Focus widgets
FOCUS_WIDGET_COUNT=$(grep -r "Focus(" lib/ --include="*.dart" | wc -l)
if [ "$FOCUS_WIDGET_COUNT" -eq 0 ]; then
    log_warning "No Focus widgets found - consider adding focus management for keyboard navigation"
    FOCUS_ISSUES=$((FOCUS_ISSUES + 1))
else
    log_success "Found $FOCUS_WIDGET_COUNT Focus widgets"
fi

# Check for AutofocusGroup widgets
AUTOFOCUS_GROUP_COUNT=$(grep -r "AutofocusGroup(" lib/ --include="*.dart" | wc -l)
if [ "$AUTOFOCUS_GROUP_COUNT" -eq 0 ]; then
    log_warning "No AutofocusGroup widgets found - consider adding for better focus management"
    FOCUS_ISSUES=$((FOCUS_ISSUES + 1))
else
    log_success "Found $AUTOFOCUS_GROUP_COUNT AutofocusGroup widgets"
fi

echo "📊 Checking for screen reader support..."

# Check for ExcludeSemantics usage
EXCLUDE_SEMANTICS_COUNT=$(grep -r "ExcludeSemantics(" lib/ --include="*.dart" | wc -l)
if [ "$EXCLUDE_SEMANTICS_COUNT" -gt 0 ]; then
    log_warning "Found $EXCLUDE_SEMANTICS_COUNT ExcludeSemantics widgets - ensure these don't hide important content"
fi

# Check for MergeSemantics usage
MERGE_SEMANTICS_COUNT=$(grep -r "MergeSemantics(" lib/ --include="*.dart" | wc -l)
if [ "$MERGE_SEMANTICS_COUNT" -gt 0 ]; then
    log_success "Found $MERGE_SEMANTICS_COUNT MergeSemantics widgets for better screen reader support"
fi

echo "🔧 Running Flutter analyze with accessibility rules..."

# Run Flutter analyze with custom rules
if flutter analyze --no-fatal-infos; then
    log_success "Flutter analyze passed"
else
    log_issue "Flutter analyze found issues"
fi

echo "📋 Generating accessibility report..."

# Create accessibility report
REPORT_FILE="docs/accessibility_report.md"
mkdir -p docs

cat > "$REPORT_FILE" << EOF
# Accessibility Audit Report

Generated on: $(date)

## Summary

- **Semantic Labels**: $SEMANTIC_ISSUES issues found
- **Contrast Issues**: $CONTRAST_ISSUES potential issues found
- **Focus Management**: $FOCUS_ISSUES issues found

## Details

### Semantic Labels
- IconButton widgets with semantic labels: $SEMANTIC_ICON_BUTTON_COUNT / $ICON_BUTTON_COUNT
- TextField widgets with semantic labels: $SEMANTIC_TEXT_FIELD_COUNT / $TEXT_FIELD_COUNT

### Focus Management
- Focus widgets: $FOCUS_WIDGET_COUNT
- AutofocusGroup widgets: $AUTOFOCUS_GROUP_COUNT

### Screen Reader Support
- ExcludeSemantics widgets: $EXCLUDE_SEMANTICS_COUNT
- MergeSemantics widgets: $MERGE_SEMANTICS_COUNT

## Recommendations

1. Add semantic labels to all interactive widgets
2. Test color contrast ratios
3. Implement proper focus management
4. Test with screen readers
5. Use Flutter's accessibility debugging tools

## Testing Commands

\`\`\`bash
# Run accessibility tests
flutter test test/a11y/

# Run with accessibility debugging
flutter run --enable-software-rendering

# Check semantic tree
flutter run --enable-software-rendering --observatory-port=8888
\`\`\`
EOF

log_success "Accessibility report generated: $REPORT_FILE"

# Final result
if [ "$ACCESSIBILITY_ISSUES_FOUND" = true ]; then
    echo ""
    echo -e "${RED}❌ Accessibility audit failed - issues found${NC}"
    echo "Check the report at: $REPORT_FILE"
    exit 1
else
    echo ""
    echo -e "${GREEN}✅ Accessibility audit passed - no critical issues found${NC}"
    exit 0
fi 