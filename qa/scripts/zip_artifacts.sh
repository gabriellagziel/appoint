#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
mkdir -p qa
rm -f qa/qa_artifact.zip || true
zip -r qa/qa_artifact.zip qa/output qa/lighthouse qa/screenshots qa/videos .auth -x "*.DS_Store" | cat
echo "sandbox:/qa/qa_artifact.zip"


