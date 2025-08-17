# Required CI Checks

## App-Oint Monorepo

This document outlines the required CI checks that should be configured in GitHub Branch Protection Rules to ensure code quality and deployment safety.

## Current Workflow Status

| Workflow | Status | Purpose | Required for |
|----------|--------|---------|--------------|
| **CI** | ✅ Active | Basic validation (Flutter + Node.js) | All branches |
| **CI Minimal** | ✅ Active | Lightweight validation | Feature branches |
| **Main CI** | ✅ Active | Comprehensive testing | Main branch |
| **Security QA** | ✅ Active | Security scanning | All branches |
| **100% QA** | ✅ Active | Full test suite | Main branch |
| **Deploy Production** | ✅ Active | Production deployment | Main branch |

## Required Checks for Branch Protection

### Main Branch Protection
```yaml
# Required checks that must pass before merging
required_status_checks:
  strict: true
  contexts:
    - "CI"
    - "Main CI"
    - "Security QA"
    - "100% QA"
    - "Deploy Production"
```

### Feature Branch Protection
```yaml
# Required checks for feature branches
required_status_checks:
  strict: false
  contexts:
    - "CI Minimal"
    - "Security QA"
```

## Check Descriptions

### 1. CI (Basic Validation)
- **Purpose**: Basic structural validation
- **Triggers**: Push, Pull Request
- **Duration**: ~15 minutes
- **Checks**:
  - Flutter setup and analysis
  - Node.js setup and installation
  - Basic linting and validation
  - ARB file validation
  - Spell checking

### 2. CI Minimal (Lightweight)
- **Purpose**: Quick validation for feature branches
- **Triggers**: Push, Pull Request
- **Duration**: ~5 minutes
- **Checks**:
  - Basic file validation
  - Syntax checking
  - Minimal dependency validation

### 3. Main CI (Comprehensive)
- **Purpose**: Full validation for main branch
- **Triggers**: Push to main
- **Duration**: ~30 minutes
- **Checks**:
  - Full test suite
  - Build validation
  - Integration testing
  - Performance checks

### 4. Security QA
- **Purpose**: Security scanning and validation
- **Triggers**: Push, Pull Request
- **Duration**: ~10 minutes
- **Checks**:
  - CodeQL analysis
  - Dependency scanning
  - Security policy compliance
  - Vulnerability assessment

### 5. 100% QA
- **Purpose**: Complete quality assurance
- **Triggers**: Push to main
- **Duration**: ~45 minutes
- **Checks**:
  - Full test coverage
  - E2E testing
  - Lighthouse performance
  - Accessibility testing
  - Internationalization audit

### 6. Deploy Production
- **Purpose**: Production deployment validation
- **Triggers**: Push to main
- **Duration**: ~20 minutes
- **Checks**:
  - Build verification
  - Deployment readiness
  - Environment validation
  - Health check verification

## Branch Protection Rules

### Main Branch (`main`)
```yaml
protection_rules:
  required_status_checks:
    strict: true
    contexts:
      - "CI"
      - "Main CI"
      - "Security QA"
      - "100% QA"
      - "Deploy Production"
  
  required_pull_request_reviews:
    required_approving_review_count: 2
    dismiss_stale_reviews: true
    require_code_owner_reviews: true
  
  enforce_admins: false
  allow_force_pushes: false
  allow_deletions: false
  block_creations: false
  required_conversation_resolution: true
```

### Development Branch (`develop`)
```yaml
protection_rules:
  required_status_checks:
    strict: false
    contexts:
      - "CI"
      - "Security QA"
  
  required_pull_request_reviews:
    required_approving_review_count: 1
    dismiss_stale_reviews: true
  
  enforce_admins: false
  allow_force_pushes: false
  allow_deletions: false
  block_creations: false
  required_conversation_resolution: true
```

### Feature Branches (`feature/*`)
```yaml
protection_rules:
  required_status_checks:
    strict: false
    contexts:
      - "CI Minimal"
      - "Security QA"
  
  required_pull_request_reviews:
    required_approving_review_count: 1
    dismiss_stale_reviews: true
  
  enforce_admins: false
  allow_force_pushes: true
  allow_deletions: true
  block_creations: false
  required_conversation_resolution: false
```

## Check Dependencies

### Sequential Execution
Some checks depend on others and should run in sequence:

1. **CI** → **Main CI** (if CI passes)
2. **Security QA** → **100% QA** (if security passes)
3. **All Checks** → **Deploy Production** (if all pass)

### Parallel Execution
Independent checks can run in parallel:
- **CI** and **Security QA** can run simultaneously
- **100% QA** can start after **CI** passes
- **Deploy Production** waits for all checks

## Failure Handling

### Check Failures
- **Required Checks**: Must pass before merge
- **Optional Checks**: Can fail without blocking merge
- **Flaky Checks**: Should be investigated and fixed

### Retry Logic
- **Automatic Retry**: Up to 3 attempts for transient failures
- **Manual Retry**: Developers can manually retry failed checks
- **Skip Checks**: Only for emergency fixes (requires admin approval)

## Monitoring and Alerts

### Check Status Dashboard
- **GitHub Actions**: Real-time status monitoring
- **Required Checks**: Branch protection compliance
- **Performance Metrics**: Check duration and success rates

### Alert Notifications
- **Check Failures**: Immediate notification to team
- **Performance Degradation**: Weekly performance reports
- **Security Issues**: Immediate security team notification

## Future Improvements

### Planned Enhancements
1. **Parallel Execution**: Optimize check dependencies
2. **Caching**: Implement build and dependency caching
3. **Conditional Checks**: Skip checks for documentation-only changes
4. **Performance Monitoring**: Track and optimize check durations

### Check Consolidation
After repository consolidation:
- **Eliminate Duplicate Workflows**: Remove web-only repository workflows
- **Unified Validation**: Single CI pipeline for all applications
- **Simplified Protection Rules**: Consistent rules across all branches

---

**Note**: These required checks ensure code quality and deployment safety. They should be updated as the CI/CD pipeline evolves and new checks are added.
