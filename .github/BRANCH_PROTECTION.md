# Branch Protection Setup Guide

## Required Status Checks

To enable branch protection for the `main` branch, go to:

**Settings > Branches > Add rule** and configure:

### Branch name pattern
```
main
```

### Protection rules to enable:

#### ✅ Require a pull request before merging
- **Require pull request reviews before merging**: Enabled
- **Required approving reviews**: 1
- **Dismiss stale PR approvals when new commits are pushed**: Enabled
- **Require review from code owners**: Enabled (if you have CODEOWNERS file)

#### ✅ Require status checks to pass before merging
- **Require branches to be up to date before merging**: Enabled
- **Required status checks**:
  - `Build` (from `.github/workflows/build.yml`)
  - `Test` (from `.github/workflows/test.yml`)
  - `Security` (from `.github/workflows/security.yml`)

#### ✅ Require conversation resolution before merging
- **Require conversation resolution before merging**: Enabled

#### ✅ Require signed commits
- **Require signed commits**: Enabled (recommended for security)

#### ✅ Require linear history
- **Require linear history**: Enabled (prevents merge commits)

#### ✅ Require deployments to succeed before merging
- **Require deployments to succeed before merging**: Enabled (if you have deployment workflows)

#### ✅ Lock branch
- **Lock branch**: Disabled (allow pushes from maintainers)

#### ✅ Do not allow bypassing the above settings
- **Do not allow bypassing the above settings**: Enabled

## Additional Settings

### Restrict pushes that create files
- **Restrict pushes that create files**: Enabled

### Restrict pushes that delete files
- **Restrict pushes that delete files**: Enabled

### Restrict pushes that modify files
- **Restrict pushes that modify files**: Enabled

## Workflow Integration

The following workflows will be required to pass:

1. **Build** (`build.yml`) - Builds the app on all platforms
2. **Test** (`test.yml`) - Runs tests with 80% coverage requirement
3. **Security** (`security.yml`) - Security scans and compliance checks

## Codecov Integration

The test workflow includes:
- Coverage reporting to Codecov
- 80% minimum coverage requirement
- Coverage badge in README

## Security Features

The security workflow includes:
- Dependency vulnerability scanning
- Code security analysis
- Firebase security rules validation
- Secrets scanning with TruffleHog
- Compliance checks

## Enforcement

Once enabled, all PRs to `main` must:
1. Have at least one approving review
2. Pass all required status checks
3. Be up to date with the base branch
4. Have all conversations resolved
5. Meet the 80% coverage threshold 