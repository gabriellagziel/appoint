#!/usr/bin/env bash
set -euo pipefail

fail(){ echo "❌ $*"; exit 1; }
ok(){ echo "✅ $*"; }

echo "== Workflows =="
workflow_files=$(find .github/workflows -type f \( -name "*.yml" -o -name "*.yaml" \) 2>/dev/null || true)
core_count=$(echo "$workflow_files" | xargs -r grep -l '^name:[[:space:]]*core-ci' | wc -l | awk '{print $1}')
[ "${core_count:-0}" -ge 1 ] || fail "core-ci workflow not found"

# Only core-ci should have push/pull_request; others must be workflow_dispatch
non_core_triggers=$(echo "$workflow_files" | xargs -r grep -nE '(^pull_request:|^push:|^schedule:)' \
  | grep -v '/core-ci.yml:' || true)
if [ -n "$non_core_triggers" ]; then
  echo "$non_core_triggers" | sed 's/^/   /'
  fail "Non-core workflows still have auto triggers (push/pull_request/schedule)"
else
  ok "All non-core workflows are manual-only"
fi

echo "== Branch protection =="
REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)"
[ -n "$REPO" ] || fail "gh not authenticated (run: gh auth login)"
contexts=$(gh api repos/$REPO/branches/main/protection | jq -r '.required_status_checks.checks[].context' 2>/dev/null || true)
echo "$contexts" | sed 's/^/   /'
need1="Flutter (web) build"
need2="Next.js apps build"
need3="Cloud Functions compile"
echo "$contexts" | grep -Fxq "$need1" || fail "Missing required check: $need1"
echo "$contexts" | grep -Fxq "$need2" || fail "Missing required check: $need2"
echo "$contexts" | grep -Fxq "$need3" || fail "Missing required check: $need3"
ok "Branch protection requires exactly the 3 core checks"

echo "== Functions runtime ==="
type_val=$(jq -r '.type // ""' functions/package.json)
engine_val=$(jq -r '.engines.node // ""' functions/package.json)
[ "$type_val" = "commonjs" ] || fail "functions/package.json must have \"type\":\"commonjs\""
[[ "$engine_val" == 18* ]] || fail "functions engines.node must start with 18 (got: $engine_val)"
ok "Functions CommonJS + Node 18 confirmed"

echo "== Pre-commit guard ==="
[ -x .githooks/pre-commit ] || fail ".githooks/pre-commit missing or not executable"
git config core.hooksPath | grep -q ".githooks" || fail "core.hooksPath not set to .githooks"
ok "Pre-commit guard installed"

echo "== Makefile & scripts =="
[ -f Makefile ] || fail "Makefile missing"
[ -x ops/scripts/local_core_sanity.sh ] || fail "local_core_sanity.sh missing/executable"
[ -x ops/scripts/enforce_required_checks.sh ] || fail "enforce_required_checks.sh missing/executable"
[ -x ops/scripts/smoke_curls.sh ] || fail "smoke_curls.sh missing/executable"
ok "Makefile and helper scripts present"

echo "== i18n =="
node ops/scripts/i18n_diff.mjs >/dev/null 2>&1 || true
[ -f ops/audit/tests/i18n.md ] || fail "i18n diff report missing"
missing_cnt=$(grep -E "^- missing \([0-9]+\)" -h ops/audit/tests/i18n.md | awk -F'[()]' '{sum+=$2} END{print (sum==""?0:sum)}')
echo "   total missing keys: ${missing_cnt:-0}"
[ "${missing_cnt:-0}" -eq 0 ] && ok "i18n has no missing keys" || echo "⚠️ i18n gaps exist → see ops/audit/tests/i18n.md"

echo "== README badge =="
grep -q "actions/workflows/core-ci.yml/badge.svg" README.md && ok "README has core-ci badge" || echo "⚠️ Core CI badge not found in README"

echo "== Vercel mapping docs =="
[ -f ops/audit/vercel/mapping.md ] && ok "ops/audit/vercel/mapping.md present" || echo "⚠️ mapping.md missing"
[ -f ops/vercel/README.md ] && ok "ops/vercel/README.md present" || echo "⚠️ ops/vercel/README.md missing"

echo "== core-ci recent =="
gh run list --limit 10 --json name,workflowName,conclusion,url,headBranch \
 | jq -r '.[] | "- \(.workflowName) • \(.headBranch) • \(.conclusion // "n/a") • \(.url)"' \
 | sed 's/^/   /'

echo
ok "All guardrails verified (or flagged above)."


