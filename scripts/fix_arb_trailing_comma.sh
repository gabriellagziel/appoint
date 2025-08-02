#!/bin/bash

# Script to remove trailing comma from the last entry in ARB files

for file in lib/l10n/app_*.arb; do
  echo "Fixing trailing comma in $file..."
  # Remove trailing comma from the last entry
  sed -i '' '$s/,$//' "$file"
done

echo "Done fixing trailing commas in ARB files!" 