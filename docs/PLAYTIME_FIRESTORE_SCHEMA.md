# Playtime Firestore Schema Documentation

## Overview
This document defines the complete Firestore schema for the Playtime feature, including collections, document structures, security rules, and data relationships.

## Collections Overview

### 1. `playtime_games` Collection
Stores game definitions and metadata for both system and user-created games.

### 2. `playtime_sessions` Collection
Tracks individual playtime sessions, including virtual and live activities.

### 3. `playtime_backgrounds` Collection
Manages background images for live play sessions with approval workflow.

### 4. `playtime_uploads` Collection
Tracks user uploads awaiting approval (backgrounds, custom content).

### 5. `playtime_chats` Collection
Stores chat messages for virtual play sessions.

### 6. `users` Collection (Extended)
Enhanced user profiles with playtime-specific fields.

## Detailed Schema Definitions

### 1. `playtime_games` Collection

#### Document Structure
```json
{
  "gameId": "string",
  "name": "string",
  "description": "string",
  "icon": "string", // Icon identifier
  "category": "string", // "educational", "creative", "physical", "social"
  "ageRange": {
    "min": "number",
    "max": "number"
  },
  "type": "string", // "virtual", "live", "both"
  "maxParticipants": "number",
  "estimatedDuration": "number", // minutes
  "isSystemGame": "boolean",
  "isPublic": "boolean",
  "creatorId": "string", // User ID who created the game
  "parentApprovalRequired": "boolean",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "isActive": "boolean",
  "tags": ["string"],
  "safetyLevel": "string", // "safe", "moderate", "supervised"
  "usageCount": "number",
  "averageRating": "number",
  "totalRatings": "number"
}
```

#### Indexes
- `category` (ascending)
- `type` (ascending)
- `isPublic` (ascending)
- `isActive` (ascending)
- `creatorId` (ascending)
- `safetyLevel` (ascending)
- `usageCount` (descending)
- `averageRating` (descending)

### 2. `playtime_sessions` Collection

#### Document Structure
```json
{
  "sessionId": "string",
  "gameId": "string",
  "type": "string", // "virtual", "live"
  "title": "string",
  "description": "string",
  "creatorId": "string",
  "participants": [
    {
      "userId": "string",
      "displayName": "string",
      "photoUrl": "string",
      "role": "string", // "creator", "participant"
      "joinedAt": "timestamp",
      "status": "string" // "invited", "joined", "left", "declined"
    }
  ],
  "invitedUsers": ["string"], // User IDs
  "scheduledFor": "timestamp", // null for immediate sessions
  "duration": "number", // minutes
  "location": {
    "name": "string",
    "address": "string",
    "coordinates": {
      "latitude": "number",
      "longitude": "number"
    }
  },
  "backgroundId": "string", // Reference to playtime_backgrounds
  "status": "string", // "pending_approval", "approved", "declined", "active", "completed", "cancelled"
  "parentApprovalStatus": {
    "required": "boolean",
    "approvedBy": ["string"], // Parent UIDs
    "declinedBy": ["string"], // Parent UIDs
    "approvedAt": "timestamp",
    "declinedAt": "timestamp"
  },
  "adminApprovalStatus": {
    "required": "boolean",
    "approvedBy": "string", // Admin UID
    "approvedAt": "timestamp"
  },
  "safetyFlags": {
    "reportedContent": "boolean",
    "moderationRequired": "boolean",
    "autoPaused": "boolean"
  },
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "startedAt": "timestamp",
  "endedAt": "timestamp",
  "chatEnabled": "boolean",
  "maxParticipants": "number",
  "currentParticipants": "number"
}
```

#### Indexes
- `creatorId` (ascending)
- `gameId` (ascending)
- `type` (ascending)
- `status` (ascending)
- `scheduledFor` (ascending)
- `parentApprovalStatus.required` (ascending)
- `adminApprovalStatus.required` (ascending)
- `participants.userId` (array-contains)
- `invitedUsers` (array-contains)

### 3. `playtime_backgrounds` Collection

#### Document Structure
```json
{
  "backgroundId": "string",
  "name": "string",
  "description": "string",
  "imageUrl": "string",
  "thumbnailUrl": "string",
  "uploadedBy": "string", // User ID
  "uploadedByDisplayName": "string",
  "category": "string", // "outdoor", "indoor", "educational", "creative"
  "tags": ["string"],
  "status": "string", // "pending_approval", "approved", "declined", "disabled"
  "approvalStatus": {
    "reviewedBy": "string", // Admin UID
    "reviewedAt": "timestamp",
    "reason": "string" // For declined backgrounds
  },
  "usageCount": "number",
  "isSystemBackground": "boolean",
  "isActive": "boolean",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "fileSize": "number", // bytes
  "dimensions": {
    "width": "number",
    "height": "number"
  },
  "safetyLevel": "string", // "safe", "moderate", "supervised"
  "ageAppropriate": {
    "minAge": "number",
    "maxAge": "number"
  }
}
```

