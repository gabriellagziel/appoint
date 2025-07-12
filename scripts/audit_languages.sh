#!/bin/bash

# Script to audit missing translation keys
# Exits with non-zero code if any keys are missing

set -e

echo "🔍 Auditing translation keys..."

# Directory containing ARB files
ARB_DIR="lib/l10n"
MAIN_ARB_FILE="$ARB_DIR/app_en.arb"

# Check if main ARB file exists
if [ ! -f "$MAIN_ARB_FILE" ]; then
    echo "❌ Main ARB file not found: $MAIN_ARB_FILE"
    exit 1
fi

# Extract all keys from the main English ARB file
echo "📋 Extracting keys from $MAIN_ARB_FILE..."
MAIN_KEYS=$(grep '^  "' "$MAIN_ARB_FILE" | sed 's/^  "\([^"]*\)".*/\1/' | sort)

# Find all ARB files (excluding the main English file)
ARB_FILES=$(find "$ARB_DIR" -name "*.arb" -not -name "app_en.arb")

MISSING_KEYS_FOUND=false

# Check each ARB file for missing keys
for arb_file in $ARB_FILES; do
    echo "🔍 Checking $arb_file..."
    
    # Extract keys from current ARB file
    CURRENT_KEYS=$(grep '^  "' "$arb_file" | sed 's/^  "\([^"]*\)".*/\1/' | sort)
    
    # Find missing keys
    MISSING_KEYS=$(comm -23 <(echo "$MAIN_KEYS") <(echo "$CURRENT_KEYS"))
    
    if [ -n "$MISSING_KEYS" ]; then
        echo "❌ Missing keys in $arb_file:"
        echo "$MISSING_KEYS" | sed 's/^/  - /'
        echo ""
        MISSING_KEYS_FOUND=true
    else
        echo "✅ All keys present in $arb_file"
    fi
done

# Check for extra keys in other files
echo "🔍 Checking for extra keys in other ARB files..."
for arb_file in $ARB_FILES; do
    CURRENT_KEYS=$(grep '^  "' "$arb_file" | sed 's/^  "\([^"]*\)".*/\1/' | sort)
    EXTRA_KEYS=$(comm -13 <(echo "$MAIN_KEYS") <(echo "$CURRENT_KEYS"))
    
    if [ -n "$EXTRA_KEYS" ]; then
        echo "⚠️  Extra keys found in $arb_file (not in main file):"
        echo "$EXTRA_KEYS" | sed 's/^/  - /'
        echo ""
    fi
done

# Check for syntax errors in ARB files
echo "🔍 Checking ARB file syntax..."
for arb_file in $(find "$ARB_DIR" -name "*.arb"); do
    if ! python3 -m json.tool "$arb_file" > /dev/null 2>&1; then
        echo "❌ Syntax error in $arb_file"
        MISSING_KEYS_FOUND=true
    fi
done

# Check for unused keys in Dart code
echo "🔍 Checking for unused translation keys..."
DART_FILES=$(find lib -name "*.dart" -not -path "*/generated/*")
USED_KEYS=$(grep -r "l10n\." $DART_FILES | sed 's/.*l10n\.\([a-zA-Z_][a-zA-Z0-9_]*\).*/\1/' | sort | uniq)

UNUSED_KEYS=$(comm -23 <(echo "$MAIN_KEYS") <(echo "$USED_KEYS"))

if [ -n "$UNUSED_KEYS" ]; then
    echo "⚠️  Potentially unused keys:"
    echo "$UNUSED_KEYS" | sed 's/^/  - /'
    echo ""
fi

# Final result
if [ "$MISSING_KEYS_FOUND" = true ]; then
    echo "❌ Translation audit failed - missing keys found"
    exit 1
else
    echo "✅ Translation audit passed - all keys present"
    exit 0
fi 