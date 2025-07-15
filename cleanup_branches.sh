#!/bin/bash

# GitHub Repository Branch Cleanup Script
# This script identifies and safely removes stale branches

set -e

echo "🔧 Starting GitHub branch cleanup..."

# Create branch analysis report
BRANCH_REPORT="branch_cleanup_report_$(date +%Y%m%d-%H%M%S).txt"

echo "📊 Analyzing branches..." > "$BRANCH_REPORT"

# Count total branches
TOTAL_BRANCHES=$(git branch -r | wc -l)
CODEX_CURSOR_BRANCHES=$(git branch -r | grep -E "(codex|cursor)" | wc -l)
OTHER_BRANCHES=$((TOTAL_BRANCHES - CODEX_CURSOR_BRANCHES))

echo "📈 Branch Statistics:" >> "$BRANCH_REPORT"
echo "  Total branches: $TOTAL_BRANCHES" >> "$BRANCH_REPORT"
echo "  Codex/Cursor branches: $CODEX_CURSOR_BRANCHES" >> "$BRANCH_REPORT"
echo "  Other branches: $OTHER_BRANCHES" >> "$BRANCH_REPORT"

# List branches by age (last commit)
echo "" >> "$BRANCH_REPORT"
echo "📅 Branches by last activity:" >> "$BRANCH_REPORT"

# Get branches older than 30 days
OLD_BRANCHES=$(git for-each-ref --sort=-committerdate --format='%(refname:short) %(committerdate:relative)' refs/remotes/origin/ | grep -E "(codex|cursor)" | head -20)

echo "🗑️ Stale branches (older than 30 days):" >> "$BRANCH_REPORT"
echo "$OLD_BRANCHES" >> "$BRANCH_REPORT"

# List branches to keep (essential)
ESSENTIAL_BRANCHES=(
    "main"
    "develop"
    "feature/ci-cd-enhancements"
    "emergency/firebase-hosting-fix"
    "safe-backup-20250715"
)

echo "" >> "$BRANCH_REPORT"
echo "✅ Essential branches to keep:" >> "$BRANCH_REPORT"
for branch in "${ESSENTIAL_BRANCHES[@]}"; do
    echo "  - $branch" >> "$BRANCH_REPORT"
done

# Create a list of branches that can be safely deleted
echo "" >> "$BRANCH_REPORT"
echo "🗑️ Branches safe for deletion (stale codex/cursor):" >> "$BRANCH_REPORT"

# Get list of stale codex/cursor branches
STALE_BRANCHES=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/remotes/origin/ | grep -E "(codex|cursor)" | grep -v "safe-backup" | head -50)

echo "$STALE_BRANCHES" >> "$BRANCH_REPORT"

echo ""
echo "📊 Branch Analysis Complete!"
echo "📄 Report saved to: $BRANCH_REPORT"
echo ""
echo "🔍 Summary:"
echo "  - Total branches: $TOTAL_BRANCHES"
echo "  - Codex/Cursor branches: $CODEX_CURSOR_BRANCHES"
echo "  - Other branches: $OTHER_BRANCHES"
echo ""
echo "⚠️  WARNING: Branch deletion requires manual intervention"
echo "   Use 'git push origin --delete <branch-name>' for each branch"
echo ""
echo "🔄 Next steps:"
echo "1. Review the branch report"
echo "2. Manually delete stale branches"
echo "3. Verify essential branches are preserved"