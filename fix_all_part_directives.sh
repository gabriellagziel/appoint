#!/bin/bash

# Comprehensive fix for all part directives
echo "Fixing all part directives..."

# Function to fix part directives in a file
fix_part_directives() {
    local file="$1"
    echo "Fixing: $file"
    
    # Replace full paths with just filenames
    sed -i '' 's|part '"'"'.*freezed\.dart'"'"'|part '"'"'$(basename "$file" .dart).freezed.dart'"'"'|g' "$file"
    sed -i '' 's|part '"'"'.*\.g\.dart'"'"'|part '"'"'$(basename "$file" .dart).g.dart'"'"'|g' "$file"
    
    # More specific replacements
    sed -i '' 's|part '"'"'features/studio_business/models/|part '"'"'|g' "$file"
    sed -i '' 's|part '"'"'features/booking/domain/entities/|part '"'"'|g' "$file"
    sed -i '' 's|part '"'"'models/|part '"'"'|g' "$file"
    sed -i '' 's|part '"'"'lib/|part '"'"'|g' "$file"
    sed -i '' 's|part '"'"'\.\./|part '"'"'|g' "$file"
    sed -i '' 's|part '"'"'\.\./\.\./|part '"'"'|g' "$file"
    sed -i '' 's|part '"'"'\.\./\.\./\.\./|part '"'"'|g' "$file"
}

# Find all Dart files with part directives and fix them
find lib -name "*.dart" -exec grep -l "part.*\.dart" {} \; | while read file; do
    if [ -f "$file" ]; then
        fix_part_directives "$file"
    fi
done

echo "All part directives fixed!" 