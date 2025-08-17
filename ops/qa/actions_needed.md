# Actions Needed: PRs & Issues

## Overview
This document lists all required actions to achieve a "perfect" codebase, organized by priority and type.

## High Priority Actions (This Week)

### 🔴 Critical Security Issues

#### Issue: [QA] Security – Cloud Functions Vulnerabilities
- **File**: `functions/package.json`
- **Problem**: 4 moderate severity vulnerabilities in esbuild/vite
- **Impact**: Development server security risk
- **Fix**: Update esbuild to >0.24.2, update related packages
- **Effort**: Medium (breaking changes possible)
- **Priority**: 🔴 Critical

#### Issue: [QA] Security – Missing Security Scanning
- **File**: `.github/workflows/security-qa.yml`
- **Problem**: Security workflow doesn't actually scan for vulnerabilities
- **Impact**: Security issues not detected in CI
- **Fix**: Add real security scanning (npm audit, CodeQL)
- **Effort**: Low
- **Priority**: 🔴 Critical

### 🔴 Critical Test Issues

#### Issue: [QA] Tests – Flutter Tests Failing
- **File**: `appoint/test/features/home/home_landing_screen_test.dart`
- **Problem**: 2 tests failing (skeleton widget, dart:html)
- **Impact**: Test suite unreliable
- **Fix**: Fix test logic, mock dart:html for tests
- **Effort**: Medium
- **Priority**: 🔴 Critical

#### Issue: [QA] Tests – Missing Test Infrastructure
- **Files**: `marketing/`, `business/`, `admin/`, `enterprise-app/`, `dashboard/`
- **Problem**: No test setup in Next.js applications
- **Impact**: No quality assurance for web apps
- **Fix**: Add Jest/Vitest setup, basic test coverage
- **Effort**: High
- **Priority**: 🔴 Critical

## Medium Priority Actions (Next 2 Weeks)

### 🟡 Security & Dependencies

#### Issue: [QA] Dependencies – Flutter Major Updates
- **File**: `appoint/pubspec.yaml`
- **Problem**: Firebase SDK 4.x → 6.x, other major updates
- **Impact**: Security improvements, new features
- **Fix**: Plan and execute major version migrations
- **Effort**: High (breaking changes)
- **Priority**: 🟡 Medium

#### Issue: [QA] Dependencies – Next.js Major Updates
- **Files**: `marketing/package.json`, `business/package.json`, `admin/package.json`
- **Problem**: React 18 → 19, Next.js 14 → 15
- **Impact**: Performance improvements, new features
- **Fix**: Plan and execute major version migrations
- **Effort**: High (breaking changes)
- **Priority**: 🟡 Medium

### 🟡 CI/CD Improvements

#### Issue: [QA] CI – Deprecated Workflows
- **Files**: Multiple deprecated CI files
- **Problem**: Confusing workflow landscape, referenced in required checks
- **Impact**: CI confusion, maintenance overhead
- **Fix**: Remove deprecated workflows, update required checks
- **Effort**: Low
- **Priority**: 🟡 Medium

#### Issue: [QA] CI – Node Version Mismatch
- **Files**: All CI workflows
- **Problem**: CI uses Node 18.x, system has 22.14.0
- **Impact**: Potential compatibility issues
- **Fix**: Update CI to Node 22.x
- **Effort**: Low
- **Priority**: 🟡 Medium

### 🟡 Internationalization

#### Issue: [QA] i18n – Missing Next.js i18n Setup
- **Files**: `marketing/`, `business/`, `enterprise-app/`, `dashboard/`
- **Problem**: No internationalization support
- **Impact**: English-only web apps (inconsistent with Flutter PWA)
- **Fix**: Implement next-i18next or next-intl
- **Effort**: High
- **Priority**: 🟡 Medium

## Low Priority Actions (Next Month)

### 🟢 Performance & UX

#### Issue: [QA] Performance – Missing Lighthouse Scores
- **Files**: All web applications
- **Problem**: No performance metrics or PWA scores
- **Impact**: Performance unknown, PWA capabilities unverified
- **Fix**: Set up Lighthouse CI, run performance audits
- **Effort**: Medium
- **Priority**: 🟢 Low

#### Issue: [QA] UX – Incomplete User Flows
- **Files**: Multiple web applications
- **Problem**: Missing pages, incomplete navigation
- **Impact**: Poor user experience
- **Fix**: Complete missing pages, standardize navigation
- **Effort**: High
- **Priority**: 🟢 Low

