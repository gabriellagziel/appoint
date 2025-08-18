#!/usr/bin/env bash
set -euo pipefail
REQ=("Flutter (web) build" "Next.js apps build" "Cloud Functions compile")
REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
echo "Enforcing required checks on $REPO ..."
CUR=$(gh api repos/$REPO/branches/main/protection | jq -r '.required_status_checks.checks[].context' 2>/dev/null || true)
echo "Current: $CUR"
# Apply definitive set
gh api -X PUT repos/$REPO/branches/main/protection \
  -H "Accept: application/vnd.github+json" \
  -f required_status_checks.strict=true \
  $(printf -- " -f required_status_checks.contexts[]=%q" "${REQ[@]}") \
  -f enforce_admins=true \
  -F required_pull_request_reviews='{"required_approving_review_count":1}' \
  -F restrictions='null'
echo "Done."


