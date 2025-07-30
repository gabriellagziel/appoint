#!/bin/bash

# Script to automatically fix common linting issues in Flutter/Dart code
echo "🔧 Fixing common linting issues..."

# Fix trailing commas
echo "📝 Adding missing trailing commas..."
find . -name "*.dart" -not -path "./.dart_tool/*" -not -path "./build/*" -not -path "./packages/*" | xargs sed -i '' 's/\([^,]\)$/\1,/' 2>/dev/null || true

# Fix single quotes
echo "📝 Converting double quotes to single quotes..."
find . -name "*.dart" -not -path "./.dart_tool/*" -not -path "./build/*" -not -path "./packages/*" | xargs sed -i '' 's/"\([^"]*\)"/'\''\1'\''/g' 2>/dev/null || true

# Fix const constructors
echo "📝 Adding const to constructors..."
find . -name "*.dart" -not -path "./.dart_tool/*" -not -path "./build/*" -not -path "./packages/*" | xargs sed -i '' 's/new /const /g' 2>/dev/null || true

# Fix import ordering
echo "📝 Sorting imports..."
dart fix --apply

# Run formatter
echo "📝 Running dart format..."
dart format .

echo "✅ Linting fixes applied!"
echo "📊 Run 'dart analyze' to see remaining issues" 