### 🟢 Environment & Configuration

#### Issue: [QA] Environment – Missing Environment Variables
- **Files**: All applications
- **Problem**: Missing API endpoints, authentication config
- **Impact**: Apps may not function properly
- **Fix**: Create environment templates, add missing variables
- **Effort**: Medium
- **Priority**: 🟢 Low

## Quick Wins (Small PRs)

### ✅ Trivial Fixes

#### PR: Add missing concurrency to workflows
- **Files**: `.github/workflows/*.yml`
- **Change**: Add `concurrency` groups to prevent parallel runs
- **Risk**: None (no behavior change)
- **Effort**: Very Low

#### PR: Add permissions to workflows
- **Files**: `.github/workflows/*.yml`
- **Change**: Add explicit `permissions` sections
- **Risk**: None (security improvement)
- **Effort**: Very Low

#### PR: Fix path filters in workflows
- **Files**: `.github/workflows/*.yml`
- **Change**: Ensure proper path filtering for app-specific workflows
- **Risk**: None (optimization)
- **Effort**: Very Low

#### PR: Add missing build scripts
- **Files**: `package.json` files
- **Change**: Add `lint`, `test` scripts where missing
- **Risk**: None (harmless additions)
- **Effort**: Very Low

## Issue Templates

### Security Issue Template
```markdown
## [QA] Security – [Summary]

### Problem
[Describe the security issue]

### Impact
[Describe the impact on security]

### Evidence
- **File**: [file path]
- **Line**: [line number]
- **Command**: [command that shows the issue]

### Suggested Fix
[Describe how to fix the issue]

### Acceptance Criteria
- [ ] Issue is resolved
- [ ] Tests pass
- [ ] Security scan shows no vulnerabilities
- [ ] Documentation updated

### Priority
🔴 Critical / 🟡 Medium / 🟢 Low

### Effort Estimate
[Time estimate]
```

### Test Issue Template
```markdown
## [QA] Tests – [Summary]

### Problem
[Describe the test issue]

### Impact
[Describe the impact on quality]

### Evidence
- **File**: [file path]
- **Test**: [test name]
- **Error**: [error message]

### Suggested Fix
[Describe how to fix the issue]

### Acceptance Criteria
- [ ] Tests pass consistently
- [ ] No flaky tests
- [ ] Coverage maintained/improved
- [ ] Test documentation updated

### Priority
🔴 Critical / 🟡 Medium / 🟢 Low

### Effort Estimate
[Time estimate]
```

## Implementation Timeline

### Week 1: Critical Issues
- [ ] Fix Cloud Functions vulnerabilities
- [ ] Fix Flutter test failures
- [ ] Update security workflow
- [ ] Create quick win PRs

### Week 2: Security & Dependencies
- [ ] Scan all applications for vulnerabilities
- [ ] Plan dependency update strategy
- [ ] Remove deprecated CI workflows
- [ ] Update Node versions

### Week 3: Testing & i18n
- [ ] Set up test infrastructure for Next.js apps
- [ ] Plan i18n implementation
- [ ] Fix remaining test issues
- [ ] Add test coverage reporting

### Week 4: Performance & UX
- [ ] Set up Lighthouse CI
- [ ] Run performance audits
- [ ] Complete missing UX flows
- [ ] Standardize navigation

### Week 5-6: Polish & Documentation
- [ ] Environment variable setup
- [ ] Performance optimization
- [ ] Documentation updates
- [ ] Final validation

## Success Metrics

### Security
- **Vulnerabilities**: 0 high/critical issues
- **Security scanning**: 100% of apps covered
- **Security gates**: All security issues block PRs

### Quality
- **Test coverage**: >80% for all apps
- **Test reliability**: 0 flaky tests
- **CI reliability**: >99% success rate

### Performance
- **Lighthouse scores**: >90 for all metrics
- **Core Web Vitals**: All within targets
- **Bundle sizes**: Within performance budgets

### User Experience
- **i18n coverage**: 5+ languages for web apps
- **Navigation**: Consistent across all apps
- **Feature completeness**: 90%+ spec compliance

## Notes
- **Admin panel**: Keep English-only (no i18n needed)
- **Pro Groups**: No business logic changes needed
- **Priority**: Security first, then quality, then features
- **Breaking changes**: Plan carefully, test thoroughly
- **Documentation**: Update as changes are made
