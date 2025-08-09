#!/usr/bin/env bash
set -e

echo "Running tests with coverage..."
flutter test --coverage

echo "Generating HTML coverage report..."
genhtml coverage/lcov.info -o coverage/html

echo "Coverage report generated at coverage/html/index.html"
echo "Coverage summary:"
lcov --summary coverage/lcov.info
