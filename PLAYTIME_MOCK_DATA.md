# Playtime Mock Data & Seed Scripts

## Overview
This document provides mock data and seed scripts for testing and development of the Playtime feature.

## Mock Data Collections

### 1. System Games (playtime_games)

```json
[
  {
    "gameId": "minecraft_adventure",
    "name": "Minecraft Adventure",
    "description": "Build and explore together in a safe Minecraft world",
    "icon": "🎮",
    "category": "creative",
    "ageRange": {
      "min": 8,
      "max": 16
    },
    "type": "virtual",
    "maxParticipants": 6,
    "estimatedDuration": 120,
    "isSystemGame": true,
    "isPublic": true,
    "creatorId": "system",
    "parentApprovalRequired": true,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z",
    "isActive": true,
    "tags": ["building", "exploration", "creative"],
    "safetyLevel": "safe",
    "usageCount": 45,
    "averageRating": 4.8,
    "totalRatings": 23
  },
  {
    "gameId": "outdoor_scavenger_hunt",
    "name": "Outdoor Scavenger Hunt",
    "description": "Find hidden treasures in your local park",
    "icon": "🏃",
    "category": "physical",
    "ageRange": {
      "min": 6,
      "max": 14
    },
    "type": "live",
    "maxParticipants": 8,
    "estimatedDuration": 60,
    "isSystemGame": true,
    "isPublic": true,
    "creatorId": "system",
    "parentApprovalRequired": true,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z",
    "isActive": true,
    "tags": ["outdoor", "exercise", "exploration"],
    "safetyLevel": "safe",
    "usageCount": 32,
    "averageRating": 4.9,
    "totalRatings": 18
  },
  {
    "gameId": "art_craft_session",
    "name": "Art & Craft Session",
    "description": "Create beautiful artwork together",
    "icon": "🎨",
    "category": "creative",
    "ageRange": {
      "min": 5,
      "max": 12
    },
    "type": "both",
    "maxParticipants": 4,
    "estimatedDuration": 90,
    "isSystemGame": true,
    "isPublic": true,
    "creatorId": "system",
    "parentApprovalRequired": true,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z",
    "isActive": true,
    "tags": ["art", "creative", "crafts"],
    "safetyLevel": "safe",
    "usageCount": 28,
    "averageRating": 4.7,
    "totalRatings": 15
  },
  {
    "gameId": "math_puzzle_challenge",
    "name": "Math Puzzle Challenge",
    "description": "Solve fun math puzzles together",
    "icon": "🧩",
    "category": "educational",
    "ageRange": {
      "min": 7,
      "max": 13
    },
    "type": "virtual",
    "maxParticipants": 6,
    "estimatedDuration": 45,
    "isSystemGame": true,
    "isPublic": true,
    "creatorId": "system",
    "parentApprovalRequired": false,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z",
    "isActive": true,
    "tags": ["math", "puzzles", "educational"],
    "safetyLevel": "safe",
    "usageCount": 67,
    "averageRating": 4.6,
    "totalRatings": 34
  }
]
```

### 2. System Backgrounds (playtime_backgrounds)