#### Indexes
- `uploadedBy` (ascending)
- `status` (ascending)
- `category` (ascending)
- `isSystemBackground` (ascending)
- `isActive` (ascending)
- `safetyLevel` (ascending)
- `usageCount` (descending)
- `createdAt` (descending)

### 4. `playtime_uploads` Collection

#### Document Structure
```json
{
  "uploadId": "string",
  "uploadedBy": "string", // User ID
  "uploadedByDisplayName": "string",
  "uploadType": "string", // "background", "game_asset", "custom_content"
  "fileName": "string",
  "fileUrl": "string",
  "fileSize": "number", // bytes
  "mimeType": "string",
  "status": "string", // "pending", "approved", "declined", "processing"
  "approvalStatus": {
    "reviewedBy": "string", // Admin UID
    "reviewedAt": "timestamp",
    "reason": "string", // For declined uploads
    "notes": "string"
  },
  "metadata": {
    "title": "string",
    "description": "string",
    "category": "string",
    "tags": ["string"],
    "dimensions": {
      "width": "number",
      "height": "number"
    }
  },
  "safetyCheck": {
    "autoApproved": "boolean",
    "flaggedForReview": "boolean",
    "flags": ["string"] // "inappropriate_content", "copyright", "size_limit"
  },
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "expiresAt": "timestamp" // For temporary uploads
}
```

#### Indexes
- `uploadedBy` (ascending)
- `uploadType` (ascending)
- `status` (ascending)
- `createdAt` (descending)
- `safetyCheck.flaggedForReview` (ascending)

### 5. `playtime_chats` Collection

#### Document Structure
```json
{
  "chatId": "string",
  "sessionId": "string",
  "messageId": "string",
  "senderId": "string",
  "senderDisplayName": "string",
  "senderPhotoUrl": "string",
  "message": "string",
  "messageType": "string", // "text", "system", "join", "leave"
  "timestamp": "timestamp",
  "isEdited": "boolean",
  "editedAt": "timestamp",
  "moderationStatus": {
    "isFlagged": "boolean",
    "flaggedBy": ["string"], // User IDs
    "flaggedAt": "timestamp",
    "reviewedBy": "string", // Admin UID
    "reviewedAt": "timestamp",
    "action": "string" // "warn", "delete", "none"
  },
  "reactions": {
    "userId": "string", // Emoji reaction
  },
  "replyTo": "string", // Message ID being replied to
  "isDeleted": "boolean",
  "deletedAt": "timestamp",
  "deletedBy": "string" // User ID who deleted
}
```

#### Indexes
- `sessionId` (ascending)
- `senderId` (ascending)
- `timestamp` (descending)
- `moderationStatus.isFlagged` (ascending)
- `messageType` (ascending)

### 6. Extended `users` Collection

#### Additional Fields for UserProfile
```json
{
  // ... existing fields ...
  "playtimeSettings": {
    "isChild": "boolean",
    "parentUid": "string", // null for parents
    "approvedPlaytimeSessions": ["string"], // Session IDs
    "playtimePreferences": {
      "favoriteGames": ["string"], // Game IDs
      "preferredCategories": ["string"],
      "maxSessionDuration": "number", // minutes
      "allowPublicSessions": "boolean",
      "allowFriendInvites": "boolean"
    },
    "safetySettings": {
      "chatEnabled": "boolean",
      "autoApproveSessions": "boolean",
      "requireParentApproval": "boolean",
      "blockedUsers": ["string"], // User IDs
      "restrictedContent": ["string"] // Content types
    },
    "usageStats": {
      "totalSessions": "number",
      "totalPlaytime": "number", // minutes
      "lastActive": "timestamp",
      "favoriteBackgrounds": ["string"] // Background IDs
    }
  },
  "playtimePermissions": {
    "canCreateSessions": "boolean",
    "canUploadContent": "boolean",
    "canInviteFriends": "boolean",
    "canJoinPublicSessions": "boolean",
    "requiresParentApproval": "boolean"
  }
}
```

## Security Rules

