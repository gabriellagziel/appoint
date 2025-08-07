# Meeting vs Event System Documentation

## Overview

App-Oint implements a sophisticated meeting classification system that automatically determines whether a gathering is a "Personal Meeting" or an "Event" based on participant count. This system enforces different feature sets and capabilities based on the meeting type.

## Business Rules

### Meeting Type Determination

The system automatically classifies meetings based on **total participant count** (including the organizer):

- **Personal Meeting**: Up to 3 participants (inclusive)
  - 1 organizer + 1-2 participants = Personal Meeting
- **Event**: 4 or more participants
  - 1 organizer + 3+ participants = Event

### Feature Availability

#### Personal Meetings (≤3 participants)
- Basic meeting scheduling
- Video/audio calls
- Location setting (physical and virtual)
- Simple participant management
- Meeting notes
- Basic notifications

#### Events (≥4 participants)
**All Personal Meeting features PLUS:**
- **Custom Registration Forms**: Collect additional information from attendees
- **Event Checklists**: Organize preparation tasks with assignments and due dates
- **Group Chat**: Dedicated chat channel for all participants
- **Advanced Admin Roles**: Assign admin permissions to participants
- **Event Settings**: Advanced configuration options
- **Enhanced Analytics**: Detailed reporting on event metrics

## Architecture

### Models

#### `Meeting` Model
Located in `lib/models/meeting.dart`

Key fields:
- `id`: Unique identifier
- `organizerId`: User who created the meeting
- `title`, `description`: Basic information
- `startTime`, `endTime`: Scheduling
- `participants`: List of `MeetingParticipant` objects
- `customFormId`, `checklistId`, `groupChatId`: Event-specific feature references

Key methods:
- `meetingType`: Returns `MeetingType.personal` or `MeetingType.event`
- `isEvent`, `isPersonalMeeting`: Boolean checks
- `canAccessEventFeatures(userId)`: Permission check for event features
- `validateMeetingCreation()`: Business rule validation

#### `MeetingParticipant` Model
- `userId`, `name`, `email`: Basic participant info
- `role`: `organizer`, `admin`, or `participant`
- `hasResponded`, `willAttend`: RSVP tracking

#### Event Feature Models
Located in `lib/models/event_features.dart`

- `EventCustomForm`: Form builder with various field types
- `EventChecklist`: Task management with status tracking
- `EventSettings`: Advanced configuration options

### Services

#### `MeetingService`
Located in `lib/services/meeting_service.dart`

Key methods:
- `createMeeting()`: Creates meeting with automatic type determination
- `addParticipants()`: Adds participants and handles type transitions
- `removeParticipants()`: Removes participants and handles type transitions
- `createEventForm()`: Creates custom forms (event-only)
- `createEventChecklist()`: Creates checklists (event-only)
- `enableEventGroupChat()`: Enables group chat (event-only)

### Backend (Firebase Functions)

#### `meetings.ts`
Located in `functions/src/meetings.ts`

Key functions:
- `onMeetingWrite`: Firestore trigger for validation and type changes
- `validateMeetingCreation`: HTTP function for frontend validation
- `checkEventFeatureAccess`: Permission validation for event features
- `getMeetingAnalytics`: Analytics data for meetings vs events
- `createEventForm`: Backend validation for form creation
- `cleanupExpiredMeetings`: Scheduled cleanup of old meetings

### UI Components

#### `CreateMeetingScreen`
Located in `lib/features/meetings/screens/create_meeting_screen.dart`

Features:
- **Dynamic Type Indicator**: Shows current meeting type based on participant count
- **Real-time Feature Visibility**: Event-specific features only appear for events
- **Participant Management**: Add/remove participants with role assignment
- **Validation**: Enforces business rules before creation

## Type Transition Behavior

### Personal Meeting → Event (Crossing 4 Participant Threshold)

When participants are added and the total reaches 4:
1. Meeting type automatically changes to Event
2. Event features become available
3. Default event settings are initialized
4. Group chat can be enabled
5. Forms and checklists become accessible

### Event → Personal Meeting (Dropping Below 4 Participants)

When participants are removed and the total drops below 4:
1. Meeting type automatically changes to Personal Meeting
2. Event-specific features are disabled/hidden
3. Associated event resources are cleaned up:
   - Custom forms are deleted
   - Checklists are removed
   - Group chat is disabled
   - Event settings are cleared

## Permission System

### Roles

1. **Organizer**: Creator of the meeting
   - Full control over meeting
   - Can access all event features
   - Can assign admin roles

2. **Admin**: Participant with elevated permissions (Events only)
   - Can access event features
   - Can manage forms and checklists
   - Cannot delete the meeting

3. **Participant**: Regular attendee
   - Can view meeting details
   - Can respond to invitations
   - Cannot access event management features

### Event Feature Access

Event-specific features (forms, checklists, group chat) are only accessible to:
- Meeting organizer
- Participants with admin role
- Only when the meeting is classified as an Event (≥4 participants)

## Analytics and Reporting

### Meeting Type Metrics

