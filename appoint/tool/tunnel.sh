#!/usr/bin/env bash
set -euo pipefail
PORT=${1:-3012}

if ! command -v ngrok >/dev/null 2>&1; then
  echo "Install ngrok first: brew install ngrok/ngrok/ngrok"
  exit 1
fi

ngrok http --scheme=http "$PORT"


