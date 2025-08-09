# 🚀 Post-Deploy Smoke Test Runbook

## 📋 Pre-Deploy Checklist

### Environment Verification
- [ ] Production environment is healthy
- [ ] Database migrations completed
- [ ] CDN cache cleared (if applicable)
- [ ] Monitoring alerts configured

### Test Data Preparation
- [ ] Test user accounts available
- [ ] Sample meetings created
- [ ] Test invites generated
- [ ] Mock location data ready

---

## 🧪 Smoke Test Suite

### 1. 🏠 Home Landing Page

**Test**: `/` (root URL)

**Expected Behavior**:
- ✅ Page loads within 3 seconds
- ✅ Greeting displays correctly
- ✅ Quick actions are visible
- ✅ Today's schedule shows merged reminders + meetings
- ✅ Suggestions appear (if any)

**Critical Checks**:
- [ ] No console errors
- [ ] Responsive design works (mobile/tablet/desktop)
- [ ] Navigation to other sections works
- [ ] Loading states display correctly

**Test Commands**:
```bash
# Open in different viewports
flutter test -d chrome test/features/home/home_landing_screen_test.dart
```

### 2. 📅 Meeting Creation Flow

**Test**: Create Meeting → Review → Success

**Expected Behavior**:
- ✅ Participants step validates input
- ✅ Meeting type selection works
- ✅ Virtual meetings skip location step
- ✅ Playtime meetings require playtime config
- ✅ Time/date picker functions correctly
- ✅ Review screen shows all data
- ✅ Creation succeeds with valid data

**Critical Checks**:
- [ ] Form validation prevents invalid submissions
- [ ] Step navigation works (next/prev/goTo)
- [ ] Data persists between steps
- [ ] Error states display correctly

**Test Commands**:
```bash
# Unit tests
flutter test test/features/meeting_creation/

# Integration test
flutter test -d chrome integration_test/meeting_creation_flow_e2e_test.dart
```

### 3. 🎮 Playtime Configuration

**Test**: Physical vs Virtual Playtime Setup

**Expected Behavior**:
- ✅ Physical playtime requires location
- ✅ Virtual playtime requires platform
- ✅ Discord requires room code + server code
- ✅ Game selection populates config
- ✅ Validation rules work correctly

**Critical Checks**:
- [ ] Platform-specific requirements enforced
- [ ] Location search works for physical
- [ ] Room/server codes validated
- [ ] Game metadata populated correctly

**Test Commands**:
```bash
flutter test test/features/playtime/playtime_controller_test.dart
```

### 4. 📍 Location & Maps Integration

**Test**: Location Search + Navigation

**Expected Behavior**:
- ✅ Location search returns results
- ✅ OSM preview renders correctly
- ✅ Navigation links open correct provider
- ✅ Coordinates calculated accurately

**Critical Checks**:
- [ ] Search handles special characters
- [ ] Maps load without network errors
- [ ] Navigation URLs formatted correctly
- [ ] Fallback behavior works

**Test Commands**:
```bash
flutter test test/services/maps/map_search_service_test.dart
flutter test test/services/navigation/REDACTED_TOKEN.dart
```

### 5. 🔗 Join Invite Flow

**Test**: `/join?token=fake&src=telegram`

**Expected Behavior**:
- ✅ Guest view renders correctly
- ✅ Invite details display properly
- ✅ Accept/Decline buttons work
- ✅ Success/error states handled
- ✅ Analytics events fired

**Critical Checks**:
- [ ] Invalid tokens show error
- [ ] Expired invites handled
- [ ] Single-use invites consumed
- [ ] Guest flow completes successfully

**Test Commands**:
```bash
flutter test test/features/invite/join_route_parsing_test.dart
flutter test test/features/invite/guest_flow_test.dart
flutter test -d chrome integration_test/join_invite_e2e_test.dart
```

### 6. 📱 Meeting Details & Sharing

**Test**: Meeting Details → Share → Navigate

**Expected Behavior**:
- ✅ Meeting details display correctly
- ✅ Share button copies invite link
- ✅ Navigate button opens map provider
- ✅ Universal sharing works across platforms

**Critical Checks**:
- [ ] Share text includes meeting info
- [ ] Deep links formatted correctly
- [ ] Copy fallback works
- [ ] Platform detection works

