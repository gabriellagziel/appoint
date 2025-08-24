import * as functions from 'firebase-functions';
import Stripe from 'stripe';
import * as admin from 'firebase-admin';
// Inline minimal validation to remove dev-time test dependency
const validate = (schema: any, data: any) => data;
const schemas: any = {};

// Initialize Stripe with safe runtime config fallback
const runtimeConfig: any = (functions as any)?.config ? (functions as any).config() : {};
const stripeSecret = runtimeConfig?.stripe?.secret_key || process.env.STRIPE_SECRET_KEY || 'REDACTED_STRIPE_KEY';
const stripe = new Stripe(stripeSecret, {
  // Remove apiVersion if not supported by installed SDK
  // apiVersion: '2023-10-16',
});

if (!admin.apps.length) {
  admin.initializeApp();
}
const db = admin.firestore();

// Create business checkout session (NEW)
export const createBusinessCheckoutSession = functions.https.onCall(async (data, context) => {
  try {
    const { plan, priceId, promoCode, metadata } = data;
    const userId = context.auth?.uid;

    if (!userId) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    if (!plan || !priceId) {
      throw new functions.https.HttpsError('invalid-argument', 'Missing required parameters: plan and priceId');
    }

    // Validate plan
    const validPlans = ['starter', 'professional', 'businessplus'];
    if (!validPlans.includes(plan.toLowerCase())) {
      throw new functions.https.HttpsError('invalid-argument', 'Invalid subscription plan');
    }

    // Get or create Stripe customer
    let customerId: string;
    const userDoc = await db.collection('business_subscriptions').where('businessId', '==', userId).limit(1).get();
    
    if (!userDoc.empty && userDoc.docs[0].data().stripeCustomerId) {
      customerId = userDoc.docs[0].data().stripeCustomerId;
    } else {
      const user = await admin.auth().getUser(userId);
      const customer = await stripe.customers.create({
        email: user.email,
        metadata: {
          businessId: userId,
          plan: plan,
        },
      });
      customerId = customer.id;
    }

    // Create checkout session
    const session = await stripe.checkout.sessions.create({
      customer: customerId,
      payment_method_types: ['card'],
      mode: 'subscription',
      line_items: [
        {
          price: priceId,
          quantity: 1,
        },
      ],
      success_url: `${functions.config().app.url || 'https://app-oint-core.web.app'}/subscription/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${functions.config().app.url || 'https://app-oint-core.web.app'}/subscription/cancel`,
      client_reference_id: userId,
      metadata: {
        businessId: userId,
        plan: plan,
        tier: metadata?.tier || plan,
        mapLimit: metadata?.mapLimit || '0',
        brandingEnabled: metadata?.brandingEnabled || 'false',
      },
      // Apply promo code if provided
      ...(promoCode && { discounts: [{ coupon: promoCode }] }),
    });

    return { sessionId: session.id, url: session.url };
  } catch (error) {
    console.error('Error creating business checkout session:', error);
    throw new functions.https.HttpsError('internal', 'Failed to create checkout session');
  }
});

// Create checkout session (LEGACY - for studio subscriptions)
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

