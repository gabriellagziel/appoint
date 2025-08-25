#!/bin/bash
set -Eeuo pipefail

root="$HOME/Desktop/ga"
cd "$root" || { echo "repo missing"; exit 1; }

ts="$(date +%F_%H%M%S)"
out="ops/proof/$ts"
mkdir -p "$out"
echo "=== FIX RUN @ $ts ==="

projects=(marketing business enterprise-app)

# 0) quick sanity + branch
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "not a git repo"; exit 1; }
cur_branch="$(git rev-parse --abbrev-ref HEAD)"
fix_branch="fix/restore-real-ui-$ts"
git checkout -B "$fix_branch"

# helper: restore file to pre-placeholder version
restore_pre_placeholder() {
  f="$1"
  shift
  pat="${*:-splash|placeholder|Time Organized|Business App}"
  [ -f "$f" ] || { echo "MISS $f"; return 1; }
  if grep -Eiq "$pat" "$f"; then
    bad="$(git log -n 1 --pretty=%H -G "$pat" -- "$f" || true)"
    if [ -n "$bad" ]; then
      good="${bad}^"
      echo "RESTORE $f from $good (pre-placeholder)"
      git show "$good:$f" > "$f"
    else
      echo "WARN: could not find introducing commit for $f; leaving as-is"
    fi
  else
    echo "OK: $f has no placeholder tokens"
  fi
}

# 1) remove static-export + shadows; normalize scripts
for p in "${projects[@]}"; do
  echo "--- normalize $p ---"
  # remove static-build in vercel.json
  if [ -f "$p/vercel.json" ]; then
    node -e "let f='$p/vercel.json';let fs=require('fs');let j={};try{j=JSON.parse(fs.readFileSync(f,'utf8'))}catch(e){};delete j.builds;fs.writeFileSync(f,JSON.stringify(j,null,2));" || true
  fi
  # nuke shadow public index.html
  rm -f "$p/public/index.html" 2>/dev/null || true
  # ensure runtime scripts
  node -e "let f='$p/package.json',fs=require('fs');let j=JSON.parse(fs.readFileSync(f,'utf8'));j.scripts=j.scripts||{};j.scripts.build='next build';j.scripts.start=j.scripts.start||'next start -p 3000';fs.writeFileSync(f,JSON.stringify(j,null,2));" || true
  # clean previous builds
  rm -rf "$p/.next" "$p/.vercel/output"
done

# 2) kill export config & dup configs in Next
for p in "${projects[@]}"; do
  for cfg in "$p/next.config.js" "$p/next.config.mjs" "$p/next.config.ts"; do
    [ -f "$cfg" ] || continue
    # remove output: "export"
    perl -0777 -pe "s/output\s*:\s*['\"]export['\"],?\s*//g" -i "$cfg" || true
    # prefer single js config; quarantine ts backup if both exist
  done
  [ -f "$p/next.config.ts" ] && [ -f "$p/next.config.js" ] && mv "$p/next.config.ts" "$p/next.config.ts.bak.$ts"
done

# 3) restore real UI from git (pre-placeholder)
restore_pre_placeholder marketing/pages/index.tsx
restore_pre_placeholder business/pages/index.tsx
# enterprise root page could be in pages/ or app/
if [ -f enterprise-app/pages/index.tsx ]; then
  restore_pre_placeholder enterprise-app/pages/index.tsx
elif [ -f enterprise-app/app/page.tsx ]; then
  restore_pre_placeholder enterprise-app/app/page.tsx
else
  # try to resurrect from history automatically
  c=$(git log -n 1 --pretty=%H -- enterprise-app/pages/index.tsx 2>/dev/null || true)
  if [ -n "$c" ]; then
    echo "RESTORE enterprise-app/pages/index.tsx from history"
    git show "$c:enterprise-app/pages/index.tsx" > enterprise-app/pages/index.tsx || true
  fi
fi

# 4) Business host rewrites (admin./personal. → Business)
node - << "NODE"
const fs=require('fs'), path=require('path');
const f=path.join('business','vercel.json');
let j={};
try{ j=JSON.parse(fs.readFileSync(f,'utf8')) }catch(e){}
j.routes = Array.isArray(j.routes)? j.routes: [];
const needs = [
  {host:'admin.app-oint.com'},
  {host:'personal.app-oint.com'}
];
for (const {host} of needs) {
  if (!j.routes.some(r=>JSON.stringify(r).includes(host))) {
    j.routes.push({ source: "/(.*)", has:[{type:"host", value:host}], destination: "/$1" });
  }
}
fs.writeFileSync(f, JSON.stringify(j,null,2));
console.log("updated business/vercel.json routes");
NODE

# 5) commit local fixes (no push)
git add -A
git commit -m "fix: restore real UI, remove static export, clean shadows, add business host rewrites" || true

