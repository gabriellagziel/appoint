import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore();

// Ambassador notification types
export enum AmbassadorNotificationType {
  PROMOTION = 'ambassador_promotion',
  TIER_UPGRADE = 'tier_upgrade',
  MONTHLY_REMINDER = 'monthly_reminder',
  PERFORMANCE_WARNING = 'performance_warning',
  DEMOTION = 'ambassador_demotion',
  REFERRAL_SUCCESS = 'referral_success',
}

// Notification templates interface
interface NotificationTemplate {
  title: string;
  body: string;
  emailSubject?: string;
  emailBody?: string;
}

// Default English templates
const DEFAULT_TEMPLATES: Record<AmbassadorNotificationType, NotificationTemplate> = {
  [AmbassadorNotificationType.PROMOTION]: {
    title: "Congratulations! You're now an Ambassador!",
    body: "Welcome to the {tier} tier! Start sharing your referral link to earn rewards.",
    emailSubject: "Welcome to the Ambassador Program!",
    emailBody: "Congratulations! You've been promoted to {tier} Ambassador. Start sharing your referral link and earn amazing rewards."
  },
  [AmbassadorNotificationType.TIER_UPGRADE]: {
    title: "Tier Upgrade! 🎉",
    body: "Amazing! You've been upgraded from {previousTier} to {newTier} with {totalReferrals} referrals!",
    emailSubject: "Ambassador Tier Upgrade - {newTier}",
    emailBody: "Fantastic news! You've been upgraded to {newTier} Ambassador with {totalReferrals} total referrals. Keep up the great work!"
  },
  [AmbassadorNotificationType.MONTHLY_REMINDER]: {
    title: "Monthly Goal Reminder",
    body: "You have {currentReferrals}/{targetReferrals} referrals this month. {daysRemaining} days left to reach your goal!",
    emailSubject: "Monthly Ambassador Goal Reminder",
    emailBody: "You're doing great! You currently have {currentReferrals} out of {targetReferrals} referrals this month. Just {daysRemaining} days left to reach your goal."
  },
  [AmbassadorNotificationType.PERFORMANCE_WARNING]: {
    title: "Ambassador Performance Alert",
    body: "Your monthly referrals ({currentReferrals}) are below the minimum requirement ({minimumRequired}). Your ambassador status may be affected.",
    emailSubject: "Important: Ambassador Status Alert",
    emailBody: "We notice your monthly referrals ({currentReferrals}) are below our minimum requirement ({minimumRequired}). To maintain your ambassador status, please increase your activity."
  },
  [AmbassadorNotificationType.DEMOTION]: {
    title: "Ambassador Status Update",
    body: "Your ambassador status has been temporarily suspended due to: {reason}. You can regain your status by meeting the requirements again.",
    emailSubject: "Ambassador Status Update",
    emailBody: "Your ambassador status has been temporarily suspended due to: {reason}. Don't worry - you can regain your status by meeting our requirements again."
  },
  [AmbassadorNotificationType.REFERRAL_SUCCESS]: {
    title: "New Referral! 🎉",
    body: "{referredUserName} joined through your referral! You now have {totalReferrals} total referrals.",
    emailSubject: "New Referral Success!",
    emailBody: "Great news! {referredUserName} has joined through your referral link. You now have {totalReferrals} total referrals."
  }
};

// Interface for notification data
interface NotificationData {
  userId: string;
  type: AmbassadorNotificationType;
  languageCode: string;
  data: Record<string, string>;
  sendPush?: boolean;
  sendEmail?: boolean;
  sendInApp?: boolean;
}

/**
 * Send Ambassador notification to a user
 */