The system tracks:
- Total meetings vs events created
- Average participant count by type
- Event feature usage rates
- Type transitions (personal→event, event→personal)

### Analytics Functions

- `getMeetingAnalytics()`: Returns comprehensive metrics
- Backend tracking via Firestore triggers
- Real-time dashboard updates

## Implementation Guidelines

### Adding New Event-Only Features

1. **Check Meeting Type**: Always verify `meeting.isEvent` before showing features
2. **Validate Permissions**: Use `meeting.canAccessEventFeatures(userId)`
3. **Backend Validation**: Implement corresponding server-side checks
4. **Cleanup Handling**: Add cleanup logic for type transitions

### Example Implementation

```dart
// UI Feature Visibility
if (meeting.isEvent && meeting.canAccessEventFeatures(currentUserId)) {
  // Show event-specific feature
}

// Service Method
Future<void> createEventFeature(String meetingId, String userId) async {
  final meeting = await getMeeting(meetingId);
  if (!meeting.isEvent) {
    throw Exception('Feature only available for events');
  }
  if (!meeting.canAccessEventFeatures(userId)) {
    throw Exception('Insufficient permissions');
  }
  // Proceed with feature creation
}
```

## Testing

### Test Coverage

Located in `test/models/meeting_test.dart`

Test categories:
- **Type Determination**: Verifies 3→4 participant threshold
- **Edge Cases**: Tests exact boundary conditions
- **Validation**: Ensures business rules are enforced
- **Permissions**: Validates access control
- **Serialization**: Tests data persistence
- **Feature Availability**: Confirms event-only restrictions

### Running Tests

```bash
flutter test test/models/meeting_test.dart
```

## Database Schema

### Firestore Collections

#### `meetings`
```json
{
  "id": "string",
  "organizerId": "string",
  "title": "string", 
  "description": "string?",
  "startTime": "timestamp",
  "endTime": "timestamp",
  "location": "string?",
  "virtualMeetingUrl": "string?",
  "participants": [
    {
      "userId": "string",
      "name": "string",
      "email": "string?",
      "role": "participant|admin|organizer",
      "hasResponded": "boolean",
      "willAttend": "boolean"
    }
  ],
  "status": "draft|scheduled|active|completed|cancelled",
  "customFormId": "string?",    // Event-only
  "checklistId": "string?",     // Event-only  
  "groupChatId": "string?",     // Event-only
  "eventSettings": "object?",   // Event-only
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### `eventForms` (Event-only)
```json
{
  "id": "string",
  "meetingId": "string",
  "title": "string",
  "fields": [...],
  "isActive": "boolean",
  "createdBy": "string"
}
```

#### `eventChecklists` (Event-only)
```json
{
  "id": "string", 
  "meetingId": "string",
  "title": "string",
  "items": [...],
  "createdBy": "string"
}
```

## Migration Strategy

### Existing Data

For existing appointments/meetings in the system:
1. **Data Migration**: Convert existing appointments to Meeting model
2. **Type Assignment**: Analyze participant count and assign appropriate type
3. **Feature Cleanup**: Remove any event features from personal meetings
4. **Validation**: Ensure all meetings comply with new business rules

### Backward Compatibility

The system maintains compatibility with existing appointment models through:
- Service layer abstraction
- Gradual migration approach
- Fallback handling for legacy data

## Security Considerations

### Access Control

- **Server-side Validation**: All business rules enforced in Firebase Functions
- **Permission Checks**: Event features require explicit permission validation
- **Data Isolation**: Event-specific data is properly scoped to authorized users

### Privacy

- **Participant Data**: Only accessible to meeting organizers and admins
- **Event Features**: Restricted based on meeting type and user permissions
- **Analytics**: Aggregated data only, no individual meeting details exposed

## Performance Considerations

### Optimization Strategies

- **Type Caching**: Meeting type is computed once and cached
- **Lazy Loading**: Event features loaded only when needed
- **Batch Operations**: Participant changes processed in batches
- **Cleanup Jobs**: Scheduled cleanup of expired meetings and associated data

### Scalability

- **Horizontal Scaling**: Firebase Functions auto-scale with demand
- **Data Partitioning**: Meetings partitioned by organization/user
- **Index Optimization**: Proper Firestore indexes for query performance

## Monitoring and Maintenance

### Health Checks

- Meeting type consistency validation
- Event feature orphan detection  
- Permission integrity checks
- Data migration status monitoring

### Scheduled Maintenance

- Expired meeting cleanup (daily)
- Analytics data aggregation (hourly)
- Permission audit (weekly)
- System health reports (daily)

## Future Enhancements

### Planned Features

1. **Hybrid Meetings**: Support for meetings that can transition between types during the event
2. **Custom Thresholds**: Allow organizations to configure the 4-participant threshold
3. **Advanced Roles**: Additional permission levels beyond organizer/admin/participant
4. **Integration APIs**: External calendar and meeting platform integration
5. **AI Features**: Smart participant suggestions and meeting type recommendations

### Extensibility

The system is designed for easy extension:
- Plugin architecture for event features
- Configurable business rules
- Modular UI components
- Extensible permission system