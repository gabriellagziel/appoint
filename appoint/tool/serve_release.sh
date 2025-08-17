#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

IP=$(ifconfig | awk '/inet / && $2!="127.0.0.1"{print $2; exit}')
PORT=${1:-3012}

echo "Desktop: http://localhost:$PORT/?preview=mobile#/home"
echo "Phone:   http://$IP:$PORT/?preview=mobile#/home"

cd build/web
python3 -m http.server "$PORT" --bind 0.0.0.0


