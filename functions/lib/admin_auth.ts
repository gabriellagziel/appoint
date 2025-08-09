import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// Initialize Firebase Admin
admin.initializeApp();

const db = admin.firestore();

/**
 * Secure admin claim management
 * Only this function can set admin/owner claims
 */
export const setAdminClaim = functions.https.onCall(async (data, context) => {
  // Verify the caller is a super admin
  const callerUid = context.auth?.uid;
  if (!callerUid) {
    throw new functions.https.HttpsError('unauthenticated', 'User not authenticated');
  }

  // Check if caller is super admin
  const callerDoc = await db.collection('admin_config').doc('owners').get();
  const ownerUids = callerDoc.data()?.ownerUids || [];
  
  if (!ownerUids.includes(callerUid)) {
    throw new functions.https.HttpsError('permission-denied', 'Only super admins can manage claims');
  }

  const { targetUid, role, action } = data;
  
  if (!targetUid || !role || !action) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing required parameters');
  }

  try {
    const userRecord = await admin.auth().getUser(targetUid);
    const currentClaims = userRecord.customClaims || {};
    
    let newClaims = { ...currentClaims };
    
    switch (action) {
      case 'grant':
        newClaims[role] = true;
        newClaims.roleUpdatedAt = Date.now();
        newClaims.roleUpdatedBy = callerUid;
        break;
        
      case 'revoke':
        delete newClaims[role];
        newClaims.roleUpdatedAt = Date.now();
        newClaims.roleUpdatedBy = callerUid;
        break;
        
      default:
        throw new functions.https.HttpsError('invalid-argument', 'Invalid action');
    }

    // Set custom claims
    await admin.auth().setCustomUserClaims(targetUid, newClaims);
    
    // Log the action
    await db.collection('admin_logs').add({
      adminId: callerUid,
      action: 'set_admin_claim',
      details: {
        targetUid,
        role,
        action,
        previousClaims: currentClaims,
        newClaims,
      },
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      ipAddress: context.rawRequest.ip,
      userAgent: context.rawRequest.headers['user-agent'],
    });

    return { success: true, message: `${role} ${action}ed for user ${targetUid}` };
    
  } catch (error) {
    console.error('Error setting admin claim:', error);
    throw new functions.https.HttpsError('internal', 'Failed to set admin claim');
  }
});

/**
 * Rotate admin credentials
 * Removes old admin claims and sets new ones
 */
export const rotateAdminCredentials = functions.https.onCall(async (data, context) => {
  const callerUid = context.auth?.uid;
  if (!callerUid) {
    throw new functions.https.HttpsError('unauthenticated', 'User not authenticated');
  }

  // Verify super admin
  const callerDoc = await db.collection('admin_config').doc('owners').get();
  const ownerUids = callerDoc.data()?.ownerUids || [];
  
  if (!ownerUids.includes(callerUid)) {
    throw new functions.https.HttpsError('permission-denied', 'Only super admins can rotate credentials');
  }

  const { newAdminUids, newOwnerUids } = data;
  
  if (!newAdminUids || !newOwnerUids) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing new admin/owner lists');
  }

  try {
    // Get current admin/owner lists
    const adminsDoc = await db.collection('admin_config').doc('admins').get();
    const ownersDoc = await db.collection('admin_config').doc('owners').get();
    
    const currentAdminUids = adminsDoc.data()?.adminUids || [];
    const currentOwnerUids = ownersDoc.data()?.ownerUids || [];

    // Revoke claims from old admins/owners
    const allOldUids = [...new Set([...currentAdminUids, ...currentOwnerUids])];
    const allNewUids = [...new Set([...newAdminUids, ...newOwnerUids])];
    
    const uidsToRevoke = allOldUids.filter(uid => !allNewUids.includes(uid));
    
    for (const uid of uidsToRevoke) {
      try {
        await admin.auth().setCustomUserClaims(uid, {});
        console.log(`Revoked claims from ${uid}`);
      } catch (error) {
        console.error(`Failed to revoke claims from ${uid}:`, error);
      }
    }

    // Grant claims to new admins/owners
    for (const uid of newAdminUids) {
      try {
        await admin.auth().setCustomUserClaims(uid, { 
          admin: true,
          roleUpdatedAt: Date.now(),
          roleUpdatedBy: callerUid,
        });
        console.log(`Granted admin claims to ${uid}`);
      } catch (error) {
        console.error(`Failed to grant admin claims to ${uid}:`, error);
      }
    }

    for (const uid of newOwnerUids) {
      try {
        await admin.auth().setCustomUserClaims(uid, { 
          owner: true,
          admin: true,
          roleUpdatedAt: Date.now(),
          roleUpdatedBy: callerUid,
        });
        console.log(`Granted owner claims to ${uid}`);
      } catch (error) {
        console.error(`Failed to grant owner claims to ${uid}:`, error);
      }
    }

    // Update Firestore config
    await db.collection('admin_config').doc('admins').set({
      adminUids: newAdminUids,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedBy: callerUid,
    });

    await db.collection('admin_config').doc('owners').set({
      ownerUids: newOwnerUids,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedBy: callerUid,
    });

    // Log the rotation
    await db.collection('admin_logs').add({
      adminId: callerUid,
      action: 'rotate_admin_credentials',
      details: {
        previousAdmins: currentAdminUids,
        previousOwners: currentOwnerUids,
        newAdmins: newAdminUids,
        newOwners: newOwnerUids,
        revokedCount: uidsToRevoke.length,
      },
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      ipAddress: context.rawRequest.ip,
      userAgent: context.rawRequest.headers['user-agent'],
    });

    return { 
      success: true, 
      message: `Admin credentials rotated. ${uidsToRevoke.length} users revoked, ${newAdminUids.length + newOwnerUids.length} users granted` 
    };
    
  } catch (error) {
    console.error('Error rotating admin credentials:', error);
    throw new functions.https.HttpsError('internal', 'Failed to rotate admin credentials');
  }
});

/**
 * Verify admin status
 * Returns current admin/owner status for a user
 */
export const verifyAdminStatus = functions.https.onCall(async (data, context) => {
  const callerUid = context.auth?.uid;
  if (!callerUid) {
    throw new functions.https.HttpsError('unauthenticated', 'User not authenticated');
  }

  const { targetUid } = data;
  
  if (!targetUid) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing target UID');
  }

  try {
    const userRecord = await admin.auth().getUser(targetUid);
    const claims = userRecord.customClaims || {};
    
    return {
      uid: targetUid,
      isAdmin: !!claims.admin,
      isOwner: !!claims.owner,
      roleUpdatedAt: claims.roleUpdatedAt,
      roleUpdatedBy: claims.roleUpdatedBy,
    };
    
  } catch (error) {
    console.error('Error verifying admin status:', error);
    throw new functions.https.HttpsError('internal', 'Failed to verify admin status');
  }
});

