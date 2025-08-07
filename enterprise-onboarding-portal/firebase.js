const admin = require('firebase-admin');
const path = require('path');

// Initialize Firebase Admin SDK
let serviceAccount;
try {
    // Try to load service account from environment variable (base64 encoded)
    if (process.env.FIREBASE_SERVICE_ACCOUNT) {
        serviceAccount = JSON.parse(Buffer.from(process.env.FIREBASE_SERVICE_ACCOUNT, 'base64').toString());
    } else {
        // Fallback to service account file
        serviceAccount = require('./service-account-key.json');
    }
} catch (error) {
    console.warn('Firebase service account not found, using default credentials');
    serviceAccount = undefined;
}

// Initialize Firebase Admin
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: process.env.FIREBASE_DATABASE_URL || 'https://appoint-enterprise.firebaseio.com'
});

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