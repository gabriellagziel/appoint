---
name: Standardize Flutter & Dart Versions
about: Standardize Flutter & Dart versions across all CI workflows
title: "Standardize Flutter & Dart versions across all CI workflows"
labels: ["ci", "flutter", "high priority"]
assignees: []
---

## Description
Our GitHub Actions workflows currently reference multiple Flutter versions (3.20.0, 3.32.4, etc.) and sometimes fail to cache properly. This causes build inconsistencies and spurious errors.

## Current Issues
- Multiple workflows use different Flutter versions
- Inconsistent caching configuration
- Build failures due to version mismatches
- Analysis errors from missing dependencies

## Acceptance Criteria
- [ ] All workflows use Flutter 3.32.0 and Dart 3.4.0
- [ ] `subosito/flutter-action@v2` is configured with `flutter-version: '3.32.0'` and `cache: true`
- [ ] `flutter pub get` runs before `flutter analyze` and `flutter test`
- [ ] CI logs show successful Flutter setup and analysis steps
- [ ] All workflows pass consistently

## Files to Update
- [ ] `.github/workflows/ci.yml`
- [ ] `.github/workflows/flutter.yml`
- [ ] `.github/workflows/flutter_web.yml`
- [ ] `.github/workflows/pr_checks.yml`
- [ ] `.github/workflows/release.yml`

## Implementation Steps
1. Update environment variables in all workflows to use `FLUTTER_VERSION: "3.32.0"` and `DART_VERSION: "3.4.0"`
2. Ensure `subosito/flutter-action@v2` is used consistently with proper caching
3. Add `flutter pub get` step before analysis and testing
4. Test all workflows to ensure they pass
5. Update documentation if needed

## Definition of Done
- [ ] All CI workflows use the same Flutter/Dart versions
- [ ] No build failures due to version mismatches
- [ ] Caching works properly across all workflows
- [ ] All tests pass consistently 