# Family UI Testing Guide - Post-Deployment

## Overview
This guide provides comprehensive testing instructions for the Family UI features with Remote Config gating and Analytics tracking.

## Pre-Testing Setup

### 1. Firebase Console Configuration
1. Navigate to Firebase Console > Remote Config
2. Create the following parameters:
   - `family_ui_enabled` (boolean, default: false)
   - `family_calendar_enabled` (boolean, default: false)
   - `family_reminder_assignment_enabled` (boolean, default: false)

### 2. Analytics DebugView Setup
1. Open Firebase Console > Analytics > DebugView
2. Enable debug mode in your app
3. Verify events are appearing in real-time

### 3. Test Data Preparation
```bash
# Run backfill script in dry-run mode
node scripts/backfill_reminders_assignee.js --dry-run
```

## Feature Flag Testing

### Test Case 1: All Flags Disabled
**Objective**: Verify features are hidden when all flags are false

**Steps**:
1. Set all Remote Config flags to `false`
2. Restart the app
3. Navigate to Family Dashboard route (`/dashboard/family`)
4. Navigate to Family Calendar route (`/family/calendar`)
5. Try to create a reminder with assignment

**Expected Results**:
- [ ] Family Dashboard shows "Feature not available" message
- [ ] Family Calendar shows "Feature not available" message
- [ ] Reminder creation doesn't show "Who is this for?" option
- [ ] No analytics events are fired for family features

### Test Case 2: Individual Flag Testing
**Objective**: Verify each feature works independently

**Steps**:
1. Set `family_ui_enabled` to `true`, others to `false`
2. Test Family Dashboard functionality
3. Set `family_calendar_enabled` to `true`, others to `false`
4. Test Family Calendar functionality
5. Set `family_reminder_assignment_enabled` to `true`, others to `false`
6. Test reminder assignment functionality

**Expected Results**:
- [ ] Only enabled features are accessible
- [ ] Disabled features show appropriate messages
- [ ] Analytics events fire only for enabled features

### Test Case 3: Flag Changes Without Restart
**Objective**: Verify flags update dynamically

**Steps**:
1. Start app with all flags disabled
2. Change a flag to `true` in Firebase Console
3. Wait for Remote Config to fetch (1-5 minutes)
4. Navigate to the feature without restarting

**Expected Results**:
- [ ] Feature becomes available without app restart
- [ ] Analytics events fire correctly
- [ ] No crashes or errors

## Analytics Testing

### Test Case 4: Family Dashboard Analytics
**Objective**: Verify dashboard analytics events

**Steps**:
1. Enable `family_ui_enabled` flag
2. Open Family Dashboard
3. Check Firebase DebugView

**Expected Results**:
- [ ] `family_dashboard_open` event is logged
- [ ] Event includes `timestamp` parameter
- [ ] No duplicate events

### Test Case 5: Family Calendar Analytics
**Objective**: Verify calendar analytics events

**Steps**:
1. Enable `family_calendar_enabled` flag
2. Open Family Calendar
3. Change filter to "All", "Me", "Child"
4. Check Firebase DebugView

**Expected Results**:
- [ ] `family_calendar_view` event is logged for each filter
- [ ] Events include `filter` and `timestamp` parameters
- [ ] Filter values are correct (all|me|child)

### Test Case 6: Reminder Analytics
**Objective**: Verify reminder creation analytics

**Steps**:
1. Enable `family_reminder_assignment_enabled` flag
2. Create reminder for "Self"
3. Create reminder for "Child"
4. Create reminder for "Spouse"
5. Check Firebase DebugView

**Expected Results**:
- [ ] `reminder_created` event is logged for each creation
- [ ] Events include `assignee` and `timestamp` parameters
- [ ] Assignee values are correct (self|child|spouse)

### Test Case 7: Security Analytics
**Objective**: Verify rules blocked analytics

**Steps**:
1. Attempt to access restricted Firestore data
2. Check Firebase DebugView

**Expected Results**:
- [ ] `rules_blocked` event is logged
- [ ] Events include `collection` and `operation` parameters
- [ ] Error details are captured

## Integration Testing

### Test Case 8: Feature Gate Widgets
**Objective**: Verify feature gate widgets work correctly

**Steps**:
1. Test `FeatureGate` widget
2. Test `FeatureGateWithMessage` widget
3. Test `FeatureGateBuilder` widget
4. Verify fallback behavior

**Expected Results**:
- [ ] Widgets show/hide content based on flags
- [ ] Disabled features show appropriate messages
- [ ] No layout issues or crashes