```json
[
  {
    "backgroundId": "park_scene",
    "name": "Park Scene",
    "description": "Beautiful park with trees and playground",
    "imageUrl": "https://storage.googleapis.com/playtime-backgrounds/park_scene.jpg",
    "thumbnailUrl": "https://storage.googleapis.com/playtime-backgrounds/park_scene_thumb.jpg",
    "uploadedBy": "system",
    "uploadedByDisplayName": "System",
    "category": "outdoor",
    "tags": ["park", "nature", "playground"],
    "status": "approved",
    "approvalStatus": {
      "reviewedBy": "admin",
      "reviewedAt": "2024-01-01T00:00:00Z"
    },
    "usageCount": 156,
    "isSystemBackground": true,
    "isActive": true,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z",
    "fileSize": 2048576,
    "dimensions": {
      "width": 1920,
      "height": 1080
    },
    "safetyLevel": "safe",
    "ageAppropriate": {
      "minAge": 3,
      "maxAge": 18
    }
  },
  {
    "backgroundId": "art_room",
    "name": "Art Room",
    "description": "Creative art studio with supplies",
    "imageUrl": "https://storage.googleapis.com/playtime-backgrounds/art_room.jpg",
    "thumbnailUrl": "https://storage.googleapis.com/playtime-backgrounds/art_room_thumb.jpg",
    "uploadedBy": "system",
    "uploadedByDisplayName": "System",
    "category": "indoor",
    "tags": ["art", "creative", "studio"],
    "status": "approved",
    "approvalStatus": {
      "reviewedBy": "admin",
      "reviewedAt": "2024-01-01T00:00:00Z"
    },
    "usageCount": 89,
    "isSystemBackground": true,
    "isActive": true,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z",
    "fileSize": 1876543,
    "dimensions": {
      "width": 1920,
      "height": 1080
    },
    "safetyLevel": "safe",
    "ageAppropriate": {
      "minAge": 4,
      "maxAge": 16
    }
  },
  {
    "backgroundId": "space_adventure",
    "name": "Space Adventure",
    "description": "Exciting space scene with planets and stars",
    "imageUrl": "https://storage.googleapis.com/playtime-backgrounds/space_adventure.jpg",
    "thumbnailUrl": "https://storage.googleapis.com/playtime-backgrounds/space_adventure_thumb.jpg",
    "uploadedBy": "system",
    "uploadedByDisplayName": "System",
    "category": "creative",
    "tags": ["space", "planets", "stars"],
    "status": "approved",
    "approvalStatus": {
      "reviewedBy": "admin",
      "reviewedAt": "2024-01-01T00:00:00Z"
    },
    "usageCount": 234,
    "isSystemBackground": true,
    "isActive": true,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z",
    "fileSize": 2154321,
    "dimensions": {
      "width": 1920,
      "height": 1080
    },
    "safetyLevel": "safe",
    "ageAppropriate": {
      "minAge": 5,
      "maxAge": 18
    }
  }
]
```

### 3. Sample Sessions (playtime_sessions)

```json
[
  {
    "sessionId": "session_001",
    "gameId": "minecraft_adventure",
    "type": "virtual",
    "title": "Minecraft Castle Building",
    "description": "Let's build an amazing castle together!",
    "creatorId": "child_user_001",
    "participants": [
      {
        "userId": "child_user_001",
        "displayName": "Emma",
        "photoUrl": "https://example.com/emma.jpg",
        "role": "creator",
        "joinedAt": "2024-03-15T14:00:00Z",
        "status": "joined"
      },
      {
        "userId": "child_user_002",
        "displayName": "Tom",
        "photoUrl": "https://example.com/tom.jpg",
        "role": "participant",
        "joinedAt": "2024-03-15T14:05:00Z",
        "status": "joined"
      }
    ],
    "invitedUsers": ["child_user_003"],
    "scheduledFor": null,
    "duration": 120,
    "location": null,
    "backgroundId": null,
    "status": "active",
    "parentApprovalStatus": {
      "required": true,
      "approvedBy": ["parent_user_001"],
      "declinedBy": [],
      "approvedAt": "2024-03-15T13:45:00Z"
    },
    "adminApprovalStatus": {
      "required": false,
      "approvedBy": null,
      "approvedAt": null
    },
    "safetyFlags": {
      "reportedContent": false,
      "moderationRequired": false,
      "autoPaused": false
    },
    "createdAt": "2024-03-15T13:30:00Z",
    "updatedAt": "2024-03-15T14:00:00Z",
    "startedAt": "2024-03-15T14:00:00Z",
    "endedAt": null,
    "chatEnabled": true,
    "maxParticipants": 6,
    "currentParticipants": 2
  },
  {
    "sessionId": "session_002",
    "gameId": "outdoor_scavenger_hunt",
    "type": "live",
    "title": "Park Treasure Hunt",
    "description": "Find hidden treasures in Central Park",
    "creatorId": "child_user_004",
    "participants": [
      {
        "userId": "child_user_004",
        "displayName": "Sara",
        "photoUrl": "https://example.com/sara.jpg",
        "role": "creator",
        "joinedAt": "2024-03-16T10:00:00Z",
        "status": "joined"
      }
    ],
    "invitedUsers": ["child_user_005", "child_user_006"],
    "scheduledFor": "2024-03-16T10:00:00Z",
    "duration": 60,
    "location": {
      "name": "Central Park",
      "address": "Central Park, New York, NY",
      "coordinates": {
        "latitude": 40.7829,
        "longitude": -73.9654
      }
    },
    "backgroundId": "park_scene",
    "status": "pending_approval",
    "parentApprovalStatus": {
      "required": true,
      "approvedBy": [],
      "declinedBy": [],
      "approvedAt": null
    },
    "adminApprovalStatus": {
      "required": false,
      "approvedBy": null,
      "approvedAt": null
    },
    "safetyFlags": {
      "reportedContent": false,
      "moderationRequired": false,
      "autoPaused": false
    },
    "createdAt": "2024-03-15T16:00:00Z",
    "updatedAt": "2024-03-15T16:00:00Z",
    "startedAt": null,
    "endedAt": null,
    "chatEnabled": false,
    "maxParticipants": 8,
    "currentParticipants": 1
  }
]
```

