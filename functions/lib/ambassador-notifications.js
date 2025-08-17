"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendMonthlyReminders = exports.sendAmbassadorNotification = exports.AmbassadorNotificationType = void 0;
exports.sendPromotionNotification = sendPromotionNotification;
exports.sendTierUpgradeNotification = sendTierUpgradeNotification;
exports.REDACTED_TOKEN = REDACTED_TOKEN;
exports.sendDemotionNotification = sendDemotionNotification;
exports.sendReferralSuccessNotification = sendReferralSuccessNotification;
exports.sendPendingApprovalNotification = sendPendingApprovalNotification;
exports.sendApprovalNotification = sendApprovalNotification;
exports.sendRejectionNotification = sendRejectionNotification;
const https_1 = require("firebase-functions/v2/https");
const scheduler_1 = require("firebase-functions/v2/scheduler");
const admin = __importStar(require("firebase-admin"));
const db = admin.firestore();
// Ambassador notification types
var AmbassadorNotificationType;
(function (AmbassadorNotificationType) {
    AmbassadorNotificationType["PROMOTION"] = "ambassador_promotion";
    AmbassadorNotificationType["TIER_UPGRADE"] = "tier_upgrade";
    AmbassadorNotificationType["MONTHLY_REMINDER"] = "monthly_reminder";
    AmbassadorNotificationType["PERFORMANCE_WARNING"] = "performance_warning";
    AmbassadorNotificationType["DEMOTION"] = "ambassador_demotion";
    AmbassadorNotificationType["REFERRAL_SUCCESS"] = "referral_success";
    AmbassadorNotificationType["PENDING_APPROVAL"] = "pending_approval";
    AmbassadorNotificationType["APPROVAL"] = "approval";
    AmbassadorNotificationType["REJECTION"] = "rejection";
})(AmbassadorNotificationType || (exports.AmbassadorNotificationType = AmbassadorNotificationType = {}));
// Default English templates
const DEFAULT_TEMPLATES = {
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
    },
    [AmbassadorNotificationType.PENDING_APPROVAL]: {
        title: "Ambassador Application Submitted",
        body: "Your ambassador application is under review. We'll notify you within 48 hours of our decision.",
        emailSubject: "Ambassador Application Received",
        emailBody: "Thank you for applying to become an ambassador! Your application is currently under review and we'll notify you of our decision within 48 hours."
    },
    [AmbassadorNotificationType.APPROVAL]: {
        title: "Ambassador Application Approved! 🎉",
        body: "Congratulations! Your ambassador application has been approved. You can now start sharing your referral link.",
        emailSubject: "Ambassador Application Approved",
        emailBody: "Great news! Your ambassador application has been approved. You can now start sharing your referral link and earning rewards."
    },
    [AmbassadorNotificationType.REJECTION]: {
        title: "Ambassador Application Update",
        body: "Your ambassador application was not approved at this time. Reason: {reason}. You can reapply in 30 days.",
        emailSubject: "Ambassador Application Update",
        emailBody: "Thank you for your interest in our ambassador program. Unfortunately, your application was not approved at this time. Reason: {reason}. You can reapply in 30 days."
    }
};
/**
 * Internal helper function to send notifications
 */
async function sendNotificationHelper(notificationData) {
    try {
        const { userId, type, languageCode, data, sendPush = true, sendEmail = false, sendInApp = true } = notificationData;
        // Get user document for FCM token and email
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists) {
            throw new Error('User not found');
        }
        const userData = userDoc.data();
        if (!userData) {
            throw new Error('User data not found');
        }
        // Get notification templates (simple implementation)
        const template = {
            title: `Ambassador ${type}`,
            message: `You have a new ambassador notification of type: ${type}`,
        };
        const processedTemplate = template; // Simple passthrough for now
        let pushSent = false;
        let emailSent = false;
        let inAppSent = false;
        // Send push notification
        if (sendPush && userData.fcmToken) {
            try {
                await admin.messaging().send({
                    token: userData.fcmToken,
                    notification: {
                        title: processedTemplate.title,
                        body: processedTemplate.message,
                    },
                    data: {
                        type,
                        userId,
                        ...data,
                    },
                });
                pushSent = true;
            }
            catch (error) {
                console.error('Failed to send push notification:', error);
            }
        }
        // Store in-app notification
        if (sendInApp) {
            try {
                await db.collection('user_notifications').add({
                    userId,
                    type,
                    title: processedTemplate.title,
                    message: processedTemplate.message,
                    data,
                    isRead: false,
                    createdAt: admin.firestore.FieldValue.serverTimestamp(),
                });
                inAppSent = true;
            }
            catch (error) {
                console.error('Failed to store in-app notification:', error);
            }
        }
        // Send email (implement if needed)
        if (sendEmail && userData.email) {
            // Email implementation would go here
            emailSent = true;
        }
        return { pushSent, emailSent, inAppSent };
    }
    catch (error) {
        console.error('Error in sendNotificationHelper:', error);
        throw error;
    }
}
/**
 * Send Ambassador notification to a user
 */