export const sendAmbassadorNotification = functions.https.onCall(async (notificationData: NotificationData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  try {
    const { userId, type, languageCode, data, sendPush = true, sendEmail = false, sendInApp = true } = notificationData;

    // Get user document for FCM token and email
    const userDoc = await db.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'User not found');
    }

    const userData = userDoc.data()!;
    const fcmToken = userData.fcmToken;
    const email = userData.email;

    // Get localized templates
    const templates = await getLocalizedTemplates(type, languageCode);
    
    // Replace placeholders in templates
    const processedTemplates = replacePlaceholders(templates, data);

    const results = {
      pushSent: false,
      emailSent: false,
      inAppSent: false,
    };

    // Send push notification
    if (sendPush && fcmToken) {
      try {
        await admin.messaging().send({
          token: fcmToken,
          notification: {
            title: processedTemplates.title,
            body: processedTemplates.body,
          },
          data: {
            type: type,
            action: 'open_ambassador_dashboard',
            ...data,
          },
          android: {
            priority: 'high',
            notification: {
              channelId: getNotificationChannel(type),
              priority: 'high',
            },
          },
          apns: {
            payload: {
              aps: {
                alert: {
                  title: processedTemplates.title,
                  body: processedTemplates.body,
                },
                sound: 'default',
                badge: 1,
              },
            },
          },
        });
        results.pushSent = true;
      } catch (error) {
        console.error('Error sending push notification:', error);
      }
    }

    // Send email notification
    if (sendEmail && email && processedTemplates.emailSubject && processedTemplates.emailBody) {
      try {
        // Use Sendgrid, Mailgun, or other email service
        await sendEmailNotification(email, processedTemplates.emailSubject, processedTemplates.emailBody);
        results.emailSent = true;
      } catch (error) {
        console.error('Error sending email notification:', error);
      }
    }

    // Store in-app notification
    if (sendInApp) {
      try {
        await db.collection('notifications').add({
          userId: userId,
          type: type,
          title: processedTemplates.title,
          body: processedTemplates.body,
          data: data,
          isRead: false,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          expiresAt: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)), // 30 days
        });
        results.inAppSent = true;
      } catch (error) {
        console.error('Error storing in-app notification:', error);
      }
    }

    // Log notification
    await db.collection('ambassador_notification_logs').add({
      userId: userId,
      type: type,
      languageCode: languageCode,
      title: processedTemplates.title,
      body: processedTemplates.body,
      results: results,
      sentAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return results;

  } catch (error) {
    console.error('Error sending ambassador notification:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send notification');
  }
});

/**
 * Scheduled function to send monthly reminders
 */
export const sendMonthlyReminders = functions.pubsub
  .schedule('0 10 * * *') // Run daily at 10 AM
  .timeZone('UTC')
  .onRun(async (context) => {
    console.log('Starting monthly reminder check...');
    
    try {
      const now = new Date();
      const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);
      const daysUntilEndOfMonth = Math.ceil((endOfMonth.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));
      
      // Only send reminders 5 days before month end
      if (daysUntilEndOfMonth !== 5) {
        console.log(`Not time for monthly reminders. ${daysUntilEndOfMonth} days until month end.`);
        return null;
      }
      
      const ambassadors = await db.collection('ambassador_profiles')
        .where('status', '==', 'approved')
        .get();
      
      let sentCount = 0;
      
      for (const doc of ambassadors.docs) {
        const profile = doc.data();
        
        // Only send reminder if they have less than 10 referrals this month
        if (profile.monthlyReferrals < 10) {
          await sendAmbassadorNotification({
            userId: profile.userId,
            type: AmbassadorNotificationType.MONTHLY_REMINDER,
            languageCode: profile.languageCode || 'en',
            data: {
              currentReferrals: profile.monthlyReferrals.toString(),
              targetReferrals: '10',
              daysRemaining: daysUntilEndOfMonth.toString(),
            },
            sendPush: true,
            sendEmail: true,
            sendInApp: true,
          }, { auth: { uid: 'system' } } as any);
          
          sentCount++;
        }
      }
      
      console.log(`Monthly reminder check completed. Sent ${sentCount} reminders.`);
      return null;
      
    } catch (error) {
      console.error('Error in monthly reminder job:', error);
      throw error;
    }
  });

/**
 * Get localized notification templates
 */
async function getLocalizedTemplates(type: AmbassadorNotificationType, languageCode: string): Promise<NotificationTemplate> {
  try {
    const doc = await db.collection('notification_templates')
      .doc(`ambassador_notifications_${languageCode}`)
      .get();
    
    if (doc.exists) {
      const templates = doc.data()!;
      return {
        title: templates[`${type}Title`] || DEFAULT_TEMPLATES[type].title,
        body: templates[`${type}Body`] || DEFAULT_TEMPLATES[type].body,
        emailSubject: templates[`${type}EmailSubject`] || DEFAULT_TEMPLATES[type].emailSubject,
        emailBody: templates[`${type}EmailBody`] || DEFAULT_TEMPLATES[type].emailBody,
      };
    }
  } catch (error) {
    console.error('Error loading localized templates:', error);
  }
  
  // Fallback to default English templates
  return DEFAULT_TEMPLATES[type];
}

/**
 * Replace placeholders in template strings
 */
function replacePlaceholders(template: NotificationTemplate, data: Record<string, string>): NotificationTemplate {
  const processTemplate = (text: string): string => {
    let processed = text;
    for (const [key, value] of Object.entries(data)) {
      processed = processed.replace(new RegExp(`{${key}}`, 'g'), value);
    }
    return processed;
  };

  return {
    title: processTemplate(template.title),
    body: processTemplate(template.body),
    emailSubject: template.emailSubject ? processTemplate(template.emailSubject) : undefined,
    emailBody: template.emailBody ? processTemplate(template.emailBody) : undefined,
  };
}

/**
 * Get notification channel based on type
 */
