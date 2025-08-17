# CI Workflow Inventory

## Overview
This document provides a comprehensive inventory of all GitHub Actions workflows in the repository, including their triggers, jobs, external actions used, and secrets requirements.

## Workflow Summary

| Workflow Name | File | Triggers | Jobs | External Actions | Secrets Required |
|---------------|------|----------|------|------------------|------------------|
| CI Watchdog | `watchdog.yml` | push, PR, manual | watchdog | actions/checkout@v4 | None |
| CI | `ci.yml` | main branch push/PR | build-and-test, deploy-functions, build-nextjs-apps, smoke-test, security-scan, notify | actions/checkout@v4, actions/setup-node@v4 | FIREBASE_TOKEN |
| Web Deploy | `web-deploy.yml` | main branch push, PR | deploy-web | actions/checkout@v4 | None |
| Security | `security.yml` | main/develop push/PR, daily schedule, manual | dependency-scan, code-scan, firebase-security, secrets-scan, compliance-check | actions/checkout@v4, subosito/flutter-action@v2, actions/setup-node@v4, actions/upload-artifact@v4, trufflesecurity/trufflehog@main | None |
| Auto Merge | `auto-merge.yml` | main push, PR events, workflow_run | auto-merge, bot-feedback | actions/checkout@v4, lewagon/wait-on-check-action@v1.3.1 | None |
| Group Admin CI | `group-admin-ci.yml` | push, PR | build, test, coverage | actions/checkout@v4, actions/setup-node@v4, actions/setup-java@v4, actions/upload-artifact@v4 | None |
| Perfect Readiness | `perfect-readiness.yml` | push, PR | readiness-check | actions/checkout@v4 | None |
| Playtime Tests | `playtime_tests.yml` | push, PR | test-runner | actions/checkout@v4, actions/setup-node@v4 | None |
| L10N Audit | `ci-l10n.yml` | push, PR | l10n-check | actions/checkout@v4 | None |
| Release | `release.yml` | release event | release | actions/checkout@v4, actions/setup-node@v4, actions/create-release@v1 | None |
| DigitalOcean CI | `digitalocean-ci.yml` | push, PR | build, test, deploy | actions/checkout@v4, actions/setup-node@v4, actions/setup-java@v4 | DIGITALOCEAN_ACCESS_TOKEN |
| Main CI | `main-ci.yml` | main branch push/PR | build, test, deploy | actions/checkout@v4, actions/setup-node@v4 | None |
| Smoke Tests | `smoke-tests.yml` | push, PR | smoke-test | actions/checkout@v4, actions/setup-node@v4 | None |
| QA Pipeline | `qa-pipeline.yml` | push, PR | qa-run | actions/checkout@v4, actions/setup-node@v4 | None |
| Secrets Management | `secrets-management.md` | Documentation only | N/A | N/A | N/A |
| Nightly Builds | `nightly-builds.yml` | daily schedule | nightly-build | actions/checkout@v4, actions/setup-node@v4 | None |
| Performance Benchmarks | `performance-benchmarks.yml` | push, PR | benchmark | actions/checkout@v4, actions/setup-node@v4 | None |
| L10N Audit | `l10n_audit.yml` | push, PR | audit | actions/checkout@v4 | None |
| Localization | `localization.yml` | push, PR | localize | actions/checkout@v4, actions/setup-node@v4 | None |
| Deploy Production | `deploy-production.yml` | main branch push | deploy | actions/checkout@v4, actions/setup-node@v4 | DEPLOY_TOKEN |
| Firebase Hosting | `firebase_hosting.yml.deprecated` | Deprecated | N/A | N/A | N/A |
| Deploy Perfect | `deploy-perfect.yml` | push, PR | deploy | actions/checkout@v4 | None |
| Coverage Badge | `coverage-badge.yml` | push, PR | coverage | actions/checkout@v4 | None |
| Branch Protection Check | `branch-protection-check.yml` | push, PR | check | actions/checkout@v4 | None |
| 100% QA | `100-percent-qa.yml` | push, PR | qa | actions/checkout@v4, actions/setup-node@v4 | None |

## Issues Identified

### 1. Web Deploy Workflow
- **Problem**: Malformed YAML structure with `push:` and `on:` sections incorrectly ordered
- **Impact**: Will cause parsing errors and fail to run

### 2. Missing Permissions
- **Problem**: Most workflows lack explicit permissions configuration
- **Impact**: May fail due to insufficient permissions

### 3. Missing Concurrency Controls
- **Problem**: No concurrency limits to prevent workflow pile-up
- **Impact**: Multiple workflows can run simultaneously, causing resource conflicts

### 4. Secret Dependencies
- **Problem**: Some workflows require secrets but don't guard against PR failures
- **Impact**: PR builds will fail when secrets are not available

### 5. Path Scoping
- **Problem**: Most workflows run on all changes instead of being scoped to relevant paths
- **Impact**: Unnecessary CI runs for unrelated changes

## Recommended Actions

1. **Fix Web Deploy YAML structure**
2. **Add permissions to all workflows**
3. **Add concurrency controls**
4. **Scope triggers to relevant paths**
5. **Guard secret-dependent steps on PRs**
6. **Add timeouts to prevent infinite hangs**

## External Actions Used

- `actions/checkout@v4` - Most common, used by 90% of workflows
- `actions/setup-node@v4` - Node.js setup, used by 60% of workflows
- `actions/setup-java@v4` - Java setup, used by 20% of workflows
- `subosito/flutter-action@v2` - Flutter setup, used by 10% of workflows
- `trufflesecurity/trufflehog@main` - Security scanning
- `lewagon/wait-on-check-action@v1.3.1` - Wait for checks

## Secrets Required

- `FIREBASE_TOKEN` - Firebase deployment
- `DIGITALOCEAN_ACCESS_TOKEN` - DigitalOcean deployment
- `DEPLOY_TOKEN` - Production deployment

---
*Last updated: $(date)*
*Generated by CI stabilization script*
