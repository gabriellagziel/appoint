#!/bin/bash

# Generate release notes from commit logs
# Usage: ./scripts/generate_release_notes.sh <version> [--dry-run]

set -e

VERSION="$1"
DRY_RUN=false
if [[ "$2" == "--dry-run" ]]; then
  DRY_RUN=true
fi

PREVIOUS_VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version> [previous_version]"
    echo "Example: $0 1.2.0 1.1.0"
    exit 1
fi

# If no previous version provided, try to get the last tag
if [ -z "$PREVIOUS_VERSION" ]; then
    PREVIOUS_VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
fi

# Create temporary files
TEMP_DIR=$(mktemp -d)
COMMITS_FILE="$TEMP_DIR/commits.txt"
FEATURES_FILE="$TEMP_DIR/features.txt"
FIXES_FILE="$TEMP_DIR/fixes.txt"
BREAKING_FILE="$TEMP_DIR/breaking.txt"
CHORES_FILE="$TEMP_DIR/chores.txt"
DOCS_FILE="$TEMP_DIR/docs.txt"
STYLE_FILE="$TEMP_DIR/style.txt"
REFACTOR_FILE="$TEMP_DIR/refactor.txt"
TEST_FILE="$TEMP_DIR/test.txt"
PERF_FILE="$TEMP_DIR/perf.txt"
CI_FILE="$TEMP_DIR/ci.txt"

# Function to get commits between versions
get_commits() {
    if [ -n "$PREVIOUS_VERSION" ]; then
        git log --pretty=format:"%H|%s|%b" "$PREVIOUS_VERSION..HEAD"
    else
        git log --pretty=format:"%H|%s|%b" --reverse
    fi
}

# Function to categorize commits
categorize_commit() {
    local commit_hash="$1"
    local subject="$2"
    local body="$3"
    
    # Convert to lowercase for easier matching
    local subject_lower=$(echo "$subject" | tr '[:upper:]' '[:lower:]')
    local body_lower=$(echo "$body" | tr '[:upper:]' '[:lower:]')
    
    # Check for conventional commit format
    if [[ "$subject" =~ ^(feat|feature)(\(.+\))?: ]]; then
        echo "$commit_hash|$subject" >> "$FEATURES_FILE"
    elif [[ "$subject" =~ ^(fix|bugfix)(\(.+\))?: ]]; then
        echo "$commit_hash|$subject" >> "$FIXES_FILE"
    elif [[ "$subject" =~ ^(breaking|breaking-change)(\(.+\))?: ]]; then
        echo "$commit_hash|$subject" >> "$BREAKING_FILE"
    elif [[ "$subject" =~ ^(chore|chores)(\(.+\))?: ]]; then
        echo "$commit_hash|$subject" >> "$CHORES_FILE"
    elif [[ "$subject" =~ ^(docs|documentation)(\(.+\))?: ]]; then
        echo "$commit_hash|$subject" >> "$DOCS_FILE"
    elif [[ "$subject" =~ ^(style|styling)(\(.+\))?: ]]; then
        echo "$commit_hash|$subject" >> "$STYLE_FILE"
    elif [[ "$subject" =~ ^(refactor|refactoring)(\(.+\))?: ]]; then
        echo "$commit_hash|$subject" >> "$REFACTOR_FILE"
    elif [[ "$subject" =~ ^(test|testing)(\(.+\))?: ]]; then
        echo "$commit_hash|$subject" >> "$TEST_FILE"
    elif [[ "$subject" =~ ^(perf|performance)(\(.+\))?: ]]; then
        echo "$commit_hash|$subject" >> "$PERF_FILE"
    elif [[ "$subject" =~ ^(ci|build)(\(.+\))?: ]]; then
        echo "$commit_hash|$subject" >> "$CI_FILE"
    else
        # Fallback categorization based on keywords
        if [[ "$subject_lower" =~ (add|new|implement|create|introduce|support) ]]; then
            echo "$commit_hash|$subject" >> "$FEATURES_FILE"
        elif [[ "$subject_lower" =~ (fix|resolve|correct|repair|patch) ]]; then
            echo "$commit_hash|$subject" >> "$FIXES_FILE"
        elif [[ "$subject_lower" =~ (update|upgrade|bump|version) ]]; then
            echo "$commit_hash|$subject" >> "$CHORES_FILE"
        elif [[ "$subject_lower" =~ (doc|readme|comment) ]]; then
            echo "$commit_hash|$subject" >> "$DOCS_FILE"
        elif [[ "$subject_lower" =~ (test|spec|check) ]]; then
            echo "$commit_hash|$subject" >> "$TEST_FILE"
        elif [[ "$subject_lower" =~ (refactor|clean|improve|optimize) ]]; then
            echo "$commit_hash|$subject" >> "$REFACTOR_FILE"
        else
            echo "$commit_hash|$subject" >> "$CHORES_FILE"
        fi
    fi
}

# Function to format commit list
format_commits() {
    local file="$1"
    local category="$2"
    
    if [ -f "$file" ] && [ -s "$file" ]; then
        echo "### $category"
        echo ""
        while IFS='|' read -r hash subject; do
            # Extract scope if present using sed
            if echo "$subject" | grep -q "^[a-z]*(.*):"; then
                scope=$(echo "$subject" | sed -n 's/^[a-z]*(\([^)]*\)):.*/\1/p')
                clean_subject="${subject#*: }"
                echo "- **$scope**: $clean_subject"
            else
                # Remove prefix if present
                clean_subject="${subject#*: }"
                echo "- $clean_subject"
            fi
        done < "$file"
        echo ""
    fi
}

