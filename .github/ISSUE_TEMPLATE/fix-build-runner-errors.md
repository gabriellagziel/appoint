---
name: Fix build_runner & Analysis Errors
about: Resolve build_runner snapshot and missing-import errors
title: "Resolve build_runner snapshot and missing-import errors"
labels: ["ci", "analysis", "high priority"]
assignees: []
---

## Description
The analyzer report shows ~44 errors, mostly missing core imports (`dart:core`, `package:flutter/material.dart`) and build_runner snapshot mismatches. Without these fixes, code generation and static analysis are non-functional.

## Current Issues
- Missing core imports in generated files
- build_runner snapshot mismatches
- Analysis failures in CI
- Code generation errors

## Acceptance Criteria
- [ ] CI environment installs Flutter 3.32.0 before analysis
- [ ] Missing imports (`dart:core`, `package:flutter/material.dart`) are added to affected files
- [ ] `build_runner` configuration (e.g. `build.yaml`) is corrected so snapshots generate without errors
- [ ] All `flutter analyze` jobs pass with zero errors
- [ ] `dart run build_runner build --delete-conflicting-outputs` completes successfully

## Files to Investigate
- [ ] `lib/generated/` directory for generated files
- [ ] `build.yaml` configuration file
- [ ] `pubspec.yaml` for build_runner dependencies
- [ ] CI workflow files for proper setup order

## Implementation Steps
1. Run `flutter analyze` locally to identify specific files with missing imports
2. Check `build.yaml` configuration for build_runner settings
3. Add missing imports to generated files or fix generation templates
4. Update CI workflows to ensure proper Flutter setup before analysis
5. Test build_runner generation locally and in CI
6. Verify all analysis passes

## Definition of Done
- [ ] `flutter analyze` passes with zero errors
- [ ] `dart run build_runner build` completes successfully
- [ ] All CI analysis jobs pass
- [ ] No missing import errors in generated files 