### 4. Sample Chat Messages (playtime_chats)

```json
[
  {
    "chatId": "chat_001",
    "sessionId": "session_001",
    "messageId": "msg_001",
    "senderId": "child_user_001",
    "senderDisplayName": "Emma",
    "senderPhotoUrl": "https://example.com/emma.jpg",
    "message": "Hi everyone! Ready to build a castle?",
    "messageType": "text",
    "timestamp": "2024-03-15T14:00:30Z",
    "isEdited": false,
    "editedAt": null,
    "moderationStatus": {
      "isFlagged": false,
      "flaggedBy": [],
      "flaggedAt": null,
      "reviewedBy": null,
      "reviewedAt": null,
      "action": null
    },
    "reactions": {},
    "replyTo": null,
    "isDeleted": false,
    "deletedAt": null,
    "deletedBy": null
  },
  {
    "chatId": "chat_002",
    "sessionId": "session_001",
    "messageId": "msg_002",
    "senderId": "child_user_002",
    "senderDisplayName": "Tom",
    "senderPhotoUrl": "https://example.com/tom.jpg",
    "message": "Yes! I love building castles!",
    "messageType": "text",
    "timestamp": "2024-03-15T14:01:15Z",
    "isEdited": false,
    "editedAt": null,
    "moderationStatus": {
      "isFlagged": false,
      "flaggedBy": [],
      "flaggedAt": null,
      "reviewedBy": null,
      "reviewedAt": null,
      "action": null
    },
    "reactions": {},
    "replyTo": "msg_001",
    "isDeleted": false,
    "deletedAt": null,
    "deletedBy": null
  }
]
```

### 5. Extended User Profiles

