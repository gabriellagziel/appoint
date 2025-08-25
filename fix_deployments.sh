#!/bin/bash
set -Eeuo pipefail

root="$HOME/Desktop/ga"
[ -d "$root" ] || { echo "ERROR: repo root not found: $root"; exit 1; }
cd "$root"

ts="$(date +%F_%H%M%S)"
out="ops/fix/$ts"; mkdir -p "$out"

team_hint="gabriellagziels-projects"   # if prompted, choose this team

say(){ printf "\n\033[1;36m%s\033[0m\n" "$*"; }
proof_line(){ printf "%s\n" "$*" | tee -a "$1" >/dev/null; }

# ---------- helpers ----------
link_and_pull () { # $1=dir $2=project
  local dir="$1" proj="$2"
  say "Link & pull → $proj"
  cd "$root/$dir"
  npx -y vercel whoami || true
  npx -y vercel link --project "$proj" --yes
  npx -y vercel pull --environment=production --yes
  [ -f .vercel/project.json ] || { echo "Link failed for $proj"; return 1; }
}

ensure_headers () { # at $PWD
  if [ ! -f vercel.json ] || ! grep -qi "Strict-Transport-Security" vercel.json; then
    cat > vercel.json << "JSON"
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "Strict-Transport-Security", "value": "max-age=63072000; includeSubDomains; preload" },
        { "key": "X-Frame-Options", "value": "DENY" },
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "Referrer-Policy", "value": "no-referrer-when-downgrade" },
        { "key": "Permissions-Policy", "value": "geolocation=(), microphone=(), camera=()" },
        { "key": "Content-Security-Policy",
          "value": "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src 'self' 'unsafe-inline' https:; img-src 'self' data: blob: https:; font-src 'self' data: https:; connect-src 'self' https: wss:; frame-ancestors 'none'; base-uri 'self'; form-action 'self'" }
      ]
    }
  ]
}
JSON
  fi
}

fix_favicon_marketing () { # in marketing dir
  say "Marketing: favicon dedupe + clean artifacts"
  mkdir -p "$out/marketing"
  { echo "== app =="; ls -la app 2>/dev/null | grep -Ei "icon|favicon" || true;
    echo "== public =="; ls -la public 2>/dev/null | grep -Ei "icon|favicon" || true; } > "$out/marketing/favicon_audit.txt"

  keep="public"
  if ls app 2>/dev/null | egrep -qi "(^|/)icon\.(png|ico|svg)$|(^|/)favicon\.ico$"; then keep="app"; fi

  if [ "$keep" = "app" ]; then rm -f public/favicon.ico 2>/dev/null || true; else rm -f app/favicon.ico app/icon.* 2>/dev/null || true; fi
  rm -rf .next .vercel
}

ensure_business_static () { # in business dir
  say "Business: static export config (distDir=out)"
  if [ ! -f vercel.json ] || ! grep -q "@vercel/static-build" vercel.json; then
    cat > vercel.json << "JSON"
{
  "builds": [
    { "src": "package.json", "use": "@vercel/static-build", "config": { "distDir": "out" } }
  ]
}
JSON
  fi
  if command -v jq >/dev/null 2>&1; then
    tmp="$(mktemp)"
    jq '.scripts |= (. // {}) | .scripts.build="next build && next export" | .scripts.start = (.scripts.start // "npx serve out -p 3000")' package.json > "$tmp" && mv "$tmp" package.json
  else
    grep -q "\"build\"" package.json || sed -i.bak 's/"scripts": {/"scripts": {"build":"next build && next export",/1' package.json || true
  fi
}

prebuilt_deploy () { # $1=dir  -> echoes DEPLOY_URL
  local dir="$1"; cd "$root/$dir"
  say "Prebuild + deploy → $dir"
  npx -y vercel build --prod
  local outlog dep
  outlog="$(mktemp)"; set +e
  npx -y vercel deploy --prebuilt --prod --yes | tee "$outlog"
  rc=$?; set -e
  dep="$(grep -Eo "https://[a-zA-Z0-9.-]+\.vercel\.app" "$outlog" | tail -1 || true)"
  rm -f "$outlog"
  [ $rc -eq 0 ] && [ -n "$dep" ] && echo "$dep" && return 0
  return 1
}

wait_200 () { # URL
  local url="$1"; for i in {1..36}; do code=$(curl -s -o /dev/null -w "%{http_code}" "$url/"); [ "$code" = "200" ] && return 0; sleep 5; done; return 1; }

alias_to () { # URL domains...
  local url="$1"; shift; for d in "$@"; do npx -y vercel alias rm "$d" --yes >/dev/null 2>&1 || true; npx -y vercel alias set "$url" "$d"; done
}

