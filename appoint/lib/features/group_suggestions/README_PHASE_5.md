# Phase 5: Saved Groups & Smart Suggestions

## Overview
This phase implements intelligent group suggestions and saved groups functionality for the meeting creation flow.

## Features Implemented

### 1. Data Models
- **`SavedGroup`**: Tracks user's saved groups with pinning, aliasing, and usage statistics
- **`GroupUsageInsight`**: Tracks usage events and analytics for scoring
- **`GroupSuggestion`**: Combines group data with scoring for UI display

### 2. Services
- **`SavedGroupsService`**: CRUD operations for saved groups
  - `getSavedGroups()`, `pinGroup()`, `aliasGroup()`, `touchGroup()`
- **`GroupSuggestionsService`**: Smart suggestions with scoring algorithm
  - `getSuggestedGroups()` with intelligent ranking
  - Scoring based on use count, recency, conversion rate, and pinned status

### 3. Scoring Algorithm
```dart
double _scoreGroup({
  required int useCount,           // Weight: 0.4
  required Duration sinceLastUse,  // Weight: 0.25
  required double convRate,        // Weight: 0.25
  required bool pinned,            // Bonus: +0.1
});
```

**Recency Normalization:**
- 0 days: 1.0
- 7 days: 0.6
- 30 days: 0.2
- 90 days: 0.05
- 365+ days: 0.01

### 4. UI Components
- **`GroupSuggestionsBar`**: Horizontal chips showing top 5 suggested groups
- **`SavedGroupsBar`**: Horizontal chips showing saved groups with "View all" button
- **`SavedGroupChip`**: Individual chip for saved group display

### 5. Riverpod Providers
- `savedGroupsProvider`: User's saved groups
- `suggestedGroupsProvider`: Smart suggestions
- `touchGroupProvider`: Update usage statistics
- `logUsageEventProvider`: Analytics tracking

### 6. Integration Points
- **Meeting Creation Flow**: Suggestions and saved groups appear in Step 1
- **Analytics**: Usage events logged for scoring algorithm
- **UX Feedback**: Toast messages and SnackBars for user actions

## Firestore Collections

### `/users/{uid}/saved_groups/{groupId}`
```json
{
  "pinned": true,
  "alias": "Family Group",
  "lastUsedAt": "2024-01-15T10:30:00Z",
  "useCount": 5
}
```

### `/analytics_group_usage/{autoId}`
```json
{
  "userId": "user123",
  "groupId": "group456",
  "event": "created_with_group",
  "source": "suggestions_bar",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

## Usage Examples

### Adding a Group to Saved Groups
```dart
final success = await ref.read(saveGroupProvider((
  userId: 'user123',
  groupId: 'group456',
)));
```

### Getting Smart Suggestions
```dart
final suggestions = await ref.read(suggestedGroupsProvider('user123'));
```

### Logging Usage Event
```dart
await ref.read(logUsageEventProvider((
  userId: 'user123',
  groupId: 'group456',
  event: GroupUsageEvent.createdWithGroup,
  source: 'suggestions_bar',
)));
```

## Next Steps
1. **Phase 6**: Group Admin Tools (admin management, voting, audit logs)
2. **Enhanced Analytics**: More detailed conversion tracking
3. **Advanced Scoring**: Machine learning-based suggestions
4. **Bulk Operations**: Batch save/unsave groups
5. **Export/Import**: Group data portability

## Testing
- Unit tests for scoring algorithm
- Widget tests for UI components
- Integration tests for provider interactions
- Performance tests for large group sets