**Test Commands**:
```bash
flutter test test/services/sharing/share_service_test.dart
flutter test -d chrome integration_test/share_universal_e2e_test.dart
```

### 7. 🗓️ Calendar & Reminders

**Test**: Calendar View + Reminder Management

**Expected Behavior**:
- ✅ Today's agenda merges reminders + meetings
- ✅ Reminder CRUD operations work
- ✅ Filtering by status works
- ✅ Due dates handled correctly

**Critical Checks**:
- [ ] Date calculations accurate
- [ ] Overdue reminders highlighted
- [ ] Family reminders show correctly
- [ ] Assignment filtering works

**Test Commands**:
```bash
flutter test test/features/reminders/reminder_controller_test.dart
flutter test test/features/calendar/calendar_agenda_merge_test.dart
```

### 8. 👨‍👩‍👧‍👦 Family Features

**Test**: Family Member Management

**Expected Behavior**:
- ✅ Link family members works
- ✅ Child approval/denial functions
- ✅ Pending lists display correctly
- ✅ Family statistics accurate

**Critical Checks**:
- [ ] Permission checks work
- [ ] Child safety features active
- [ ] Family reminders shared
- [ ] Privacy settings respected

**Test Commands**:
```bash
flutter test test/features/family/family_controller_test.dart
```

### 9. 🎯 Ad-Gate Integration

**Test**: Free vs Premium User Experience

**Expected Behavior**:
- ✅ Free users see watch requirement
- ✅ Premium users bypass ads
- ✅ Ad completion unlocks feature
- ✅ Graceful degradation if ads fail

**Critical Checks**:
- [ ] Ad loading doesn't block UI
- [ ] Completion tracking works
- [ ] Fallback for ad failures
- [ ] Premium detection accurate

**Test Commands**:
```bash
flutter test test/features/ads/ad_gate_modal_test.dart
```

### 10. 🔔 Push Notifications

**Test**: Notification System

**Expected Behavior**:
- ✅ Permission requests work
- ✅ Notifications display correctly
- ✅ Deep links from notifications work
- ✅ Badge counts accurate

**Critical Checks**:
- [ ] Permission denied handled
- [ ] Notification content correct
- [ ] Deep link navigation works
- [ ] Badge clearing works

---

## 🚨 Error Scenarios

### Network Failures
- [ ] Offline mode works
- [ ] Retry mechanisms function
- [ ] Error messages user-friendly
- [ ] Data cached appropriately

### Invalid Data
- [ ] Malformed invites handled
- [ ] Invalid locations handled
- [ ] Corrupted meeting data handled
- [ ] Graceful degradation

### Performance Issues
- [ ] Large datasets handled
- [ ] Memory usage reasonable
- [ ] Loading states display
- [ ] No UI freezing

---

## 📊 Analytics Verification

### Events to Verify
- [ ] Page views tracked
- [ ] User interactions logged
- [ ] Error events captured
- [ ] Conversion funnels complete

### Data Quality
- [ ] No PII in analytics
- [ ] Event names consistent
- [ ] Parameters structured correctly
- [ ] No duplicate events

---

## 🔧 Debugging Commands

### Coverage Check
```bash
cd appoint
flutter test --coverage
dart run tool/check_coverage.dart
```

### Copy Consistency
```bash
./scripts/scan_copy.sh
```

### Performance Check
```bash
flutter test --coverage --dart-define=profile=true
```

### Golden Test Update
```bash
flutter test test/goldens/ --update-goldens
```

---

## 📞 Emergency Contacts

### On-Call Engineer
- **Name**: [Primary On-Call]
- **Slack**: @[handle]
- **Phone**: [number]

### Product Owner
- **Name**: [Product Owner]
- **Slack**: @[handle]

### DevOps
- **Slack**: #devops-alerts
- **PagerDuty**: [escalation]

---

## 📝 Test Results Template

### Deployment Info
- **Version**: [X.X.X]
- **Deployed At**: [timestamp]
- **Deployed By**: [name]

### Test Results
- [ ] All smoke tests pass
- [ ] Performance acceptable
- [ ] No critical errors
- [ ] Analytics firing correctly

### Issues Found
- [ ] None
- [ ] [List issues with severity]

### Rollback Decision
- [ ] No rollback needed
- [ ] Rollback initiated (reason: [explanation])

---

**Last Updated**: December 2024  
**Version**: 1.0.0
