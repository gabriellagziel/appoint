#!/usr/bin/env bash
# go-live.sh — App-Oint (run in ~/Desktop/ga)
set -euo pipefail

# ==== CONFIG ====
TEAM="${TEAM:-gabriellagziels-projects}"   # ניתן לשנות אם צריך
PROJECTS=(marketing business enterprise-app admin appoint)
DOMAINS_APEX=(app-oint.com www.app-oint.com)
DOMAINS_SUB=(business.app-oint.com enterprise.app-oint.com admin.app-oint.com personal.app-oint.com)

need_cmd(){ command -v "$1" >/dev/null 2>&1 || { echo "❌ missing command: $1"; exit 1; }; }
need_cmd awk
need_cmd npx
need_cmd curl

# ---- safety: token must exist (לא מודפס) ----
: "${VERCEL_TOKEN:?❌ VERCEL_TOKEN is not set in this shell}"

V="npx -y vercel@latest --token \"$VERCEL_TOKEN\" --scope \"$TEAM\""

echo "== VERIFY SCOPE =="
eval $V whoami >/dev/null
npx -y vercel@latest switch "$TEAM" --token "$VERCEL_TOKEN" >/dev/null 2>&1 || true
echo "✅ scope: $TEAM (verified via whoami)"

echo "== LINK PROJECTS (idempotent) =="
for p in "${PROJECTS[@]}"; do
  dir="$HOME/Desktop/ga/$p"
  if [ -d "$dir" ]; then
    ( cd "$dir" && eval $V link --project "$p" --yes >/dev/null ) || true
    echo "• linked: $p"
  else
    echo "• skip: $p (dir missing)"
  fi
done

echo "== SET ALIASES BY PROJECT NAME =="
# apex + www -> marketing
eval $V domains add app-oint.com marketing || true
eval $V alias set marketing app-oint.com || true
eval $V domains add www.app-oint.com marketing || true
eval $V alias set marketing www.app-oint.com || true

# subdomains -> their projects
eval $V domains add business.app-oint.com business || true
eval $V alias set business business.app-oint.com || true

eval $V domains add enterprise.app-oint.com enterprise-app || true
eval $V alias set enterprise-app enterprise.app-oint.com || true

eval $V domains add admin.app-oint.com admin || true
eval $V alias set admin admin.app-oint.com || true

# personal -> appoint (Flutter Web)
personal_alias_status="ALIASED"
if ! eval $V domains add personal.app-oint.com appoint >/dev/null 2>&1; then
  personal_alias_status="PERMISSION"
fi
if ! eval $V alias set appoint personal.app-oint.com >/dev/null 2>&1; then
  personal_alias_status="PERMISSION"
fi

echo "== DNS INSPECT =="
report_domains=()
for d in "${DOMAINS_APEX[@]}" "${DOMAINS_SUB[@]}"; do
  out="$(eval $V domains inspect "$d" 2>/dev/null || true)"
  if echo "$out" | grep -qi "misconfigured"; then
    status="NEEDS_DNS"
  else
    status="CONFIGURED"
  fi
  printf "%-26s %s\n" "$d:" "$status"
  report_domains+=("$d:$status")
done

