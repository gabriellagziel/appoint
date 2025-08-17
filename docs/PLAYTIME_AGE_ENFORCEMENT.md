# Playtime Age Enforcement System

## 🎯 Overview

The Playtime Age Enforcement System implements comprehensive age restrictions for child safety and COPPA compliance. This system ensures that users can only access age-appropriate games while providing parents with full control over their children's playtime activities.

## 🔒 Key Principles

### 1. **Adult Exemption (Critical)**
> ⚠️ **Adults (18+) are completely exempt from all age-based restrictions.**
- No game access limitations
- No parental approval requirements  
- No UI restrictions or warnings
- Full access to all content and features

### 2. **Safety-First Approach**
- Default to restrictive settings when user data is incomplete
- Require explicit parent approval for questionable content
- Firestore rules enforce restrictions at database level

### 3. **Layered Protection**
- **Service Layer**: Age validation in `PlaytimeService.createSession()`
- **UI Layer**: Filtered game lists and error handling
- **Database Layer**: Firestore security rules
- **Client Layer**: Real-time age checking

## 📁 Implementation Files

### Core Services
- `lib/services/coppa_service.dart` - Age calculation and user classification
- `lib/services/playtime_service.dart` - Session creation with age validation
- `lib/services/playtime_preferences_service.dart` - Parental controls

### UI Components
- `lib/widgets/age_aware_game_selector.dart` - Age-filtered game selection
- `lib/widgets/age_aware_session_creator.dart` - Session creation with validation

### Data Models
- `lib/models/playtime_preferences.dart` - Parental control settings
- `lib/exceptions/playtime_exceptions.dart` - Age-related exceptions

### Providers
- `lib/providers/playtime_provider.dart` - Age-aware Riverpod providers

### Security
- `firestore.rules` - Database-level age enforcement

### Tests
- `test/services/playtime_age_restriction_test.dart` - Comprehensive test suite

## 🛡️ Age Validation Logic

### Service Layer Validation

```dart
// In PlaytimeService.createSession()
static Future<void> _validateSessionAgeRestrictions(PlaytimeSession session) async {
  final userAgeInfo = await CoppaService.getUserAgeInfo(session.creatorId);
  final game = await getGameById(session.gameId);
  
  // CRITICAL: Adults (18+) bypass ALL restrictions
  if (userAgeInfo.isAdult) {
    return; // No restrictions for adults
  }
  
  // Check age bounds for non-adults
  final userAge = userAgeInfo.calculatedAge;
  if (userAge < game.minAge) {
    throw AgeRestrictedError(...);
  }
  
  // Check parent approval for children
  if (userAgeInfo.needsParentalApproval && !hasParentApproval) {
    throw ParentApprovalRequiredError(...);
  }
}
```

### Firestore Rules Validation

```javascript
// Age validation in firestore.rules
function isOldEnoughForGame(gameId, uid) {
  // Adults bypass all age restrictions
  if (isAdultUser(uid)) return true;
  
  let userAge = getUserAge(uid);
  let gameData = getGameData(gameId);
  
  // Safety: deny if age unknown
  if (userAge == null) return false;
  
  // Check age bounds
  return userAge >= gameData.ageRange.min && 
         (gameData.ageRange.max >= 18 || userAge <= gameData.ageRange.max);
}
```

## 🔧 Exception Handling

### Custom Exceptions

| Exception | Thrown When | UI Response |
|-----------|-------------|-------------|
| `AgeRestrictedError` | User age outside game's age range | Show age requirement message |
| `ParentApprovalRequiredError` | Child needs parent approval | Prompt to contact parent |
| `SafetyRestrictedError` | Safety level restrictions | Display safety message |
| `UserDataIncompleteError` | Missing age/profile data | Prompt profile completion |

### Error Details

```dart
class AgeRestrictedError extends PlaytimeException {
  final int userAge;
  final int? minAge, maxAge;
  final String gameId, gameName;
  
  bool get isTooYoung => minAge != null && userAge < minAge!;
  bool get isTooOld => maxAge != null && userAge > maxAge!;
  String get ageRangeString => '$minAge-$maxAge years';
}
```

## 🎮 Game Access Matrix

| User Type | Age Range | Access Level | Approval Required |
|-----------|-----------|--------------|-------------------|
| **Adult** | 18+ | **Full Access** | **Never** |
| Teen | 13-17 | Age-appropriate only | For some games |
| Child | 5-12 | Restricted selection | For most games |
| Toddler | <5 | Minimal selection | Always |

## 👨‍👩‍👧‍👦 Parental Controls

### Override Settings

```dart
class PlaytimePreferences {
  final bool allowOverrideAgeRestriction;  // Bypass age checks
  final List<String> approvedGames;        // Pre-approved games  
  final List<String> blockedGames;         // Explicitly blocked
  final int? maxDailyPlaytime;             // Daily time limit
  final List<TimeRange> allowedPlaytimes;  // Allowed hours
}
```

### Parent Actions

```dart
// Approve specific game
await PlaytimePreferencesService.approveGame(childId, gameId, parentId);

// Enable age override
await PlaytimePreferencesService.setParentalOverride(childId, true, parentId);

// Set time limits
await PlaytimePreferencesService.setPlaytimeLimits(
  childId,
  maxDailyPlaytime: 120, // 2 hours
  parentId: parentId,
);
```

