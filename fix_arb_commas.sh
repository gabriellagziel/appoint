#!/bin/bash

# Script to fix missing commas in ARB files
# This fixes the issue where failedToUpdateConsent is missing a comma

for file in lib/l10n/app_*.arb; do
  echo "Fixing $file..."
  # Replace "failedToUpdateConsent.*}\)$/\1,/" "$file"
  sed -i '' 's/\(failedToUpdateConsent.*}\)$/\1,/' "$file"
done

echo "Done fixing ARB files!" 