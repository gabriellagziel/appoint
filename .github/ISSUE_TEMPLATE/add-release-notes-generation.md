---
name: Add Release Notes Generation
about: Integrate release-notes script into release workflow
title: "Integrate release-notes script into release workflow"
labels: ["ci", "automation", "medium priority"]
assignees: []
---

## Description
Our release workflow lacks automated release-note generation. We have a script under `scripts/generate_release_notes.sh`—we need to invoke it in GitHub Actions.

## Current Issues
- Manual release note generation
- Inconsistent release documentation
- Time-consuming release process
- Risk of missing important changes

## Acceptance Criteria
- [ ] Release workflow (`.github/workflows/release.yml`) calls `scripts/generate_release_notes.sh --dry-run` on `pull_request` and `workflow_dispatch`
- [ ] Script output appears in job logs
- [ ] Release notes formatting matches project standards
- [ ] Script runs successfully in CI environment
- [ ] Release notes are generated for actual releases

## Files to Update
- [ ] `.github/workflows/release.yml` - add release notes generation step
- [ ] `scripts/generate_release_notes.sh` - ensure it works in CI
- [ ] Test the script in CI environment

## Implementation Steps
1. Review existing `scripts/generate_release_notes.sh` script
2. Add step to release workflow to run the script
3. Configure script to run on pull requests and manual triggers
4. Test the workflow in a pull request
5. Verify release notes are generated correctly
6. Update documentation if needed

## Workflow Integration
```yaml
- name: Generate Release Notes
  run: |
    chmod +x scripts/generate_release_notes.sh
    ./scripts/generate_release_notes.sh --dry-run
  if: github.event_name == 'pull_request' || github.event_name == 'workflow_dispatch'
```

## Definition of Done
- [ ] Release workflow includes release notes generation
- [ ] Script runs successfully in CI environment
- [ ] Release notes appear in job logs
- [ ] Format matches project standards
- [ ] Process is documented 