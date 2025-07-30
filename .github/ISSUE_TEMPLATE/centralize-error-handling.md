---
name: Centralize Error Handling
about: Extract NotificationService and replace all SnackBar calls
title: "Extract NotificationService and replace all SnackBar calls"
labels: ["refactoring", "flutter", "high priority"]
assignees: []
---

## Description
We have 60+ direct uses of `ScaffoldMessenger.of(...).showSnackBar()`. Create a `NotificationService` with methods like `showSuccess()`, `showError()`, and update screens to use it instead of raw SnackBars.

## Current Issues
- 60+ direct `ScaffoldMessenger.of(...).showSnackBar()` calls scattered across the codebase
- Inconsistent error handling patterns
- No centralized notification management
- Difficult to maintain and update notification styling

## Acceptance Criteria
- [ ] New file: `lib/services/notification_service.dart` with reusable methods
- [ ] App's root `ScaffoldMessengerKey` wired to the service
- [ ] At least 3 sample screens fully refactored
- [ ] No remaining direct `showSnackBar` calls
- [ ] Service supports success, error, warning, and info notifications

## Service Interface
```dart
class NotificationService {
  static void showSuccess(String message);
  static void showError(String message);
  static void showWarning(String message);
  static void showInfo(String message);
  static void showLoading(String message);
  static void hideLoading();
}
```

## Files to Update
- [ ] Create `lib/services/notification_service.dart`
- [ ] Update `lib/main.dart` to wire up the service
- [ ] Refactor screens in `lib/features/` directories
- [ ] Update any providers that show notifications

## Implementation Steps
1. Create `NotificationService` class with static methods
2. Add `GlobalKey<ScaffoldMessengerState>` to main app
3. Wire the service to use the global key
4. Refactor 3+ screens to use the new service
5. Update any providers that show notifications
6. Test all notification types work correctly

## Definition of Done
- [ ] `NotificationService` is implemented and working
- [ ] At least 3 screens use the new service
- [ ] All notification types (success, error, warning, info) work
- [ ] No direct `ScaffoldMessenger` calls remain
- [ ] Service is properly integrated with the app's global state 