## 🎨 UI Implementation

### Age-Aware Game Selector

```dart
AgeAwareGameSelector(
  userId: currentUserId,
  onGameSelected: (game) => handleGameSelection(game),
  showRestrictedGames: true, // Show with restrictions
)
```

### Features:
- **Color-coded status indicators**
  - 🟢 Green: Available
  - 🟡 Orange: Needs approval  
  - 🔴 Red: Age restricted
- **Contextual messages**
- **Automatic filtering based on user age**
- **Parent approval dialogs**

### Session Creation Flow

```dart
AgeAwareSessionCreator(
  userId: currentUserId,
  onSessionCreated: () => navigateToSessions(),
)
```

### Error Handling:
- Catches `AgeRestrictedError` → Shows age requirement
- Catches `ParentApprovalRequiredError` → Prompts parent contact
- Graceful fallbacks for all restriction types

## 🔐 Security Rules

### Session Creation Rules

```javascript
match /playtime_sessions/{docId} {
  allow create: if isSignedIn() &&
    request.auth.uid == request.resource.data.creatorId &&
    isOldEnoughForGame(request.resource.data.gameId, request.auth.uid) &&
    hasParentApproval(request.resource.data, request.auth.uid);
}
```

### Key Security Features:
- **Age validation at database level**
- **Parent approval enforcement**
- **Adult user exemptions**
- **Creator identity verification**

## 🧪 Testing Strategy

### Test Categories

1. **Age Validation Tests**
   - Adult bypass verification
   - Under-age restriction enforcement
   - Over-age restriction enforcement
   - Age-appropriate access confirmation

2. **Parent Approval Tests**
   - Approval requirement enforcement
   - Approved session creation
   - Override functionality
   - Parent-child relationship verification

3. **Game Filtering Tests**
   - Adult user gets all games
   - Child user gets filtered games
   - Access result accuracy

4. **Exception Tests**
   - Correct exception types
   - Accurate error details
   - Proper error messages

### Running Tests

```bash
# Run age restriction tests
flutter test test/services/playtime_age_restriction_test.dart

# Run all tests
flutter test
```

## 📊 Usage Examples

### Basic Age Checking

```dart
// Check if user can access game
final accessResult = await PlaytimeService.checkGameAccess(userId, gameId);

if (accessResult.canAccess) {
  if (accessResult.needsParentApproval) {
    showParentApprovalDialog();
  } else {
    proceedToGameCreation();
  }
} else {
  showAgeRestrictionMessage(accessResult.error);
}
```

### Getting Age-Filtered Games

```dart
// Get games appropriate for user
final games = await PlaytimeService.getGamesForUser(userId);

// Get games with approval status
final gamesWithStatus = await PlaytimeService.getGamesWithApprovalStatus(userId);

for (final gameStatus in gamesWithStatus) {
  if (gameStatus.shouldHide) {
    continue; // Don't show restricted games
  }
  
  displayGame(
    game: gameStatus.game,
    enabled: !gameStatus.shouldDisable,
    message: gameStatus.displayMessage,
  );
}
```

### Creating Sessions with Validation

```dart
try {
  final session = PlaytimeSession(...);
  await PlaytimeService.createSessionWithValidation(session);
  showSuccessMessage();
} on AgeRestrictedError catch (e) {
  showDialog(
    title: 'Age Restriction',
    message: 'Required age: ${e.ageRangeString}',
  );
} on ParentApprovalRequiredError catch (e) {
  showParentApprovalDialog(e.gameName);
}
```

## 🚀 Production Deployment

### Required Configuration

1. **Firebase Setup**
   - Deploy updated Firestore rules
   - Ensure user collection has age data
   - Set up parent-child relationships

2. **Environment Variables**
   ```bash
   flutter run --dart-define=USE_MOCK_AUTH=false
   ```

3. **Data Migration**
   - Ensure all users have birth dates
   - Initialize default preferences
   - Set up family relationships

### Monitoring

- Monitor age restriction exceptions
- Track parent approval rates  
- Watch for bypass attempts
- Audit rule effectiveness

## ⚠️ Important Notes

### Adult User Behavior
- **Must** bypass all age restrictions
- **Must** have full game access
- **Must not** see approval prompts
- **Must not** be subject to time limits

### Child Safety
- Default to restrictive when in doubt
- Always require parent verification
- Log all restriction bypasses
- Audit approval patterns

### Performance
- Cache age calculations
- Minimize Firestore reads
- Use efficient filtering
- Batch permission checks

## 🔄 Maintenance

### Regular Tasks
- Update age calculations for birthdays
- Review and update safety levels
- Monitor exception patterns
- Audit parent-child relationships

### Updates Required
- Game age range adjustments
- New safety categories
- COPPA regulation changes
- Platform policy updates

---

## 📞 Support

For questions about the age enforcement system:

1. **Technical Issues**: Check test suite results
2. **Policy Questions**: Review COPPA compliance docs
3. **UI/UX Issues**: Test with different age groups
4. **Security Concerns**: Audit Firestore rules

This system ensures safe, compliant, and age-appropriate playtime experiences while maintaining full adult access and comprehensive parental control.















