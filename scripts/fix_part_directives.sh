#!/bin/bash

# Fix part directives in model files
echo "Fixing part directives in model files..."

# Function to fix part directives in a file
fix_part_directives() {
    local file="$1"
    echo "Fixing: $file"
    
    # Replace part directives that point to generated subdirectories
    sed -i '' 's|part '"'"'\.\./generated/|part '"'"'|g' "$file"
    sed -i '' 's|part '"'"'\.\./\.\./generated/|part '"'"'|g' "$file"
    sed -i '' 's|part '"'"'\.\./\.\./\.\./generated/|part '"'"'|g' "$file"
    
    # Remove any remaining generated/ paths
    sed -i '' 's|part '"'"'generated/|part '"'"'|g' "$file"
}

# Fix files in lib/models
for file in lib/models/*.dart; do
    if [ -f "$file" ]; then
        fix_part_directives "$file"
    fi
done

# Fix files in lib/features/studio_business/models
for file in lib/features/studio_business/models/*.dart; do
    if [ -f "$file" ]; then
        fix_part_directives "$file"
    fi
done

# Fix files in lib/features/booking/domain/entities
for file in lib/features/booking/domain/entities/*.dart; do
    if [ -f "$file" ]; then
        fix_part_directives "$file"
    fi
done

echo "Part directives fixed!" 