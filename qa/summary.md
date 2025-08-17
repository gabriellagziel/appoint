| App/Area | Flows | Ads | A11y | Lighthouse | Links |
|---|---|---|---|---|---|
| MAIN | FAIL (CTAs not found) | PASS | TBD | FAIL (NO_FCP) | N/A |
| PERSONAL | BLOCKER (DNS) | N/A | TBD | N/A | N/A |
| BUSINESS | PASS (LP+guard) | PASS | TBD | TBD | PASS (basic) |
| ENTERPRISE | PASS (LP+guard) | PASS | TBD | TBD | PASS (basic) |
| API PORTAL | BLOCKER (DNS) | N/A | TBD | N/A | N/A |
| ADMIN | BLOCKER (DNS) | N/A | TBD | N/A | N/A |

Final verdict: NOT READY

BLOCKERs:
- PERSONAL DNS: https://app.app-oint.com not resolvable. Fix: Configure DNS A/AAAA and TLS.
- API PORTAL DNS: https://api.app-oint.com not resolvable. Fix: Configure DNS and deploy.
- ADMIN DNS: https://admin.app-oint.com not resolvable. Fix: Configure DNS and deploy.
- MAIN Flow: 3 CTA anchors not present. Fix: Ensure Business/API/Personal CTAs exist and are visible in DOM.
- Naked redirect: https://app-oint.com fails SSL/redirect. Fix: Add 301 → https://www.app-oint.com/ and issue cert.

Note: Ads network requests not observed on MAIN/BUSINESS/ENTERPRISE homepage loads.


