#!/bin/bash

# Script to merge all unmerged branches to main
# This script will merge branches one by one, resolving conflicts by taking incoming changes

echo "Starting to merge all unmerged branches..."

# Get list of unmerged branches
UNMERGED_BRANCHES=$(git branch -r --no-merged origin/main | sed 's/origin\///')

# Counter for progress
COUNT=0
TOTAL=$(echo "$UNMERGED_BRANCHES" | wc -l | tr -d ' ')

echo "Found $TOTAL branches to merge"

for branch in $UNMERGED_BRANCHES; do
    COUNT=$((COUNT + 1))
    echo "[$COUNT/$TOTAL] Merging origin/$branch..."
    
    # Try to merge the branch
    if git merge "origin/$branch" --no-edit; then
        echo "✅ Successfully merged origin/$branch"
    else
        echo "⚠️  Merge conflict in origin/$branch, resolving by taking incoming changes..."
        
        # Get list of conflicted files
        CONFLICTED_FILES=$(git status --porcelain | grep "^UU\|^AA" | awk '{print $2}')
        DELETED_FILES=$(git status --porcelain | grep "^UD" | awk '{print $2}')
        
        if [ -n "$CONFLICTED_FILES" ]; then
            # Resolve conflicts by taking incoming changes
            for file in $CONFLICTED_FILES; do
                if [ -f "$file" ]; then
                    git checkout --theirs "$file"
                    git add "$file"
                fi
            done
        fi
        
        # Handle deleted files
        if [ -n "$DELETED_FILES" ]; then
            for file in $DELETED_FILES; do
                git rm "$file"
            done
        fi
        
        # Commit the resolved merge
        if git commit -m "Merge origin/$branch - resolved conflicts by taking incoming changes"; then
            echo "✅ Successfully resolved and merged origin/$branch"
        else
            echo "❌ Failed to commit merge for origin/$branch"
            echo "Current status:"
            git status
            exit 1
        fi
    fi
done

echo "🎉 All branches merged successfully!"
echo "Total branches merged: $COUNT" 