#!/usr/bin/env bash
set -euo pipefail

# Usage:
# APP_URLS="https://admin.example.com,https://business.example.com,https://enterprise.example.com" \
# PR_NUMBER=123 GITHUB_TOKEN=ghp_xxx \
# bash scripts/promote_to_prod.sh

SHA=$(git rev-parse HEAD)
echo "Release SHA: $SHA"

echo "Deploying Hosting to production..."
firebase deploy --only hosting | cat

APP_URLS_CSV=${APP_URLS:-}
if [[ -z "$APP_URLS_CSV" ]]; then
  echo "APP_URLS is not set; skipping pings and Lighthouse."
  exit 0
fi

IFS=',' read -r -a URLS <<< "$APP_URLS_CSV"

echo "Pinging /api/debug-sentry on each app..."
for url in "${URLS[@]}"; do
  dbg="${url%/}/api/debug-sentry"
  echo "- $dbg"
  set +e
  resp=$(curl -sS "$dbg" || true)
  code=$(curl -s -o /dev/null -w "%{http_code}" "$dbg" || true)
  set -e
  echo "  status=$code body=$resp"
done

echo "Collecting Lighthouse (if @lhci/cli is available)..."
mkdir -p .lhr
for url in "${URLS[@]}"; do
  if npx --yes @lhci/cli@0.14.0 --help >/dev/null 2>&1; then
    safe=$(echo "$url" | sed 's#https\?://##; s#[^a-zA-Z0-9._-]#_#g')
    out=".lhr/${safe}.json"
    echo "- LHCI collect: $url -> $out"
    npx --yes @lhci/cli@0.14.0 collect --url="$url" --numberOfRuns=1 --outputPath="$out" >/dev/null 2>&1 || true
    node tools/summarize_lhr.mjs "$out" || true
  fi
done

if [[ -n "${GITHUB_TOKEN:-}" && -n "${PR_NUMBER:-}" ]]; then
  echo "Posting summary comment to PR #$PR_NUMBER"
  summary=$(printf "Release: %s\n" "$SHA")
  body=$(jq -Rc --arg s "$summary" '{body: $s}' <<<"")
  curl -s -X POST \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${PR_NUMBER}/comments" \
    -d "{\"body\": \"Deployed release ${SHA} to production.\"}" >/dev/null 2>&1 || true
fi

echo "Done."



