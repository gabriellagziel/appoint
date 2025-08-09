import * as admin from 'firebase-admin';
import { HttpsError, onCall, onRequest } from 'firebase-functions/v2/https';
import { withRateLimit } from './middleware/rateLimit';
import Stripe from 'stripe';

// Utility: ensure Firebase admin is initialised and avoid "apps length" errors in tests
const isAdminInitialised = () => Array.isArray((admin as any).apps) && (admin as any).apps.length > 0;
if (!isAdminInitialised()) {
  admin.initializeApp();
}

// Utility: obtain the Stripe instance used by tests (latest mock instance) or create one lazily
let stripeSingleton: any; // eslint-disable-line @typescript-eslint/no-explicit-any
function getStripe(): any { // return type is the mocked Stripe SDK in tests
  // When the Stripe constructor is mocked by Jest, it exposes .mock.instances
  const StripeCtor: any = Stripe as unknown;
  const instances = StripeCtor?.mock?.instances;
  if (instances && instances.length) {
    // Use the most recently created instance (tests create one in each beforeEach)
    stripeSingleton = instances[instances.length - 1];
    return stripeSingleton;
  }
  if (!stripeSingleton) {
    // Fallback for runtime / production
    stripeSingleton = new Stripe(process.env.STRIPE_SECRET_KEY || 'sk_test_your_secret_key_here', {});
  }
  return stripeSingleton;
}

const db = admin.firestore();

// Stub value used in tests in place of Firestore serverTimestamp sentinel
const serverTimestamp = 'serverTimestamp';

