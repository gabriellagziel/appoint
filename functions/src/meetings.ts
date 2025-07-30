import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';

const db = admin.firestore();

// Types
interface MeetingParticipant {
  userId: string;
  name: string;
  email?: string;
  avatarUrl?: string;
  role: 'organizer' | 'admin' | 'participant';
  hasResponded: boolean;
  willAttend: boolean;
  respondedAt?: any;
}

interface Meeting {
  id: string;
  organizerId: string;
  title: string;
  description?: string;
  startTime: any;
  endTime: any;
  location?: string;
  virtualMeetingUrl?: string;
  participants: MeetingParticipant[];
  status: 'draft' | 'scheduled' | 'active' | 'completed' | 'cancelled';
  createdAt: any;
  updatedAt: any;
  customFormId?: string;
  checklistId?: string;
  groupChatId?: string;
  eventSettings?: any;
  businessProfileId?: string;
  isRecurring?: boolean;
  recurringPattern?: string;
}

// Business Logic Functions
function getMeetingType(participants: MeetingParticipant[]): 'personal' | 'event' {
  const totalParticipants = participants.length + 1; // +1 for organizer
  return totalParticipants >= 4 ? 'event' : 'personal';
}

function validateMeetingBusinessRules(meeting: Meeting): string | null {
  const totalParticipants = meeting.participants.length + 1; // +1 for organizer
  
  if (totalParticipants < 2) {
    return 'Meeting must have at least one participant besides the organizer';
  }
  
  const meetingType = getMeetingType(meeting.participants);
  
  // Event-only features validation
  if (meetingType === 'personal') {
    if (meeting.customFormId) {
      return 'Custom forms are only available for events (4+ participants)';
    }
    if (meeting.checklistId) {
      return 'Checklists are only available for events (4+ participants)';
    }
    if (meeting.groupChatId) {
      return 'Group chat is only available for events (4+ participants)';
    }
  }
  
  return null;
}

function canAccessEventFeatures(meeting: Meeting, userId: string): boolean {
  const meetingType = getMeetingType(meeting.participants);
  if (meetingType !== 'event') return false;
  
  // Organizer can access
  if (meeting.organizerId === userId) return true;
  
  // Admin participants can access
  const participant = meeting.participants.find(p => p.userId === userId);
  return participant?.role === 'admin';
}

// Cloud Functions

// Firestore trigger for meeting validation
export const onMeetingWrite = functions.firestore.onDocumentWritten(
  'meetings/{meetingId}',
  async (event) => {
    const meetingId = event.params.meetingId;
    
    // Handle deletion
    if (!event.data?.after?.exists) {
      console.log(`Meeting ${meetingId} was deleted`);
      return;
    }
    
    const meeting = event.data?.after?.data() as Meeting;
    const previousMeeting = event.data?.before?.exists ? event.data?.before?.data() as Meeting : null;
    
    // Validate business rules
    const validationError = validateMeetingBusinessRules(meeting);
    if (validationError) {
      console.error(`Meeting validation failed for ${meetingId}: ${validationError}`);
      // In a real implementation, you might want to revert the change or notify admins
      return;
    }
    
    // Check if meeting type changed
    const currentType = getMeetingType(meeting.participants);
    const previousType = previousMeeting ? getMeetingType(previousMeeting.participants) : currentType;
    
    if (currentType !== previousType) {
      console.log(`Meeting ${meetingId} type changed from ${previousType} to ${currentType}`);
      
      // If changed from event to personal, clean up event features
      if (previousType === 'event' && currentType === 'personal') {
        await cleanupEventFeatures(meetingId, meeting);
      }
      
      // If changed from personal to event, initialize event features
      if (previousType === 'personal' && currentType === 'event') {
        await initializeEventFeatures(meetingId);
      }
      
      // Update analytics
      await updateMeetingTypeAnalytics(meeting.organizerId, currentType, previousType);
    }
    
    // Send notifications for participant changes
    if (previousMeeting) {
      await handleParticipantChanges(meeting, previousMeeting);
    }
  });

// HTTP function to validate meeting creation
export const validateMeetingCreation = functions.https.onCall(async (request) => {
  // Check authentication
  if (!request.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const userId = request.auth.uid;
  const { title, participants, startTime, endTime } = request.data;
  
  // Basic validation
  if (!title || !participants || !startTime || !endTime) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing required fields');
  }
  
  // Validate participant count
  const totalParticipants = participants.length + 1; // +1 for organizer
  if (totalParticipants < 2) {
    throw new functions.https.HttpsError('invalid-argument', 
      'Meeting must have at least one participant besides the organizer');
  }
  
  const meetingType = getMeetingType(participants);
  
  return {
    isValid: true,
    meetingType,
    totalParticipants,
    canUseEventFeatures: meetingType === 'event'
  };
});

