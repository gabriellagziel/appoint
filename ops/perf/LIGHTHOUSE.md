# Lighthouse Plan
- Scope: marketing, business, enterprise, dashboard
- Mode: Mobile, throttled
- Targets: Performance ≥ 80, Best Practices ≥ 90, Accessibility ≥ 90, SEO ≥ 90
- Store reports under `ops/perf/YYYY-MM-DD/<app>.html`

## Commands (local)
lighthouse https://marketing.example.com --output html --output-path ops/perf/$(date +%F)/marketing.html --throttling-method=devtools --preset=desktop
