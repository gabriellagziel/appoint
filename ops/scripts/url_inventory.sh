#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../../" && pwd)"
OUT_DIR="$REPO_ROOT/ops/audit/urls"
mkdir -p "$OUT_DIR"
cd "$REPO_ROOT" # repo root

# temp files
RAW_URLS="$OUT_DIR/raw_urls.tsv"
ENV_REFS="$OUT_DIR/env_refs.tsv"
REWRITES="$OUT_DIR/rewrites.tsv"
FUNCTIONS="$OUT_DIR/functions.tsv"
PUBLIC_FILES="$OUT_DIR/public_files.tsv"
>"$RAW_URLS"; >"$ENV_REFS"; >"$REWRITES"; >"$FUNCTIONS"; >"$PUBLIC_FILES"

# helper: infer app from path (top-level dir)
infer_app(){
  local f="$1"
  local top
  top=$(printf '%s' "$f" | awk -F'/' '{print $1}')
  case "$top" in
    marketing|business|dashboard|enterprise-app|functions|appoint|admin) echo "$top" ;;
    *) echo "other" ;;
  esac
}

# 1) Hardcoded URLs
# capture file:line and the URL matched
rg -nH --pcre2 -S "https?://[^\"'\\)\s]+" -g '!node_modules' -g '!**/*.min.*' . | while IFS=: read -r file line rest; do
  url=$(printf '%s' "$rest" | rg -o --pcre2 "https?://[^\"'\\)\s]+" | head -n1 || true)
  [ -n "$url" ] || continue
  app=$(infer_app "$file")
  printf '%s\t%s\t%s\t%s\t%s\n' "Hardcoded" "$app" "$url" "$file" "$line" >>"$RAW_URLS"
done || true

# 2) Env URL-like refs (names only)
rg -n --pcre2 -S "process\\.env\\.[A-Z0-9_]+" -g '!node_modules' . | while IFS=: read -r file line match; do
  var=$(printf '%s' "$match" | rg -o --pcre2 "process\\.env\\.[A-Z0-9_]+" | head -n1 || true)
  [ -n "$var" ] || continue
  app=$(infer_app "$file")
  printf '%s\t%s\t%s\t%s\t%s\n' "Env Reference" "$app" "$var" "$file" "$line" >>"$ENV_REFS"
done || true

# 3) Next.js rewrites/redirects and config
rg -n --pcre2 -S "(rewrites\\(|redirects\\(|basePath|trailingSlash)" -g '!node_modules' . | while IFS=: read -r file line text; do
  app=$(infer_app "$file")
  printf '%s\t%s\t%s\t%s\t%s\n' "Next Config" "$app" "$text" "$file" "$line" >>"$REWRITES"
done || true
# Attempt to extract source/destination pairs
rg -n --pcre2 -S "(source|destination)\s*:\s*['\"]([^'\"]+)['\"]" -g '!node_modules' . | while IFS=: read -r file line text; do
  app=$(infer_app "$file")
  patt=$(printf '%s' "$text" | sed -E 's/^\s+//')
  printf '%s\t%s\t%s\t%s\t%s\n' "Rewrite/Redirect" "$app" "$patt" "$file" "$line" >>"$REWRITES"
done || true

# 4) Firebase/Hosting configs
for cfg in vercel.json firebase.json; do
  rg -n -S "$cfg" . >/dev/null 2>&1 || continue
  if [ -f "$cfg" ]; then
    app="root"
    printf '%s\t%s\t%s\t%s\t%s\n' "Hosting Config" "$app" "$cfg" "$cfg" 1 >>"$REWRITES"
  fi
  rg -n --pcre2 -S "(rewrites|redirects|headers)" "$cfg" 2>/dev/null | while IFS=: read -r file line text; do
    app="root"
    printf '%s\t%s\t%s\t%s\t%s\n' "Hosting Config" "$app" "$text" "$file" "$line" >>"$REWRITES"
  done || true
  rg -n --pcre2 -S '"(source|destination)"\s*:\s*"([^"]+)"' "$cfg" 2>/dev/null | while IFS=: read -r file line text; do
    app="root"
    printf '%s\t%s\t%s\t%s\t%s\n' "Rewrite/Redirect" "$app" "$text" "$file" "$line" >>"$REWRITES"
  done || true
done

