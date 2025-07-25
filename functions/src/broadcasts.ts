import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { CallableContext } from 'firebase-functions/v1/https';

// Ensure Firebase Admin is initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const firestore = admin.firestore();
const messaging = admin.messaging();

// Configuration constants
const BATCH_SIZE = 100; // FCM tokens per batch
const MAX_RETRY_ATTEMPTS = 3;
const RETRY_DELAY_MS = 1000;

// Types for broadcast operations
interface BroadcastRequest {
  messageId: string;
  adminId: string;
}

interface ScheduledBroadcastRequest {
  // No parameters needed for scheduled processing
}

interface DeliveryResult {
  success: boolean;
  deliveredCount: number;
  failedCount: number;
  retryCount: number;
  errors: string[];
}

interface FCMPayload {
  token: string;
  notification: {
    title: string;
    body: string;
    imageUrl?: string;
  };
  data: {
    messageId: string;
    type: string;
    imageUrl?: string;
    videoUrl?: string;
    externalLink?: string;
    pollOptions?: string;
  };
  android?: {
    notification: {
      imageUrl?: string;
    };
  };
  apns?: {
    payload: {
      aps: {
        'mutable-content': 1;
      };
    };
    fcm_options: {
      image?: string;
    };
  };
}

/**
 * Callable function to send broadcast messages
 * Triggered by admin users from the Flutter app
 */
