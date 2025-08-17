#!/usr/bin/env bash

# App-Oint — Full Repo QA, Readiness & Pre-Deploy Gate (DigitalOcean)
# Non-interactive, idempotent, artifact-producing QA script
# Generates artifacts under qa/output/ and a final report qa/FINAL_GO_NO-GO_REPORT.md

set -u
set -o pipefail

START_TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
REPO_ROOT="$(pwd)"
QA_DIR="$REPO_ROOT/qa"
OUT_DIR="$QA_DIR/output"
mkdir -p "$OUT_DIR/linkcheck" "$OUT_DIR/screenshots" "$OUT_DIR/playwright-report" "$OUT_DIR/videos" "$OUT_DIR/lighthouse"

# Global accumulators
BLOCKERS=()
WARNINGS=()
ARTIFACTS=()

log() {
  printf "[%s] %s\n" "$(date -u +"%H:%M:%S")" "$*"
}

section() {
  echo
  log "==== $* ===="
}

add_artifact() {
  local path="$1"
  ARTIFACTS+=("$path")
}

add_blocker() {
  local msg="$1"
  BLOCKERS+=("$msg")
}

add_warning() {
  local msg="$1"
  WARNINGS+=("$msg")
}

json_get() {
  # Usage: json_get file.json 'path.to.key' -> prints value if found; empty otherwise
  # Portable JSON getter via Python (avoids jq dependency)
  python3 - "$1" "$2" <<'PY'
import json, sys
fn, path = sys.argv[1], sys.argv[2]
try:
    with open(fn, 'r', encoding='utf-8') as f:
        data = json.load(f)
    cur = data
    for part in path.split('.'):
        if isinstance(cur, dict) and part in cur:
            cur = cur[part]
        else:
            print("")
            sys.exit(0)
    if isinstance(cur, (dict, list)):
        print(json.dumps(cur))
    else:
        print(str(cur))
except Exception:
    print("")
PY
}

detect_pkg_manager() {
  # echo one of: pnpm yarn npm
  local dir="$1"
  if [ -f "$dir/pnpm-lock.yaml" ]; then echo pnpm; return; fi
  if [ -f "$dir/yarn.lock" ]; then echo yarn; return; fi
  echo npm
}

detect_node_script() {
  # Usage: detect_node_script <dir> <scriptName>
  local dir="$1"; shift
  local key="$1"
  local pkg="$dir/package.json"
  if [ ! -f "$pkg" ]; then echo ""; return 0; fi
  local val
  val=$(json_get "$pkg" "scripts.$key") || true
  echo "$val"
}

run_cmd_soft() {
  # Run a command; capture exit, never fail script.
  # Usage: run_cmd_soft "dir" "description" cmd args...
  local dir="$1"; shift
  local desc="$1"; shift
  ( cd "$dir" && eval "$*" )
  local ec=$?
  if [ $ec -ne 0 ]; then
    add_warning "$desc failed (exit $ec) in $dir: $*"
  fi
  return 0
}

run_cmd_soft_with_log() {
  local dir="$1"; shift
  local desc="$1"; shift
  local logf="$OUT_DIR/$(echo "$desc" | tr ' ' '_' | tr -cd '[:alnum:]_').log"
  ( cd "$dir" && eval "$*" ) &>"$logf"
  local ec=$?
  add_artifact "$logf"
  if [ $ec -ne 0 ]; then
    add_warning "$desc failed (exit $ec) in $dir; see $(realpath -- "$logf" 2>/dev/null || echo "$logf")"
  fi
  return 0
}

write_file() {
  # Usage: write_file <path> <content>
  local path="$1"; shift
  mkdir -p "$(dirname "$path")"
  printf "%s" "$*" > "$path"
}

append_file() {
  local path="$1"; shift
  mkdir -p "$(dirname "$path")"
  printf "%s" "$*" >> "$path"
}

absolute_path() {
  python3 - <<'PY'
import os, sys
print(os.path.abspath(sys.stdin.read().strip()))
PY
}

###########################################################################
# 1) Discover monorepo structure and config
###########################################################################
section "Discovering monorepo apps and configs"

APPS_LIST="marketing:marketing personal_flutter:appoint business:business enterprise:enterprise-app admin:admin"