# helper: remote build & capture URL
deploy_proj () {
  p="$1"
  echo "== DEPLOY $p (remote) =="
  (cd "$p" && npx -y vercel --prod --yes --force) | tee "$out/${p}_deploy.txt"
  url="$(grep -Eo "https://[a-z0-9.-]+\.vercel\.app" "$out/${p}_deploy.txt" | tail -1 || true)"
  echo "$url" > "$out/${p}_url.txt"
  echo "URL($p)=$url"
}

# 6) remote builds (no prebuilt) — serial to avoid rate spikes
deploy_proj marketing
deploy_proj business
deploy_proj enterprise-app

M_URL="$(cat "$out/marketing_url.txt" 2>/dev/null || true)"
B_URL="$(cat "$out/business_url.txt" 2>/dev/null || true)"
E_URL="$(cat "$out/enterprise-app_url.txt" 2>/dev/null || true)"

# 7) poll readiness (not just 200; also HTML size/chunk refs)
poll_ready () {
  url="$1"
  name="$2"
  tries=60
  [ -n "$url" ] || { echo "NO URL for $name"; return 1; }
  for i in $(seq 1 $tries); do
    code=$(curl -s -o /dev/null -w "%{http_code}" "$url/")
    body="$(curl -sL "$url/")"
    size=${#body}
    chunks=$(printf "%s" "$body" | grep -Eo "_next/static/chunks/" | wc -l | tr -d " ")
    if [[ "$code" == "200" && $size -ge 5000 && $chunks -ge 2 ]]; then
      echo "$name READY ($code,$size bytes,$chunks chunks)"
      return 0
    fi
    sleep 3
  done
  echo "$name NOT READY (code=$code size=$size chunks=$chunks)"
  return 1
}

poll_ready "$M_URL" "Marketing" || true
poll_ready "$B_URL" "Business"  || true
poll_ready "$E_URL" "Enterprise"|| true

# 8) UI-aware validation (reject placeholders)
ui_ok () {
  url="$1"
  html="$(curl -sL "$url/")"
  echo "$html" | grep -Eiq "splash|placeholder|Time Organized|Business App(?! Portal)" && return 1
  bytes=${#html}
  chunks=$(echo "$html" | grep -Eo "_next/static/chunks/" | wc -l | tr -d " ")
  [ $bytes -ge 5000 ] && [ $chunks -ge 2 ]
}

ui_ok "$M_URL" && echo "UIOK Marketing" || echo "UIBAD Marketing"
ui_ok "$B_URL" && echo "UIOK Business"  || echo "UIBAD Business"
ui_ok "$E_URL" && echo "UIOK Enterprise"|| echo "UIBAD Enterprise"

# 9) ensure domains attached to right projects (idempotent)
(cd marketing && npx -y vercel domains add app-oint.com >/dev/null 2>&1 || true; npx -y vercel domains add www.app-oint.com >/dev/null 2>&1 || true)
(cd business && npx -y vercel domains add business.app-oint.com >/dev/null 2>&1 || true; npx -y vercel domains add admin.app-oint.com >/dev/null 2>&1 || true; npx -y vercel domains add personal.app-oint.com >/dev/null 2>&1 || true)
(cd enterprise-app && npx -y vercel domains add enterprise.app-oint.com >/dev/null 2>&1 || true)

# 10) alias ONLY if UIOK
ui_ok "$M_URL" && npx -y vercel alias set "$M_URL" app-oint.com >/dev/null && npx -y vercel alias set "$M_URL" www.app-oint.com >/dev/null || echo "SKIP alias Marketing"
ui_ok "$B_URL" && npx -y vercel alias set "$B_URL" business.app-oint.com >/dev/null && npx -y vercel alias set "$B_URL" admin.app-oint.com >/dev/null && npx -y vercel alias set "$B_URL" personal.app-oint.com >/dev/null || echo "SKIP alias Business"
ui_ok "$E_URL" && npx -y vercel alias set "$E_URL" enterprise.app-oint.com >/dev/null || echo "SKIP alias Enterprise"

# 11) write proofs (headers + top of body)
domains=(app-oint.com www.app-oint.com business.app-oint.com enterprise.app-oint.com admin.app-oint.com personal.app-oint.com)
for d in "${domains[@]}"; do
  f="$out/${d//./_}.txt"
  {
    echo "--- $d ---"
    curl -sI "https://$d/" | awk 'BEGIN{IGNORECASE=1}/^(HTTP|strict-transport-security|x-frame-options|content-security-policy):/{print}'
    echo
    curl -sL "https://$d/" | sed -n '1,140p'
  } > "$f" || true
  echo "proof: $f"
done

echo "DONE. Branch: $fix_branch  Proof dir: $out"

