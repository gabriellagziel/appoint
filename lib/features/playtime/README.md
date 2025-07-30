# Playtime Feature

## Overview
The Playtime feature provides a comprehensive system for managing virtual and live play sessions for children. It includes game management, session scheduling, background customization, and real-time chat functionality.

## Architecture

### Models
- **PlaytimeGame**: Represents a game that can be played in sessions
- **PlaytimeSession**: Represents a scheduled play session with participants
- **PlaytimeBackground**: Represents customizable backgrounds for virtual sessions
- **PlaytimeChat**: Represents chat messages within a session

### Providers
The feature uses Riverpod for state management with the following key providers:

- `allGamesProvider`: Stream of all available games
- `allSessionsProvider`: Stream of all play sessions
- `allBackgroundsProvider`: Stream of all available backgrounds
- `playtimeServiceProvider`: Service for Playtime operations

### Services
- **PlaytimeService**: Handles all Firebase operations for Playtime data
- **PlaytimeAdminNotifier**: Static methods for admin operations (approve, reject, delete)

## Features

### Game Management
- Create, update, and delete games
- Admin approval system for games
- Status tracking (pending, approved, rejected)

### Session Management
- Schedule virtual and live play sessions
- Participant management
- Real-time session updates

### Background System
- Upload and manage custom backgrounds
- Admin approval for backgrounds
- Category and tag organization

### Chat System
- Real-time messaging within sessions
- Message history and persistence

## Usage

### Basic Provider Usage
```dart
// Watch all games
final games = ref.watch(allGamesProvider);

// Watch all sessions
final sessions = ref.watch(allSessionsProvider);

// Watch all backgrounds
final backgrounds = ref.watch(allBackgroundsProvider);
```

### Admin Operations
```dart
// Approve a game
await PlaytimeAdminNotifier.approveGame(gameId);

// Reject a game
await PlaytimeAdminNotifier.rejectGame(gameId);

// Delete a game
await PlaytimeAdminNotifier.deleteGame(gameId);
```

## Firestore Collections

### playtime_games
- `id`: String (document ID)
- `name`: String
- `createdBy`: String (user ID)
- `status`: String (pending/approved/rejected)
- `createdAt`: DateTime

### playtime_sessions
- `id`: String (document ID)
- `gameId`: String
- `participants`: List<String> (user IDs)
- `scheduledTime`: DateTime
- `mode`: String (virtual/live)
- `backgroundId`: String

### playtime_backgrounds
- `id`: String (document ID)
- `imageUrl`: String
- `createdBy`: String (user ID)

### playtime_chats
- `id`: String (document ID)
- `sessionId`: String
- `messages`: List<ChatMessage>

## Security Rules
- Games and backgrounds: Read access for all, write access for admins only
- Sessions: Read/write access for authenticated users
- Chats: Read/write access for session participants

## Testing
Run the Playtime tests with:
```bash
flutter test test/playtime/playtime_provider_test.dart
```

## Dependencies
- flutter_riverpod: State management
- cloud_firestore: Database operations
- firebase_auth: Authentication
- freezed: Model generation 