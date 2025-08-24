#!/bin/bash
echo "=== 1. DNS Verification ==="
bash ops/scripts/verify_user_subdomains.sh app-oint.com

echo -e "\n=== 2. Backend Still Live ==="
curl -s -o /dev/null -w "Backend: %{http_code}\n" https://us-central1-app-oint-core.cloudfunctions.net/businessApi

echo -e "\n=== 3. PR Status ==="
gh pr view 541 --json state,reviewDecision,mergeable

echo -e "\n=== 4. PR Checks ==="
gh pr checks 541

echo -e "\n=== Ready for merge commands (for reviewer): ==="
echo "gh pr review 541 --approve"
echo "gh pr merge 541 --squash --delete-branch"