proof () { # dep_url file domains...
  local dep="$1"; shift; local file="$1"; shift
  body_hash () { curl -sL "$1" | head -c 8192 | shasum -a 256 | cut -d" " -f1; }
  local hdep; hdep="$(body_hash "$dep")"
  : > "$file"
  proof_line "$file" "=== PROOF $(date -Iseconds) ==="
  proof_line "$file" "DEPLOY: $dep"
  proof_line "$file" "DEP_HASH: $hdep"
  for d in "$@"; do
    local hdom hdr hsts xfo csp
    hdom="$(body_hash "https://$d/")"
    hdr="$(curl -sI "https://$d/")"
    [[ "$hdr" =~ [Ss]trict-Transport-Security ]] && hsts=OK || hsts=MISSING
    [[ "$hdr" =~ [Xx]-[Ff]rame-[Oo]ptions ]] && xfo=OK || xfo=MISSING
    [[ "$hdr" =~ [Cc]ontent-[Ss]ecurity-[Pp]olicy ]] && csp=OK || csp=MISSING
    proof_line "$file" "--- $d ---"
    proof_line "$file" "DOM_HASH: $hdom"
    proof_line "$file" "MATCH: $([ "$hdep" = "$hdom" ] && echo YES || echo NO)"
    proof_line "$file" "HEADERS: HSTS=$hsts | XFO=$xfo | CSP=$csp"
  done
  echo "Wrote $file"
}

# ---------- DOMAIN OWNERSHIP sanity (optional clean) ----------
say "Normalize domain attachments (one domain per project)"
# safe removes (ignore errors)
(cd business && npx -y vercel domains rm app-oint.com --yes 2>/dev/null || true)
(cd business && npx -y vercel domains rm www.app-oint.com --yes 2>/dev/null || true)
(cd enterprise-app && npx -y vercel domains rm app-oint.com --yes 2>/dev/null || true)
(cd enterprise-app && npx -y vercel domains rm www.app-oint.com --yes 2>/dev/null || true)
(cd marketing && npx -y vercel domains rm business.app-oint.com --yes 2>/dev/null || true)
(cd enterprise-app && npx -y vercel domains rm business.app-oint.com --yes 2>/dev/null || true)
(cd marketing && npx -y vercel domains rm enterprise.app-oint.com --yes 2>/dev/null || true)
(cd business && npx -y vercel domains rm enterprise.app-oint.com --yes 2>/dev/null || true)

# ---------- MARKETING ----------
say "MARKETING"
link_and_pull "marketing" "marketing"
cd "$root/marketing"
fix_favicon_marketing
ensure_headers

dep_marketing="$(prebuilt_deploy marketing || true)"
if [ -n "$dep_marketing" ] && wait_200 "$dep_marketing"; then
  alias_to "$dep_marketing" app-oint.com www.app-oint.com
  proof "$dep_marketing" "$out/marketing_proof.txt" app-oint.com www.app-oint.com
else
  echo "Marketing deploy failed or not ready."
fi

# ---------- BUSINESS ----------
say "BUSINESS"
link_and_pull "business" "business"
cd "$root/business"
ensure_business_static
ensure_headers

dep_business="$(prebuilt_deploy business || true)"
if [ -n "$dep_business" ] && wait_200 "$dep_business"; then
  alias_to "$dep_business" business.app-oint.com
  proof "$dep_business" "$out/business_proof.txt" business.app-oint.com
else
  echo "Business deploy failed or not ready."
fi

# ---------- ENTERPRISE (headers only if missing) ----------
say "ENTERPRISE (headers only if missing)"
link_and_pull "enterprise-app" "enterprise-app"
cd "$root/enterprise-app"
ensure_headers || true
# (no alias change here unless you want)

# ---------- Final health ----------
say "Final health"
health="$out/health.txt"; echo "=== HEALTH $(date -Iseconds) ===" | tee "$health"
for d in app-oint.com www.app-oint.com business.app-oint.com enterprise.app-oint.com; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://$d/")
  hdr=$(curl -sI "https://$d/")
  hsts=$([[ "$hdr" =~ [Ss]trict-Transport-Security ]] && echo OK || echo MISSING)
  xfo=$([[ "$hdr" =~ [Xx]-[Ff]rame-[Oo]ptions ]] && echo OK || echo MISSING)
  csp=$([[ "$hdr" =~ [Cc]ontent-[Ss]ecurity-[Pp]olicy ]] && echo OK || echo MISSING)
  printf "%-27s  HTTP:%s  HSTS:%s  XFO:%s  CSP:%s\n" "$d" "$code" "$hsts" "$xfo" "$csp" | tee -a "$health"
done

say "Artifacts:"
ls -1 "$out" | sed "s|^|$out/|"
