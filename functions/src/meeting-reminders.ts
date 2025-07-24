import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

interface MeetingDetails {
  id: string;
  title: string;
  scheduledAt: admin.firestore.Timestamp;
  endTime: admin.firestore.Timestamp;
  participants: MeetingParticipant[];
  location?: Location;
  isLocationTrackingEnabled: boolean;
  reminderMinutes: number;
  type: 'oneOnOne' | 'group' | 'event';
  chatId?: string;
}

interface MeetingParticipant {
  userId: string;
  email: string;
  displayName: string;
  status: 'pending' | 'confirmed' | 'declined' | 'late' | 'arrived';
  role: 'host' | 'coHost' | 'participant';
  isRunningLate: boolean;
  currentLocation?: Location;
  estimatedArrival?: admin.firestore.Timestamp;
}

interface Location {
  latitude: number;
  longitude: number;
  address?: string;
}

/**
 * Scheduled function: Check locations for upcoming meetings every 15 minutes
 */
export const checkMeetingLocations = functions.pubsub
  .schedule('every 15 minutes')
  .onRun(async (context) => {
    console.log('Starting meeting location check...');
    
    const now = admin.firestore.Timestamp.now();
    const oneHourFromNow = admin.firestore.Timestamp.fromMillis(
      now.toMillis() + (60 * 60 * 1000)
    );
    
    try {
      // Get meetings starting in the next hour with location tracking enabled
      const meetingsQuery = await db
        .collection('meetings')
        .where('scheduledAt', '>', now)
        .where('scheduledAt', '<', oneHourFromNow)
        .where('isLocationTrackingEnabled', '==', true)
        .get();

      let checkedCount = 0;
      let notificationsSent = 0;

      for (const doc of meetingsQuery.docs) {
        const meeting = { id: doc.id, ...doc.data() } as MeetingDetails;
        checkedCount++;

        // Check each confirmed participant
        for (const participant of meeting.participants) {
          if (participant.status === 'confirmed' && !participant.isRunningLate) {
            // Get user's current location from their profile or device
            const userDoc = await db.collection('users').doc(participant.userId).get();
            const userData = userDoc.data();
            
            if (userData?.currentLocation && meeting.location) {
              const willBeLate = await checkIfUserWillBeLate(
                userData.currentLocation,
                meeting.location,
                meeting.scheduledAt.toDate()
              );

              if (willBeLate) {
                await sendLateWarningNotification(meeting, participant);
                notificationsSent++;
              }
            }
          }
        }
      }

      console.log(`Meeting location check completed. Checked ${checkedCount} meetings, sent ${notificationsSent} warnings.`);
    } catch (error) {
      console.error('Error in meeting location check:', error);
    }
  });

/**
 * Scheduled function: Send meeting reminders
 */
export const sendMeetingReminders = functions.pubsub
  .schedule('every 5 minutes')
  .onRun(async (context) => {
    console.log('Starting meeting reminder check...');
    
    const now = admin.firestore.Timestamp.now();
    const fiveMinutesFromNow = admin.firestore.Timestamp.fromMillis(
      now.toMillis() + (5 * 60 * 1000)
    );
    
    try {
      // Get meetings with reminders due in the next 5 minutes
      const reminderQuery = await db
        .collection('meeting_reminders')
        .where('scheduledAt', '>', now)
        .where('scheduledAt', '<', fiveMinutesFromNow)
        .where('sent', '==', false)
        .get();

      let remindersSent = 0;

      for (const doc of reminderQuery.docs) {
        const reminder = doc.data();
        const meetingDoc = await db.collection('meetings').doc(reminder.meetingId).get();
        
        if (meetingDoc.exists) {
          const meeting = { id: meetingDoc.id, ...meetingDoc.data() } as MeetingDetails;
          await sendReminderNotification(meeting, reminder.userId);
          
          // Mark reminder as sent
          await doc.ref.update({ sent: true, sentAt: admin.firestore.FieldValue.serverTimestamp() });
          remindersSent++;
        }
      }

      console.log(`Meeting reminder check completed. Sent ${remindersSent} reminders.`);
    } catch (error) {
      console.error('Error in meeting reminder check:', error);
    }
  });

/**
 * Firestore trigger: Create reminders when a meeting is created
 */
