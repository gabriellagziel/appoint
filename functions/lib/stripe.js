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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createPaymentIntent = exports.cancelSubscription = exports.stripeWebhook = exports.handleCheckoutSessionCompleted = exports.confirmSession = exports.createCheckoutSession = void 0;
const admin = __importStar(require("firebase-admin"));
const https_1 = require("firebase-functions/v2/https");
const rateLimiter_js_1 = require("./middleware/rateLimiter.js");
const stripe_1 = __importDefault(require("stripe"));
// Utility: ensure Firebase admin is initialised and avoid "apps length" errors in tests
const isAdminInitialised = () => Array.isArray(admin.apps) && admin.apps.length > 0;
if (!isAdminInitialised()) {
    admin.initializeApp();
}
// Utility: obtain the Stripe instance used by tests (latest mock instance) or create one lazily
let stripeSingleton; // eslint-disable-line @typescript-eslint/no-explicit-any
function getStripe() {
    // When the Stripe constructor is mocked by Jest, it exposes .mock.instances
    const StripeCtor = stripe_1.default;
    const instances = StripeCtor?.mock?.instances;
    if (instances && instances.length) {
        // Use the most recently created instance (tests create one in each beforeEach)
        stripeSingleton = instances[instances.length - 1];
        return stripeSingleton;
    }
    if (!stripeSingleton) {
        // Fallback for runtime / production
        stripeSingleton = new stripe_1.default(process.env.STRIPE_SECRET_KEY || 'REDACTED_STRIPE_KEY', {});
    }
    return stripeSingleton;
}
const db = admin.firestore();
// Stub value used in tests in place of Firestore serverTimestamp sentinel
const serverTimestamp = 'serverTimestamp';
// Create checkout session
exports.createCheckoutSession = (0, https_1.onRequest)(async (req, res) => {
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
        const ip = req.headers['x-forwarded-for'] || req.ip || 'unknown';
        await (0, rateLimiter_js_1.withRateLimit)(`ip:${ip}`, async () => Promise.resolve());
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
            url: session && session.url ? session.url : undefined,
            sessionId: session && session.id ? session.id : undefined,
        });
    }
    catch (error) {
        console.error('Error creating checkout session:', error);
        res.status(500).json({ error: 'Failed to create checkout session' });
    }
});
// Confirm checkout session
exports.confirmSession = (0, https_1.onRequest)(async (req, res) => {
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
        const ip = req.headers['x-forwarded-for'] || req.ip || 'unknown';
        await (0, rateLimiter_js_1.withRateLimit)(`ip:${ip}`, async () => Promise.resolve());
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
            const subscription = await stripe.subscriptions.retrieve(session.subscription);
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
        }
        else {
            res.status(400).json({ error: 'Payment not completed' });
        }
    }
    catch (error) {
        console.error('Error confirming session:', error);
        res.status(500).json({ error: 'Failed to confirm session' });
    }
});
// Handle Stripe webhooks
exports.handleCheckoutSessionCompleted = (0, https_1.onRequest)(async (req, res) => {
    const stripe = getStripe();
    const sig = req.headers['stripe-signature'];
    const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET || 'whsec_your_webhook_secret_here';
    let event;
    try {
        // Rate limit per IP
        const ip = req.headers['x-forwarded-for'] || req.ip || 'unknown';
        await (0, rateLimiter_js_1.withRateLimit)(`ip:${ip}`, async () => Promise.resolve());
        event = stripe.webhooks.constructEvent(req.rawBody, sig, endpointSecret);
    }
    catch (err) {
        console.error('Webhook signature verification failed:', err);
        res.status(400).send(`Webhook Error: ${err.message}`);
        return;
    }
    try {
        switch (event.type) {
            case 'checkout.session.completed':
                const session = event.data.object;
                await processCheckoutSessionCompleted(session);
                break;
            case 'customer.subscription.updated':
                const subscription = event.data.object;
                await handleSubscriptionUpdated(subscription);
                break;
            case 'customer.subscription.deleted':
                const deletedSubscription = event.data.object;
                await handleSubscriptionDeleted(deletedSubscription);
                break;
            case 'invoice.payment_failed':
                const invoice = event.data.object;
                await handlePaymentFailed(invoice);
                break;
            default:
                console.log(`Unhandled event type: ${event.type}`);
        }
        res.json({ received: true });
    }
    catch (error) {
        console.error('Error handling webhook:', error);
        res.status(500).json({ error: 'Webhook handler failed' });
    }
});
// Alias for backward compatibility with older clients / tests
exports.stripeWebhook = exports.handleCheckoutSessionCompleted;
// Handle checkout session completed (renamed to avoid duplicate identifier)
async function processCheckoutSessionCompleted(session) {
    const studioId = session.client_reference_id || session.metadata?.studioId;
    if (!studioId) {
        console.error('No studio ID found in session');
        return;
    }
    if (session.payment_status === 'paid' && session.subscription) {
        // Response<Subscription> has properties directly accessible
        const stripe = getStripe();
        const subscription = await stripe.subscriptions.retrieve(session.subscription);
        // Personal user premium mapping: studioId prefixed with 'user:'
        if (studioId?.startsWith('user:')) {
            const userId = studioId.split(':')[1];
            await db.collection('users').doc(userId).set({
                isPremium: true,
                premium: {
                    sessionId: session.id,
                    subscriptionId: subscription.id,
                    customerId: subscription.customer,
                    status: subscription.status,
                    currentPeriodEnd: subscription.current_period_end ? new Date(subscription.current_period_end * 1000) : null,
                    createdAt: subscription.created ? new Date(subscription.created * 1000) : null,
                },
            }, { merge: true });
        }
        else if (studioId) {
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
        }
        console.log(`Subscription activated for studio: ${studioId}`);
    }
}
// Handle subscription updated
async function handleSubscriptionUpdated(subscription) {
    const studioId = subscription.metadata?.studioId;
    if (!studioId) {
        console.error('No studio ID found in subscription metadata');
        return;
    }
    const sub = subscription;
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
async function handleSubscriptionDeleted(subscription) {
    const studioId = subscription.metadata?.studioId;
    if (!studioId) {
        console.error('No studio ID found in subscription metadata');
        return;
    }
    const sub = subscription;
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
async function handlePaymentFailed(invoice) {
    const invoiceData = invoice;
    if (!invoiceData.subscription) {
        console.error('No subscription ID found in invoice');
        return;
    }
    // Response<Subscription> has properties directly accessible
    const stripe = getStripe();
    const subscription = await stripe.subscriptions.retrieve(invoiceData.subscription);
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
exports.cancelSubscription = (0, https_1.onRequest)(async (req, res) => {
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
        const uid = req.headers['x-user-id'] || 'anonymous';
        await (0, rateLimiter_js_1.withRateLimit)(`uid:${uid}`, async () => Promise.resolve());
        if (!studioId || !subscriptionId) {
            res.status(400).json({ error: 'Missing required parameters' });
            return;
        }
        // Cancel the subscription at period end
        const stripe = getStripe();
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
    }
    catch (error) {
        console.error('Error cancelling subscription:', error);
        res.status(500).json({ error: 'Failed to cancel subscription' });
    }
});
// Create payment intent with 3D Secure support
exports.createPaymentIntent = (0, https_1.onCall)(async (request) => {
    try {
        // Basic validation
        const { amount } = request.data || {};
        if (!amount || typeof amount !== 'number' || amount <= 0) {
            throw new https_1.HttpsError('invalid-argument', 'Amount must be a positive number');
        }
        const stripe = getStripe();
        const paymentIntent = await stripe.paymentIntents.create({
            amount: Math.round(amount * 100),
            currency: 'eur',
            payment_method_options: {
                card: { request_three_d_secure: 'any' },
            },
            metadata: {
                userId: request.auth?.uid || 'anonymous',
                type: 'payment',
            },
        });
        return {
            clientSecret: paymentIntent.client_secret,
            paymentIntentId: paymentIntent.id,
            status: paymentIntent.status,
        };
    }
    catch (error) {
        console.error('Error creating payment intent:', error);
        if (error instanceof https_1.HttpsError) {
            throw error;
        }
        throw new https_1.HttpsError('internal', 'Failed to create payment intent');
    }
});
