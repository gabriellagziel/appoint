#!/usr/bin/env node

/**
 * Staging User Seeding Script
 * Creates test users for manual Playtime testing
 * 
 * Usage: node scripts/staging_seed_users.js
 */

const admin = require('firebase-admin');

// Initialize Firebase Admin (you'll need to set up service account)
// const serviceAccount = require('./path/to/serviceAccountKey.json');
// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
//   projectId: 'your-staging-project-id'
// });

const db = admin.firestore();

// Test users data
const testUsers = [
  {
    uid: 'adult_25',
    age: 25,
    isChild: false,
    parentUid: null,
    displayName: 'Adult Test User',
    email: 'adult@test.com',
    role: 'user',
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    uid: 'teen_15',
    age: 15,
    isChild: true,
    parentUid: 'parent_40',
    displayName: 'Teen Test User',
    email: 'teen@test.com',
    role: 'user',
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    uid: 'child_10',
    age: 10,
    isChild: true,
    parentUid: 'parent_40',
    displayName: 'Child Test User',
    email: 'child@test.com',
    role: 'user',
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    uid: 'parent_40',
    age: 40,
    isChild: false,
    parentUid: null,
    displayName: 'Parent Test User',
    email: 'parent@test.com',
    role: 'parent',
    createdAt: new Date(),
    updatedAt: new Date()
  }
];

// Parent preferences
const parentPreferences = {
  parentId: 'parent_40',
  allowOverrideAgeRestriction: true,
  blockedGames: [],
  allowedPlatforms: ['PC', 'Console', 'Mobile'],
  maxSessionDuration: 120,
  allowVirtualSessions: true,
  allowPhysicalSessions: true,
  requirePreApproval: true,
  createdAt: new Date(),
  updatedAt: new Date()
};

// Test games (subset of the main seed file)
const testGames = [
  {
    id: 'minecraft',
    name: 'Minecraft',
    description: 'Build and explore together in creative mode',
    icon: '🎮',
    category: 'creative',
    ageRange: { min: 8, max: 99 },
    type: 'virtual',
    platform: 'PC',
    minAge: 8,
    maxPlayers: 10,
    maxParticipants: 10,
    estimatedDuration: 120,
    isSystemGame: true,
    isPublic: true,
    isActive: true,
    creatorId: 'system',
    parentApprovalRequired: true,
    parentApproved: true,
    safetyLevel: 'safe',
    rating: 'E for Everyone',
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    id: 'fortnite',
    name: 'Fortnite',
    description: 'Battle royale game with building mechanics',
    icon: '🏰',
    category: 'action',
    ageRange: { min: 13, max: 99 },
    type: 'virtual',
    platform: 'Console',
    minAge: 13,
    maxPlayers: 4,
    maxParticipants: 4,
    estimatedDuration: 30,
    isSystemGame: true,
    isPublic: true,
    isActive: true,
    creatorId: 'system',
    parentApprovalRequired: true,
    parentApproved: true,
    safetyLevel: 'monitored',
    rating: 'T for Teen',
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    id: 'mature_shooter',
    name: 'Mature Shooter',
    description: 'Intense combat simulation for adults',
    icon: '💥',
    category: 'action',
    ageRange: { min: 18, max: 99 },
    type: 'virtual',
    platform: 'Console',
    minAge: 18,
    maxPlayers: 8,
    maxParticipants: 8,
    estimatedDuration: 60,
    isSystemGame: true,
    isPublic: true,
    isActive: true,
    creatorId: 'system',
    parentApprovalRequired: true,
    parentApproved: true,
    safetyLevel: 'adults_only',
    rating: 'AO for Adults Only',
    createdAt: new Date(),
    updatedAt: new Date()
  }
];

async function seedUsers() {
  console.log('🌱 Seeding test users...');
  
  try {
    // Create users
    for (const user of testUsers) {
      await db.collection('users').doc(user.uid).set(user);
      console.log(`✅ Created user: ${user.displayName} (${user.age} years old)`);
    }
    
    // Create parent preferences
    await db.collection('playtime_preferences').doc(parentPreferences.parentId).set(parentPreferences);
    console.log(`✅ Created parent preferences for: ${parentPreferences.parentId}`);
    
    // Create games
    for (const game of testGames) {
      await db.collection('playtime_games').doc(game.id).set(game);
      console.log(`✅ Created game: ${game.name} (minAge: ${game.minAge})`);
    }
    
    console.log('🎉 All test data seeded successfully!');
    console.log('\n📋 Test Users Created:');
    console.log('  - Adult (25): Can play any game without approval');
    console.log('  - Teen (15): Needs approval for age-restricted games');
    console.log('  - Child (10): Needs approval for all games (COPPA)');
    console.log('  - Parent (40): Can approve child/teen sessions');
    
  } catch (error) {
    console.error('❌ Error seeding test data:', error);
    process.exit(1);
  }
}

// Run the seeding
if (require.main === module) {
  seedUsers();
}

module.exports = { seedUsers, testUsers, testGames, parentPreferences };