```json
[
  {
    "uid": "child_user_001",
    "displayName": "Emma",
    "email": "emma@example.com",
    "photoUrl": "https://example.com/emma.jpg",
    "playtimeSettings": {
      "isChild": true,
      "parentUid": "parent_user_001",
      "approvedPlaytimeSessions": ["session_001"],
      "playtimePreferences": {
        "favoriteGames": ["minecraft_adventure", "art_craft_session"],
        "preferredCategories": ["creative", "educational"],
        "maxSessionDuration": 120,
        "allowPublicSessions": false,
        "allowFriendInvites": true
      },
      "safetySettings": {
        "chatEnabled": true,
        "autoApproveSessions": false,
        "requireParentApproval": true,
        "blockedUsers": [],
        "restrictedContent": ["violent", "inappropriate"]
      },
      "usageStats": {
        "totalSessions": 12,
        "totalPlaytime": 1440,
        "lastActive": "2024-03-15T14:00:00Z",
        "favoriteBackgrounds": ["park_scene", "art_room"]
      }
    },
    "playtimePermissions": {
      "canCreateSessions": true,
      "canUploadContent": false,
      "canInviteFriends": true,
      "canJoinPublicSessions": false,
      "requiresParentApproval": true
    }
  },
  {
    "uid": "parent_user_001",
    "displayName": "Sarah Johnson",
    "email": "sarah@example.com",
    "photoUrl": "https://example.com/sarah.jpg",
    "playtimeSettings": {
      "isChild": false,
      "parentUid": null,
      "approvedPlaytimeSessions": [],
      "playtimePreferences": {
        "favoriteGames": [],
        "preferredCategories": [],
        "maxSessionDuration": 0,
        "allowPublicSessions": false,
        "allowFriendInvites": false
      },
      "safetySettings": {
        "chatEnabled": false,
        "autoApproveSessions": false,
        "requireParentApproval": false,
        "blockedUsers": [],
        "restrictedContent": []
      },
      "usageStats": {
        "totalSessions": 0,
        "totalPlaytime": 0,
        "lastActive": null,
        "favoriteBackgrounds": []
      }
    },
    "playtimePermissions": {
      "canCreateSessions": false,
      "canUploadContent": false,
      "canInviteFriends": false,
      "canJoinPublicSessions": false,
      "requiresParentApproval": false
    }
  }
]
```

## Seed Scripts

### 1. Firebase CLI Seed Script

```bash
#!/bin/bash

# Seed Playtime Games
echo "Seeding playtime games..."
firebase firestore:set /playtime_games/minecraft_adventure ./mock_data/games/minecraft_adventure.json
firebase firestore:set /playtime_games/outdoor_scavenger_hunt ./mock_data/games/outdoor_scavenger_hunt.json
firebase firestore:set /playtime_games/art_craft_session ./mock_data/games/art_craft_session.json
firebase firestore:set /playtime_games/math_puzzle_challenge ./mock_data/games/math_puzzle_challenge.json

# Seed Playtime Backgrounds
echo "Seeding playtime backgrounds..."
firebase firestore:set /playtime_backgrounds/park_scene ./mock_data/backgrounds/park_scene.json
firebase firestore:set /playtime_backgrounds/art_room ./mock_data/backgrounds/art_room.json
firebase firestore:set /playtime_backgrounds/space_adventure ./mock_data/backgrounds/space_adventure.json

# Seed Sample Sessions
echo "Seeding sample sessions..."
firebase firestore:set /playtime_sessions/session_001 ./mock_data/sessions/session_001.json
firebase firestore:set /playtime_sessions/session_002 ./mock_data/sessions/session_002.json

# Seed Sample Chat Messages
echo "Seeding chat messages..."
firebase firestore:set /playtime_chats/chat_001 ./mock_data/chats/chat_001.json
firebase firestore:set /playtime_chats/chat_002 ./mock_data/chats/chat_002.json

# Update User Profiles
echo "Updating user profiles..."
firebase firestore:set /users/child_user_001 ./mock_data/users/child_user_001.json
firebase firestore:set /users/parent_user_001 ./mock_data/users/parent_user_001.json

echo "Seeding complete!"
```