function getNotificationChannel(type: AmbassadorNotificationType): string {
  switch (type) {
    case AmbassadorNotificationType.PROMOTION:
    case AmbassadorNotificationType.TIER_UPGRADE:
    case AmbassadorNotificationType.REFERRAL_SUCCESS:
      return 'ambassador_promotion';
    case AmbassadorNotificationType.PERFORMANCE_WARNING:
    case AmbassadorNotificationType.DEMOTION:
      return 'ambassador_performance';
    case AmbassadorNotificationType.MONTHLY_REMINDER:
      return 'ambassador_monthly_reminder';
    default:
      return 'default';
  }
}

/**
 * Send email notification with App-Oint branding
 */
async function sendEmailNotification(email: string, subject: string, body: string): Promise<void> {
  // Wrap email body with App-Oint branding template
  const emailHtml = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>${subject}</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
      <!-- App-Oint Header -->
      <div style="text-align: center; margin-bottom: 30px; padding: 20px; background: #f8f9fa; border-radius: 8px;">
        <img src="https://app-oint.com/assets/logo-app-oint.svg" alt="App-Oint Logo" style="height: 40px; margin-bottom: 10px;">
        <div style="font-size: 24px; font-weight: bold; color: #1576d4;">APP-OINT</div>
        <div style="font-size: 14px; color: #666; margin-top: 5px;">Time Organized • Set Send Done</div>
      </div>
      
      <!-- Email Content -->
      <div style="margin-bottom: 40px;">
        ${body}
      </div>
      
      <!-- App-Oint Footer Branding (Required) -->
      <div style="text-align: center; font-size: 13px; color: #888; border-top: 1px solid #eee; padding-top: 20px; margin-top: 30px;">
        <img src="https://app-oint.com/assets/logo-app-oint.svg" alt="App-Oint Logo" style="height: 20px; vertical-align: middle; margin-right: 6px;">
        Powered by <a href="https://app-oint.com" style="color: #1576d4; text-decoration: none; font-weight: bold;">App-Oint</a>
      </div>
    </body>
    </html>
  `;

  // Placeholder for email service integration
  // In production, integrate with SendGrid, Mailgun, or similar
  console.log(`Email notification sent to ${email}: ${subject}`);
  
  // Example with SendGrid (uncomment and configure):
  /*
  const sgMail = require('@sendgrid/mail');
  sgMail.setApiKey(functions.config().sendgrid.api_key);
  
  const msg = {
    to: email,
    from: 'noreply@app-oint.com',
    subject: subject,
    html: emailHtml,
  };
  
  await sgMail.send(msg);
  */
}

/**
 * Convenience functions for specific notification types
 */
export async function sendPromotionNotification(userId: string, languageCode: string, tier: string): Promise<void> {
  await sendAmbassadorNotification({
    userId,
    type: AmbassadorNotificationType.PROMOTION,
    languageCode,
    data: { tier },
    sendPush: true,
    sendEmail: true,
    sendInApp: true,
  }, { auth: { uid: 'system' } } as any);
}

export async function sendTierUpgradeNotification(
  userId: string, 
  languageCode: string, 
  previousTier: string, 
  newTier: string, 
  totalReferrals: number
): Promise<void> {
  await sendAmbassadorNotification({
    userId,
    type: AmbassadorNotificationType.TIER_UPGRADE,
    languageCode,
    data: { 
      previousTier, 
      newTier, 
      totalReferrals: totalReferrals.toString() 
    },
    sendPush: true,
    sendEmail: true,
    sendInApp: true,
  }, { auth: { uid: 'system' } } as any);
}

export async function REDACTED_TOKEN(
  userId: string, 
  languageCode: string, 
  currentReferrals: number, 
  minimumRequired: number
): Promise<void> {
  await sendAmbassadorNotification({
    userId,
    type: AmbassadorNotificationType.PERFORMANCE_WARNING,
    languageCode,
    data: { 
      currentReferrals: currentReferrals.toString(), 
      minimumRequired: minimumRequired.toString() 
    },
    sendPush: true,
    sendEmail: true,
    sendInApp: true,
  }, { auth: { uid: 'system' } } as any);
}

export async function sendDemotionNotification(
  userId: string, 
  languageCode: string, 
  reason: string
): Promise<void> {
  await sendAmbassadorNotification({
    userId,
    type: AmbassadorNotificationType.DEMOTION,
    languageCode,
    data: { reason },
    sendPush: true,
    sendEmail: true,
    sendInApp: true,
  }, { auth: { uid: 'system' } } as any);
}

export async function sendReferralSuccessNotification(
  userId: string, 
  languageCode: string, 
  referredUserName: string, 
  totalReferrals: number
): Promise<void> {
  await sendAmbassadorNotification({
    userId,
    type: AmbassadorNotificationType.REFERRAL_SUCCESS,
    languageCode,
    data: { 
      referredUserName, 
      totalReferrals: totalReferrals.toString() 
    },
    sendPush: true,
    sendEmail: false, // Usually don't email for every referral
    sendInApp: true,
  }, { auth: { uid: 'system' } } as any);
}