// HTTP function to check event feature access
export const checkEventFeatureAccess = functions.https.onCall(async (request) => {
  if (!request.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const userId = request.auth.uid;
  const { meetingId, feature } = request.data;
  
  // Get meeting
  const meetingDoc = await db.collection('meetings').doc(meetingId).get();
  if (!meetingDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Meeting not found');
  }
  
  const meeting = meetingDoc.data() as Meeting;
  const meetingType = getMeetingType(meeting.participants);
  
  // Check if feature is event-only
  const eventOnlyFeatures = ['customForm', 'checklist', 'groupChat'];
  if (eventOnlyFeatures.includes(feature) && meetingType !== 'event') {
    return {
      hasAccess: false,
      reason: `${feature} is only available for events (4+ participants)`
    };
  }
  
  // Check user permissions for event features
  if (meetingType === 'event' && eventOnlyFeatures.includes(feature)) {
    const hasAccess = canAccessEventFeatures(meeting, userId);
    return {
      hasAccess,
      reason: hasAccess ? null : 'Only organizers and admins can access this feature'
    };
  }
  
  return { hasAccess: true, reason: null };
});

// HTTP function to get meeting analytics
export const getMeetingAnalytics = functions.https.onCall(async (request) => {
  if (!request.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const userId = request.auth.uid;
  const { startDate, endDate } = request.data;
  
  let query = db.collection('meetings').where('organizerId', '==', userId);
  
  if (startDate) {
    query = query.where('createdAt', '>=', admin.firestore.Timestamp.fromDate(new Date(startDate)));
  }
  if (endDate) {
    query = query.where('createdAt', '<=', admin.firestore.Timestamp.fromDate(new Date(endDate)));
  }
  
  const snapshot = await query.get();
  const meetings = snapshot.docs.map(doc => doc.data() as Meeting);
  
  const personalMeetings = meetings.filter(m => getMeetingType(m.participants) === 'personal');
  const events = meetings.filter(m => getMeetingType(m.participants) === 'event');
  
  return {
    totalMeetings: meetings.length,
    personalMeetings: personalMeetings.length,
    events: events.length,
    averageParticipantsPersonal: personalMeetings.length === 0 ? 0 : 
      personalMeetings.reduce((sum, m) => sum + m.participants.length + 1, 0) / personalMeetings.length,
    averageParticipantsEvents: events.length === 0 ? 0 : 
      events.reduce((sum, m) => sum + m.participants.length + 1, 0) / events.length,
    eventsWithForms: events.filter(e => e.customFormId).length,
    eventsWithChecklists: events.filter(e => e.checklistId).length,
    eventsWithGroupChat: events.filter(e => e.groupChatId).length
  };
});

// HTTP function to create event form (with validation)
export const createEventForm = functions.https.onCall(async (request) => {
  if (!request.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const userId = request.auth.uid;
  const { meetingId, title, description, fields } = request.data;
  
  // Get and validate meeting
  const meetingDoc = await db.collection('meetings').doc(meetingId).get();
  if (!meetingDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Meeting not found');
  }
  
  const meeting = meetingDoc.data() as Meeting;
  const meetingType = getMeetingType(meeting.participants);
  
  if (meetingType !== 'event') {
    throw new functions.https.HttpsError('failed-precondition', 
      'Custom forms are only available for events (4+ participants)');
  }
  
  if (!canAccessEventFeatures(meeting, userId)) {
    throw new functions.https.HttpsError('permission-denied', 
      'Only event organizers and admins can create forms');
  }
  
  // Create form
  const formRef = db.collection('eventForms').doc();
  const form = {
    id: formRef.id,
    meetingId,
    title,
    description,
    fields: fields || [],
    isActive: true,
    allowAnonymousSubmissions: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    createdBy: userId
  };
  
  await formRef.set(form);
  
  // Update meeting with form reference
  await db.collection('meetings').doc(meetingId).update({
    customFormId: formRef.id,
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  });
  
  return { formId: formRef.id };
});

// Scheduled function to clean up expired meetings
export const cleanupExpiredMeetings = functions.scheduler.onSchedule(
  'every 24 hours',
  async (event) => {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - 30); // 30 days ago
    
    const expiredMeetings = await db.collection('meetings')
      .where('endTime', '<', admin.firestore.Timestamp.fromDate(cutoffDate))
      .where('status', 'in', ['completed', 'cancelled'])
      .get();
    
    const batch = db.batch();
    let count = 0;
    
    for (const doc of expiredMeetings.docs) {
      const meeting = doc.data() as Meeting;
      
      // Clean up associated event features
      if (meeting.customFormId) {
        batch.delete(db.collection('eventForms').doc(meeting.customFormId));
      }
      if (meeting.checklistId) {
        batch.delete(db.collection('eventChecklists').doc(meeting.checklistId));
      }
      
      // Archive or delete the meeting
      batch.delete(doc.ref);
      count++;
      
      if (count % 500 === 0) {
        await batch.commit();
      }
    }
    
    if (count > 0) {
      await batch.commit();
      console.log(`Cleaned up ${count} expired meetings`);
    }
  });

// Helper functions
async function cleanupEventFeatures(meetingId: string, meeting: Meeting) {
  const batch = db.batch();
  
  // Remove event-specific fields from meeting
  const meetingRef = db.collection('meetings').doc(meetingId);
  batch.update(meetingRef, {
    customFormId: admin.firestore.FieldValue.delete(),
    checklistId: admin.firestore.FieldValue.delete(),
    groupChatId: admin.firestore.FieldValue.delete(),
    eventSettings: admin.firestore.FieldValue.delete(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  });
  
  // Delete associated event resources
  if (meeting.customFormId) {
    batch.delete(db.collection('eventForms').doc(meeting.customFormId));
  }
  if (meeting.checklistId) {
    batch.delete(db.collection('eventChecklists').doc(meeting.checklistId));
  }
  
  await batch.commit();
  console.log(`Cleaned up event features for meeting ${meetingId}`);
}

async function initializeEventFeatures(meetingId: string) {
  const eventSettings = {
    requiresRegistration: false,
    allowWaitlist: false,
    enableGroupChat: true,
    allowParticipantInvites: false,
    moderateChat: false,
    isPublic: false,
    allowPublicRegistration: false,
    sendReminders: true,
    reminderHours: [24, 1],
    allowRecording: false,
    enableSharedNotes: false
  };
  
  await db.collection('meetings').doc(meetingId).update({
    eventSettings,
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  });
  
  console.log(`Initialized event features for meeting ${meetingId}`);
}

async function updateMeetingTypeAnalytics(userId: string, newType: string, oldType: string) {
  const analyticsRef = db.collection('analytics').doc(`meeting_types_${userId}`);
  
  await db.runTransaction(async (transaction) => {
    const doc = await transaction.get(analyticsRef);
    const data = doc.exists ? doc.data() : {};
    
    const increment = admin.firestore.FieldValue.increment(1);
    const decrement = admin.firestore.FieldValue.increment(-1);
    
    const updates: any = {
      [`${newType}Count`]: increment,
      lastUpdated: admin.firestore.FieldValue.serverTimestamp()
    };
    
    if (oldType !== newType) {
      updates[`${oldType}Count`] = decrement;
      updates.typeChanges = increment;
    }
    
    transaction.set(analyticsRef, updates, { merge: true });
  });
}

async function handleParticipantChanges(currentMeeting: Meeting, previousMeeting: Meeting) {
  const currentParticipantIds = new Set(currentMeeting.participants.map(p => p.userId));
  const previousParticipantIds = new Set(previousMeeting.participants.map(p => p.userId));
  
  // Find added participants
  const addedParticipants = currentMeeting.participants.filter(
    p => !previousParticipantIds.has(p.userId)
  );
  
  // Find removed participants
  const removedParticipantIds = Array.from(previousParticipantIds).filter(
    id => !currentParticipantIds.has(id)
  );
  
  // Send notifications to added participants
  for (const participant of addedParticipants) {
    await sendNotificationToUser(
      participant.userId,
      'Meeting Invitation',
      `You have been added to ${currentMeeting.title}`
    );
  }
  
  // Log removals (could send notifications to removed participants if needed)
  if (removedParticipantIds.length > 0) {
    console.log(`Removed participants from meeting ${currentMeeting.id}:`, removedParticipantIds);
  }
}

async function sendNotificationToUser(userId: string, title: string, body: string) {
  // This would integrate with your existing notification system
  console.log(`Notification to ${userId}: ${title} - ${body}`);
  // Implementation would depend on your notification service
}