#!/bin/bash

# CI/CD Verification Script
# This script verifies the current status of CI/CD workflows and runs

set -e

echo "🔍 CI/CD Verification Script"
echo "=============================="

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed"
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub CLI"
    echo "Please run: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI authenticated"

# Get current repository
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
echo "📁 Repository: $REPO"

echo ""
echo "📋 Recent Workflow Runs"
echo "----------------------"
gh run list --limit 10

echo ""
echo "🔧 Available Workflows"
echo "---------------------"
gh workflow list

echo ""
echo "📊 Workflow Status Summary"
echo "-------------------------"

# Get workflow status for the last 24 hours
RECENT_RUNS=$(gh run list --limit 20 --json status,conclusion,workflowName,createdAt)

# Count by status
SUCCESS=$(echo "$RECENT_RUNS" | jq -r '.[] | select(.conclusion == "success") | .workflowName' | wc -l)
FAILURE=$(echo "$RECENT_RUNS" | jq -r '.[] | select(.conclusion == "failure") | .workflowName' | wc -l)
CANCELLED=$(echo "$RECENT_RUNS" | jq -r '.[] | select(.conclusion == "cancelled") | .workflowName' | wc -l)
RUNNING=$(echo "$RECENT_RUNS" | jq -r '.[] | select(.status == "in_progress") | .workflowName' | wc -l)

echo "✅ Successful: $SUCCESS"
echo "❌ Failed: $FAILURE"
echo "⏹️  Cancelled: $CANCELLED"
echo "🔄 Running: $RUNNING"

echo ""
echo "🔍 Failed Workflows (Last 20 runs)"
echo "----------------------------------"
FAILED_WORKFLOWS=$(echo "$RECENT_RUNS" | jq -r '.[] | select(.conclusion == "failure") | .workflowName')
if [ -z "$FAILED_WORKFLOWS" ]; then
    echo "✅ No failed workflows found"
else
    echo "$FAILED_WORKFLOWS" | sort | uniq -c | sort -nr
fi

echo ""
echo "📈 Workflow Performance"
echo "----------------------"

# Get workflow performance data
WORKFLOWS=$(gh workflow list --json name,state,createdAt,updatedAt)
echo "$WORKFLOWS" | jq -r '.[] | "\(.name): \(.state) (Updated: \(.updatedAt))"'

echo ""
echo "🔒 Branch Protection Status"
echo "--------------------------"

# Check if we're on a protected branch
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"

# Check branch protection rules
if gh api repos/:owner/:repo/branches/$CURRENT_BRANCH/protection &> /dev/null; then
    PROTECTION=$(gh api repos/:owner/:repo/branches/$CURRENT_BRANCH/protection)
    echo "✅ Branch protection enabled"
    
    # Check required status checks
    REQUIRED_CHECKS=$(echo "$PROTECTION" | jq -r '.required_status_checks.checks[]?.context // empty' 2>/dev/null || echo "None")
    if [ -n "$REQUIRED_CHECKS" ]; then
        echo "Required checks:"
        echo "$REQUIRED_CHECKS" | while read -r check; do
            echo "  - $check"
        done
    else
        echo "No required status checks configured"
    fi
else
    echo "⚠️  No branch protection rules found"
fi

echo ""
echo "🎯 Verification Complete"
echo "======================="

if [ "$FAILURE" -gt 0 ]; then
    echo "⚠️  Found $FAILURE failed workflow runs"
    echo "Please investigate and fix the issues above"
    exit 1
else
    echo "✅ All workflows are passing"
    echo "CI/CD system is healthy"
fi

echo ""
echo "💡 Next Steps:"
echo "1. Review any failed workflows above"
echo "2. Check branch protection rules if needed"
echo "3. Monitor workflow performance"
echo "4. Update required checks in GitHub settings if needed"