# Function to get contributors
get_contributors() {
    if [ -n "$PREVIOUS_VERSION" ]; then
        git shortlog -sn "$PREVIOUS_VERSION..HEAD" | head -10
    else
        git shortlog -sn | head -10
    fi
}

# Function to get release date
get_release_date() {
    date '+%Y-%m-%d'
}

# Function to get commit count
get_commit_count() {
    if [ -n "$PREVIOUS_VERSION" ]; then
        git rev-list --count "$PREVIOUS_VERSION..HEAD"
    else
        git rev-list --count HEAD
    fi
}

# Function to get files changed
get_files_changed() {
    if [ -n "$PREVIOUS_VERSION" ]; then
        git diff --name-only "$PREVIOUS_VERSION..HEAD" | wc -l
    else
        git diff --name-only HEAD | wc -l
    fi
}

# Function to get lines changed
get_lines_changed() {
    if [ -n "$PREVIOUS_VERSION" ]; then
        git diff --stat "$PREVIOUS_VERSION..HEAD" | tail -1
    else
        git diff --stat HEAD | tail -1
    fi
}

# Main execution
echo "Generating release notes for version $VERSION..."

# Get commits and categorize them
get_commits | while IFS='|' read -r hash subject body; do
    categorize_commit "$hash" "$subject" "$body"
done

# If dry run, output to stdout and exit
if $DRY_RUN; then
  echo "# Release Notes - $VERSION"
  echo ""
  echo "**Release Date:** $(get_release_date)"
  echo "**Previous Version:** ${PREVIOUS_VERSION:-"Initial Release"}"
  echo "**Commits:** $(get_commit_count)"
  echo "**Files Changed:** $(get_files_changed)"
  echo "**Lines Changed:** $(get_lines_changed)"
  echo ""
  echo "## 🎉 What's New"
  echo ""
  format_commits "$FEATURES_FILE" "✨ Features"
  format_commits "$PERF_FILE" "⚡ Performance"
  format_commits "$FIXES_FILE" "🐛 Bug Fixes"
  format_commits "$REFACTOR_FILE" "♻️ Refactoring"
  format_commits "$TEST_FILE" "🧪 Tests"
  format_commits "$DOCS_FILE" "📚 Documentation"
  format_commits "$STYLE_FILE" "💄 Styling"
  format_commits "$CI_FILE" "🔧 CI/CD"
  format_commits "$CHORES_FILE" "🔨 Chores"
  echo "## 👥 Contributors"
  echo ""
  get_contributors | while read -r count author; do
    echo "- $author ($count commits)"
  done
  exit 0
fi

# If RELEASE_NOTES.md exists, append, else create
if [ -f RELEASE_NOTES.md ]; then
  echo -e "\n\n# Release Notes - $VERSION\n" >> RELEASE_NOTES.md
else
  echo "# Release Notes - $VERSION" > RELEASE_NOTES.md
fi

# Add features
format_commits "$FEATURES_FILE" "✨ Features"

# Add performance improvements
format_commits "$PERF_FILE" "⚡ Performance"

# Add breaking changes
if [ -f "$BREAKING_FILE" ] && [ -s "$BREAKING_FILE" ]; then
    echo "## ⚠️ Breaking Changes" >> "RELEASE_NOTES.md"
    echo "" >> "RELEASE_NOTES.md"
    format_commits "$BREAKING_FILE" "🚨 Breaking Changes" >> "RELEASE_NOTES.md"
fi

# Add fixes
format_commits "$FIXES_FILE" "🐛 Bug Fixes"

# Add refactoring
format_commits "$REFACTOR_FILE" "♻️ Refactoring"

# Add tests
format_commits "$TEST_FILE" "🧪 Tests"

# Add documentation
format_commits "$DOCS_FILE" "📚 Documentation"

# Add styling
format_commits "$STYLE_FILE" "💄 Styling"

# Add CI/CD
format_commits "$CI_FILE" "🔧 CI/CD"

# Add chores
format_commits "$CHORES_FILE" "🔨 Chores"

# Add contributors
echo "## 👥 Contributors" >> "RELEASE_NOTES.md"
echo "" >> "RELEASE_NOTES.md"
get_contributors | while read -r count author; do
    echo "- $author ($count commits)" >> "RELEASE_NOTES.md"
done

# Add installation instructions
cat >> "RELEASE_NOTES.md" << EOF

## 📦 Installation

### Android
Download the APK from the release assets:
- \`appoint-arm64-release.apk\` - For ARM64 devices
- \`appoint-arm-release.apk\` - For ARM devices  
- \`appoint-x64-release.apk\` - For x64 devices

Or install from Google Play Store (if available).

### iOS
Download the IPA from the release assets and install via:
- TestFlight (if available)
- Direct installation (requires developer account)

### Web
Access the web version at: https://appoint.web.app

## 🔗 Links

- [GitHub Repository](https://github.com/your-org/appoint)
- [Documentation](https://docs.appoint.app)
- [Support](https://support.appoint.app)
- [Privacy Policy](https://appoint.app/privacy)
- [Terms of Service](https://appoint.app/terms)

## 📋 Changelog

For a detailed changelog, see [CHANGELOG.md](CHANGELOG.md).

---

*Generated automatically on $(get_release_date)*
EOF

# Clean up temporary files
rm -rf "$TEMP_DIR"

echo "Release notes generated successfully!"
echo "File: RELEASE_NOTES.md"
echo "Version: $VERSION"
echo "Previous Version: ${PREVIOUS_VERSION:-"Initial Release"}"
echo "Commits: $(get_commit_count)"
echo "Files Changed: $(get_files_changed)"

# Output the release notes for GitHub Actions
cat "RELEASE_NOTES.md" 