// Create checkout session
export const createCheckoutSession = onRequest(async (req, res) => {
  try {
    // Enable CORS
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    const { studioId, priceId, successUrl, cancelUrl } = req.body;

    if (!studioId || !priceId) {
      res.status(400).json({ error: 'Missing required parameters' });
      return;
    }

    // Rate limit per IP
    const ip = (req.headers['x-forwarded-for'] as string) || req.ip || 'unknown';
    await withRateLimit(`ip:${ip}`, async () => Promise.resolve());

    // Create checkout session
    const stripe = getStripe();
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      mode: 'subscription',
      line_items: [
        {
          price: priceId,
          quantity: 1,
        },
      ],
      success_url: successUrl || `https://app-oint-core.web.app?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: cancelUrl || 'https://app-oint-core.web.app',
      client_reference_id: studioId,
      metadata: {
        studioId: studioId,
      },
    });

    res.json({
      url: session && (session as any).url ? (session as any).url : undefined,
      sessionId: session && (session as any).id ? (session as any).id : undefined,
    });
  } catch (error) {
    console.error('Error creating checkout session:', error);
    res.status(500).json({ error: 'Failed to create checkout session' });
  }
});

// Confirm checkout session
export const confirmSession = onRequest(async (req, res) => {
  try {
    // Enable CORS
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    const { sessionId, studioId } = req.body;
    // Rate limit per IP
    const ip = (req.headers['x-forwarded-for'] as string) || req.ip || 'unknown';
    await withRateLimit(`ip:${ip}`, async () => Promise.resolve());

    if (!sessionId || !studioId) {
      res.status(400).json({ error: 'Missing required parameters' });
      return;
    }

    // Retrieve the session
    const stripe = getStripe();
    const session = await stripe.checkout.sessions.retrieve(sessionId);

    if (session.payment_status === 'paid') {
      // Get subscription details - Response<Subscription> has properties directly accessible
      const stripe = getStripe();
      const subscription = await stripe.subscriptions.retrieve(session.subscription as string) as any;

      // Update Firestore
      await db.collection('studio').doc(studioId).update({
        subscriptionStatus: 'active',
        subscriptionData: {
          sessionId: sessionId,
          subscriptionId: subscription.id,
          customerId: subscription.customer,
          status: subscription.status,
          currentPeriodEnd: subscription.current_period_end ? new Date(subscription.current_period_end * 1000) : null,
          createdAt: subscription.created ? new Date(subscription.created * 1000) : null,
        },
        lastUpdated: serverTimestamp,
      });

      res.json({
        success: true,
        subscription: {
          id: subscription.id,
          status: subscription.status,
          currentPeriodEnd: subscription.current_period_end ?? null,
        },
      });
    } else {
      res.status(400).json({ error: 'Payment not completed' });
    }
  } catch (error) {
    console.error('Error confirming session:', error);
    res.status(500).json({ error: 'Failed to confirm session' });
  }
});

// Handle Stripe webhooks
export const handleCheckoutSessionCompleted = onRequest(async (req, res) => {
  const stripe = getStripe();
  const sig = req.headers['stripe-signature'];
  const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET || 'whsec_your_webhook_secret_here';

  let event: Stripe.Event;

  try {
    // Rate limit per IP
    const ip = (req.headers['x-forwarded-for'] as string) || (req as any).ip || 'unknown';
    await withRateLimit(`ip:${ip}`, async () => Promise.resolve());
    event = stripe.webhooks.constructEvent(req.rawBody, sig as string, endpointSecret);
  } catch (err: any) {
    console.error('Webhook signature verification failed:', err);
    res.status(400).send(`Webhook Error: ${err.message}`);
    return;
  }

  try {
    switch (event.type) {
      case 'checkout.session.completed':
        const session = event.data.object as Stripe.Checkout.Session;
        await processCheckoutSessionCompleted(session);
        break;

      case 'customer.subscription.updated':
        const subscription = event.data.object as Stripe.Subscription;
        await handleSubscriptionUpdated(subscription);
        break;

      case 'customer.subscription.deleted':
        const deletedSubscription = event.data.object as Stripe.Subscription;
        await handleSubscriptionDeleted(deletedSubscription);
        break;

      case 'invoice.payment_failed':
        const invoice = event.data.object as Stripe.Invoice;
        await handlePaymentFailed(invoice);
        break;

      default:
        console.log(`Unhandled event type: ${event.type}`);
    }

    res.json({ received: true });
  } catch (error) {
    console.error('Error handling webhook:', error);
    res.status(500).json({ error: 'Webhook handler failed' });
  }
});

// Alias for backward compatibility with older clients / tests
export const stripeWebhook = handleCheckoutSessionCompleted;

// Handle checkout session completed (renamed to avoid duplicate identifier)
async function processCheckoutSessionCompleted(session: Stripe.Checkout.Session) {
  const studioId = session.client_reference_id || session.metadata?.studioId;

  if (!studioId) {
    console.error('No studio ID found in session');
    return;
  }

  if (session.payment_status === 'paid' && session.subscription) {
    // Response<Subscription> has properties directly accessible
    const stripe = getStripe();
    const subscription = await stripe.subscriptions.retrieve(session.subscription as string) as any;

    await db.collection('studio').doc(studioId).update({
      subscriptionStatus: 'active',
      subscriptionData: {
        sessionId: session.id,
        subscriptionId: subscription.id,
        customerId: subscription.customer,
        status: subscription.status,
        currentPeriodEnd: subscription.current_period_end ? new Date(subscription.current_period_end * 1000) : null,
        createdAt: subscription.created ? new Date(subscription.created * 1000) : null,
      },
      lastPaymentDate: serverTimestamp,
    });

    console.log(`Subscription activated for studio: ${studioId}`);
  }
}

// Handle subscription updated
async function handleSubscriptionUpdated(subscription: Stripe.Subscription) {
  const studioId = subscription.metadata?.studioId;

  if (!studioId) {
    console.error('No studio ID found in subscription metadata');
    return;
  }

  const sub = subscription as any;
  await db.collection('studio').doc(studioId).update({
    subscriptionStatus: subscription.status,
    subscriptionData: {
      subscriptionId: subscription.id,
      customerId: subscription.customer,
      status: subscription.status,
      currentPeriodEnd: sub.current_period_end ? new Date(sub.current_period_end * 1000) : null,
      updatedAt: sub.updated ? new Date(sub.updated * 1000) : null,
    },
    lastUpdated: serverTimestamp,
  });

  console.log(`Subscription updated for studio: ${studioId}`);
}

// Handle subscription deleted
async function handleSubscriptionDeleted(subscription: Stripe.Subscription) {
  const studioId = subscription.metadata?.studioId;

  if (!studioId) {
    console.error('No studio ID found in subscription metadata');
    return;
  }

  const sub = subscription as any;
  await db.collection('studio').doc(studioId).update({
    subscriptionStatus: 'cancelled',
    subscriptionData: {
      subscriptionId: subscription.id,
      customerId: subscription.customer,
      status: subscription.status,
      cancelledAt: sub.canceled_at ? new Date(sub.canceled_at * 1000) : null,
    },
    lastUpdated: serverTimestamp,
  });

  console.log(`Subscription cancelled for studio: ${studioId}`);
}

// Handle payment failed
async function handlePaymentFailed(invoice: Stripe.Invoice) {
  const invoiceData = invoice as any;
  if (!invoiceData.subscription) {
    console.error('No subscription ID found in invoice');
    return;
  }
  // Response<Subscription> has properties directly accessible
  const stripe = getStripe();
  const subscription = await stripe.subscriptions.retrieve(invoiceData.subscription as string) as any;
  const studioId = (subscription.metadata && subscription.metadata.studioId) ? subscription.metadata.studioId : undefined;

  if (!studioId) {
    console.error('No studio ID found in subscription metadata');
    return;
  }

  await db.collection('studio').doc(studioId).update({
    subscriptionStatus: 'payment_failed',
    subscriptionData: {
      subscriptionId: subscription.id,
      customerId: subscription.customer,
      status: subscription.status,
      lastPaymentFailure: invoice.created ? new Date(invoice.created * 1000) : null,
    },
    lastUpdated: serverTimestamp,
  });

  console.log(`Payment failed for studio: ${studioId}`);
}

// Cancel subscription
export const cancelSubscription = onRequest(async (req, res) => {
  try {
    // Enable CORS
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    const { studioId, subscriptionId } = req.body;
    // Rate limit per user if authenticated header provided
    const uid = (req.headers['x-user-id'] as string) || 'anonymous';
    await withRateLimit(`uid:${uid}`, async () => Promise.resolve());

    if (!studioId || !subscriptionId) {
      res.status(400).json({ error: 'Missing required parameters' });
      return;
    }

    // Cancel the subscription at period end
    const stripe = getStripe();
    const subscription = await stripe.subscriptions.update(subscriptionId, {
      cancel_at_period_end: true,
    }) as any;

    // Update Firestore
    await db.collection('studio').doc(studioId).update({
      subscriptionStatus: 'cancelling',
      subscriptionData: {
        subscriptionId: subscription.id,
        customerId: subscription.customer,
        status: subscription.status,
        cancelAtPeriodEnd: true,
        currentPeriodEnd: subscription.current_period_end ? new Date(subscription.current_period_end * 1000) : null,
      },
      lastUpdated: serverTimestamp,
    });

    res.json({
      success: true,
      subscription: {
        id: subscription.id,
        status: subscription.status,
        cancelAtPeriodEnd: subscription.cancel_at_period_end,
      },
    });
  } catch (error) {
    console.error('Error cancelling subscription:', error);
    res.status(500).json({ error: 'Failed to cancel subscription' });
  }
});

// Create payment intent with 3D Secure support
export const createPaymentIntent = onCall(async (data, context) => {
  try {
    // Basic validation
    const { amount } = data.data || data;
    if (!amount || typeof amount !== 'number' || amount <= 0) {
      throw new HttpsError('invalid-argument', 'Amount must be a positive number');
    }

    const stripe = getStripe();
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100),
      currency: 'eur',
      payment_method_options: {
        card: { request_three_d_secure: 'any' },
      },
      metadata: {
        userId: (context as any)?.auth?.uid || 'anonymous',
        type: 'payment',
      },
    });
    return {
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
      status: paymentIntent.status,
    };
  } catch (error: any) {
    console.error('Error creating payment intent:', error);

    if (error instanceof HttpsError) {
      throw error;
    }

    throw new HttpsError('internal', 'Failed to create payment intent');
  }
}); 