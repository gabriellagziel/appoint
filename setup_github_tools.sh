#!/bin/bash

# 🚀 GitHub Tools Setup Script for AppOint
# This script helps you set up all the GitHub tools and workflows

set -e

echo "🚀 Setting up GitHub Tools for AppOint..."
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "This script must be run from the root of a git repository"
    exit 1
fi

# Get repository information
REPO_URL=$(git remote get-url origin)
REPO_NAME=$(basename -s .git "$REPO_URL")

print_status "Repository: $REPO_NAME"
print_status "Repository URL: $REPO_URL"

# Check if .github directory exists
if [ ! -d ".github" ]; then
    print_status "Creating .github directory..."
    mkdir -p .github
fi

# Check if workflows directory exists
if [ ! -d ".github/workflows" ]; then
    print_status "Creating workflows directory..."
    mkdir -p .github/workflows
fi

# Check if issue templates directory exists
if [ ! -d ".github/ISSUE_TEMPLATE" ]; then
    print_status "Creating issue templates directory..."
    mkdir -p .github/ISSUE_TEMPLATE
fi

print_success "Directory structure created"

# Check if required files exist
echo ""
print_status "Checking required files..."

REQUIRED_FILES=(
    ".github/workflows/ci-cd.yml"
    ".github/workflows/dependency-updates.yml"
    ".github/pull_request_template.md"
    ".github/ISSUE_TEMPLATE/bug_report.md"
    ".github/ISSUE_TEMPLATE/feature_request.md"
    ".github/dependabot.yml"
    ".github/CODEOWNERS"
    "GITHUB_TOOLS_GUIDE.md"
)

MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "✓ $file"
    else
        print_warning "✗ $file (missing)"
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo ""
    print_warning "Some required files are missing. Please ensure all files are created before proceeding."
fi

echo ""
print_status "Next steps to complete the setup:"
echo ""

echo "1. 📋 Repository Settings:"
echo "   - Go to https://github.com/$(echo $REPO_URL | sed 's/.*github.com[:/]//' | sed 's/\.git$//')/settings"
echo "   - Enable Issues, Projects, Wiki, and Discussions"
echo ""

echo "2. 🔒 Branch Protection:"
echo "   - Go to Settings > Branches"
echo "   - Set up protection rules for 'main' and 'develop' branches"
echo "   - Configure required status checks"
echo ""

echo "3. 🔐 Security Settings:"
echo "   - Go to Settings > Security"
echo "   - Enable secret scanning"
echo "   - Enable dependency review"
echo "   - Enable code scanning"
echo ""

echo "4. 🔑 Repository Secrets:"
echo "   - Go to Settings > Secrets and variables > Actions"
echo "   - Add the following secrets:"
echo "     * VERCEL_TOKEN"
echo "     * VERCEL_ORG_ID"
echo "     * VERCEL_PROJECT_ID"
echo "     * FIREBASE_SERVICE_ACCOUNT"
echo "     * FIREBASE_PROJECT_ID"
echo "     * SNYK_TOKEN (optional)"
echo ""

echo "5. 📊 GitHub Apps:"
echo "   - Install Dependabot (already configured)"
echo "   - Consider installing SonarCloud or CodeClimate for code quality"
echo ""

echo "6. 🧪 Test the Setup:"
echo "   - Make a small change to trigger the CI/CD pipeline"
echo "   - Create a test issue using the templates"
echo "   - Create a test PR using the template"
echo ""

echo "7. 📚 Read the Documentation:"
echo "   - Review GITHUB_TOOLS_GUIDE.md for detailed information"
echo "   - Check the .github/ directory for all configurations"
echo ""

# Check if this is a GitHub repository
if [[ $REPO_URL == *"github.com"* ]]; then
    print_success "This appears to be a GitHub repository"
    echo ""
    print_status "Quick links:"
    echo "   Repository: https://github.com/$(echo $REPO_URL | sed 's/.*github.com[:/]//' | sed 's/\.git$//')"
    echo "   Settings: https://github.com/$(echo $REPO_URL | sed 's/.*github.com[:/]//' | sed 's/\.git$//')/settings"
    echo "   Actions: https://github.com/$(echo $REPO_URL | sed 's/.*github.com[:/]//' | sed 's/\.git$//')/actions"
    echo "   Issues: https://github.com/$(echo $REPO_URL | sed 's/.*github.com[:/]//' | sed 's/\.git$//')/issues"
else
    print_warning "This doesn't appear to be a GitHub repository"
    echo "   Please ensure you're pushing to GitHub to use these tools"
fi

echo ""
print_success "GitHub Tools setup script completed!"
echo ""
print_status "Remember to:"
echo "   - Commit and push all the .github/ files"
echo "   - Configure the repository settings manually"
echo "   - Test the workflows with a small change"
echo "   - Monitor the Actions tab for workflow execution"
echo ""
print_status "Happy coding! 🎉"
