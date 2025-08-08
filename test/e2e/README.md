# Playtime E2E Testing Suite

This directory contains end-to-end tests for the Playtime system, specifically focused on age enforcement, parent approval workflows, and COPPA compliance.

## Test Coverage

### Age-Based Scenarios
- **Adult (18+)**: Can create any playtime session without approval requirements
- **Teen (13-17)**: Needs parent approval for age-restricted games
- **Child (<13)**: Blocked from inappropriate games, requires parent approval for all sessions

### Safety and Monitoring
- Content flagging and admin review workflows
- Inappropriate content detection
- Safety flags and restrictions

## Prerequisites

1. **Firebase CLI**: Install the Firebase CLI to run the Firestore emulator
   ```bash
   npm install -g firebase-tools
   ```

2. **Flutter**: Ensure Flutter is installed and configured
   ```bash
   flutter doctor
   ```

## Running the Tests

### Option 1: Using the Script (Recommended)
```bash
./scripts/run_e2e_tests.sh
```

### Option 2: Manual Steps
1. Start the Firestore emulator:
   ```bash
   firebase emulators:start --only firestore
   ```

2. In another terminal, run the tests:
   ```bash
   flutter test test/e2e/playtime_e2e_test.dart \
     --dart-define=FIRESTORE_EMULATOR_HOST=localhost \
     --dart-define=FIRESTORE_EMULATOR_PORT=8080
   ```

## Test Data

The tests automatically seed the following data:

### Users
- `adult_18`: 18 years old, no parent restrictions
- `teen_15`: 15 years old, parent is `parent_42`
- `child_10`: 10 years old, parent is `parent_42`
- `parent_42`: 40 years old, parent with preferences set

### Games
- `minecraft`: MinAge 8, suitable for children
- `mature_shooter`: MinAge 18, restricted content

### Parent Preferences
- `parent_42`: Allows age restriction overrides, no blocked games

## What Each Test Validates

### 1. Adult Session Creation
- **Scenario**: Adult creates both physical and virtual sessions
- **Expected**: Sessions created without approval requirements
- **Validates**: Age bypass for adults (18+)

### 2. Child Restriction Enforcement
- **Scenario**: Child tries to create session with mature game
- **Expected**: Throws `AgeRestrictedError` or `ParentApprovalRequiredError`
- **Validates**: COPPA compliance for children under 13

### 3. Teen Parent Approval Flow
- **Scenario**: Teen creates session with age-restricted game
- **Expected**: Requires parent approval before session creation
- **Validates**: Parent approval workflow for 13-17 age group

### 4. Age-Appropriate Content
- **Scenario**: Child creates session with age-appropriate game
- **Expected**: Session created with parent approval
- **Validates**: Normal flow for appropriate content

### 5. Safety Monitoring
- **Scenario**: Content flagged as inappropriate
- **Expected**: Admin approval required, safety flags set
- **Validates**: Content moderation and safety systems

## Debugging Tests

1. **Check Emulator Status**: Ensure the Firestore emulator is running on localhost:8080
2. **View Emulator UI**: Open http://localhost:4000 to see the emulator UI
3. **Check Logs**: Review console output for detailed error messages
4. **Verify Data**: Use the emulator UI to inspect seeded data

## Firebase Rules

The tests use the `firestore.rules` file which implements:
- Age-based access controls
- Parent-child relationship validation
- Session creation restrictions
- Approval workflow enforcement

## Common Issues

### Emulator Connection Failed
- Ensure Firebase CLI is installed: `npm install -g firebase-tools`
- Check if port 8080 is available
- Try restarting the emulator

### Test Data Not Found
- Verify the `_seedData()` function runs successfully
- Check emulator UI to confirm data was created
- Ensure emulator is using the correct project ID

### Permission Denied Errors
- Verify Firestore rules are loaded correctly
- Check user authentication context in tests
- Review rule logic for the failing operation

## Extending Tests

To add new test scenarios:

1. **Add Test Data**: Update `_seedData()` with required users/games/preferences
2. **Create Test Case**: Add new test in the appropriate group
3. **Validate Behavior**: Use assertions to verify expected outcomes
4. **Update Documentation**: Document the new scenario here

## Related Files

- `lib/services/coppa_service.dart`: COPPA compliance logic
- `lib/services/playtime_preferences_service.dart`: Parent preferences
- `lib/services/playtime_service.dart`: Session creation with validation
- `firestore.rules`: Security rules for age-based access control
- `lib/models/playtime_session.dart`: Session data models