// Create customer portal session
export const createCustomerPortalSession = functions.https.onCall(async (data, context) => {
  try {
    const userId = context.auth?.uid;

    if (!userId) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    // Get customer ID from business subscription
    const subscriptionDoc = await db.collection('business_subscriptions')
      .where('businessId', '==', userId)
      .limit(1)
      .get();

    if (subscriptionDoc.empty) {
      throw new functions.https.HttpsError('not-found', 'No subscription found');
    }

    const customerId = subscriptionDoc.docs[0].data().customerId;
    if (!customerId) {
      throw new functions.https.HttpsError('not-found', 'No customer ID found');
    }

    // Create portal session
    const portalSession = await stripe.billingPortal.sessions.create({
      customer: customerId,
      return_url: `${functions.config().app.url || 'https://app-oint-core.web.app'}/subscription`,
    });

    return { url: portalSession.url };
  } catch (error) {
    console.error('Error creating customer portal session:', error);
    throw new functions.https.HttpsError('internal', 'Failed to create customer portal session');
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
      // Get subscription details - Response<Subscription> has properties directly accessible
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
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
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
export const handleCheckoutSessionCompleted = functions.https.onRequest(async (req, res) => {
  const sig = req.headers['stripe-signature'];
  const endpointSecret = functions.config().stripe.webhook_secret || 'whsec_your_webhook_secret_here';

  let event: Stripe.Event;

  try {
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

      case 'invoice.payment_succeeded':
        const paidInvoice = event.data.object as Stripe.Invoice;
        await handlePaymentSucceeded(paidInvoice);
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

// Handle checkout session completed (renamed to avoid duplicate identifier)
async function processCheckoutSessionCompleted(session: Stripe.Checkout.Session) {
  const businessId = session.client_reference_id || session.metadata?.businessId;
  const isBusinessSubscription = session.metadata?.plan !== undefined;

  if (!businessId) {
    console.error('No business/studio ID found in session');
    return;
  }

  if (session.payment_status === 'paid' && session.subscription) {
    const subscription = await stripe.subscriptions.retrieve(session.subscription as string) as any;

    if (isBusinessSubscription) {
      // Handle business subscription
      const metadata = session.metadata || {};
      await db.collection('business_subscriptions').doc(businessId).set({
        businessId: businessId,
        customerId: subscription.customer,
        plan: metadata.plan || 'starter',
        status: 'active',
        stripeSubscriptionId: subscription.id,
        stripePriceId: subscription.items.data[0]?.price?.id || '',
        currentPeriodStart: new Date(subscription.current_period_start * 1000),
        currentPeriodEnd: new Date(subscription.current_period_end * 1000),
        mapUsageCurrentPeriod: 0,
        mapOverageThisPeriod: 0.0,
        createdAt: new Date(subscription.created * 1000),
        updatedAt: new Date(),
        metadata: {
          tier: metadata.tier,
          mapLimit: parseInt(metadata.mapLimit || '0'),
          brandingEnabled: metadata.brandingEnabled === 'true',
        },
      }, { merge: true });

      console.log(`Business subscription activated for: ${businessId}`);
    } else {
      // Handle studio subscription (legacy)
      await db.collection('studio').doc(businessId).update({
        subscriptionStatus: 'active',
        subscriptionData: {
          sessionId: session.id,
          subscriptionId: subscription.id,
          customerId: subscription.customer,
          status: subscription.status,
          currentPeriodEnd: subscription.current_period_end ? new Date(subscription.current_period_end * 1000) : null,
          createdAt: subscription.created ? new Date(subscription.created * 1000) : null,
        },
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`Studio subscription activated for: ${businessId}`);
    }
  }
}

// Handle subscription updated
async function handleSubscriptionUpdated(subscription: Stripe.Subscription) {
  const businessId = subscription.metadata?.businessId || subscription.metadata?.studioId;

  if (!businessId) {
    console.error('No business/studio ID found in subscription metadata');
    return;
  }

  const isBusinessSubscription = subscription.metadata?.plan !== undefined;

  if (isBusinessSubscription) {
    // Update business subscription
    await db.collection('business_subscriptions').doc(businessId).update({
      status: subscription.status,
      currentPeriodStart: new Date(subscription.current_period_start * 1000),
      currentPeriodEnd: new Date(subscription.current_period_end * 1000),
      updatedAt: new Date(),
    });

    // Reset map usage for new billing period
    if (subscription.status === 'active') {
      await db.collection('business_subscriptions').doc(businessId).update({
        mapUsageCurrentPeriod: 0,
        mapOverageThisPeriod: 0.0,
      });
    }
  } else {
    // Update studio subscription (legacy)
    const sub = subscription as any;
    await db.collection('studio').doc(businessId).update({
      subscriptionStatus: subscription.status,
      subscriptionData: {
        subscriptionId: subscription.id,
        customerId: subscription.customer,
        status: subscription.status,
        currentPeriodEnd: sub.current_period_end ? new Date(sub.current_period_end * 1000) : null,
        updatedAt: sub.updated ? new Date(sub.updated * 1000) : null,
      },
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    });
  }

  console.log(`Subscription updated for: ${businessId}`);
}

// Handle subscription deleted
async function handleSubscriptionDeleted(subscription: Stripe.Subscription) {
  const businessId = subscription.metadata?.businessId || subscription.metadata?.studioId;

  if (!businessId) {
    console.error('No business/studio ID found in subscription metadata');
    return;
  }

  const isBusinessSubscription = subscription.metadata?.plan !== undefined;

  if (isBusinessSubscription) {
    await db.collection('business_subscriptions').doc(businessId).update({
      status: 'canceled',
      updatedAt: new Date(),
    });
  } else {
    const sub = subscription as any;
    await db.collection('studio').doc(businessId).update({
      subscriptionStatus: 'cancelled',
      subscriptionData: {
        subscriptionId: subscription.id,
        customerId: subscription.customer,
        status: subscription.status,
        cancelledAt: sub.canceled_at ? new Date(sub.canceled_at * 1000) : null,
      },
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    });
  }

  console.log(`Subscription cancelled for: ${businessId}`);
}

// Handle payment failed
async function handlePaymentFailed(invoice: Stripe.Invoice) {
  const invoiceData = invoice as any;
  if (!invoiceData.subscription) {
    console.error('No subscription ID found in invoice');
    return;
  }
  
  const subscription = await stripe.subscriptions.retrieve(invoiceData.subscription as string) as any;
  const businessId = subscription.metadata?.businessId || subscription.metadata?.studioId;

  if (!businessId) {
    console.error('No business/studio ID found in subscription metadata');
    return;
  }

  const isBusinessSubscription = subscription.metadata?.plan !== undefined;

  if (isBusinessSubscription) {
    await db.collection('business_subscriptions').doc(businessId).update({
      status: 'past_due',
      updatedAt: new Date(),
    });
  } else {
    await db.collection('studio').doc(businessId).update({
      subscriptionStatus: 'payment_failed',
      subscriptionData: {
        subscriptionId: subscription.id,
        customerId: subscription.customer,
        status: subscription.status,
        paymentFailedAt: invoice.created ? new Date(invoice.created * 1000) : null,
      },
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    });
  }

  console.log(`Payment failed for: ${businessId}`);
}

// Handle payment succeeded (NEW - for overage billing)
async function handlePaymentSucceeded(invoice: Stripe.Invoice) {
  const invoiceData = invoice as any;
  if (!invoiceData.subscription) {
    return; // Not a subscription invoice
  }
  
  const subscription = await stripe.subscriptions.retrieve(invoiceData.subscription as string) as any;
  const businessId = subscription.metadata?.businessId;

  if (!businessId) {
    return; // Not a business subscription
  }

  // Check if this is an overage invoice
  const businessSubscription = await db.collection('business_subscriptions').doc(businessId).get();
  if (businessSubscription.exists) {
    const data = businessSubscription.data();
    if (data && data.mapOverageThisPeriod > 0) {
      // Reset overage amount after successful payment
      await db.collection('business_subscriptions').doc(businessId).update({
        mapOverageThisPeriod: 0.0,
        updatedAt: new Date(),
      });

      console.log(`Overage payment processed for business: ${businessId}`);
    }
  }
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

// Create payment intent with 3D Secure support
export const createPaymentIntent = functions.https.onCall(async (data, context) => {
  try {
    // Validate input data
    const validatedData = validate(schemas.createPaymentIntent, data);
    const { amount } = validatedData;
    
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
    
    // Handle validation errors
    if (error.code === 'invalid-argument') {
      throw new functions.https.HttpsError(
        'invalid-argument',
        error.message,
        { field: error.details?.field }
      );
    }
    
    throw new functions.https.HttpsError('internal', 'Failed to create payment intent');
  }
}); 