echo "== SECURITY HEADERS / HTTP SMOKE =="
urls=(https://app-oint.com https://www.app-oint.com https://business.app-oint.com https://enterprise.app-oint.com https://admin.app-oint.com https://personal.app-oint.com)
# Use regular arrays for compatibility
for u in "${urls[@]}"; do
  res="$(curl -sS -I -L --max-time 20 "$u" || true)"
  code="$(printf "%s" "$res" | awk 'BEGIN{IGNORECASE=1} /^HTTP\//{c=$2} END{print c+0}')"
  hsts="$(printf "%s" "$res" | awk 'BEGIN{IGNORECASE=1} tolower($0)~/^strict-transport-security:/{print "yes"; exit} END{print "no"}')"
  csp="$( printf "%s" "$res" | awk 'BEGIN{IGNORECASE=1} tolower($0)~/^content-security-policy:/{print "yes"; exit} END{print "no"}')"
  xfo="$( printf "%s" "$res" | awk 'BEGIN{IGNORECASE=1} tolower($0)~/^x-frame-options:/{print "yes"; exit} END{print "no"}')"
  echo "• $u → HTTP=$code HSTS=$hsts CSP=$csp XFO=$xfo"
done

echo
echo "================ GO-LIVE REPORT ================"
echo "Team: $TEAM"
echo
echo "[Aliases]"
printf "app-oint.com:            %s\n"     "$(eval $V alias ls | grep -qi '^app-oint\.com' && echo ALIASED || echo NOT_SET)"
printf "www.app-oint.com:        %s\n"     "$(eval $V alias ls | grep -qi '^www\.app-oint\.com' && echo ALIASED || echo NOT_SET)"
printf "business.app-oint.com:   %s\n"     "$(eval $V alias ls | grep -qi '^business\.app-oint\.com' && echo ALIASED || echo NOT_SET)"
printf "enterprise.app-oint.com: %s\n"     "$(eval $V alias ls | grep -qi '^enterprise\.app-oint\.com' && echo ALIASED || echo NOT_SET)"
printf "admin.app-oint.com:      %s\n"     "$(eval $V alias ls | grep -qi '^admin\.app-oint\.com' && echo ALIASED || echo NOT_SET)"
printf "personal.app-oint.com:   %s\n"     "$personal_alias_status"
echo
echo "[DNS]"
for item in "${report_domains[@]}"; do
  dom="${item%%:*}"; st="${item#*:}"
  printf "%-26s %s\n" "$dom:" "$st"
done
echo
echo "[Security Headers]"
for u in "${urls[@]}"; do
  res="$(curl -sS -I -L --max-time 20 "$u" || true)"
  code="$(printf "%s" "$res" | awk 'BEGIN{IGNORECASE=1} /^HTTP\//{c=$2} END{print c+0}')"
  hsts="$(printf "%s" "$res" | awk 'BEGIN{IGNORECASE=1} tolower($0)~/^strict-transport-security:/{print "yes"; exit} END{print "no"}')"
  csp="$( printf "%s" "$res" | awk 'BEGIN{IGNORECASE=1} tolower($0)~/^content-security-policy:/{print "yes"; exit} END{print "no"}')"
  xfo="$( printf "%s" "$res" | awk 'BEGIN{IGNORECASE=1} tolower($0)~/^x-frame-options:/{print "yes"; exit} END{print "no"}')"
  printf "%-27s HSTS=%s CSP=%s XFO=%s HTTP=%s\n" "$(echo "$u" | sed 's#https://##'):" "$hsts" "$csp" "$xfo" "$code"
done
echo
echo "[Blockers]"
blk=0
# DNS hints
apex_dns_hint="A 76.76.21.21"
www_dns_hint="CNAME → cname.vercel-dns.com"
sub_dns_hint="CNAME → cname.vercel-dns.com"
for item in "${report_domains[@]}"; do
  dom="${item%%:*}"; st="${item#*:}"
  if [ "$st" = "NEEDS_DNS" ]; then
    blk=1
    case "$dom" in
      app-oint.com)         echo "- $dom: NEEDS_DNS (set $apex_dns_hint at registrar)";;
      www.app-oint.com)     echo "- $dom: NEEDS_DNS (set $www_dns_hint)";;
      *.app-oint.com)       echo "- $dom: NEEDS_DNS (set $sub_dns_hint)";;
    esac
  fi
done
if [ "$personal_alias_status" = "PERMISSION" ]; then
  blk=1
  echo "- personal.app-oint.com: PERMISSION (transfer/remove from other team, verify via DNS TXT, או השאר ב-Firebase: CNAME → ghs.googlehosted.com)"
fi
[ "$blk" -eq 0 ] || true
echo "================================================="


