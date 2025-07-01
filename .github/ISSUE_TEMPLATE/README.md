# Issue Templates

This directory contains GitHub issue templates for the APP-OINT project. These templates help standardize issue creation and ensure all necessary information is captured.

## Available Templates

### 🔴 Critical Priority

1. **[Standardize Flutter & Dart Versions](standardize-flutter-versions.md)**
   - Fix Flutter/Dart version inconsistencies across CI workflows
   - Labels: `ci`, `flutter`, `high priority`

2. **[Fix build_runner & Analysis Errors](fix-build-runner-errors.md)**
   - Resolve build_runner snapshot and missing-import errors
   - Labels: `ci`, `analysis`, `high priority`

3. **[Centralize Error Handling](centralize-error-handling.md)**
   - Extract NotificationService and replace all SnackBar calls
   - Labels: `refactoring`, `flutter`, `high priority`

### 🟡 High Priority

4. **[Integrate Cached Network Images](integrate-cached-network-images.md)**
   - Add cached_network_image for offline-capable image caching
   - Labels: `performance`, `flutter`, `enhancement`

5. **[Harden Firestore Rules](harden-firestore-rules.md)**
   - Enhance Firestore security rules (admin checks + rate limiting)
   - Labels: `security`, `firestore`, `high priority`

### 🟢 Medium Priority

6. **[Create Missing Documentation](create-missing-docs.md)**
   - Scaffold API, Onboarding, and Security docs
   - Labels: `documentation`, `medium priority`

7. **[Add Release Notes Generation](add-release-notes-generation.md)**
   - Integrate release-notes script into release workflow
   - Labels: `ci`, `automation`, `medium priority`

### 🔧 Existing Templates

8. **[CI Network Access Issue](ci-network-access.md)**
   - Report blocked network access in CI
   - Labels: `ci`

## Usage

To create a new issue using these templates:

1. Go to the Issues tab in your GitHub repository
2. Click "New issue"
3. Select the appropriate template from the list
4. Fill in the required information
5. Submit the issue

## Template Structure

Each template includes:
- **Description**: Clear explanation of the issue
- **Current Issues**: List of problems being addressed
- **Acceptance Criteria**: Specific requirements for completion
- **Files to Update**: List of files that need modification
- **Implementation Steps**: Step-by-step approach
- **Definition of Done**: Clear completion criteria

## Contributing

When adding new templates:
1. Follow the existing format and structure
2. Include all required sections
3. Use appropriate labels
4. Test the template by creating a test issue
5. Update this README with the new template 