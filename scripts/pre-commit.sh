#!/bin/bash

# Pre-commit hook to run checks before committing
echo "🔍 Running pre-commit checks..."

# Run analyzer
if ! dart analyze --fatal-infos; then
    echo "❌ Static analysis failed. Please fix the issues before committing."
    exit 1
fi

# Check formatting
if ! dart format . --set-exit-if-changed; then
    echo "❌ Code formatting issues found. Please run 'dart format .' before committing."
    exit 1
fi

# Run tests
if ! flutter test --reporter=compact; then
    echo "❌ Tests failed. Please fix the failing tests before committing."
    exit 1
fi

echo "✅ Pre-commit checks passed!" 