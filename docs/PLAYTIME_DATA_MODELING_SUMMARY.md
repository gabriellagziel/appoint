# Playtime Data Modeling & Firestore Schema - Complete Deliverables

## Overview
This document summarizes all data modeling deliverables for the Playtime feature, including Firestore schema, security rules, data models, and mock data.

## 📋 Deliverables Summary

### 1. Firestore Schema Documentation
**File**: `PLAYTIME_FIRESTORE_SCHEMA.md`
- Complete collection definitions with field specifications
- Document structures and data types
- Index requirements and performance considerations
- Data validation rules and business logic

### 2. Security Rules
**File**: `firestore.rules` (Updated)
- Child vs Parent vs Admin access controls
- Session participant permissions
- Content approval workflows
- Safety and moderation features

### 3. Data Models
**Files**: 
- `lib/models/playtime_game.dart`
- `lib/models/playtime_session.dart`
- `lib/models/playtime_background.dart`
- `lib/models/user_profile.dart` (Extended)

### 4. Mock Data & Seed Scripts
**File**: `PLAYTIME_MOCK_DATA.md`
- Sample data for all collections
- Seed scripts for development
- Testing scenarios and validation

## 🗄️ Database Collections

### 1. `playtime_games`
**Purpose**: Store game definitions and metadata
**Key Features**:
- System vs user-created games
- Age-appropriate categorization
- Safety level indicators
- Usage statistics and ratings

**Document Structure**:
```json
{
  "gameId": "string",
  "name": "string",
  "description": "string",
  "icon": "string",
  "category": "string", // educational, creative, physical, social
  "ageRange": { "min": "number", "max": "number" },
  "type": "string", // virtual, live, both
  "maxParticipants": "number",
  "estimatedDuration": "number",
  "isSystemGame": "boolean",
  "isPublic": "boolean",
  "creatorId": "string",
  "parentApprovalRequired": "boolean",
  "safetyLevel": "string", // safe, moderate, supervised
  "usageCount": "number",
  "averageRating": "number",
  "totalRatings": "number"
}
```

### 2. `playtime_sessions`
**Purpose**: Track individual playtime sessions
**Key Features**:
- Virtual and live session support
- Participant management
- Parent approval workflow
- Safety monitoring

**Document Structure**:
```json
{
  "sessionId": "string",
  "gameId": "string",
  "type": "string", // virtual, live
  "title": "string",
  "description": "string",
  "creatorId": "string",
  "participants": [
    {
      "userId": "string",
      "displayName": "string",
      "photoUrl": "string",
      "role": "string", // creator, participant
      "joinedAt": "timestamp",
      "status": "string" // invited, joined, left, declined
    }
  ],
  "invitedUsers": ["string"],
  "scheduledFor": "timestamp",
  "duration": "number",
  "location": {
    "name": "string",
    "address": "string",
    "coordinates": { "latitude": "number", "longitude": "number" }
  },
  "backgroundId": "string",
  "status": "string", // pending_approval, approved, declined, active, completed, cancelled
  "parentApprovalStatus": {
    "required": "boolean",
    "approvedBy": ["string"],
    "declinedBy": ["string"],
    "approvedAt": "timestamp",
    "declinedAt": "timestamp"
  },
  "adminApprovalStatus": {
    "required": "boolean",
    "approvedBy": "string",
    "approvedAt": "timestamp"
  },
  "safetyFlags": {
    "reportedContent": "boolean",
    "moderationRequired": "boolean",
    "autoPaused": "boolean"
  }
}
```

### 3. `playtime_backgrounds`
**Purpose**: Manage background images for live sessions
**Key Features**:
- Upload approval workflow
- Category and tag organization
- Usage tracking
- Safety level classification

**Document Structure**:
```json
{
  "backgroundId": "string",
  "name": "string",
  "description": "string",
  "imageUrl": "string",
  "thumbnailUrl": "string",
  "uploadedBy": "string",
  "uploadedByDisplayName": "string",
  "category": "string", // outdoor, indoor, educational, creative
  "tags": ["string"],
  "status": "string", // pending_approval, approved, declined, disabled
  "approvalStatus": {
    "reviewedBy": "string",
    "reviewedAt": "timestamp",
    "reason": "string"
  },
  "usageCount": "number",
  "isSystemBackground": "boolean",
  "isActive": "boolean",
  "fileSize": "number",
  "dimensions": { "width": "number", "height": "number" },
  "safetyLevel": "string",
  "ageAppropriate": { "minAge": "number", "maxAge": "number" }
}
```

