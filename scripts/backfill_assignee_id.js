// Backfill script for assigneeId in existing reminders
// Run with: node scripts/backfill_assignee_id.js

const admin = require('firebase-admin');

// Initialize Firebase Admin (you'll need to set up service account)
// admin.initializeApp({
//   credential: admin.credential.applicationDefault(),
//   projectId: 'your-project-id'
// });

const backfillReminders = async () => {
  const firestore = admin.firestore();
  
  console.log('🔄 Starting assigneeId backfill...');
  
  try {
    // Get all reminders without assigneeId
    const remindersSnapshot = await firestore
      .collection('reminders')
      .where('assigneeId', '==', null)
      .get();
    
    console.log(`📊 Found ${remindersSnapshot.size} reminders without assigneeId`);
    
    const batch = firestore.batch();
    let updatedCount = 0;
    
    remindersSnapshot.forEach((doc) => {
      const reminder = doc.data();
      
      // Set assigneeId to ownerId if not set
      batch.update(doc.ref, {
        assigneeId: reminder.ownerId,
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });
      
      updatedCount++;
    });
    
    if (updatedCount > 0) {
      await batch.commit();
      console.log(`✅ Successfully updated ${updatedCount} reminders`);
    } else {
      console.log('ℹ️ No reminders need updating');
    }
    
  } catch (error) {
    console.error('❌ Error during backfill:', error);
    throw error;
  }
};

const validateBackfill = async () => {
  const firestore = admin.firestore();
  
  console.log('🔍 Validating backfill results...');
  
  try {
    // Check for any remaining reminders without assigneeId
    const remainingSnapshot = await firestore
      .collection('reminders')
      .where('assigneeId', '==', null)
      .get();
    
    if (remainingSnapshot.size === 0) {
      console.log('✅ All reminders now have assigneeId');
    } else {
      console.log(`⚠️ Found ${remainingSnapshot.size} reminders still without assigneeId`);
    }
    
    // Check total reminders count
    const totalSnapshot = await firestore.collection('reminders').get();
    console.log(`📊 Total reminders in database: ${totalSnapshot.size}`);
    
  } catch (error) {
    console.error('❌ Error during validation:', error);
    throw error;
  }
};

// Main execution
const main = async () => {
  console.log('🚀 Starting assigneeId backfill process...');
  
  try {
    await backfillReminders();
    await validateBackfill();
    console.log('🎉 Backfill process completed successfully!');
  } catch (error) {
    console.error('💥 Backfill process failed:', error);
    process.exit(1);
  }
};

// Export for use as module
module.exports = { backfillReminders, validateBackfill };

// Run if called directly
if (require.main === module) {
  main();
}
