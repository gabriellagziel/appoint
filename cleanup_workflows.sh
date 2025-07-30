#!/bin/bash

# GitHub Repository Workflow Cleanup Script
# This script safely backs up and removes problematic workflow files

set -e

echo "🔧 Starting GitHub workflow cleanup..."

# Create backup directory
BACKUP_DIR=".github/workflows/backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "📁 Creating backup in: $BACKUP_DIR"

# List of workflows to backup and remove (problematic/duplicate)
PROBLEMATIC_WORKFLOWS=(
    "ci.yaml"                    # Duplicate of ci.yml
    "ci-consolidated.yml"        # Redundant with ci-cd-pipeline.yml
    "100-percent-qa.yml"         # May conflict with qa-pipeline.yml
    "asset-optimization.yml"      # Can be merged into main CI
    "dependency-scan.yml"        # Can be integrated into main CI
    "firebase_hosting.yml"       # Redundant with web-deploy.yml
    "health-check.yml"           # Can be integrated into main CI
    "l10n_audit.yml"            # Redundant with l10n-check.yml
    "localization.yml"           # Redundant with sync-translations.yml
    "nightly-builds.yml"         # Redundant with nightly.yml
    "performance-benchmarks.yml" # Can be integrated into main CI
    "pr_checks.yml"             # Can be integrated into main CI
    "pseudo-l10n.yml"           # Redundant with l10n-check.yml
    "security.yml"               # Redundant with security-qa.yml
    "test-config.yml"            # Can be integrated into main CI
    "validate-secrets.yml"       # Can be integrated into main CI
    "build-and-push-devcontainer.yml" # Not essential for CI/CD
    "dashboard-deploy.yml"       # Can be integrated into main deployment
)

# List of workflows to keep (essential)
ESSENTIAL_WORKFLOWS=(
    "ci.yml"                    # Main CI workflow
    "ci-cd-pipeline.yml"        # Main CD pipeline
    "qa-pipeline.yml"           # QA pipeline
    "release.yml"               # Release workflow
    "security-qa.yml"           # Security QA
    "web-deploy.yml"            # Web deployment
    "android-build.yml"         # Android builds
    "ios-build.yml"             # iOS builds
    "nightly.yml"               # Nightly builds
    "sync-translations.yml"     # Translation sync
    "deployment-config.yml"     # Deployment configuration
    "secrets-management.md"     # Documentation
    "README.md"                 # Documentation
    "l10n-check.yml"            # Localization checks
)

echo "📋 Workflows to backup and remove:"
for workflow in "${PROBLEMATIC_WORKFLOWS[@]}"; do
    if [ -f ".github/workflows/$workflow" ]; then
        echo "  - $workflow"
    fi
done

echo ""
echo "✅ Workflows to keep:"
for workflow in "${ESSENTIAL_WORKFLOWS[@]}"; do
    if [ -f ".github/workflows/$workflow" ]; then
        echo "  - $workflow"
    fi
done

echo ""
echo "🚨 WARNING: This will remove $(echo "${PROBLEMATIC_WORKFLOWS[@]}" | wc -w) workflow files"
echo "Press Ctrl+C to cancel, or any key to continue..."
read -n 1 -s

# Backup problematic workflows
echo "💾 Backing up problematic workflows..."
for workflow in "${PROBLEMATIC_WORKFLOWS[@]}"; do
    if [ -f ".github/workflows/$workflow" ]; then
        cp ".github/workflows/$workflow" "$BACKUP_DIR/"
        echo "  ✓ Backed up: $workflow"
    fi
done

# Remove problematic workflows
echo "🗑️ Removing problematic workflows..."
for workflow in "${PROBLEMATIC_WORKFLOWS[@]}"; do
    if [ -f ".github/workflows/$workflow" ]; then
        rm ".github/workflows/$workflow"
        echo "  ✓ Removed: $workflow"
    fi
done

echo ""
echo "✅ Workflow cleanup completed!"
echo "📁 Backup created in: $BACKUP_DIR"
echo "📋 Remaining workflows:"
ls -la .github/workflows/

echo ""
echo "🔄 Next steps:"
echo "1. Test the remaining workflows"
echo "2. Commit the changes"
echo "3. Push to GitHub"
echo "4. Verify CI/CD pipeline functionality"