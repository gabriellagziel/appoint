#!/usr/bin/env bash
set -euo pipefail

# Kill common ports so dev servers can bind
for p in 3000 3001 3002 3003 3004 3005 5000; do
  lsof -ti :$p 2>/dev/null | xargs -r kill -9 || true
done

# Node version sanity
node -v

# Clean (fallback without requiring rimraf yet)
rm -rf node_modules .turbo

# Minimal root dev tooling (without traversing workspaces)
npm i -D npm-run-all rimraf --workspaces=false || true

# Install design-system deps only and build it
npm --prefix packages/design-system i --workspaces=false
npm --prefix packages/design-system run build

echo "✅ Bootstrap complete. Run: npm run dev:all"


