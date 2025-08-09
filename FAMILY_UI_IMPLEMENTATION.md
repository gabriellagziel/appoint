# Family UI Implementation - Post-Deployment Features

## Overview
This document details the implementation of Family UI features with Remote Config gating and Analytics tracking.

## Remote Config Feature Flags

### Flags Configuration
- `family_ui_enabled` (bool) - Controls Family Dashboard visibility
- `family_calendar_enabled` (bool) - Controls Family Calendar access
- `family_reminder_assignment_enabled` (bool) - Controls "Who is this for?" feature

### Default Values
All flags default to `false` for safe rollout.

### Implementation
```dart
// Remote Config Service
final remoteConfig = RemoteConfigService();
await remoteConfig.initialize();

// Feature flag getters
bool isFamilyUiEnabled = remoteConfig.isFamilyUiEnabled;
bool isFamilyCalendarEnabled = remoteConfig.isFamilyCalendarEnabled;
bool isFamilyReminderAssignmentEnabled = remoteConfig.isFamilyReminderAssignmentEnabled;
```

## Analytics Events

### Family Dashboard Events
- `family_dashboard_open` - Triggered when Family Dashboard is opened
- Parameters: `timestamp`

### Family Calendar Events
- `family_calendar_view` - Triggered when calendar is viewed
- Parameters: `filter` (all|me|child), `timestamp`

### Reminder Events
- `reminder_created` - Triggered when reminder is created
- Parameters: `assignee` (self|child|spouse), `timestamp`

### Security Events
- `rules_blocked` - Triggered when Firestore rules block access
- Parameters: `collection`, `operation`, `timestamp`

### Feature Flag Events
- `feature_flag_check` - Triggered when feature flag is checked
- Parameters: `flag_name`, `is_enabled`, `timestamp`

## Implementation Files

### Services
- `lib/services/remote_config_service.dart` - Remote Config management
- `lib/services/analytics_service.dart` - Analytics event tracking

### Providers
- `lib/providers/remote_config_provider.dart` - Riverpod providers for feature flags
- `lib/providers/analytics_provider.dart` - Riverpod providers for analytics events

### Widgets
- `lib/widgets/feature_gate.dart` - Feature gating widgets
  - `FeatureGate` - Simple feature gate
  - `FeatureGateWithMessage` - Feature gate with disabled message
  - `FeatureGateBuilder` - Builder pattern for feature gates

## Usage Examples

### Feature Gating
```dart
// Simple feature gate
FeatureGate(
  featureName: 'family_ui',
  child: FamilyDashboardScreen(),
)

// Feature gate with message
FeatureGateWithMessage(
  featureName: 'family_calendar',
  child: FamilyCalendarScreen(),
  message: 'Family Calendar is not available',
)

// Builder pattern
FeatureGateBuilder(
  featureName: 'family_reminder_assignment',
  builder: (isEnabled) => isEnabled 
    ? ReminderAssignmentWidget() 
    : Text('Assignment disabled'),
)
```

### Analytics Tracking
```dart
// Track dashboard open
ref.read(familyDashboardOpenProvider);

// Track calendar view with filter
ref.read(familyCalendarViewProvider('all'));

// Track reminder creation
ref.read(reminderCreatedProvider('child'));

// Track rules blocked
ref.read(rulesBlockedProvider({
  'collection': 'reminders',
  'operation': 'read',
}));
```

## Backfill Script

### Location
`scripts/backfill_reminders_assignee.js`

### Usage
```bash
# Dry run (no changes)
node scripts/backfill_reminders_assignee.js --dry-run

# Live run
node scripts/backfill_reminders_assignee.js
```

### What it does
- Finds reminders without `assigneeId`
- Sets `assigneeId = ownerId` for missing values
- Sets `visibility = 'private'` if not set
- Processes in batches of 500 documents
- Validates results after completion

## Deployment Checklist

### Remote Config Setup
1. [ ] Configure feature flags in Firebase Console
2. [ ] Set default values to `false`
3. [ ] Test with different user segments
4. [ ] Monitor analytics for flag usage

### Analytics Setup
1. [ ] Verify Firebase Analytics is enabled
2. [ ] Test events in DebugView
3. [ ] Set up custom dashboards for family features
4. [ ] Monitor conversion rates

### Backfill Execution
1. [ ] Run dry run first
2. [ ] Verify data integrity
3. [ ] Execute live backfill
4. [ ] Validate results
5. [ ] Monitor for any issues

## Testing Guide

### Feature Flag Testing
1. Set all flags to `false` - verify features are hidden
2. Set individual flags to `true` - verify specific features work
3. Test flag changes without app restart
4. Verify fallback behavior

### Analytics Testing
1. Use Firebase DebugView to verify events
2. Test all event parameters
3. Verify user properties are set correctly
4. Monitor for any failed events

### Integration Testing
1. Test feature gates with real navigation
2. Verify analytics events fire correctly
3. Test backfill script with test data
4. Verify no breaking changes to existing features

## Monitoring

### Key Metrics
- Feature flag adoption rates
- Analytics event volumes
- Error rates for blocked operations
- User engagement with family features

### Alerts
- High error rates for rules_blocked events
- Missing analytics events
- Backfill script failures
- Feature flag configuration issues

## Rollout Strategy

### Phase 1: Internal Testing (10%)
- Enable flags for internal team
- Monitor analytics and errors
- Validate feature functionality

### Phase 2: Beta Users (50%)
- Enable for beta user group
- Collect feedback and metrics
- Optimize based on usage patterns

### Phase 3: Full Rollout (100%)
- Enable for all users
- Monitor performance and engagement
- Plan feature enhancements

## Troubleshooting

### Common Issues
1. **Feature flags not updating** - Check Remote Config initialization
2. **Analytics events not firing** - Verify Firebase Analytics setup
3. **Backfill script errors** - Check Firebase Admin SDK credentials
4. **Feature gates not working** - Verify provider dependencies

### Debug Commands
```bash
# Check Remote Config values
flutter run --debug

# Test analytics events
# Check Firebase DebugView

# Validate backfill
node scripts/backfill_reminders_assignee.js --dry-run
```
