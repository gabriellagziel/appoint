## app-oint.com (Apex)

- [x] Landing with clear CTAs to subdomains
  - Evidence: marketing/pages/index.tsx:59-85, 86-110, 111-134
- [x] Support/Contact page with FAQ section
  - Evidence: marketing/pages/contact.tsx:13-19, 40-56, 169-179
- [ ] FAQ standalone page
  - Evidence: None found → see GAPS.md
- [ ] Blog
  - Evidence: None found → see GAPS.md
- [ ] Ambassador Program page
  - Evidence: None found → see GAPS.md

## personal.app-oint.com

- [ ] Home with Quick Actions (Create Meeting/Reminder)
  - Evidence: None found in `appoint/lib/**`
- [ ] Meeting Flow (type → participants → details → review)
  - Evidence: None found
- [ ] Meeting Page: "I'm late", Chat/Discussion, links to Reminders/Playtime
  - Evidence: None found
- [ ] Sections: Groups, Family, Playtime
  - Evidence: None found

## business.app-oint.com

- [x] Dashboard
  - Evidence: dashboard/src/app/dashboard/page.tsx:19-22
- [x] Appointments list and creation
  - Evidence: dashboard/src/app/dashboard/appointments/page.tsx:20-41; dashboard/src/app/dashboard/appointments/new/page.tsx:1-4
- [x] Reports/Analytics
  - Evidence: dashboard/src/app/dashboard/reports/page.tsx:20-61
- [ ] Clients module
  - Evidence: Not found
- [ ] Payments module
  - Evidence: Not found

## enterprise.app-oint.com

- [x] API Landing with features
  - Evidence: marketing/pages/enterprise.tsx:69-76, 83-99
- [x] Pricing/Plans
  - Evidence: marketing/pages/enterprise.tsx:101-128
- [ ] Docs section (/docs)
  - Evidence: Not found
- [ ] Onboarding flow
  - Evidence: Not found
- [ ] Dashboard for API keys/logs/stats
  - Evidence: Not found

## admin.app-oint.com

- [x] Admin dashboard
  - Evidence: admin/src/app/page.tsx:20-29
- [x] Ambassadors module
  - Evidence: admin/src/app/admin/ambassadors/page.tsx:11-21
- [x] Analytics module
  - Evidence: admin/src/app/admin/analytics/page.tsx:10-22
- [x] System settings/monitoring module
  - Evidence: admin/src/app/admin/system/page.tsx:171-181, 228-236
- [ ] Ads (3 free)
  - Evidence: Not found
- [ ] Fraud module
  - Evidence: Not found
- [x] Payments module placeholder
  - Evidence: admin/src/app/admin/payments/page.tsx:1-1 (file exists)
- [x] Users module placeholder
  - Evidence: admin/src/app/admin/users/page.tsx:1-1 (file exists)