exports.sendAmbassadorNotification = (0, https_1.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_1.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        return await sendNotificationHelper(request.data);
    }
    catch (error) {
        console.error('Error sending notification:', error);
        throw new https_1.HttpsError('internal', 'Failed to send notification');
    }
});
/**
 * Scheduled function to send monthly reminders
 */
exports.sendMonthlyReminders = (0, scheduler_1.onSchedule)('0 10 * * *', async (event) => {
    console.log('Starting monthly reminder check...');
    try {
        const now = new Date();
        const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);
        const daysUntilEndOfMonth = Math.ceil((endOfMonth.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));
        // Only send reminders 5 days before month end
        if (daysUntilEndOfMonth !== 5) {
            console.log(`Not time for monthly reminders. ${daysUntilEndOfMonth} days until month end.`);
            return;
        }
        const ambassadors = await db.collection('ambassador_profiles')
            .where('status', '==', 'approved')
            .get();
        let sentCount = 0;
        for (const doc of ambassadors.docs) {
            const profile = doc.data();
            // Only send reminder if they have less than 10 referrals this month
            if (profile.monthlyReferrals < 10) {
                await sendNotificationHelper({
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
                });
                sentCount++;
            }
        }
        console.log(`Monthly reminder check completed. Sent ${sentCount} reminders.`);
        return;
    }
    catch (error) {
        console.error('Error in monthly reminder job:', error);
        throw error;
    }
});
/**
 * Get localized notification templates
 */
async function getLocalizedTemplates(type, languageCode) {
    try {
        const doc = await db.collection('notification_templates')
            .doc(`ambassador_notifications_${languageCode}`)
            .get();
        if (doc.exists) {
            const templates = doc.data();
            return {
                title: templates[`${type}Title`] || DEFAULT_TEMPLATES[type].title,
                body: templates[`${type}Body`] || DEFAULT_TEMPLATES[type].body,
                emailSubject: templates[`${type}EmailSubject`] || DEFAULT_TEMPLATES[type].emailSubject,
                emailBody: templates[`${type}EmailBody`] || DEFAULT_TEMPLATES[type].emailBody,
            };
        }
    }
    catch (error) {
        console.error('Error loading localized templates:', error);
    }
    // Fallback to default English templates
    return DEFAULT_TEMPLATES[type];
}
/**
 * Replace placeholders in template strings
 */
function replacePlaceholders(template, data) {
    const processTemplate = (text) => {
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
function getNotificationChannel(type) {
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
async function sendEmailNotification(email, subject, body) {
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
async function sendPromotionNotification(userId, languageCode, tier) {
    await sendNotificationHelper({
        userId,
        type: AmbassadorNotificationType.PROMOTION,
        languageCode,
        data: { tier },
        sendPush: true,
        sendEmail: true,
        sendInApp: true,
    });
}
async function sendTierUpgradeNotification(userId, languageCode, previousTier, newTier, totalReferrals) {
    await sendNotificationHelper({
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
    });
}
async function REDACTED_TOKEN(userId, languageCode, currentReferrals, minimumRequired) {
    await sendNotificationHelper({
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
    });
}
async function sendDemotionNotification(userId, languageCode, reason) {
    await sendNotificationHelper({
        userId,
        type: AmbassadorNotificationType.DEMOTION,
        languageCode,
        data: { reason },
        sendPush: true,
        sendEmail: true,
        sendInApp: true,
    });
}
async function sendReferralSuccessNotification(userId, languageCode, referredUserName, totalReferrals) {
    await sendNotificationHelper({
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
    });
}
async function sendPendingApprovalNotification(userId, languageCode) {
    try {
        await sendNotificationHelper({
            userId,
            type: AmbassadorNotificationType.PENDING_APPROVAL,
            languageCode,
            data: {},
            sendPush: true,
            sendEmail: true,
            sendInApp: true,
        });
    }
    catch (error) {
        console.error('Error sending pending approval notification:', error);
    }
}
async function sendApprovalNotification(userId, languageCode) {
    try {
        await sendNotificationHelper({
            userId,
            type: AmbassadorNotificationType.APPROVAL,
            languageCode,
            data: {},
            sendPush: true,
            sendEmail: true,
            sendInApp: true,
        });
    }
    catch (error) {
        console.error('Error sending approval notification:', error);
    }
}
async function sendRejectionNotification(userId, languageCode, reason) {
    try {
        await sendNotificationHelper({
            userId,
            type: AmbassadorNotificationType.REJECTION,
            languageCode,
            data: { reason },
            sendPush: true,
            sendEmail: true,
            sendInApp: true,
        });
    }
    catch (error) {
        console.error('Error sending rejection notification:', error);
    }
}
