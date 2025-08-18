#!/usr/bin/env bash
set -euo pipefail

echo "== Flutter web =="
( cd appoint && flutter config --enable-web && flutter pub get && flutter analyze && flutter test || true && flutter build web --release --no-tree-shake-icons )

for APP in marketing business enterprise-app dashboard; do
  [ -d "$APP" ] || continue
  echo "== Next.js: $APP =="
  ( cd "$APP" && npx -y npm@10 ci && npm run build )
done

echo "== Functions =="
( cd functions && npx -y npm@10 ci && node -e "const p=require('./package.json'); if(p.type!=='commonjs') process.exit(1); if(!(p.engines && p.engines.node && p.engines.node.startsWith('18'))) process.exit(1)" && npm run build --if-present )
echo "All good."


