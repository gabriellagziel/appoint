# QA Roadmap
_Updated: 2025-07-05_

| Sprint | Feature focus | Environments | Devices/Browsers | Owner | Exit criteria |
|--------|---------------|--------------|------------------|-------|---------------|
| 2025-07-Sprint-1 | Booking core | Staging | Chrome 125, Android 14, iOS 17 | QA-1 | ✔ Unit + integration tests green <br> ✔ Manual calendar CRUD pass |
| 2025-07-Sprint-2 | Payments v2 | Staging | Chrome, Safari, Pixel 8 | QA-2 | ✔ Stripe sandbox OK <br> ✔ Refund flow manual pass |
| 2025-08-Sprint-1 | Notifications | Dev & Staging | Chrome, iOS, Android | QA-3 | ✔ Push received in <2 s <br> ✔ Localisation he/it OK |

## Device matrix
| OS | Version | Device | Priority |
|----|---------|--------|----------|
| Android | 14 | Pixel 8 | P0 |
| Android | 12 | Samsung S21 | P1 |
| iOS | 17 | iPhone 15 | P0 |
| Web | Chrome 125 | Desktop | P0 |
| Web | Safari 17 | Mac | P1 |

## Coverage bump rules

| Overall coverage holds for… | New gate |
|-----------------------------|----------|
| ≥25 % for 2 consecutive weeks | 40 % |
| ≥50 % for 2 consecutive weeks | 60 % |
| ≥70 % for 2 consecutive weeks | 80 % |

> CI maintainer: update the threshold in `.github/workflows/flutter_ci.yml` each time the rule triggers.

## Sign-off flow
1. Feature branch merges → CI green.  
2. QA executes relevant manual suite.  
3. PO reviews demo video.  
4. Tag release `vX.Y.Z` & publish changelog. 