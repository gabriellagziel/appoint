import * as functions from 'firebase-functions';
import Stripe from 'stripe';
import * as admin from 'firebase-admin';

// Initialize Stripe with your secret key
const stripe = new Stripe(functions.config().stripe.secret_key || 'REDACTED_STRIPE_KEY', {
  apiVersion: '2023-10-16',
});

admin.initializeApp();
const db = admin.firestore();

// Create checkout session
export const createCheckoutSession = functions.https.onRequest(async (req, res) => {
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

    // Create checkout session
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

    res.json({ url: session.url });
  } catch (error) {
    console.error('Error creating checkout session:', error);
    res.status(500).json({ error: 'Failed to create checkout session' });
  }
});

// Confirm checkout session
export const confirmSession = functions.https.onRequest(async (req, res) => {
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

    if (!sessionId || !studioId) {
      res.status(400).json({ error: 'Missing required parameters' });
      return;
    }

    // Retrieve the session
    const session = await stripe.checkout.sessions.retrieve(sessionId);

    if (session.payment_status === 'paid') {
      // Get subscription details
      const subscription = await stripe.subscriptions.retrieve(session.subscription as string);

      // Update Firestore
      await db.collection('studio').doc(studioId).update({
        subscriptionStatus: 'active',
        subscriptionData: {
          sessionId: sessionId,
          subscriptionId: subscription.id,
          customerId: subscription.customer,
          status: subscription.status,
          currentPeriodEnd: new Date(subscription.current_period_end * 1000),
          createdAt: new Date(subscription.created * 1000),
        },
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      });

      res.json({
        success: true,
        subscription: {
          id: subscription.id,
          status: subscription.status,
          currentPeriodEnd: subscription.current_period_end,
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
export const handleCheckoutSessionCompleted = functions.https.onRequest(async (req, res) => {
  const sig = req.headers['stripe-signature'];
  const endpointSecret = functions.config().stripe.webhook_secret || 'whsec_your_webhook_secret_here';

  let event: Stripe.Event;

  try {
    event = stripe.webhooks.constructEvent(req.rawBody, sig as string, endpointSecret);
  } catch (err) {
    console.error('Webhook signature verification failed:', err);
    res.status(400).send(`Webhook Error: ${err.message}`);
    return;
  }

  try {
    switch (event.type) {
      case 'checkout.session.completed':
        const session = event.data.object as Stripe.Checkout.Session;
        await handleCheckoutSessionCompleted(session);
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

// Handle checkout session completed
async function handleCheckoutSessionCompleted(session: Stripe.Checkout.Session) {
  const studioId = session.client_reference_id || session.metadata?.studioId;

  if (!studioId) {
    console.error('No studio ID found in session');
    return;
  }

  if (session.payment_status === 'paid' && session.subscription) {
    const subscription = await stripe.subscriptions.retrieve(session.subscription as string);

    await db.collection('studio').doc(studioId).update({
      subscriptionStatus: 'active',
      subscriptionData: {
        sessionId: session.id,
        subscriptionId: subscription.id,
        customerId: subscription.customer,
        status: subscription.status,
        currentPeriodEnd: new Date(subscription.current_period_end * 1000),
        createdAt: new Date(subscription.created * 1000),
      },
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
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

  await db.collection('studio').doc(studioId).update({
    subscriptionStatus: subscription.status,
    subscriptionData: {
      subscriptionId: subscription.id,
      customerId: subscription.customer,
      status: subscription.status,
      currentPeriodEnd: new Date(subscription.current_period_end * 1000),
      updatedAt: new Date(subscription.updated * 1000),
    },
    lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
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

  await db.collection('studio').doc(studioId).update({
    subscriptionStatus: 'cancelled',
    subscriptionData: {
      subscriptionId: subscription.id,
      customerId: subscription.customer,
      status: subscription.status,
      cancelledAt: new Date(subscription.canceled_at! * 1000),
    },
    lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
  });

  console.log(`Subscription cancelled for studio: ${studioId}`);
}

// Handle payment failed
async function handlePaymentFailed(invoice: Stripe.Invoice) {
  const subscription = await stripe.subscriptions.retrieve(invoice.subscription as string);
  const studioId = subscription.metadata?.studioId;

  if (!studioId) {
    console.error('No studio ID found in subscription metadata');
    return;
  }

  await db.collection('studio').doc(studioId).update({
    subscriptionStatus: 'past_due',
    subscriptionData: {
      subscriptionId: subscription.id,
      customerId: subscription.customer,
      status: subscription.status,
      lastPaymentFailed: new Date(invoice.created * 1000),
    },
    lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
  });

  console.log(`Payment failed for studio: ${studioId}`);
}

// Cancel subscription
export const cancelSubscription = functions.https.onRequest(async (req, res) => {
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

    if (!studioId || !subscriptionId) {
      res.status(400).json({ error: 'Missing required parameters' });
      return;
    }

    // Cancel the subscription at period end
    const subscription = await stripe.subscriptions.update(subscriptionId, {
      cancel_at_period_end: true,
    });

    // Update Firestore
    await db.collection('studio').doc(studioId).update({
      subscriptionStatus: 'cancelling',
      subscriptionData: {
        subscriptionId: subscription.id,
        customerId: subscription.customer,
        status: subscription.status,
        cancelAtPeriodEnd: true,
        currentPeriodEnd: new Date(subscription.current_period_end * 1000),
      },
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
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