const admin = require('firebase-admin');

// Development Firebase configuration - no credentials required
let app;
try {
    // Check if Firebase is already initialized
    if (admin.apps.length === 0) {
        app = admin.initializeApp({
            projectId: 'appoint-enterprise-dev',
            databaseURL: 'https://appoint-enterprise-dev.firebaseio.com'
        });
    } else {
        app = admin.app();
    }
} catch (error) {
    console.warn('Firebase initialization failed, using mock data');
    // Create mock collections for development
    const mockCollections = {
        users: { doc: () => ({ set: () => Promise.resolve(), get: () => Promise.resolve({ exists: false }) }) },
        apiKeys: { doc: () => ({ set: () => Promise.resolve(), get: () => Promise.resolve({ exists: false }) }) },
        usageLogs: { add: () => Promise.resolve() },
        subscriptions: { doc: () => ({ set: () => Promise.resolve() }) },
        invoices: { add: () => Promise.resolve() }
    };

    module.exports = {
        admin: { firestore: () => ({ collection: (name) => mockCollections[name] }) },
        db: { collection: (name) => mockCollections[name] },
        collections: mockCollections,
        SUBSCRIPTION_PLANS: {
            basic: { name: 'Basic', price: 99, monthlyApiCalls: 10000 },
            pro: { name: 'Professional', price: 299, monthlyApiCalls: 50000 },
            enterprise: { name: 'Enterprise', price: 999, monthlyApiCalls: 200000 }
        },
        RATE_LIMITS: {
            basic: { requestsPerMinute: 60, requestsPerHour: 1000 },
            pro: { requestsPerMinute: 300, requestsPerHour: 5000 },
            enterprise: { requestsPerMinute: 1000, requestsPerHour: 20000 }
        }
    };
    return;
}

// Initialize Firestore
const db = admin.firestore();

// Collection references
const collections = {
    users: db.collection('users'),
    apiKeys: db.collection('api_keys'),
    usageLogs: db.collection('usage_logs'),
    subscriptions: db.collection('subscriptions'),
    invoices: db.collection('invoices')
};

// Subscription plans configuration
const SUBSCRIPTION_PLANS = {
    basic: {
        name: 'Basic',
        price: 99,
        monthlyApiCalls: 10000,
        features: ['API Access', 'Basic Analytics', 'Email Support']
    },
    pro: {
        name: 'Professional',
        price: 299,
        monthlyApiCalls: 50000,
        features: ['API Access', 'Advanced Analytics', 'Priority Support', 'Custom Integrations']
    },
    enterprise: {
        name: 'Enterprise',
        price: 999,
        monthlyApiCalls: 200000,
        features: ['API Access', 'Advanced Analytics', 'Priority Support', 'Custom Integrations', 'White Label', 'Dedicated Support']
    }
};

// Rate limiting configuration per plan
const RATE_LIMITS = {
    basic: { requestsPerMinute: 60, requestsPerHour: 1000 },
    pro: { requestsPerMinute: 300, requestsPerHour: 5000 },
    enterprise: { requestsPerMinute: 1000, requestsPerHour: 20000 }
};

module.exports = {
    admin,
    db,
    collections,
    SUBSCRIPTION_PLANS,
    RATE_LIMITS
}; 