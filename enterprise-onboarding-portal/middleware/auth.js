const { admin } = require('../firebase');

// Firebase authentication middleware
const authenticateFirebaseToken = async (req, res, next) => {
    try {
        const authHeader = req.headers['authorization'];
        const token = authHeader && authHeader.split(' ')[1];

        if (!token) {
            return res.status(401).json({ error: 'Access token required' });
        }

        // Verify Firebase ID token
        const decodedToken = await admin.auth().verifyIdToken(token);
        req.user = decodedToken;
        next();
    } catch (error) {
        console.error('Firebase auth error:', error);
        return res.status(403).json({ error: 'Invalid token' });
    }
};

// API key authentication middleware
const authenticateApiKey = async (req, res, next) => {
    try {
        const apiKey = req.headers['x-api-key'] || req.query.api_key;

        if (!apiKey) {
            return res.status(401).json({ error: 'API key required' });
        }

        const { collections } = require('../firebase');
        const apiKeyDoc = await collections.apiKeys.doc(apiKey).get();

        if (!apiKeyDoc.exists) {
            return res.status(401).json({ error: 'Invalid API key' });
        }

        const apiKeyData = apiKeyDoc.data();

        // Check if API key is active
        if (!apiKeyData.isActive) {
            return res.status(401).json({ error: 'API key is suspended' });
        }

        // Check expiry
        if (apiKeyData.expiryDate && new Date() > apiKeyData.expiryDate.toDate()) {
            return res.status(401).json({ error: 'API key has expired' });
        }

        req.apiKey = apiKeyData;
        req.userId = apiKeyData.userId;
        next();
    } catch (error) {
        console.error('API key auth error:', error);
        return res.status(500).json({ error: 'Authentication error' });
    }
};

// Rate limiting middleware per API key
const rateLimitApiKey = async (req, res, next) => {
    try {
        const { collections, RATE_LIMITS } = require('../firebase');

        // Get user's subscription plan
        const userDoc = await collections.users.doc(req.userId).get();
        const userData = userDoc.data();
        const plan = userData.subscriptionPlan || 'basic';
        const limits = RATE_LIMITS[plan];

        // Check rate limits
        const now = new Date();
        const oneMinuteAgo = new Date(now.getTime() - 60 * 1000);
        const oneHourAgo = new Date(now.getTime() - 60 * 60 * 1000);

        // Get recent usage logs
        const recentLogs = await collections.usageLogs
            .where('apiKey', '==', req.headers['x-api-key'])
            .where('timestamp', '>=', oneMinuteAgo)
            .get();

        const hourlyLogs = await collections.usageLogs
            .where('apiKey', '==', req.headers['x-api-key'])
            .where('timestamp', '>=', oneHourAgo)
            .get();

        if (recentLogs.size >= limits.requestsPerMinute) {
            return res.status(429).json({ error: 'Rate limit exceeded (per minute)' });
        }

        if (hourlyLogs.size >= limits.requestsPerHour) {
            return res.status(429).json({ error: 'Rate limit exceeded (per hour)' });
        }

        next();
    } catch (error) {
        console.error('Rate limiting error:', error);
        next(); // Continue on error
    }
};

// Usage logging middleware
const logApiUsage = async (req, res, next) => {
    const originalSend = res.send;
    res.send = function (data) {
        // Log usage after response is sent
        logUsage(req, res.statusCode);
        originalSend.call(this, data);
    };
    next();
};

const logUsage = async (req, statusCode) => {
    try {
        const { collections } = require('../firebase');
        const apiKey = req.headers['x-api-key'] || req.query.api_key;

        if (!apiKey) return;

        await collections.usageLogs.add({
            apiKey,
            userId: req.userId,
            endpoint: req.path,
            method: req.method,
            statusCode,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            userAgent: req.get('User-Agent'),
            ipAddress: req.ip
        });
    } catch (error) {
        console.error('Usage logging error:', error);
    }
};

module.exports = {
    authenticateFirebaseToken,
    authenticateApiKey,
    rateLimitApiKey,
    logApiUsage
}; 