### Test Case 9: Provider Integration
**Objective**: Verify Riverpod providers work correctly

**Steps**:
1. Test `remoteConfigProvider`
2. Test `familyUiEnabledProvider`
3. Test `familyCalendarEnabledProvider`
4. Test `familyReminderAssignmentEnabledProvider`
5. Test `analyticsProvider`

**Expected Results**:
- [ ] Providers return correct values
- [ ] Providers update when flags change
- [ ] No provider errors or exceptions

## Backfill Script Testing

### Test Case 10: Dry Run
**Objective**: Verify backfill script works without making changes

**Steps**:
```bash
node scripts/backfill_reminders_assignee.js --dry-run
```

**Expected Results**:
- [ ] Script runs without errors
- [ ] Shows count of documents that would be updated
- [ ] Shows sample documents
- [ ] No actual changes are made

### Test Case 11: Live Run
**Objective**: Verify backfill script updates data correctly

**Steps**:
```bash
node scripts/backfill_reminders_assignee.js
```

**Expected Results**:
- [ ] Script runs without errors
- [ ] Documents are updated in batches
- [ ] Validation shows all reminders have `assigneeId`
- [ ] No unrelated documents are affected

## Performance Testing

### Test Case 12: Remote Config Performance
**Objective**: Verify Remote Config doesn't impact app performance

**Steps**:
1. Measure app startup time
2. Test flag changes and response time
3. Monitor memory usage

**Expected Results**:
- [ ] App startup time is acceptable (<3 seconds)
- [ ] Flag changes are reflected within 5 minutes
- [ ] Memory usage is stable

### Test Case 13: Analytics Performance
**Objective**: Verify analytics don't impact app performance

**Steps**:
1. Trigger multiple analytics events
2. Monitor app responsiveness
3. Check network usage

**Expected Results**:
- [ ] App remains responsive during analytics events
- [ ] Network usage is reasonable
- [ ] No memory leaks

## Error Handling Testing

### Test Case 14: Network Issues
**Objective**: Verify graceful handling of network issues

**Steps**:
1. Disconnect internet
2. Try to access Remote Config
3. Reconnect and verify recovery

**Expected Results**:
- [ ] App uses default values when offline
- [ ] No crashes or errors
- [ ] Features work correctly when reconnected

### Test Case 15: Firebase Errors
**Objective**: Verify graceful handling of Firebase errors

**Steps**:
1. Simulate Firebase service issues
2. Test feature gates
3. Test analytics events

**Expected Results**:
- [ ] App continues to function
- [ ] Features fall back to disabled state
- [ ] Analytics errors are logged but don't crash app

## Smoke Test Checklist

### Quick Verification
- [ ] App starts without errors
- [ ] Remote Config initializes successfully
- [ ] Feature flags default to false
- [ ] Analytics events are logged
- [ ] Feature gates work correctly
- [ ] Backfill script runs without errors

### Manual Testing
- [ ] Navigate to Family Dashboard (should be disabled)
- [ ] Navigate to Family Calendar (should be disabled)
- [ ] Create reminder (should not show assignment)
- [ ] Check Firebase DebugView for events
- [ ] Verify Remote Config values in console

## Debug Commands

### Check Remote Config
```bash
flutter run --debug
# Check console for Remote Config logs
```

### Test Analytics
```bash
# Check Firebase DebugView in browser
# Verify events are appearing
```

### Validate Backfill
```bash
node scripts/backfill_reminders_assignee.js --dry-run
```

### Check Dependencies
```bash
flutter pub get
flutter analyze
```

## Reporting Issues

### When reporting issues, include:
1. **Environment**: Device, OS, Flutter version
2. **Steps**: Exact steps to reproduce
3. **Expected vs Actual**: What should happen vs what happened
4. **Logs**: Console output and error messages
5. **Screenshots**: Visual evidence of the issue
6. **Remote Config**: Current flag values
7. **Analytics**: Events that were/weren't fired

### Common Issues and Solutions

#### Issue: Feature flags not updating
**Solution**: Check Remote Config initialization in main.dart

#### Issue: Analytics events not firing
**Solution**: Verify Firebase Analytics setup and DebugView

#### Issue: Backfill script errors
**Solution**: Check Firebase Admin SDK credentials and permissions

#### Issue: Feature gates not working
**Solution**: Verify provider dependencies and imports

## Success Criteria

### All tests pass when:
- [ ] All feature flags work correctly
- [ ] Analytics events fire as expected
- [ ] Backfill script runs successfully
- [ ] No performance degradation
- [ ] Error handling works gracefully
- [ ] Documentation is complete and accurate