export const onMeetingCreated = functions.firestore
  .document('meetings/{meetingId}')
  .onCreate(async (snap, context) => {
    const meeting = { id: snap.id, ...snap.data() } as MeetingDetails;
    
    try {
      await createMeetingReminders(meeting);
      console.log(`Created reminders for meeting: ${meeting.id}`);
    } catch (error) {
      console.error('Error creating meeting reminders:', error);
    }
  });

/**
 * Firestore trigger: Update chat when participant status changes
 */
export const onParticipantStatusChange = functions.firestore
  .document('meetings/{meetingId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data() as MeetingDetails;
    const after = change.after.data() as MeetingDetails;
    
    // Check for participant status changes
    const statusChanges = findParticipantStatusChanges(before.participants, after.participants);
    
    if (statusChanges.length > 0 && after.chatId) {
      for (const change of statusChanges) {
        await sendChatStatusUpdate(after.chatId, change);
      }
    }
  });

async function checkIfUserWillBeLate(
  currentLocation: Location, 
  meetingLocation: Location, 
  meetingTime: Date
): Promise<boolean> {
  // Calculate distance using Haversine formula
  const distance = calculateDistance(currentLocation, meetingLocation);
  
  // Estimate travel time (assuming average speed of 30 km/h for mixed transportation)
  const averageSpeedKmh = 30;
  const travelTimeMinutes = (distance / averageSpeedKmh) * 60;
  
  // Add buffer time (20% extra for safety)
  const bufferedTravelTime = travelTimeMinutes * 1.2;
  
  const timeUntilMeeting = (meetingTime.getTime() - Date.now()) / (1000 * 60); // minutes
  
  // Consider late if travel time is more than 80% of remaining time
  return bufferedTravelTime > (timeUntilMeeting * 0.8);
}

