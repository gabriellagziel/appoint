#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

export $(grep -v '^#' qa/.env.qa | xargs)

echo "== Start local servers =="
bash qa/start_local.sh

echo "== Availability (local) =="
bash qa/availability_local.sh

echo "== Playwright tests =="
cd qa
npx playwright test --project=chromium --reporter=list | tee ../qa/output/run_local.txt

echo "== Lighthouse =="
npm run lh | cat || true

echo "== Clean data (stub) =="
node scripts/clean_data.ts | tee ../qa/output/clean.log || true

echo "== Zip artifacts =="
bash scripts/zip_artifacts.sh | cat

echo "== FINAL VERDICT: See summary and run logs in qa/output =="


