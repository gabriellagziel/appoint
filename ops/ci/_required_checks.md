# Required CI Checks for Branch Protection

This document lists the CI checks that should be configured as required in GitHub branch protection rules.

## Current Required Checks

After the CI stabilization, the following checks should be configured as required in GitHub branch protection:

### Main Branch Protection
- [ ] **CI Watchdog** - Basic repository health check
- [ ] **actionlint** - GitHub Actions syntax validation
- [ ] **CI** - Main build and test pipeline
- [ ] **Security** - Security scanning and compliance checks

### Pull Request Checks
- [ ] **CI Watchdog** - Must pass before merge
- [ ] **actionlint** - Must pass before merge
- [ ] **CI** - Must pass before merge (excluding secret-dependent steps)
- [ ] **Security** - Must pass before merge

## Check Details

### 1. CI Watchdog
- **Workflow**: `watchdog.yml`
- **Job**: `watchdog`
- **Purpose**: Basic repository health validation
- **Requirements**: 
  - YAML syntax validation
  - Large file detection
  - Environment sanity check
- **Expected Duration**: < 5 minutes
- **Failure Impact**: Blocks merge if basic health checks fail

### 2. actionlint
- **Workflow**: `actionlint.yml`
- **Job**: `lint`
- **Purpose**: GitHub Actions syntax and best practices validation
- **Requirements**: 
  - Workflow YAML validation
  - Action reference validation
  - Best practices enforcement
- **Expected Duration**: < 5 minutes
- **Failure Impact**: Blocks merge if workflow syntax is invalid

### 3. CI
- **Workflow**: `ci.yml`
- **Jobs**: 
  - `build-and-test` (required)
  - `build-nextjs-apps` (required)
  - `deploy-functions` (optional on PRs - requires secrets)
  - `smoke-test` (optional on PRs - requires secrets)
  - `security-scan` (optional on PRs - requires secrets)
  - `notify` (always runs)
- **Purpose**: Main application build and test pipeline
- **Requirements**: 
  - All tests pass
  - All builds succeed
  - No critical errors
- **Expected Duration**: 15-30 minutes
- **Failure Impact**: Blocks merge if core functionality fails

### 4. Security
- **Workflow**: `security.yml`
- **Jobs**: 
  - `dependency-scan` (required)
  - `code-scan` (required)
  - `firebase-security` (required)
  - `secrets-scan` (required)
  - `compliance-check` (required)
- **Purpose**: Security and compliance validation
- **Requirements**: 
  - No critical security vulnerabilities
  - Compliance documents present
  - Security rules validated
- **Expected Duration**: 10-20 minutes
- **Failure Impact**: Blocks merge if security issues detected

## Optional Checks (Not Required for Merge)

### Web Deploy
- **Workflow**: `web-deploy.yml`
- **Purpose**: Web application deployment preparation
- **Note**: This is a preparation step, not a blocking check

### Auto Merge
- **Workflow**: `auto-merge.yml`
- **Purpose**: Automated PR merging when conditions are met
- **Note**: This runs after merge, not before

### Other Workflows
- `group-admin-ci.yml` - Group admin specific CI
- `perfect-readiness.yml` - Perfect readiness checks
- `playtime_tests.yml` - Playtime test suite
- `l10n_audit.yml` - Localization audit
- `release.yml` - Release automation
- `digitalocean-ci.yml` - DigitalOcean deployment
- `main-ci.yml` - Main CI pipeline
- `smoke-tests.yml` - Smoke test suite
- `qa-pipeline.yml` - QA pipeline
- `nightly-builds.yml` - Nightly builds
- `performance-benchmarks.yml` - Performance testing
- `localization.yml` - Localization pipeline
- `deploy-production.yml` - Production deployment
- `deploy-perfect.yml` - Perfect deployment
- `coverage-badge.yml` - Coverage reporting
- `branch-protection-check.yml` - Branch protection validation
- `100-percent-qa.yml` - 100% QA coverage

## Configuration Instructions

### 1. GitHub Branch Protection Setup
1. Go to repository Settings → Branches
2. Click "Add rule" for the `main` branch
3. Enable "Require status checks to pass before merging"
4. Add the required checks listed above
5. Enable "Require branches to be up to date before merging"
6. Save changes

### 2. Required Status Checks
Add these checks in order:
1. `CI Watchdog`
2. `actionlint`
3. `CI`
4. `Security`

### 3. Check Configuration
- **Strict**: Require branches to be up to date before merging
- **Contexts**: Only the checks listed above
- **Dismiss stale**: Allow stale checks to be dismissed

## Monitoring and Maintenance

### Check Health Monitoring
- Monitor check failure rates
- Track check execution times
- Alert on repeated failures

### Regular Review
- Review required checks quarterly
- Remove obsolete checks
- Add new critical checks as needed

### Performance Optimization
- Optimize slow-running checks
- Parallelize independent checks
- Cache dependencies where possible

## Troubleshooting

### Common Issues
1. **Check Not Appearing**: Ensure the workflow file exists and is valid
2. **Check Always Failing**: Review workflow configuration and dependencies
3. **Check Too Slow**: Optimize workflow steps and add caching
4. **False Positives**: Review check logic and thresholds

### Emergency Override
If a check is consistently failing and blocking critical work:
1. Temporarily disable the failing check
2. Investigate and fix the root cause
3. Re-enable the check once fixed
4. Document the incident and resolution

---
*Last updated: $(date)*
*Generated by CI stabilization script*
