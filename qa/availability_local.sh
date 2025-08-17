#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(git rev-parse --show-toplevel)"
OUT="$ROOT_DIR/qa/output/availability_local.txt"
echo "== Local availability ==" > "$OUT"
for h in \
  http://127.0.0.1:3000 \
  http://127.0.0.1:3001 \
  http://127.0.0.1:3002 \
  http://127.0.0.1:3003 \
  http://127.0.0.1:3010 \
  http://127.0.0.1:3005; do
  echo "== $h ==" | tee -a "$OUT"
  curl -s -o /dev/null -w "status:%{http_code} time:%{time_total}s\n" "$h" | tee -a "$OUT"
  curl -sI "$h" | head -5 | tr -d '\r' | tee -a "$OUT"
  echo | tee -a "$OUT"
done

