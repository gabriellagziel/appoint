import * as admin from 'firebase-admin';

// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();
const auth = admin.auth();

/**
 * Log admin actions to /logs/admin/
 */
export async function logAdminAction(
  uid: string, 
  type: string, 
  details: any,
  metadata?: {
    ip?: string;
    userAgent?: string;
    timestamp?: Date;
  }
) {
  try {
    const logEntry = {
      uid,
      type,
      details,
      metadata: {
        ip: metadata?.ip || 'unknown',
        userAgent: metadata?.userAgent || 'unknown',
        timestamp: metadata?.timestamp || new Date(),
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await db.collection('logs').doc('admin').collection('actions').add(logEntry);
    console.log(`✅ Logged admin action: ${type} by ${uid}`);
  } catch (error) {
    console.error('Error logging admin action:', error);
    throw error;
  }
}

/**
 * Fetch latest invoice for a business
 */
export async function fetchLatestInvoice(businessId: string) {
  try {
    const invoicesRef = db.collection('businesses').doc(businessId).collection('invoices');
    const snapshot = await invoicesRef
      .orderBy('createdAt', 'desc')
      .limit(1)
      .get();

    if (snapshot.empty) {
      return null;
    }

    return snapshot.docs[0].data();
  } catch (error) {
    console.error('Error fetching latest invoice:', error);
    throw error;
  }
}

/**
 * Get all invoices for a business with pagination
 */
export async function getBusinessInvoices(
  businessId: string, 
  limit: number = 10, 
  startAfter?: any
) {
  try {
    let query = db.collection('businesses').doc(businessId).collection('invoices')
      .orderBy('createdAt', 'desc')
      .limit(limit);

    if (startAfter) {
      query = query.startAfter(startAfter);
    }

    const snapshot = await query.get();
    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
  } catch (error) {
    console.error('Error fetching business invoices:', error);
    throw error;
  }
}

/**
 * Manage users programmatically
 */
export async function manageUser(
  action: 'create' | 'update' | 'delete',
  userData: {
    email: string;
    password?: string;
    displayName?: string;
    uid?: string;
  }
) {
  try {
    switch (action) {
      case 'create':
        const userRecord = await auth.createUser({
          email: userData.email,
          password: userData.password,
          displayName: userData.displayName,
        });
        console.log(`✅ Created user: ${userRecord.uid}`);
        return userRecord;

      case 'update':
        if (!userData.uid) throw new Error('UID required for update');
        const updatedUser = await auth.updateUser(userData.uid, {
          email: userData.email,
          displayName: userData.displayName,
        });
        console.log(`✅ Updated user: ${updatedUser.uid}`);
        return updatedUser;

      case 'delete':
        if (!userData.uid) throw new Error('UID required for delete');
        await auth.deleteUser(userData.uid);
        console.log(`✅ Deleted user: ${userData.uid}`);
        return { success: true };

      default:
        throw new Error(`Invalid action: ${action}`);
    }
  } catch (error) {
    console.error(`Error managing user (${action}):`, error);
    throw error;
  }
}

/**
 * Manage appointments programmatically
 */
export async function manageAppointment(
  action: 'create' | 'update' | 'delete',
  appointmentData: any,
  businessId: string
) {
  try {
    const appointmentsRef = db.collection('businesses').doc(businessId).collection('appointments');
    
    switch (action) {
      case 'create':
        const docRef = await appointmentsRef.add({
          ...appointmentData,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        console.log(`✅ Created appointment: ${docRef.id}`);
        return { id: docRef.id, ...appointmentData };

      case 'update':
        if (!appointmentData.id) throw new Error('Appointment ID required for update');
        await appointmentsRef.doc(appointmentData.id).update({
          ...appointmentData,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        console.log(`✅ Updated appointment: ${appointmentData.id}`);
        return appointmentData;

      case 'delete':
        if (!appointmentData.id) throw new Error('Appointment ID required for delete');
        await appointmentsRef.doc(appointmentData.id).delete();
        console.log(`✅ Deleted appointment: ${appointmentData.id}`);
        return { success: true };

      default:
        throw new Error(`Invalid action: ${action}`);
    }
  } catch (error) {
    console.error(`Error managing appointment (${action}):`, error);
    throw error;
  }
}

/**
 * Run scheduled tasks or backend patches
 */
export async function runScheduledTask(
  taskName: string,
  taskFunction: () => Promise<any>,
  metadata?: any
) {
  try {
    console.log(`🔄 Starting scheduled task: ${taskName}`);
    
    // Log task start
    await logAdminAction('system', 'scheduled_task_start', {
      taskName,
      metadata,
    });

    // Execute task
    const result = await taskFunction();

    // Log task completion
    await logAdminAction('system', 'scheduled_task_complete', {
      taskName,
      result,
      metadata,
    });

    console.log(`✅ Completed scheduled task: ${taskName}`);
    return result;
  } catch (error) {
    console.error(`❌ Scheduled task failed: ${taskName}`, error);
    
    // Log task failure
    await logAdminAction('system', 'scheduled_task_failed', {
      taskName,
      error: (error as Error).message,
      metadata,
    });

    throw error;
  }
}

/**
 * Track background quota resets
 */
export async function trackQuotaReset(
  businessId: string,
  quotaType: 'appointments' | 'users' | 'storage',
  newQuota: number
) {
  try {
    const quotaReset = {
      businessId,
      quotaType,
      newQuota,
      resetAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await db.collection('quota_resets').add(quotaReset);
    
    // Update business quota
    await db.collection('businesses').doc(businessId).update({
      [`quotas.${quotaType}`]: newQuota,
      [`quotas.${quotaType}ResetAt`]: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`✅ Tracked quota reset for ${businessId}: ${quotaType} = ${newQuota}`);
  } catch (error) {
    console.error('Error tracking quota reset:', error);
    throw error;
  }
}

/**
 * Secure access to Firestore + Cloud Functions
 */
export async function validateAdminAccess(uid: string, requiredRole: string = 'admin') {
  try {
    const userRecord = await auth.getUser(uid);
    const customClaims = userRecord.customClaims || {};
    
    if (!customClaims[requiredRole]) {
      throw new Error(`User ${uid} does not have required role: ${requiredRole}`);
    }
    
    return userRecord;
  } catch (error) {
    console.error('Error validating admin access:', error);
    throw error;
  }
}

/**
 * Get system metrics and health status
 */
export async function getSystemHealth() {
  try {
    const healthData = {
      timestamp: new Date(),
      firestore: {
        collections: await db.listCollections().then(cols => cols.length),
      },
      auth: {
        users: await auth.listUsers().then(result => result.users.length),
      },
    };

    // Store health data
    await db.collection('system').doc('health').set(healthData);
    
    return healthData;
  } catch (error) {
    console.error('Error getting system health:', error);
    throw error;
  }
} 