# ===== App-Oint Makefile =====
# Copy to repo root: Makefile
# Usage examples:
#   make enforce-checks
#   make disable-legacy
#   make core-ci
#   make ci
#   make smoke
#   make ship
#   make rollback

SHELL := /bin/bash
REPO  := $(shell gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
API_HEALTH ?= https://your-api.example.com/api/status
MARKETING_URL ?= https://marketing.example.com
BUSINESS_URL  ?= https://business.example.com
ENTERPRISE_URL?= https://enterprise.example.com
DASHBOARD_URL ?= https://dashboard.example.com

.PHONY: help enforce-checks disable-legacy disable-legacy-sed core-ci ci smoke ship rollback verify-protection

help:
	@echo "Targets:"
	@echo "  enforce-checks    - Enforce exactly 3 required checks (Flutter, Next.js apps, Functions)."
	@echo "  disable-legacy    - Disable non-core workflows & remove schedules (uses yq if present)."
	@echo "  disable-legacy-sed- Same as above without yq (sed/awk fallback)."
	@echo "  core-ci           - Trigger core-ci and list latest runs."
	@echo "  ci                - Local mirror of core-ci (fast repro)."
	@echo "  smoke             - Quick curl-based smoke across apps + API."
	@echo "  ship              - Ship sequence: Functions first, then Vercel promote (manual if you don’t use CLI)."
	@echo "  rollback          - Rollback tips/commands."
	@echo "  verify-protection - Print current branch protection contexts."

enforce-checks:
	bash ops/scripts/enforce_required_checks.sh
	$(MAKE) verify-protection

verify-protection:
	@test -n "$(REPO)" || (echo "Run: gh auth login"; exit 1)
	@gh api repos/$(REPO)/branches/main/protection | jq -r '.required_status_checks.checks[].context'

disable-legacy:
	@if command -v yq >/dev/null 2>&1; then \
		for f in .github/workflows/*.yml .github/workflows/*.yaml; do \
			[ -f $$f ] || continue; \
			grep -q "^name:[[:space:]]*core-ci" $$f && continue; \
			echo "→ workflow_dispatch: $$f"; \
			yq -i '.on = "workflow_dispatch"' $$f; \
			yq -i 'del(.on.schedule)' $$f || true; \
		done; \
		git add .github/workflows && git commit -m "ci: keep core-ci only; remove schedules" || true; \
		git push || true; \
	else \
		$(MAKE) disable-legacy-sed; \
	fi

disable-legacy-sed:
	@for f in .github/workflows/*.yml .github/workflows/*.yaml; do \
		[ -f $$f ] || continue; \
		grep -q "^name:[[:space:]]*core-ci" $$f && continue; \
		echo "→ sed fallback: $$f"; \
		awk 'BEGIN{in_on=0} /^on:/{print "on: workflow_dispatch"; in_on=1; next} in_on && NF==0 {in_on=0; next} in_on && /^[^[:space:]]/ {in_on=0} !in_on {print}' $$f > $$f.tmp && mv $$f.tmp $$f; \
		sed -i.bak '/^[[:space:]]*schedule:/,/^[^[:space:]]/d' $$f && rm -f $$f.bak; \
	done; \
	git add .github/workflows && git commit -m "ci: disable legacy workflows; remove schedules (sed)" || true; \
	git push || true

core-ci:
	@test -n "$(REPO)" || (echo "Run: gh auth login"; exit 1)
	@gh workflow run core-ci.yml || true
	@sleep 5
	@gh run list --limit 10

ci:
	bash ops/scripts/local_core_sanity.sh

smoke:
	@echo "== API health =="; \
	curl -s -o /dev/null -w "%{http_code}  $(API_HEALTH)\n" "$(API_HEALTH)"
	@for U in "$(MARKETING_URL)" "$(BUSINESS_URL)" "$(ENTERPRISE_URL)" "$(DASHBOARD_URL)"; do \
		[ -z "$$U" ] && continue; \
		echo "== $$U =="; \
		curl -s -o /dev/null -w "%{http_code}  $$U\n" "$$U"; \
	done

ship:
	@echo "== Step 1: Backend (Functions) =="; \
	cd functions && npm ci && npm run build
	@echo "Deploy your functions now (example): firebase deploy --only functions"
	@echo "Health check: $(API_HEALTH)"
	@curl -s -o /dev/null -w "%{http_code}  $(API_HEALTH)\n" "$(API_HEALTH)"
	@echo "== Step 2: Vercel Preview (manual or vercel CLI) =="; \
	echo "Verify each app Preview is green, then promote Preview → Production."
	@echo "== Step 3: Done =="

rollback:
	@echo "Vercel: promote previous deployment to Production (UI or vercel CLI)."
	@echo "Functions: redeploy previous tag/artifact (e.g., git checkout vX.Y.Z && firebase deploy --only functions)."