### 4. `playtime_uploads`
**Purpose**: Track user uploads awaiting approval
**Key Features**:
- Content moderation workflow
- Safety checking
- File metadata tracking
- Expiration handling

**Document Structure**:
```json
{
  "uploadId": "string",
  "uploadedBy": "string",
  "uploadedByDisplayName": "string",
  "uploadType": "string", // background, game_asset, custom_content
  "fileName": "string",
  "fileUrl": "string",
  "fileSize": "number",
  "mimeType": "string",
  "status": "string", // pending, approved, declined, processing
  "approvalStatus": {
    "reviewedBy": "string",
    "reviewedAt": "timestamp",
    "reason": "string",
    "notes": "string"
  },
  "metadata": {
    "title": "string",
    "description": "string",
    "category": "string",
    "tags": ["string"],
    "dimensions": { "width": "number", "height": "number" }
  },
  "safetyCheck": {
    "autoApproved": "boolean",
    "flaggedForReview": "boolean",
    "flags": ["string"]
  }
}
```

### 5. `playtime_chats`
**Purpose**: Store chat messages for virtual sessions
**Key Features**:
- Real-time messaging
- Message moderation
- Reply threading
- Reaction support

**Document Structure**:
```json
{
  "chatId": "string",
  "sessionId": "string",
  "messageId": "string",
  "senderId": "string",
  "senderDisplayName": "string",
  "senderPhotoUrl": "string",
  "message": "string",
  "messageType": "string", // text, system, join, leave
  "timestamp": "timestamp",
  "isEdited": "boolean",
  "editedAt": "timestamp",
  "moderationStatus": {
    "isFlagged": "boolean",
    "flaggedBy": ["string"],
    "flaggedAt": "timestamp",
    "reviewedBy": "string",
    "reviewedAt": "timestamp",
    "action": "string" // warn, delete, none
  },
  "reactions": { "userId": "string" },
  "replyTo": "string",
  "isDeleted": "boolean",
  "deletedAt": "timestamp",
  "deletedBy": "string"
}
```

### 6. Extended `users` Collection
**Purpose**: Enhanced user profiles with playtime-specific fields
**Key Features**:
- Child/parent relationship tracking
- Playtime preferences and settings
- Safety controls and permissions
- Usage statistics

