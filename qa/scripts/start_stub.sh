#!/usr/bin/env bash
set -euo pipefail
PORT=${PORT:-3000}
APP_NAME=${APP_NAME:-app}
TMPDIR=$(mktemp -d)
cat > "$TMPDIR/index.html" <<HTML
<!doctype html>
<meta charset="utf-8"/>
<title>stub - $APP_NAME</title>
<h1>$APP_NAME (stub)</h1>
<ul>
 <li><a href="http://127.0.0.1:3001/">Business</a></li>
 <li><a href="http://127.0.0.1:3003/">API</a></li>
 <li><a href="http://127.0.0.1:3010/">Personal</a></li>
 <li><a href="/login">Login</a></li>
 <li><a href="/dashboard">Dashboard</a></li>
 <li><a href="/keys">API Keys</a></li>
 <li><a href="/admin">Admin</a></li>
</ul>
HTML
npx --yes http-server "$TMPDIR" -p "$PORT"