### Base Rules Structure
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isChild(userId) {
      return get(/databases/$(database)/documents/users/$(userId)).data.playtimeSettings.isChild == true;
    }
    
    function isParent(userId) {
      return get(/databases/$(database)/documents/users/$(userId)).data.playtimeSettings.isChild == false;
    }
    
    function isAdmin() {
      return request.auth.token.admin == true;
    }
    
    function isParentOfChild(childId) {
      return isParent(request.auth.uid) && 
             get(/databases/$(database)/documents/users/$(childId)).data.playtimeSettings.parentUid == request.auth.uid;
    }
    
    function isSessionParticipant(sessionId) {
      return request.auth.uid in resource.data.participants[*].userId;
    }
    
    function isSessionCreator(sessionId) {
      return resource.data.creatorId == request.auth.uid;
    }
    
    function isSessionInvited(sessionId) {
      return request.auth.uid in resource.data.invitedUsers;
    }
    
    function requiresParentApproval(sessionId) {
      return resource.data.parentApprovalStatus.required == true;
    }
    
    function isParentApproved(sessionId) {
      return !requiresParentApproval(sessionId) || 
             request.auth.uid in resource.data.parentApprovalStatus.approvedBy;
    }
    
    // Playtime Games Rules
    match /playtime_games/{gameId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && 
                   (isAdmin() || !resource.data.isSystemGame);
      allow update: if isAuthenticated() && 
                   (isAdmin() || resource.data.creatorId == request.auth.uid);
      allow delete: if isAuthenticated() && isAdmin();
    }
    
    // Playtime Sessions Rules
    match /playtime_sessions/{sessionId} {
      allow read: if isAuthenticated() && 
                 (isSessionParticipant(sessionId) || 
                  isSessionInvited(sessionId) || 
                  isParentOfChild(resource.data.creatorId) ||
                  isAdmin());
      allow create: if isAuthenticated() && 
                   get(/databases/$(database)/documents/users/$(request.auth.uid)).data.playtimePermissions.canCreateSessions == true;
      allow update: if isAuthenticated() && 
                   (isSessionCreator(sessionId) || isAdmin());
      allow delete: if isAuthenticated() && 
                   (isSessionCreator(sessionId) || isAdmin());
    }
    
    // Playtime Backgrounds Rules
    match /playtime_backgrounds/{backgroundId} {
      allow read: if isAuthenticated() && 
                 (resource.data.status == 'approved' || 
                  resource.data.uploadedBy == request.auth.uid ||
                  isAdmin());
      allow create: if isAuthenticated() && 
                   get(/databases/$(database)/documents/users/$(request.auth.uid)).data.playtimePermissions.canUploadContent == true;
      allow update: if isAuthenticated() && 
                   (resource.data.uploadedBy == request.auth.uid || isAdmin());
      allow delete: if isAuthenticated() && isAdmin();
    }
    
    // Playtime Uploads Rules
    match /playtime_uploads/{uploadId} {
      allow read: if isAuthenticated() && 
                 (resource.data.uploadedBy == request.auth.uid || isAdmin());
      allow create: if isAuthenticated() && 
                   get(/databases/$(database)/documents/users/$(request.auth.uid)).data.playtimePermissions.canUploadContent == true;
      allow update: if isAuthenticated() && 
                   (resource.data.uploadedBy == request.auth.uid || isAdmin());
      allow delete: if isAuthenticated() && 
                   (resource.data.uploadedBy == request.auth.uid || isAdmin());
    }
    
    // Playtime Chats Rules
    match /playtime_chats/{chatId} {
      allow read: if isAuthenticated() && 
                 isSessionParticipant(resource.data.sessionId);
      allow create: if isAuthenticated() && 
                   isSessionParticipant(resource.data.sessionId) &&
                   resource.data.senderId == request.auth.uid;
      allow update: if isAuthenticated() && 
                   resource.data.senderId == request.auth.uid &&
                   resource.data.timestamp > timestamp.date(2024, 1, 1); // Allow editing recent messages
      allow delete: if isAuthenticated() && 
                   (resource.data.senderId == request.auth.uid || isAdmin());
    }
    
    // Extended Users Rules
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated() && 
                   (request.auth.uid == userId || 
                    isParentOfChild(userId) || 
                    isAdmin());
    }
  }
}
```

## Data Relationships

### One-to-Many Relationships
- User → Sessions (creator)
- User → Uploads (uploader)
- Game → Sessions (gameId)
- Session → Chats (sessionId)
- Background → Sessions (backgroundId)

### Many-to-Many Relationships
- Users ↔ Sessions (participants)
- Users ↔ Games (favorites)
- Users ↔ Backgrounds (favorites)

### Parent-Child Relationships
- Parent → Child (family links)
- Parent → Child Sessions (approval)

## Indexes Summary

### Composite Indexes Required
1. `playtime_sessions`: `creatorId` + `status` + `scheduledFor`
2. `playtime_sessions`: `type` + `status` + `createdAt`
3. `playtime_chats`: `sessionId` + `timestamp` + `senderId`
4. `playtime_backgrounds`: `status` + `category` + `createdAt`
5. `playtime_uploads`: `uploadedBy` + `status` + `createdAt`

### Performance Considerations
- Use pagination for large result sets
- Implement caching for frequently accessed data
- Use composite indexes for complex queries
- Consider data archival for old sessions and chats

## Data Validation Rules

### Session Validation
- Participants cannot exceed maxParticipants
- Scheduled sessions must have future dates
- Live sessions must have location data
- Parent approval required for children under 13

### Chat Validation
- Messages must be under 500 characters
- Rate limiting: max 10 messages per minute per user
- No duplicate messages within 5 seconds

### Upload Validation
- File size limits: 10MB for backgrounds, 5MB for other content
- Supported formats: JPG, PNG, GIF for images
- Content moderation required for user uploads

### Background Validation
- Minimum resolution: 800x600
- Maximum resolution: 4096x4096
- Aspect ratio: 4:3, 16:9, or 1:1 preferred 