function calculateDistance(loc1: Location, loc2: Location): number {
  const R = 6371; // Earth's radius in kilometers
  const dLat = toRadians(loc2.latitude - loc1.latitude);
  const dLon = toRadians(loc2.longitude - loc1.longitude);
  
  const a = 
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRadians(loc1.latitude)) * Math.cos(toRadians(loc2.latitude)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
    
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

function toRadians(degrees: number): number {
  return degrees * (Math.PI / 180);
}

async function sendLateWarningNotification(meeting: MeetingDetails, participant: MeetingParticipant) {
  const payload = {
    notification: {
      title: "You might be late! ⏰",
      body: `Based on your location, you might be late for ${meeting.title}. Tap to update your status or get directions.`,
    },
    data: {
      type: 'late_warning',
      meetingId: meeting.id,
      action: 'show_late_options',
    },
  };

  // Get user's FCM token
  const userDoc = await db.collection('users').doc(participant.userId).get();
  const fcmToken = userDoc.data()?.fcmToken;
  
  if (fcmToken) {
    await admin.messaging().send({
      token: fcmToken,
      ...payload,
    });
  }
}

async function sendReminderNotification(meeting: MeetingDetails, userId: string) {
  const timeUntilMeeting = Math.round(
    (meeting.scheduledAt.toMillis() - Date.now()) / (1000 * 60)
  );

  const payload = {
    notification: {
      title: "Upcoming Meeting",
      body: `${meeting.title} starts in ${timeUntilMeeting} minutes`,
    },
    data: {
      type: 'meeting_reminder',
      meetingId: meeting.id,
      action: 'view_meeting',
    },
  };

  // Get user's FCM token
  const userDoc = await db.collection('users').doc(userId).get();
  const fcmToken = userDoc.data()?.fcmToken;
  
  if (fcmToken) {
    await admin.messaging().send({
      token: fcmToken,
      ...payload,
    });
  }
}

async function createMeetingReminders(meeting: MeetingDetails) {
  const reminderTime = new Date(meeting.scheduledAt.toMillis() - (meeting.reminderMinutes * 60 * 1000));
  
  // Create reminder documents for each participant
  const batch = db.batch();
  
  for (const participant of meeting.participants) {
    const reminderRef = db.collection('meeting_reminders').doc();
    batch.set(reminderRef, {
      meetingId: meeting.id,
      userId: participant.userId,
      scheduledAt: admin.firestore.Timestamp.fromDate(reminderTime),
      sent: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
  
  await batch.commit();
}

function findParticipantStatusChanges(
  beforeParticipants: MeetingParticipant[], 
  afterParticipants: MeetingParticipant[]
): Array<{participant: MeetingParticipant, oldStatus: string, newStatus: string}> {
  const changes: Array<{participant: MeetingParticipant, oldStatus: string, newStatus: string}> = [];
  
  afterParticipants.forEach(afterParticipant => {
    const beforeParticipant = beforeParticipants.find(p => p.userId === afterParticipant.userId);
    
    if (beforeParticipant && beforeParticipant.status !== afterParticipant.status) {
      changes.push({
        participant: afterParticipant,
        oldStatus: beforeParticipant.status,
        newStatus: afterParticipant.status,
      });
    }
  });
  
  return changes;
}

async function sendChatStatusUpdate(chatId: string, statusChange: any) {
  const { participant, newStatus } = statusChange;
  
  let message = '';
  switch (newStatus) {
    case 'confirmed':
      message = `${participant.displayName} confirmed attendance ✅`;
      break;
    case 'declined':
      message = `${participant.displayName} declined the meeting ❌`;
      break;
    case 'late':
      message = `${participant.displayName} is running late ⏰`;
      break;
    case 'arrived':
      message = `${participant.displayName} has arrived 🎉`;
      break;
    default:
      return;
  }
  
  // Add system message to chat
  await db.collection('chats').doc(chatId).collection('messages').add({
    type: 'system',
    content: message,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    senderId: 'system',
    metadata: {
      participantId: participant.userId,
      statusChange: newStatus,
    },
  });
}

/**
 * HTTP function: Get meeting analytics
 */
export const getMeetingAnalytics = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { userId, startDate, endDate } = data;
  
  if (context.auth.uid !== userId) {
    throw new functions.https.HttpsError('permission-denied', 'User can only access their own analytics');
  }

  try {
    const start = admin.firestore.Timestamp.fromDate(new Date(startDate));
    const end = admin.firestore.Timestamp.fromDate(new Date(endDate));
    
    const meetingsQuery = await db
      .collection('meetings')
      .where('participants', 'array-contains', { userId })
      .where('scheduledAt', '>=', start)
      .where('scheduledAt', '<=', end)
      .get();

    const analytics = {
      totalMeetings: meetingsQuery.size,
      attendedMeetings: 0,
      declinedMeetings: 0,
      lateMeetings: 0,
      averageDuration: 0,
      meetingTypes: { oneOnOne: 0, group: 0, event: 0 },
    };

    let totalDuration = 0;

    meetingsQuery.docs.forEach(doc => {
      const meeting = doc.data() as MeetingDetails;
      const userParticipant = meeting.participants.find(p => p.userId === userId);
      
      if (userParticipant) {
        if (userParticipant.status === 'confirmed' || userParticipant.status === 'arrived') {
          analytics.attendedMeetings++;
        } else if (userParticipant.status === 'declined') {
          analytics.declinedMeetings++;
        }
        
        if (userParticipant.isRunningLate) {
          analytics.lateMeetings++;
        }
      }
      
      const duration = meeting.endTime.toMillis() - meeting.scheduledAt.toMillis();
      totalDuration += duration;
      
      analytics.meetingTypes[meeting.type]++;
    });

    analytics.averageDuration = analytics.totalMeetings > 0 
      ? Math.round(totalDuration / analytics.totalMeetings / (1000 * 60)) // minutes
      : 0;

    return analytics;
  } catch (error) {
    console.error('Error getting meeting analytics:', error);
    throw new functions.https.HttpsError('internal', 'Failed to get meeting analytics');
  }
});

/**
 * HTTP function: Update user location
 */
export const updateUserLocation = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { latitude, longitude, address } = data;
  
  if (typeof latitude !== 'number' || typeof longitude !== 'number') {
    throw new functions.https.HttpsError('invalid-argument', 'Invalid location coordinates');
  }

  try {
    await db.collection('users').doc(context.auth.uid).update({
      currentLocation: {
        latitude,
        longitude,
        address: address || null,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
    });

    return { success: true };
  } catch (error) {
    console.error('Error updating user location:', error);
    throw new functions.https.HttpsError('internal', 'Failed to update location');
  }
});