### 2. Flutter/Dart Seed Script

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PlaytimeSeedData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedAllData() async {
    await seedGames();
    await seedBackgrounds();
    await seedSessions();
    await seedChats();
    await seedUsers();
  }

  static Future<void> seedGames() async {
    final games = [
      {
        'gameId': 'minecraft_adventure',
        'name': 'Minecraft Adventure',
        'description': 'Build and explore together in a safe Minecraft world',
        'icon': '🎮',
        'category': 'creative',
        'ageRange': {'min': 8, 'max': 16},
        'type': 'virtual',
        'maxParticipants': 6,
        'estimatedDuration': 120,
        'isSystemGame': true,
        'isPublic': true,
        'creatorId': 'system',
        'parentApprovalRequired': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'isActive': true,
        'tags': ['building', 'exploration', 'creative'],
        'safetyLevel': 'safe',
        'usageCount': 45,
        'averageRating': 4.8,
        'totalRatings': 23,
      },
      // Add more games...
    ];

    for (final game in games) {
      await _firestore
          .collection('playtime_games')
          .doc(game['gameId'])
          .set(game);
    }
  }

  static Future<void> seedBackgrounds() async {
    final backgrounds = [
      {
        'backgroundId': 'park_scene',
        'name': 'Park Scene',
        'description': 'Beautiful park with trees and playground',
        'imageUrl': 'https://storage.googleapis.com/playtime-backgrounds/park_scene.jpg',
        'thumbnailUrl': 'https://storage.googleapis.com/playtime-backgrounds/park_scene_thumb.jpg',
        'uploadedBy': 'system',
        'uploadedByDisplayName': 'System',
        'category': 'outdoor',
        'tags': ['park', 'nature', 'playground'],
        'status': 'approved',
        'approvalStatus': {
          'reviewedBy': 'admin',
          'reviewedAt': Timestamp.now(),
        },
        'usageCount': 156,
        'isSystemBackground': true,
        'isActive': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'fileSize': 2048576,
        'dimensions': {'width': 1920, 'height': 1080},
        'safetyLevel': 'safe',
        'ageAppropriate': {'minAge': 3, 'maxAge': 18},
      },
      // Add more backgrounds...
    ];

    for (final background in backgrounds) {
      await _firestore
          .collection('playtime_backgrounds')
          .doc(background['backgroundId'])
          .set(background);
    }
  }

  // Add more seed methods for sessions, chats, and users...
}
```

### 3. Node.js Seed Script

```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./service-account-key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function seedPlaytimeData() {
  try {
    // Seed games
    const games = [
      {
        gameId: 'minecraft_adventure',
        name: 'Minecraft Adventure',
        description: 'Build and explore together in a safe Minecraft world',
        icon: '🎮',
        category: 'creative',
        ageRange: { min: 8, max: 16 },
        type: 'virtual',
        maxParticipants: 6,
        estimatedDuration: 120,
        isSystemGame: true,
        isPublic: true,
        creatorId: 'system',
        parentApprovalRequired: true,
        createdAt: admin.firestore.Timestamp.now(),
        updatedAt: admin.firestore.Timestamp.now(),
        isActive: true,
        tags: ['building', 'exploration', 'creative'],
        safetyLevel: 'safe',
        usageCount: 45,
        averageRating: 4.8,
        totalRatings: 23,
      },
      // Add more games...
    ];

    for (const game of games) {
      await db.collection('playtime_games').doc(game.gameId).set(game);
    }

    console.log('Playtime data seeded successfully!');
  } catch (error) {
    console.error('Error seeding data:', error);
  }
}

seedPlaytimeData();
```

## Testing Data

### Test Users
- **Child Users**: child_user_001, child_user_002, child_user_003
- **Parent Users**: parent_user_001, parent_user_002
- **Admin Users**: admin_user_001

### Test Scenarios
1. **Child creates session** → Parent approval required
2. **Child joins public session** → Automatic approval
3. **Child uploads background** → Admin approval required
4. **Parent approves session** → Session becomes active
5. **Admin moderates content** → Content flagged/reviewed

### Performance Test Data
- 1000+ games for pagination testing
- 500+ sessions for filtering testing
- 10000+ chat messages for real-time testing
- 100+ backgrounds for grid testing

## Data Validation

### Required Fields
- All IDs must be unique
- Timestamps must be valid ISO strings
- Arrays must not be null (empty arrays allowed)
- Required boolean flags must be present

### Business Rules
- Children under 13 require parent approval
- Sessions cannot exceed max participants
- Chat messages must be under 500 characters
- Backgrounds must meet size and format requirements

### Security Validation
- Users can only access their own data
- Parents can only access their children's data
- Admins can access all data
- Content moderation flags must be respected 