**Additional Fields**:
```json
{
  "playtimeSettings": {
    "isChild": "boolean",
    "parentUid": "string",
    "approvedPlaytimeSessions": ["string"],
    "playtimePreferences": {
      "favoriteGames": ["string"],
      "preferredCategories": ["string"],
      "maxSessionDuration": "number",
      "allowPublicSessions": "boolean",
      "allowFriendInvites": "boolean"
    },
    "safetySettings": {
      "chatEnabled": "boolean",
      "autoApproveSessions": "boolean",
      "requireParentApproval": "boolean",
      "blockedUsers": ["string"],
      "restrictedContent": ["string"]
    },
    "usageStats": {
      "totalSessions": "number",
      "totalPlaytime": "number",
      "lastActive": "timestamp",
      "favoriteBackgrounds": ["string"]
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

## 🔐 Security Rules Overview

### Access Control Levels
1. **Child Users**: Limited access, requires parent approval
2. **Parent Users**: Can manage their children's data
3. **Admin Users**: Full access to all data and moderation tools

### Key Security Functions
- `isAuthenticated()`: Check if user is logged in
- `isChild(userId)`: Check if user is a child
- `isParent(userId)`: Check if user is a parent
- `isParentOfChild(childId)`: Check parent-child relationship
- `isSessionCreator(sessionId)`: Check if user created session
- `isSessionInvited(sessionId)`: Check if user is invited
- `hasPlaytimePermission(permission)`: Check user permissions

### Collection-Specific Rules
- **Games**: Read by all, create by admin or non-system games
- **Sessions**: Read by participants/invited/parents/admins, create by permission
- **Backgrounds**: Read approved/own/admin, create by permission
- **Uploads**: Read own/admin, create by permission
- **Chats**: Read by session participants, create by participants with chat enabled
- **Users**: Read all, write own/parent-of-child/admin

## 📊 Indexes Required

### Single Field Indexes
- `playtime_games`: category, type, isPublic, isActive, creatorId, safetyLevel
- `playtime_sessions`: creatorId, gameId, type, status, scheduledFor
- `playtime_backgrounds`: uploadedBy, status, category, isSystemBackground, isActive
- `playtime_uploads`: uploadedBy, uploadType, status, createdAt
- `playtime_chats`: sessionId, senderId, timestamp, messageType

### Composite Indexes
1. `playtime_sessions`: creatorId + status + scheduledFor
2. `playtime_sessions`: type + status + createdAt
3. `playtime_chats`: sessionId + timestamp + senderId
4. `playtime_backgrounds`: status + category + createdAt
5. `playtime_uploads`: uploadedBy + status + createdAt

## 🧪 Testing & Development

### Mock Data Available
- **4 System Games**: Minecraft, Scavenger Hunt, Art & Craft, Math Puzzles
- **3 System Backgrounds**: Park Scene, Art Room, Space Adventure
- **2 Sample Sessions**: Virtual and Live sessions
- **2 Sample Chat Messages**: Basic conversation
- **2 Extended User Profiles**: Child and Parent examples

### Seed Scripts
- **Firebase CLI**: Bash script for direct Firestore seeding
- **Flutter/Dart**: Dart class for programmatic seeding
- **Node.js**: JavaScript script for server-side seeding

### Test Scenarios
1. Child creates session → Parent approval required
2. Child joins public session → Automatic approval
3. Child uploads background → Admin approval required
4. Parent approves session → Session becomes active
5. Admin moderates content → Content flagged/reviewed

## 🚀 Implementation Steps

### Phase 1: Foundation
1. Deploy updated Firestore security rules
2. Create data models with code generation
3. Set up indexes for performance
4. Seed initial system data

### Phase 2: Core Features
1. Implement game management
2. Build session creation and management
3. Add background upload and approval
4. Create chat system

### Phase 3: Safety & Moderation
1. Implement parent approval workflows
2. Add content moderation tools
3. Build admin management interface
4. Add safety monitoring

### Phase 4: Optimization
1. Performance tuning and caching
2. Advanced search and filtering
3. Analytics and reporting
4. Data archival strategies

## 📈 Performance Considerations

### Data Size Estimates
- **Games**: ~1KB per document, ~1000 documents
- **Sessions**: ~5KB per document, ~10,000 documents
- **Backgrounds**: ~2KB per document, ~500 documents
- **Chats**: ~1KB per document, ~100,000 documents
- **Uploads**: ~3KB per document, ~2000 documents

### Optimization Strategies
- Use pagination for large result sets
- Implement caching for frequently accessed data
- Use composite indexes for complex queries
- Consider data archival for old sessions and chats
- Implement real-time listeners efficiently

## 🔒 Safety & Compliance

### Child Safety Features
- Age-appropriate content filtering
- Parent approval requirements
- Content moderation workflows
- Safety flag monitoring
- Blocked user management

### Data Privacy
- Minimal data collection
- Secure data transmission
- Access control enforcement
- Data retention policies
- GDPR compliance considerations

### Content Moderation
- Automated safety checks
- Manual review workflows
- User reporting system
- Admin moderation tools
- Content flagging and removal

## 📞 Support & Maintenance

### Monitoring
- Database performance metrics
- Security rule effectiveness
- Content moderation efficiency
- User activity patterns
- Error rate tracking

### Maintenance Tasks
- Regular index optimization
- Data cleanup and archival
- Security rule updates
- Content moderation reviews
- Performance tuning

---

**Note**: This data modeling system is designed to support a safe, scalable, and child-friendly playtime feature. All security rules prioritize child safety while maintaining good user experience for parents and administrators. 