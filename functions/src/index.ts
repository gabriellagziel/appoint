import { onRequest } from 'firebase-functions/v2/https';
import app from './server';
export { createCheckoutSession, confirmSession, handleCheckoutSessionCompleted as stripeWebhook, cancelSubscription, createPaymentIntent } from './stripe';

// Export Express app as a single HTTPS function entry for Firebase
export const groups = onRequest(app);

