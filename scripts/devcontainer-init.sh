#!/usr/bin/env bash
set -e
for domain in storage.googleapis.com dart.dev pub.dev firebase-public.firebaseio.com raw.githubusercontent.com; do
  echo "Checking $domain…"
  curl --fail "https://$domain" -I >/dev/null
done
echo "All domains reachable."