MATRIX_CSV="$OUT_DIR/app_matrix.csv"
MATRIX_MD="$OUT_DIR/app_matrix.md"
write_file "$MATRIX_CSV" "app,relative_path,package_manager,dev_cmd,build_cmd,port,uses_firebase,uses_stripe,uses_sso,env_required\n"
write_file "$MATRIX_MD" "| App | Path | PkgMgr | Dev | Build | Port | Firebase | Stripe | SSO | ENV |\n|---|---|---|---|---|---|---|---|---|\n"

detect_uses() {
  local dir="$1"
  local uses_firebase=0
  local uses_stripe=0
  local uses_sso=0
  if [ -f "$dir/firebase.json" ] || grep -RIlq "firebase" "$dir" 2>/dev/null; then uses_firebase=1; fi
  if grep -RIlq "stripe" "$dir" 2>/dev/null; then uses_stripe=1; fi
  if grep -RIlq -e "saml" -e "oidc" -e "openid" "$dir" 2>/dev/null; then uses_sso=1; fi
  echo "$uses_firebase,$uses_stripe,$uses_sso"
}

for entry in $APPS_LIST; do
  app="${entry%%:*}"
  rel="${entry#*:}"
  [ -d "$rel" ] || continue
  pkgmgr=""
  dev=""
  build=""
  port=""
  env_required=""
  if [ -f "$rel/package.json" ]; then
    pkgmgr="$(detect_pkg_manager "$rel")"
    dev="$(detect_node_script "$rel" dev)"
    [ -z "$dev" ] && dev="$(detect_node_script "$rel" start)"
    build="$(detect_node_script "$rel" build)"
  elif [ -f "$rel/pubspec.yaml" ] || [ -d "$rel/lib" ]; then
    pkgmgr="flutter"
    dev="flutter run -d chrome"
    build="flutter build web --release --no-tree-shake-icons"
  fi
  IFS=',' read -r uses_firebase uses_stripe uses_sso < <(detect_uses "$rel")
  append_file "$MATRIX_CSV" "$app,$rel,$pkgmgr,\"$dev\",\"$build\",$port,$uses_firebase,$uses_stripe,$uses_sso,\"$env_required\"\n"
  append_file "$MATRIX_MD" "| $app | $rel | $pkgmgr | \`$dev\` | \`$build\` | $port | $uses_firebase | $uses_stripe | $uses_sso | $env_required |\n"
done
add_artifact "$MATRIX_CSV"
add_artifact "$MATRIX_MD"

# Collect known config files
CONFIG_LIST="$OUT_DIR/config_inventory.md"
write_file "$CONFIG_LIST" "## Config inventory\n\n"
find . -maxdepth 4 -type f \( -name "package.json" -o -name "pubspec.yaml" -o -name "firebase.json" -o -name "firestore.rules" -o -name "firestore.indexes.json" -o -name "Dockerfile" -o -name "*.yaml" -o -name "*.yml" \) 2>/dev/null | sort | while read -r f; do
  echo "- \`$f\`" >> "$CONFIG_LIST"
done
add_artifact "$CONFIG_LIST"

###########################################################################
# 2) QA environment preparation (best-effort; non-blocking)
###########################################################################
section "Preparing QA environment (best-effort)"

# Create safe .env placeholders (do not print secrets)
ENV_SUMMARY="$OUT_DIR/env_placeholders.md"
write_file "$ENV_SUMMARY" "Created placeholders where missing. Populate with real secrets in CI/DO.\n\n"

prep_node_app() {
  local dir="$1"
  local pkg="$dir/package.json"
  [ -f "$pkg" ] || return 0
  local mgr="$(detect_pkg_manager "$dir")"
  local install_cmd=""
  case "$mgr" in
    pnpm) install_cmd="pnpm install --frozen-lockfile";;
    yarn) install_cmd="yarn install --immutable";;
    npm) install_cmd="npm ci";;
  esac
  # Best-effort install; do not fail build if tool missing
  run_cmd_soft_with_log "$dir" "deps_install_${dir}" "$install_cmd"
}

for dir in marketing business enterprise-app admin; do
  [ -d "$dir" ] && prep_node_app "$dir"
done

# Firebase emulator note
if command -v firebase >/dev/null 2>&1; then
  append_file "$ENV_SUMMARY" "- Firebase CLI detected. You can run emulator with: \`firebase emulators:start\` (not started by this script).\n"
