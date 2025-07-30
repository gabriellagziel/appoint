# Family Management System

This module provides comprehensive Minor-Parent Relationship Management functionality for the appointment booking app.

## Overview

The family management system allows parents to:

- Invite children to their family account
- Manage permissions and access levels
- Handle privacy requests from children
- Grant/revoke consent for family relationships

Children can:

- Accept family invitations
- Request private sessions
- Manage their privacy settings

## Architecture

### Data Models

- **FamilyLink**: Represents the relationship between a parent and child
- **Permission**: Defines access levels for different categories (profile, activity, messages, etc.)
- **PrivacyRequest**: Handles child requests for private sessions

### Services

- **FamilyService**: API client for family management operations
- **FamilyBackgroundService**: Handles daily age transitions and cleanup tasks

### Providers

- **familyServiceProvider**: Provides FamilyService instance
- **familyLinksProvider**: Manages family relationship data
- **permissionsProvider**: Handles permission data for specific family links
- **privacyRequestsProvider**: Manages privacy request data

### UI Components

- **FamilyDashboardScreen**: Main dashboard for family management
- **InvitationModal**: Modal for inviting children
- **PermissionsScreen**: Screen for managing permissions
- **ConsentControls**: Widget for consent management
- **PrivacyRequestWidget**: Widget for privacy requests

## Features

### 1. Family Invitations

- Parents can invite children via email
- Children receive invitations and can accept/decline
- Multi-parent consent system

### 2. Permission Management

- Granular permission control (none, read, write)
- Categories: profile, activity, messages, payments, bookings
- Real-time permission updates

### 3. Privacy Requests

- Children can request private sessions
- Parents receive notifications and can approve/deny
- Automatic cleanup of expired requests

### 4. Consent Management

- Multi-parent consent tracking
- Consent history and audit trail
- Age-appropriate consent requirements

### 5. Background Processing

- Daily age transition checks
- Automatic cleanup of expired requests
- Family link validation

## Usage

### Adding Family Management to Your App

1. **Initialize the background service** in your main.dart:

```dart
void main() {
  runApp(MyApp());
  FamilyBackgroundService.instance.start();
}
```

2. **Navigate to family dashboard**:

```dart
Navigator.of(context).pushNamed('/dashboard/family');
```

3. **Show invitation modal**:

```dart
Navigator.of(context).pushNamed('/family/invite');
```

### API Integration

The system is designed to work with a REST API. Update the `_base` URL in `FamilyService` to point to your API endpoint.

### Customization

- Modify permission categories in `Permission` model
- Adjust consent requirements in `ConsentControls`
- Customize age transition logic in `FamilyBackgroundService`

## Security Considerations

- All API calls should use proper authentication
- Implement proper validation for parent-child relationships
- Consider COPPA compliance for children under 13
- Audit all consent and permission changes

## Next Steps

1. **Wire up InvitationModal** to FamilyService.inviteChild via provider
2. **Build SharedFeed and ChildReminderPanel** UI components
3. **Implement multi-parent consent logic** in ConsentControls widget
4. **Add daily age-transition handler** in background service
5. **Integrate with authentication system** to get real user IDs
6. **Add push notifications** for privacy requests and consent updates
7. **Implement data persistence** for offline functionality

## Testing

Use the provided test files to verify functionality:

- `test/features/family/family_management_test.dart`
- `test/services/family_service_test.dart`

## Dependencies

- `flutter_riverpod`: State management
- `http`: API communication
- `freezed`: Data class generation (optional) 