# 5) Cloud Functions endpoints (patterns from function names)
rg -n --pcre2 -S "export\s+const\s+([A-Za-z0-9_]+)\s*=\s*on(Request|Call)\(" functions/src 2>/dev/null | while IFS=: read -r file line text; do
  name=$(printf '%s' "$text" | sed -E 's/.*export\s+const\s+([A-Za-z0-9_]+)\s*=.*/\1/')
  app="functions"
  patt="https://us-central1-<project>.cloudfunctions.net/${name}"
  printf '%s\t%s\t%s\t%s\t%s\n' "API/Function" "$app" "$patt" "$file" "$line" >>"$FUNCTIONS"
done || true
# Also compiled JS (best-effort)
rg -n --pcre2 -S "exports\\.([A-Za-z0-9_]+)\s*=\s*on(Request|Call)\(" functions/lib 2>/dev/null | while IFS=: read -r file line text; do
  name=$(printf '%s' "$text" | sed -E 's/.*exports\.([A-Za-z0-9_]+)\s*=.*/\1/')
  app="functions"
  patt="https://us-central1-<project>.cloudfunctions.net/${name}"
  printf '%s\t%s\t%s\t%s\t%s\n' "API/Function" "$app" "$patt" "$file" "$line" >>"$FUNCTIONS"
done || true

# 6) Public files indicating URLs (robots, sitemap, app links)
find . -type f \( -name robots.txt -o -name sitemap.xml -o -name apple-app-site-association -o -name assetlinks.json \) 2>/dev/null | while read -r f; do
  route="/${f#*/public/}"
  [ "$route" = "/$f" ] && route="/$f"
  app=$(infer_app "${f#./}")
  printf '%s\t%s\t%s\t%s\t1\n' "Public File" "$app" "$route" "${f#./}" >>"$PUBLIC_FILES"
done || true

# 7) Flutter deep links
rg -n --pcre2 -S "(GoRouter|AutoRoute|onGenerateRoute|RouteSettings|https?://|/(u|book|meeting|meet|m)/)" appoint/lib 2>/dev/null | while IFS=: read -r file line text; do
  app="appoint"
  printf '%s\t%s\t%s\t%s\t%s\n' "Flutter Route/URL" "$app" "$text" "$file" "$line" >>"$PUBLIC_FILES"
done || true

# Compose structured outputs with Python
PYTHON_EXEC=python3
command -v "$PYTHON_EXEC" >/dev/null 2>&1 || PYTHON_EXEC=python
"$PYTHON_EXEC" - "$OUT_DIR" <<'PY'
import os, sys, json, re, subprocess
out_dir = sys.argv[1]

rows = []
# load TSVs
for fname, category in [
  ("raw_urls.tsv","Hardcoded"),
  ("env_refs.tsv","Env Reference"),
  ("rewrites.tsv","Rewrite/Redirect"),
  ("functions.tsv","API/Function"),
  ("public_files.tsv","Public File"),
]:
    path = os.path.join(out_dir, fname)
    if not os.path.exists(path):
        continue
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            parts = line.rstrip('\n').split('\t')
            if len(parts) < 5: continue
            cat, app, value, file, line_no = parts[0], parts[1], parts[2], parts[3], parts[4]
            rows.append({
                'category': cat,
                'app': app,
                'env': 'Prod',
                'url_or_pattern': value,
                'sources': [{'file': file, 'line': int(line_no), 'preview': False}],
                'notes': ''
            })

# Normalize and dedupe while preserving sources per url_or_pattern+category+app
keyed = {}
for r in rows:
    key = (r['category'], r['app'], r['url_or_pattern'])
    if key not in keyed:
        keyed[key] = r
    else:
        keyed[key]['sources'].extend(r['sources'])

entries = list(keyed.values())

# Classify patterns vs concrete URLs
url_re = re.compile(r'^https?://', re.I)
for e in entries:
    if e['category'] == 'Env Reference':
        e['notes'] = 'Env var reference (name only)'
    if e['category'] == 'API/Function' and '<project>' in e['url_or_pattern']:
        e['notes'] = (e.get('notes') or '') + ' Project ID required'

# Write urls.json
with open(os.path.join(out_dir, 'urls.json'), 'w', encoding='utf-8') as f:
    json.dump(entries, f, indent=2)

# INVENTORY.md table
def md_row(e):
    srcs = ', '.join([f"{s['file']}:{s['line']}" for s in e['sources'][:3]])
    return f"| {e['category']} | {e['app']} | {e['env']} | {e['url_or_pattern']} | {srcs} | {e['notes']} |"