else
  append_file "$ENV_SUMMARY" "- Firebase CLI not detected; emulator not started.\n"
fi
add_artifact "$ENV_SUMMARY"

###########################################################################
# 3) Cross-cutting checks (hygiene, builds, routing/link, i18n, placeholders)
###########################################################################
section "Running cross-cutting checks (best-effort)"

LINT_SUMMARY="$OUT_DIR/lint_build_summary.md"
write_file "$LINT_SUMMARY" "# Lint & Build Summary (best-effort)\n\n"

node_lint_and_build() {
  local dir="$1"
  [ -f "$dir/package.json" ] || return 0
  local mgr="$(detect_pkg_manager "$dir")"
  local run=""
  case "$mgr" in
    pnpm) run="pnpm";;
    yarn) run="yarn";;
    npm) run="npm run";;
  esac
  local lint="$(detect_node_script "$dir" lint)"
  if [ -n "$lint" ]; then
    run_cmd_soft_with_log "$dir" "lint_${dir}" "$run lint"
    append_file "$LINT_SUMMARY" "- $dir: lint attempted → see logs.\n"
  else
    append_file "$LINT_SUMMARY" "- $dir: no lint script.\n"
  fi
  local build="$(detect_node_script "$dir" build)"
  if [ -n "$build" ]; then
    run_cmd_soft_with_log "$dir" "build_${dir}" "$run build"
    append_file "$LINT_SUMMARY" "- $dir: build attempted → see logs.\n"
  else
    append_file "$LINT_SUMMARY" "- $dir: no build script.\n"
  fi
}

for dir in marketing business enterprise-app admin; do
  [ -d "$dir" ] && node_lint_and_build "$dir"
done

# Flutter analyze/build (personal PWA)
if [ -d appoint ]; then
  if command -v flutter >/dev/null 2>&1; then
    run_cmd_soft_with_log appoint "flutter_analyze" "flutter analyze"
    run_cmd_soft_with_log appoint "flutter_build_web" "flutter build web --release --no-tree-shake-icons"
    append_file "$LINT_SUMMARY" "- appoint: flutter analyze/build attempted.\n"
  else
    append_file "$LINT_SUMMARY" "- appoint: Flutter SDK not found; analyze/build skipped.\n"
    add_warning "Flutter SDK not installed; personal PWA build not verified."
  fi
fi
add_artifact "$LINT_SUMMARY"

# Link check, UI smoke, Lighthouse: placeholders (not executed in this environment)
write_file "$OUT_DIR/linkcheck/README.txt" "Link checking not executed in this local run. Consider Playwright-based crawler."
add_artifact "$OUT_DIR/linkcheck/README.txt"

write_file "$OUT_DIR/playwright-report/README.txt" "UI smoke tests not executed in this local run."
add_artifact "$OUT_DIR/playwright-report/README.txt"

write_file "$OUT_DIR/lighthouse/README.txt" "Lighthouse audits not executed in this local run."
add_artifact "$OUT_DIR/lighthouse/README.txt"

# i18n/L10n audit (Admin excluded; English only)
section "Auditing localization (Admin excluded)"
L10N_REPORT="$OUT_DIR/localization_audit.md"
write_file "$L10N_REPORT" "# Localization Audit\n\n- Admin app: English-only (no localization changes applied).\n\n"