export const sendBroadcastMessage = functions.https.onCall(
  async (data: BroadcastRequest, context: CallableContext): Promise<DeliveryResult> => {
    // Verify admin authentication
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    // Verify admin privileges
    const userDoc = await firestore.collection('users').doc(context.auth.uid).get();
    if (!userDoc.exists || userDoc.data()?.role !== 'admin') {
      throw new functions.https.HttpsError('permission-denied', 'Admin privileges required');
    }

    const { messageId, adminId } = data;

    try {
      console.log(`Starting broadcast delivery for message: ${messageId}`);
      
      // Get broadcast message
      const messageDoc = await firestore.collection('admin_broadcasts').doc(messageId).get();
      if (!messageDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'Broadcast message not found');
      }

      const messageData = messageDoc.data()!;
      
      // Verify message is in pending status
      if (messageData.status !== 'pending') {
        throw new functions.https.HttpsError('failed-precondition', 'Message is not in pending status');
      }

      // Get target users
      const targetUsers = await getTargetUsers(messageData.targetingFilters);
      console.log(`Found ${targetUsers.length} target users`);

      // Update message status to sending
      await firestore.collection('admin_broadcasts').doc(messageId).update({
        status: 'sending',
        actualRecipients: targetUsers.length,
        sentAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Send messages in batches
      const result = await sendMessagesInBatches(messageData, targetUsers, messageId);

      // Update final status based on results
      const finalStatus = result.failedCount === 0 ? 'sent' : 
                         result.deliveredCount === 0 ? 'failed' : 'partially_sent';

      await firestore.collection('admin_broadcasts').doc(messageId).update({
        status: finalStatus,
        deliveredCount: result.deliveredCount,
        failedCount: result.failedCount,
        retryCount: result.retryCount,
        processedAt: admin.firestore.FieldValue.serverTimestamp(),
        ...(result.errors.length > 0 && { 
          failureReason: result.errors.slice(0, 5).join('; ') // Store first 5 errors
        }),
      });

      console.log(`Broadcast delivery completed: ${result.deliveredCount} delivered, ${result.failedCount} failed`);
      return result;

    } catch (error) {
      console.error('Broadcast delivery failed:', error);
      
      // Update message status to failed
      await firestore.collection('admin_broadcasts').doc(messageId).update({
        status: 'failed',
        failureReason: error instanceof Error ? error.message : 'Unknown error',
        processedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      
      throw new functions.https.HttpsError('internal', 'Failed to send broadcast message');
    }
  }
);

/**
 * Scheduled function to process pending broadcast messages
 * Runs every minute to check for scheduled messages
 */
export const processScheduledBroadcasts = functions.pubsub
  .schedule('every 1 minutes')
  .onRun(async (context) => {
    console.log('Processing scheduled broadcasts...');
    
    try {
      const now = admin.firestore.Timestamp.now();
      
      // Find scheduled messages ready to send
      const scheduledQuery = await firestore
        .collection('admin_broadcasts')
        .where('status', '==', 'pending')
        .where('scheduledFor', '<=', now)
        .limit(10) // Process max 10 at a time
        .get();

      if (scheduledQuery.empty) {
        console.log('No scheduled messages to process');
        return;
      }

      console.log(`Found ${scheduledQuery.size} scheduled messages to process`);

      // Process each scheduled message
      const promises = scheduledQuery.docs.map(async (doc) => {
        const messageId = doc.id;
        const messageData = doc.data();
        
        try {
          console.log(`Processing scheduled message: ${messageId}`);
          
          // Get target users
          const targetUsers = await getTargetUsers(messageData.targetingFilters);
          
          // Update status to sending
          await firestore.collection('admin_broadcasts').doc(messageId).update({
            status: 'sending',
            actualRecipients: targetUsers.length,
            sentAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          // Send messages in batches
          const result = await sendMessagesInBatches(messageData, targetUsers, messageId);

          // Update final status
          const finalStatus = result.failedCount === 0 ? 'sent' : 
                             result.deliveredCount === 0 ? 'failed' : 'partially_sent';

          await firestore.collection('admin_broadcasts').doc(messageId).update({
            status: finalStatus,
            deliveredCount: result.deliveredCount,
            failedCount: result.failedCount,
            retryCount: result.retryCount,
            processedAt: admin.firestore.FieldValue.serverTimestamp(),
            ...(result.errors.length > 0 && { 
              failureReason: result.errors.slice(0, 5).join('; ')
            }),
          });

          console.log(`Scheduled message ${messageId} processed: ${result.deliveredCount} delivered`);

        } catch (error) {
          console.error(`Failed to process scheduled message ${messageId}:`, error);
          
          await firestore.collection('admin_broadcasts').doc(messageId).update({
            status: 'failed',
            failureReason: error instanceof Error ? error.message : 'Scheduled processing failed',
            processedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        }
      });

      await Promise.all(promises);
      console.log('Scheduled broadcast processing completed');

    } catch (error) {
      console.error('Scheduled broadcast processing failed:', error);
    }
  });

/**
 * Get target users based on targeting filters
 */
async function getTargetUsers(targetingFilters: any): Promise<Array<{ id: string; fcmToken: string }>> {
  try {
    let query: FirebaseFirestore.Query = firestore.collection('users');

    // Apply targeting filters
    if (targetingFilters.countries && targetingFilters.countries.length > 0) {
      query = query.where('country', 'in', targetingFilters.countries);
    }

    if (targetingFilters.cities && targetingFilters.cities.length > 0) {
      query = query.where('city', 'in', targetingFilters.cities);
    }

    if (targetingFilters.subscriptionTiers && targetingFilters.subscriptionTiers.length > 0) {
      query = query.where('subscriptionTier', 'in', targetingFilters.subscriptionTiers);
    }

    if (targetingFilters.userRoles && targetingFilters.userRoles.length > 0) {
      query = query.where('role', 'in', targetingFilters.userRoles);
    }

    if (targetingFilters.accountStatuses && targetingFilters.accountStatuses.length > 0) {
      query = query.where('status', 'in', targetingFilters.accountStatuses);
    }

    if (targetingFilters.joinedAfter) {
      query = query.where('createdAt', '>=', targetingFilters.joinedAfter);
    }

    if (targetingFilters.joinedBefore) {
      query = query.where('createdAt', '<=', targetingFilters.joinedBefore);
    }

    const snapshot = await query.get();
    
    // Filter users with valid FCM tokens
    const users: Array<{ id: string; fcmToken: string }> = [];
    snapshot.forEach((doc) => {
      const userData = doc.data();
      const fcmToken = userData.fcmToken;
      if (fcmToken && typeof fcmToken === 'string' && fcmToken.length > 0) {
        users.push({
          id: doc.id,
          fcmToken: fcmToken,
        });
      }
    });

    return users;
  } catch (error) {
    console.error('Error getting target users:', error);
    throw error;
  }
}

/**
 * Send messages to users in batches with retry logic
 */
async function sendMessagesInBatches(
  messageData: any,
  targetUsers: Array<{ id: string; fcmToken: string }>,
  messageId: string
): Promise<DeliveryResult> {
  const result: DeliveryResult = {
    success: true,
    deliveredCount: 0,
    failedCount: 0,
    retryCount: 0,
    errors: [],
  };

  // Create FCM payload template
  const basePayload = createFCMPayload(messageData, messageId);

  // Process users in batches
  const batches = chunkArray(targetUsers, BATCH_SIZE);
  console.log(`Processing ${batches.length} batches of ${BATCH_SIZE} users each`);

  for (let i = 0; i < batches.length; i++) {
    const batch = batches[i];
    console.log(`Processing batch ${i + 1}/${batches.length} with ${batch.length} users`);

    const batchResult = await sendBatchWithRetry(batch, basePayload, messageId);
    
    result.deliveredCount += batchResult.deliveredCount;
    result.failedCount += batchResult.failedCount;
    result.retryCount += batchResult.retryCount;
    result.errors.push(...batchResult.errors);

    // Small delay between batches to respect rate limits
    if (i < batches.length - 1) {
      await delay(100);
    }
  }

  result.success = result.failedCount === 0;
  return result;
}

/**
 * Send a batch of messages with retry logic
 */
async function sendBatchWithRetry(
  users: Array<{ id: string; fcmToken: string }>,
  basePayload: any,
  messageId: string,
  attempt = 1
): Promise<DeliveryResult> {
  const result: DeliveryResult = {
    success: true,
    deliveredCount: 0,
    failedCount: 0,
    retryCount: attempt > 1 ? 1 : 0,
    errors: [],
  };

  try {
    // Create multicast message
    const tokens = users.map(user => user.fcmToken);
    const message = {
      ...basePayload,
      tokens: tokens,
    };

    // Send to FCM
    const response = await messaging.sendMulticast(message);
    
    console.log(`Batch attempt ${attempt}: ${response.successCount} successful, ${response.failureCount} failed`);

    result.deliveredCount = response.successCount;
    result.failedCount = response.failureCount;

    // Track successful deliveries
    const successfulUsers = users.filter((_, index) => response.responses[index].success);
    await trackDeliveryEvents(successfulUsers, messageId, 'sent');

    // Handle failures
    if (response.failureCount > 0) {
      const failedUsers: Array<{ id: string; fcmToken: string; error: string }> = [];
      
      response.responses.forEach((resp, index) => {
        if (!resp.success) {
          const error = resp.error?.code || 'unknown-error';
          failedUsers.push({
            ...users[index],
            error: error,
          });
          result.errors.push(`${users[index].id}: ${error}`);
        }
      });

      // Track failed deliveries
      await trackFailedDeliveries(failedUsers, messageId);

      // Retry logic for retryable errors
      if (attempt < MAX_RETRY_ATTEMPTS) {
        const retryableUsers = failedUsers.filter(user => 
          isRetryableError(user.error)
        );

        if (retryableUsers.length > 0) {
          console.log(`Retrying ${retryableUsers.length} failed messages (attempt ${attempt + 1})`);
          await delay(RETRY_DELAY_MS * attempt);
          
          const retryResult = await sendBatchWithRetry(
            retryableUsers.map(u => ({ id: u.id, fcmToken: u.fcmToken })),
            basePayload,
            messageId,
            attempt + 1
          );

          result.deliveredCount += retryResult.deliveredCount;
          result.failedCount = result.failedCount - retryableUsers.length + retryResult.failedCount;
          result.retryCount += retryResult.retryCount;
          result.errors.push(...retryResult.errors);
        }
      }
    }

  } catch (error) {
    console.error(`Batch sending failed (attempt ${attempt}):`, error);
    result.failedCount = users.length;
    result.errors.push(`Batch error: ${error instanceof Error ? error.message : 'Unknown error'}`);
    
    // Track all as failed
    await trackFailedDeliveries(
      users.map(u => ({ ...u, error: 'batch-send-error' })),
      messageId
    );

    // Retry on network/temporary errors
    if (attempt < MAX_RETRY_ATTEMPTS && isRetryableError(error instanceof Error ? error.message : 'unknown')) {
      console.log(`Retrying entire batch (attempt ${attempt + 1})`);
      await delay(RETRY_DELAY_MS * attempt);
      return sendBatchWithRetry(users, basePayload, messageId, attempt + 1);
    }
  }

  result.success = result.failedCount === 0;
  return result;
}

/**
 * Create FCM payload from message data
 */
function createFCMPayload(messageData: any, messageId: string): any {
  const payload: any = {
    notification: {
      title: messageData.title,
      body: messageData.content,
    },
    data: {
      messageId: messageId,
      type: messageData.type,
    },
    android: {
      notification: {
        channel_id: 'admin_broadcasts',
        priority: 'high',
      },
    },
    apns: {
      payload: {
        aps: {
          alert: {
            title: messageData.title,
            body: messageData.content,
          },
          sound: 'default',
        },
      },
    },
  };

  // Add media URLs if present
  if (messageData.imageUrl) {
    payload.notification.imageUrl = messageData.imageUrl;
    payload.data.imageUrl = messageData.imageUrl;
    payload.android.notification.imageUrl = messageData.imageUrl;
    payload.apns.fcm_options = { image: messageData.imageUrl };
  }

  if (messageData.videoUrl) {
    payload.data.videoUrl = messageData.videoUrl;
  }

  if (messageData.externalLink) {
    payload.data.externalLink = messageData.externalLink;
  }

  if (messageData.pollOptions) {
    payload.data.pollOptions = JSON.stringify(messageData.pollOptions);
  }

  return payload;
}

/**
 * Track successful delivery events in analytics
 */
async function trackDeliveryEvents(
  users: Array<{ id: string; fcmToken: string }>,
  messageId: string,
  event: string
): Promise<void> {
  const batch = firestore.batch();
  
  users.forEach(user => {
    const analyticsRef = firestore.collection('broadcast_analytics').doc();
    batch.set(analyticsRef, {
      messageId: messageId,
      userId: user.id,
      event: event,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
  });

  try {
    await batch.commit();
  } catch (error) {
    console.error('Failed to track delivery events:', error);
    // Don't throw - analytics failure shouldn't break delivery
  }
}

/**
 * Track failed delivery events in analytics
 */
async function trackFailedDeliveries(
  failedUsers: Array<{ id: string; fcmToken: string; error: string }>,
  messageId: string
): Promise<void> {
  const batch = firestore.batch();
  
  failedUsers.forEach(user => {
    const analyticsRef = firestore.collection('broadcast_analytics').doc();
    batch.set(analyticsRef, {
      messageId: messageId,
      userId: user.id,
      event: 'failed',
      error: user.error,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
  });

  try {
    await batch.commit();
  } catch (error) {
    console.error('Failed to track failed deliveries:', error);
  }
}

/**
 * Check if an error is retryable
 */
function isRetryableError(error: string): boolean {
  const retryableErrors = [
    'unavailable',
    'internal-error',
    'quota-exceeded',
    'timeout',
    'network-error',
    'batch-send-error',
  ];
  
  return retryableErrors.some(retryableError => 
    error.toLowerCase().includes(retryableError)
  );
}

/**
 * Utility functions
 */
function chunkArray<T>(array: T[], size: number): T[][] {
  const chunks: T[][] = [];
  for (let i = 0; i < array.length; i += size) {
    chunks.push(array.slice(i, i + size));
  }
  return chunks;
}

function delay(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}