import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { 
  validateInput, 
  createCheckoutSessionSchema, 
  cancelSubscriptionSchema, 
  sendNotificationToStudioSchema 
} from './validation';

admin.initializeApp();
const db = admin.firestore();

// FCM Push Notification for New Bookings
export const onNewBooking = functions.firestore
  .document('bookings/{bookingId}')
  .onCreate(async (snap, context) => {
    try {
      const booking = snap.data();
      const studioId = booking.studioId;
      const clientName = booking.clientName || booking.customerName || 'A client';
      const bookingId = context.params.bookingId;

      console.log(`New booking created: ${bookingId} for studio: ${studioId}`);

      // Get studio FCM token
      const studioDoc = await admin.firestore().collection('studio').doc(studioId).get();
      
      if (!studioDoc.exists) {
        console.log(`Studio ${studioId} not found`);
        return null;
      }

      const fcmToken = studioDoc.get('fcmToken');
      if (!fcmToken) {
        console.log(`No FCM token found for studio ${studioId}`);
        return null;
      }

      const payload = {
        notification: {
          title: 'New Booking',
          body: `New booking from ${clientName}`,
        },
        data: {
          bookingId: bookingId,
          studioId: studioId,
          type: 'new_booking',
          timestamp: Date.now().toString(),
        },
        android: {
          notification: {
            channelId: 'bookings',
            priority: 'high',
            defaultSound: true,
          },
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
            },
          },
        },
      };

      const response = await admin.messaging().sendToDevice(fcmToken, payload);
      console.log(`FCM notification sent to studio ${studioId}:`, response);
      
      return null;
    } catch (error) {
      console.error('Error sending FCM notification:', error);
      return null;
    }
  });

// Stripe Checkout Session Creation
export const createCheckoutSession = functions.https.onRequest(async (req, res) => {
  try {
    // Validate input data
    const validatedData = validateInput(createCheckoutSessionSchema, req.body);
    const { studioId, priceId, successUrl, cancelUrl, customerEmail } = validatedData;

    const stripe = require('stripe')(functions.config().stripe.secret_key);

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      mode: 'subscription',
      line_items: [{ price: priceId, quantity: 1 }],
      success_url: successUrl || `https://your-app.com/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: cancelUrl || `https://your-app.com/cancel`,
      metadata: { 
        studioId,
        type: 'subscription'
      },
      customer_email: customerEmail,
    });

    res.json({ url: session.url, sessionId: session.id });
  } catch (error) {
    console.error('Error creating checkout session:', error);
    res.status(500).json({ error: 'Failed to create checkout session' });
  }
});

// Stripe Webhook Handler
export const stripeWebhook = functions.https.onRequest(async (req, res) => {
  const stripe = require('stripe')(functions.config().stripe.secret_key);
  const sig = req.headers['stripe-signature'];
  const endpointSecret = functions.config().stripe.webhook_secret;

  let event;

  try {
    event = stripe.webhooks.constructEvent(req.rawBody, sig, endpointSecret);
  } catch (err) {
    console.error('Webhook signature verification failed:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  try {
    switch (event.type) {
      case 'checkout.session.completed':
        const session = event.data.object;
        const studioId = session.metadata.studioId;
        
        if (studioId) {
          await admin.firestore().collection('studio').doc(studioId).update({
            subscriptionStatus: 'active',
            subscriptionId: session.subscription,
            lastPaymentDate: admin.firestore.FieldValue.serverTimestamp(),
          });
          console.log(`Subscription activated for studio ${studioId}`);
        }
        break;

      case 'customer.subscription.deleted':
        const subscription = event.data.object;
        // Handle subscription cancellation
        console.log(`Subscription cancelled: ${subscription.id}`);
        break;

      default:
        console.log(`Unhandled event type: ${event.type}`);
    }

    res.json({ received: true });
  } catch (error) {
    console.error('Error processing webhook:', error);
    res.status(500).json({ error: 'Webhook processing failed' });
  }
});

// Cancel Subscription
export const cancelSubscription = functions.https.onCall(async (data, context) => {
  try {
    // Validate input data
    const validatedData = validateInput(cancelSubscriptionSchema, data);
    const { subscriptionId } = validatedData;

    const stripe = require('stripe')(functions.config().stripe.secret_key);

    // Cancel the subscription at period end
    const subscription = await stripe.subscriptions.update(subscriptionId, {
      cancel_at_period_end: true,
    });

    console.log(`Subscription ${subscriptionId} will be cancelled at period end`);

    return { success: true, subscription };
  } catch (error) {
    console.error('Error cancelling subscription:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to cancel subscription'
    );
  }
});

// Optional: Function to send notification to specific studio
export const sendNotificationToStudio = functions.https.onCall(async (data, context) => {
  try {
    // Validate input data
    const validatedData = validateInput(sendNotificationToStudioSchema, data);
    const { studioId, title, body, data: additionalData } = validatedData;

    // Get studio's FCM token
    const studioSnap = await db.collection('studio').doc(studioId).get();
    
    if (!studioSnap.exists) {
      throw new functions.https.HttpsError('not-found', 'Studio not found');
    }

    const studioData = studioSnap.data()!;
    const token = studioData.fcmToken;

    if (!token) {
      throw new functions.https.HttpsError('failed-precondition', 'No FCM token found for studio');
    }

    const message = {
      token: token,
      notification: {
        title: title,
        body: body,
      },
      data: additionalData || {},
    };

    const response = await admin.messaging().send(message);
    return { success: true, messageId: response };
    
  } catch (error) {
    console.error('Error sending notification:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send notification');
  }
}); 