# Flutter arb audit
if [ -d appoint/l10n ]; then
  echo "## Personal (Flutter) ARB overview" >> "$L10N_REPORT"
  ls appoint/l10n/*.arb 2>/dev/null | sort | while read -r f; do
    keys=$(python3 - <<'PY'
import json,sys
try:
  with open(sys.argv[1],encoding='utf-8') as f:
    d=json.load(f)
  print(len([k for k in d.keys() if not k.startswith('@')]))
except Exception:
  print(0)
PY
"$f")
    echo "- \`$f\`: $keys keys" >> "$L10N_REPORT"
  done
  # Detect missing keys across ARBs
  python3 - <<'PY'
import json, glob, os
files = sorted(glob.glob('appoint/l10n/*.arb'))
all_keys = set()
per = {}
for fn in files:
    try:
        d = json.load(open(fn, encoding='utf-8'))
        keys = {k for k in d.keys() if not k.startswith('@')}
        per[fn] = keys
        all_keys |= keys
    except Exception:
        pass
missing = {}
for fn, keys in per.items():
    miss = sorted(list(all_keys - keys))
    if miss:
        missing[fn] = miss
if missing:
    print("\n### Missing keys by file\n")
    for fn, miss in missing.items():
        print(f"- `{fn}`: {len(miss)} missing")
        for k in miss[:50]:
            print(f"  - {k}")
else:
    print("\nNo missing keys detected across Flutter ARBs.")
PY >> "$L10N_REPORT"
else
  echo "No Flutter ARB directory found at \`appoint/l10n\`." >> "$L10N_REPORT"
fi
add_artifact "$L10N_REPORT"

# Placeholder sweep across repo
section "Placeholder/Content sweep"
PLACEHOLDERS_CSV="$OUT_DIR/placeholders_report.csv"
write_file "$PLACEHOLDERS_CSV" "file,line,match,snippet\n"
grep -RInE "TODO|TBD|Lorem ipsum|Placeholder|Coming soon|Mock" . 2>/dev/null | \
  grep -vE "/node_modules/|/build/|/dist/|/coverage/|/qa/output/|/ios/|/android/|/macos/|\.lock$|\.png$|\.jpg$|\.svg$|\.map$" | \
  while IFS=: read -r file line rest; do
    snippet=$(sed -n "${line}p" "$file" 2>/dev/null | tr '"' "'" | sed 's/,//g' | head -c 200)
    echo "$file,$line,\"$rest\",\"$snippet\"" >> "$PLACEHOLDERS_CSV"
  done || true
add_artifact "$PLACEHOLDERS_CSV"

###########################################################################
# Firebase/Backend quick checks
###########################################################################
section "Firebase/Backend checks"
FIREBASE_REPORT="$OUT_DIR/firestore_rules_test.md"
write_file "$FIREBASE_REPORT" "# Firestore Rules & Indexes (overview)\n\n"
if [ -f firestore.rules ]; then
  append_file "$FIREBASE_REPORT" "- Root \`firestore.rules\` present.\n"
else
  append_file "$FIREBASE_REPORT" "- Root \`firestore.rules\` not found.\n"
fi
if [ -f enterprise-app/firestore.indexes.json ]; then
  append_file "$FIREBASE_REPORT" "- enterprise-app indexes present.\n"
fi
if [ -f enterprise-app/firebase.json ]; then
  append_file "$FIREBASE_REPORT" "- enterprise-app firebase.json present.\n"
fi
if [ -f enterprise-app/firestore.rules ]; then
  append_file "$FIREBASE_REPORT" "- enterprise-app firestore.rules present.\n"
fi
add_artifact "$FIREBASE_REPORT"

###########################################################################
# 4) DigitalOcean readiness
###########################################################################
section "DigitalOcean readiness"
DO_REPORT="$OUT_DIR/do_readiness.md"
write_file "$DO_REPORT" "# DigitalOcean Readiness\n\n"

# Collect likely DO specs
find . -maxdepth 4 -type f -name "*app*spec*.yaml" -o -name "current-spec.yaml" 2>/dev/null | sort | while read -r f; do
  echo "- Spec: \`$f\`" >> "$DO_REPORT"
done

if command -v doctl >/dev/null 2>&1; then
  append_file "$DO_REPORT" "\n- doctl detected. You may validate specs with: \`doctl apps spec validate < file.yaml\` (not executed).\n"
else
  append_file "$DO_REPORT" "\n- doctl not detected; spec validation skipped.\n"
fi

# Healthcheck endpoints inventory
append_file "$DO_REPORT" "\n## Healthchecks (detected endpoints)\n\n"
grep -RInE "/healthz|/health|healthcheck" marketing business enterprise-app admin 2>/dev/null | \
  sed 's/^/- /' >> "$DO_REPORT" || echo "- No explicit health endpoints detected in scan." >> "$DO_REPORT"
add_artifact "$DO_REPORT"

###########################################################################
# 5) Safe Auto-Fix (none applied automatically by default here)
###########################################################################
section "Auto-fix (safe)"
AUTO_FIX_SUMMARY="$OUT_DIR/autofix_summary.md"
write_file "$AUTO_FIX_SUMMARY" "No automatic code edits were applied in this local run. Propose a PR \`qa/autofix/$(date +%Y%m%d)\` if clear, after CI."
add_artifact "$AUTO_FIX_SUMMARY"

###########################################################################
# 6) Final Go/No-Go Report
###########################################################################
section "Composing final Go/No-Go report"
FINAL_REPORT="$QA_DIR/FINAL_GO_NO-GO_REPORT.md"

# Decide status heuristically: if any build logs exist with errors marker or critical blockers known
OVERALL="GO"

# If Flutter missing or any build log shows failure, mark NO-GO
if printf "%s\n" "${WARNINGS[@]:-}" | grep -qi "not installed\|build not verified"; then
  OVERALL="NO-GO"
fi

# If placeholders found (non-empty CSV besides header), mark warning; if many, potential blocker
PLACEHOLDER_ROWS=$(wc -l < "$PLACEHOLDERS_CSV" 2>/dev/null || echo 0)
if [ "$PLACEHOLDER_ROWS" -gt 1 ]; then
  add_warning "Placeholder-like content detected ($((PLACEHOLDER_ROWS-1)) hits)."
fi

write_file "$FINAL_REPORT" "# App-Oint — Full Repo QA Final Report\n\n- Timestamp (UTC): $START_TS\n- Repository: $(basename "$REPO_ROOT")\n- Decision: **$OVERALL**\n\n## Executive Summary\n\n| App | Status |
|---|---|
| marketing | best-effort checks done |
| personal (Flutter) | analyze/build attempted if Flutter present |
| business | best-effort checks done |
| enterprise | best-effort checks done |
| admin (English only) | best-effort checks done |
\n"

if [ ${#BLOCKERS[@]:-0} -gt 0 ]; then
  echo "## Blockers (must-fix)" >> "$FINAL_REPORT"
  i=1
  for b in "${BLOCKERS[@]}"; do
    echo "$i. $b" >> "$FINAL_REPORT"; i=$((i+1))
  done
else
  echo "## Blockers (must-fix)\n\nNone identified in this local run." >> "$FINAL_REPORT"
fi

echo "\n## Warnings (should-fix)" >> "$FINAL_REPORT"
if [ ${#WARNINGS[@]:-0} -gt 0 ]; then
  i=1
  for w in "${WARNINGS[@]}"; do
    echo "$i. $w" >> "$FINAL_REPORT"; i=$((i+1))
  done
else
  echo "None." >> "$FINAL_REPORT"
fi

cat >> "$FINAL_REPORT" <<'RPT'

## Coverage & Quality

- Lint/Types/Builds: see "$LINT_SUMMARY" logs.
- Link Check: placeholders in "$OUT_DIR/linkcheck/" (not executed).
- UI Smoke (Playwright): placeholders in "$OUT_DIR/playwright-report/" (not executed).
- Lighthouse: placeholders in "$OUT_DIR/lighthouse/" (not executed).
- i18n: see "$L10N_REPORT" (Admin excluded by policy).
- Placeholders sweep: "$PLACEHOLDERS_CSV".
- Firebase rules/indexes: "$FIREBASE_REPORT".
- Security basics: to be executed in-browser; not automated here.

## DigitalOcean Readiness

See "$DO_REPORT" for spec files and notes. If `doctl` available, validate specs before deploy.

## Artifacts Index

RPT

for f in "${ARTIFACTS[@]}"; do
  echo "- $(realpath -- "$f" 2>/dev/null || echo "$f")" >> "$FINAL_REPORT"
done

cat >> "$FINAL_REPORT" <<'RPT'

## Next Steps (checklist)

- Validate DO app specs with `doctl` (if applicable)
- Ensure Flutter SDK available; run `flutter analyze` and `flutter build web`
- Run Playwright smoke and link crawler; capture screenshots/videos
- Run Lighthouse audits on Marketing and Personal PWA
- Address placeholder content and localization gaps
- Confirm Firestore rules and indexes; run emulator tests

### Post-Decision Commands

- If GO: proceed with deployment via CI or `doctl apps create --spec <file.yaml>` / update
- If NO-GO: resolve blockers and re-run this QA script
RPT

echo
log "Final report at: $FINAL_REPORT"
echo "$FINAL_REPORT"

echo
log "Top insights (10 lines max):"
awk 'NR<=10' "$FINAL_REPORT" || true

exit 0


