# Meeting Page System - Architecture & Documentation

## Overview

The Meeting Page system provides real-time collaboration features for App-Oint meetings, including participant management, chat, checklists, and role-based permissions.

## Architecture

### Core Components

#### 1. Meeting Service (`lib/features/meeting/services/meeting_service.dart`)
- **Firestore Integration**: Handles all database operations
- **Real-time Streams**: Provides live updates for meeting data
- **Subcollections**: Manages participants, chat, checklist, and roles

#### 2. Meeting Controller (`lib/features/meeting/controllers/meeting_controller.dart`)
- **State Management**: Uses Riverpod for reactive state
- **Business Logic**: Handles user actions and data transformations
- **Real-time Listeners**: Connects UI to Firestore streams

#### 3. Meeting Details Screen (`lib/features/meeting/screens/meeting_details_screen.dart`)
- **Main UI**: Responsive layout for desktop/mobile
- **Auth Integration**: Redirects guests to public page
- **Widget Composition**: Integrates all meeting components

### Widget Components

#### Meeting Header (`lib/features/meeting/widgets/meeting_header.dart`)
- **Title & Time**: Displays meeting information
- **Go/Join Actions**: OSM navigation and URL launching
- **Responsive Design**: Adapts to screen size

#### Participant List (`lib/features/meeting/widgets/participant_list.dart`)
- **Status Indicators**: Shows RSVP status and arrival
- **Late Indicators**: Orange icons with reasons
- **Real-time Updates**: Live participant status changes

#### Meeting Actions Bar (`lib/features/meeting/widgets/meeting_actions_bar.dart`)
- **RSVP Actions**: Accept/Decline buttons
- **Status Updates**: "I've Arrived" and "I'm Late"
- **Auth Integration**: Uses real userId from Auth

#### Meeting Chat (`lib/features/meeting/widgets/meeting_chat.dart`)
- **Real-time Messages**: Live chat with participants
- **Message Validation**: Prevents empty/long messages
- **Public Access**: Respects publicReadChat toggle

#### Meeting Checklist (`lib/features/meeting/widgets/meeting_checklist.dart`)
- **Add/Remove Items**: Full CRUD operations
- **Toggle Status**: Check/uncheck items
- **Real-time Sync**: Live updates across clients

## Data Structure

### Firestore Collections

```
meetings/{meetingId}
├── participants/{userId}
│   ├── status: "accepted" | "declined" | "pending"
│   ├── arrived: boolean
│   ├── isLate: boolean
│   └── lateReason: string
├── chat/{messageId}
│   ├── text: string
│   ├── senderId: string
│   └── createdAt: timestamp
├── checklist/{itemId}
│   ├── label: string
│   ├── done: boolean
│   └── updatedAt: timestamp
└── roles/{userId}
    ├── role: "host" | "cohost" | "editor"
    └── assignedAt: timestamp
```

### Meeting Document Fields

```dart
{
  title: string,
  startsAt: timestamp,
  isVirtual: boolean,
  virtualUrl: string?,
  lat: number?,
  lng: number?,
  location: string?,
  public: boolean,
  publicReadChat: boolean,
  hostId: string
}
```

## Security Rules

### Access Control

1. **Meeting Access**:
   - Participants: Full read/write access
   - Public meetings: Read-only access
   - Host: Full management permissions

2. **Chat Access**:
   - Participants: Read/write access
   - Public with `publicReadChat: true`: Read-only access
   - Message validation: Max 2000 characters

3. **Checklist Access**:
   - Participants: Toggle items
   - Host/Cohost: Add/remove items
   - Public meetings: Read-only access

4. **Role Management**:
   - Host: Assign/remove roles
   - Cohost: Manage chat and checklist
   - Editor: Limited management permissions

## Real-time Features

### Live Updates

1. **RSVP Changes**: Instant status updates
2. **Arrival Status**: Real-time arrival indicators
3. **Chat Messages**: Live message delivery
4. **Checklist Items**: Instant toggle sync
5. **Role Changes**: Immediate permission updates

### Stream Listeners

```dart
// Meeting data
svc.watchMeeting(meetingId).listen((m) => state = state.copyWith(meeting: m));

// Participants
svc.watchParticipants(meetingId).listen((p) => state = state.copyWith(participants: p));

// Chat messages
svc.watchChat(meetingId).listen((c) => state = state.copyWith(chat: c));

// Checklist items
svc.watchChecklist(meetingId).listen((list) => updateChecklist(list));
```

## Navigation & Links

### Go/Join Actions

1. **Virtual Meetings**: Opens URL in external browser
2. **Physical Meetings**: Opens OSM map with location
3. **Fallback Handling**: Graceful error handling

### Guest Redirect

- **Unauthenticated Users**: Redirected to public page
- **Public Access**: Read-only meeting view
- **Auth Required**: Full feature access

## Responsive Design

### Desktop Layout
- **Side-by-side**: Chat and checklist panels
- **Full-width**: Header and actions
- **Multi-column**: Participant grid

### Mobile Layout
- **Stacked**: Vertical component arrangement
- **Touch-friendly**: Large buttons and spacing
- **Optimized**: Reduced information density

## Error Handling

### Network Issues
- **Offline Support**: Graceful degradation
- **Retry Logic**: Automatic reconnection
- **User Feedback**: Clear error messages

### Validation
- **Message Length**: Max 2000 characters
- **Required Fields**: Proper form validation
- **Permission Checks**: Role-based access control

## Performance Optimizations

### Firestore Queries
- **Indexed Fields**: Optimized for common queries
- **Pagination**: Efficient large dataset handling
- **Caching**: Local state management

### UI Performance
- **Lazy Loading**: Components load on demand
- **Virtual Scrolling**: Large list optimization
- **Debounced Updates**: Prevent excessive re-renders

## Testing Strategy

### Widget Tests
- **RSVP Updates**: Real-time status changes
- **Chat Delivery**: Message appearance
- **Checklist Sync**: Item toggle behavior
- **Guest Redirect**: Authentication flow

### Integration Tests
- **Firebase Emulator**: Local testing environment
- **Real-time Sync**: Multi-client scenarios
- **Permission Tests**: Role-based access

## Deployment Checklist

### Production Readiness
- [ ] All tests passing
- [ ] Firestore rules deployed
- [ ] Indexes created
- [ ] Performance validated
- [ ] Security reviewed

### Monitoring
- [ ] Error tracking configured
- [ ] Performance metrics
- [ ] Usage analytics
- [ ] Real-time monitoring

## Future Enhancements

### Planned Features
1. **Typing Indicators**: Show when users are typing
2. **File Sharing**: Document upload support
3. **Meeting Recording**: Audio/video capture
4. **Advanced Roles**: More granular permissions
5. **Mobile Push**: Real-time notifications

### Technical Improvements
1. **Offline Support**: Enhanced offline capabilities
2. **Performance**: Further optimization
3. **Accessibility**: WCAG compliance
4. **Internationalization**: Multi-language support


