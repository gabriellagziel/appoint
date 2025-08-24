#!/usr/bin/env bash
set -euo pipefail
echo "== Scanning for personal booking routes =="

# search common web apps (Next.js)
apps=(marketing business enterprise-app dashboard)
pat_routes='(\/u\/\[?(handle|user(name)?)\]?|\/@\[?(handle|user(name)?)\]?|\/(book|meeting|meet|m)\/\[?(handle|user(name)?)\]?)'
pat_text='(create.*meeting|new.*meeting|book.*appointment|book.*meeting)'

found=()

for a in "${apps[@]}"; do
  [ -d "$a" ] || continue
  # App Router (app/ and src/app)
  if [ -d "$a/app" ]; then
    if rg -n --pcre2 -S "$pat_routes" "$a/app" 2>/dev/null; then
      found+=("$a/app")
    fi
  fi
  if [ -d "$a/src/app" ]; then
    if rg -n --pcre2 -S "$pat_routes" "$a/src/app" 2>/dev/null; then
      found+=("$a/src/app")
    fi
  fi
  # Pages Router (pages/ and src/pages)
  if [ -d "$a/pages" ]; then
    if rg -n --pcre2 -S "$pat_routes" "$a/pages" 2>/dev/null; then
      found+=("$a/pages")
    fi
  fi
  if [ -d "$a/src/pages" ]; then
    if rg -n --pcre2 -S "$pat_routes" "$a/src/pages" 2>/dev/null; then
      found+=("$a/src/pages")
    fi
  fi
done

# Flutter (appoint)
if [ -d appoint ]; then
  { rg -n -S "$pat_text" appoint/lib 2>/dev/null || true; } | head -n 20
  { rg -n -S '/(u|book|meeting|meet|m)/' appoint/lib 2>/dev/null || true; } | head -n 20
fi

echo
echo "== Candidate patterns =="
{ rg -n --pcre2 -S "$pat_routes" -g '!node_modules' -g '!**/*.min.*' . 2>/dev/null || true; } | sed -E 's/^/ - /' | head -n 50

echo
echo "== Guess (top common patterns) =="
printf '%s\n' \
  "https://app-oint.com/u/<handle>" \
  "https://app-oint.com/@<handle>" \
  "https://app-oint.com/book/<handle>" \
  "https://app-oint.com/meet/<handle>" \
  "https://app-oint.com/m/<handle>"
