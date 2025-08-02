#!/bin/bash

echo "Fixing all part directives to point to correct locations..."

# Function to fix part directives in a file
fix_part_directives() {
    local file="$1"
    local dir=$(dirname "$file")
    local base=$(basename "$file" .dart)
    
    echo "Fixing: $file"
    
    # Replace all incorrect part directives with correct ones
    sed -i '' "s|part 'models/${base}\.freezed\.dart'|part '${base}.freezed.dart'|g" "$file"
    sed -i '' "s|part 'models/${base}\.g\.dart'|part '${base}.g.dart'|g" "$file"
    sed -i '' "s|part 'features/studio_business/models/${base}\.freezed\.dart'|part '${base}.freezed.dart'|g" "$file"
    sed -i '' "s|part 'features/studio_business/models/${base}\.g\.dart'|part '${base}.g.dart'|g" "$file"
    sed -i '' "s|part 'features/booking/domain/entities/${base}\.freezed\.dart'|part '${base}.freezed.dart'|g" "$file"
    sed -i '' "s|part 'features/booking/domain/entities/${base}\.g\.dart'|part '${base}.g.dart'|g" "$file"
    
    # Remove any remaining full paths
    sed -i '' "s|part '.*/${base}\.freezed\.dart'|part '${base}.freezed.dart'|g" "$file"
    sed -i '' "s|part '.*/${base}\.g\.dart'|part '${base}.g.dart'|g" "$file"
}

# Find all Dart files with part directives and fix them
find lib -name "*.dart" -exec grep -l "part.*\.dart" {} \; | while read file; do
    if [ -f "$file" ]; then
        fix_part_directives "$file"
    fi
done

echo "All part directives fixed!" 