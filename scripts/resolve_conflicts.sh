#!/bin/bash

echo "Resolving merge conflicts..."

# Get all conflicted files
conflicted_files=$(git status --porcelain | grep "^UU" | cut -c4-)

# Count total conflicts
total_files=$(echo "$conflicted_files" | wc -l)
echo "Found $total_files conflicted files"

# Resolve each conflict by keeping our version (which has the fixed syntax)
count=0
for file in $conflicted_files; do
    count=$((count + 1))
    echo "[$count/$total_files] Resolving conflict in: $file"
    
    # Check out our version (the one with fixed syntax)
    git checkout --theirs "$file"
    git add "$file"
done

echo "✅ All conflicts resolved!"
echo "Files are staged and ready to commit"