required_categories = [
    'Primary domains & subdomains',
    'Personal Booking',
    'API/Function',
    'Rewrites/Redirects',
    'Auth/OAuth',
    'Webhooks',
    'Emails/Templates',
    'Deep Links',
    'Sitemaps/robots/SEO',
    'Public Assets/Buckets',
    'Env-derived URLs',
]

present = set(e['category'] for e in entries)

with open(os.path.join(out_dir, 'INVENTORY.md'), 'w', encoding='utf-8') as f:
    f.write('| Category | Owning app | Env (Preview/Prod) | URL / Pattern | Source (file:line) | Notes |\n')
    f.write('|---|---|---|---|---|---|\n')
    for e in entries:
        f.write(md_row(e) + '\n')
    for rc in required_categories:
        if rc not in present:
            f.write(f"| {rc} | - | - | None | - | None found |\n")

# Duplicates by url_or_pattern across different apps
by_url = {}
for e in entries:
    by_url.setdefault(e['url_or_pattern'], set()).add(e['app'])
dups = {u: apps for u, apps in by_url.items() if len(apps) > 1}
with open(os.path.join(out_dir, 'DUPLICATES.md'), 'w', encoding='utf-8') as f:
    if not dups:
        f.write('No duplicates or collisions detected.\n')
    else:
        for u, apps in sorted(dups.items()):
            f.write(f"- {u}: {', '.join(sorted(apps))}\n")

# TODOs: Ambiguities
todos = []
for e in entries:
    if e['category'] == 'API/Function' and '<project>' in e['url_or_pattern']:
        todos.append({'item': 'Fill Firebase project ID for Functions base URL', 'source': e['sources'][0], 'pattern': e['url_or_pattern']})
with open(os.path.join(out_dir, 'TODO.md'), 'w', encoding='utf-8') as f:
    if not todos:
        f.write('None\n')
    else:
        for t in todos:
            f.write(f"- {t['item']} @ {t['source']['file']}:{t['source']['line']} → {t['pattern']}\n")

# curl_report.md for public URLs
public_urls = []
for e in entries:
    u = e['url_or_pattern']
    if not url_re.match(u):
        continue
    # skip localhost/internal
    if re.search(r'localhost|127\.0\.0\.1|10\.|192\.168\.|\.local', u):
        continue
    public_urls.append(u)

# dedupe
seen = set()
public_urls = [u for u in public_urls if not (u in seen or seen.add(u))]

def curl_head(u):
    try:
        p = subprocess.run(['curl','-sS','-I','--max-time','8',u], capture_output=True, text=True)
        hdrs = p.stdout.strip().splitlines()
        code = None
        loc = srv = xv = ''
        for h in hdrs:
            if h.startswith('HTTP/'):
                try:
                    code = int(h.split()[1])
                except Exception:
                    pass
            hn = h.split(':',1)[0].lower() if ':' in h else ''
            hv = h.split(':',1)[1].strip() if ':' in h else ''
            if hn == 'location': loc = hv
            if hn == 'server': srv = hv
            if hn == 'x-vercel-id': xv = hv
        status = 'PASS' if code and (200 <= code < 400) else 'FAIL'
        return code, loc, srv, xv, status, p.stdout
    except Exception as ex:
        return None, '', '', '', 'ERROR', str(ex)

verify_pass = 0
with open(os.path.join(out_dir, 'curl_report.md'), 'w', encoding='utf-8') as f:
    if not public_urls:
        f.write('No public URLs found to verify.\n')
    for u in public_urls:
        code, loc, srv, xv, status, raw = curl_head(u)
        if status == 'PASS':
            verify_pass += 1
        f.write(f"---\n{u}\nHTTP: {code}\n")
        if loc: f.write(f"location: {loc}\n")
        if srv: f.write(f"server: {srv}\n")
        if xv: f.write(f"x-vercel-id: {xv}\n")
        f.write(f"Result: {status}\n")

# Summary
counts = {
  'total_urls': len([e for e in entries if url_re.match(e['url_or_pattern'])]),
  'total_patterns': len([e for e in entries if not url_re.match(e['url_or_pattern'])]),
  'total_verified': verify_pass,
  'total_todos': len(todos),
}
with open(os.path.join(out_dir, 'SUMMARY.json'),'w',encoding='utf-8') as f:
    json.dump(counts, f, indent=2)
PY

# Print first 50 lines of INVENTORY and summary
head -n 50 "$OUT_DIR/INVENTORY.md" || true
printf "\n"
cat "$OUT_DIR/SUMMARY.json" || true
