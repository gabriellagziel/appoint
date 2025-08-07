const express = require('express');
const { collections, SUBSCRIPTION_PLANS } = require('../firebase');
const { authenticateFirebaseToken, authenticateApiKey, rateLimitApiKey, logApiUsage } = require('../middleware/auth');

const router = express.Router();

// Get usage analytics for authenticated user
router.get('/analytics', authenticateFirebaseToken, async (req, res) => {
    try {
        const userId = req.user.uid;

        // Get user's subscription plan
        const userDoc = await collections.users.doc(userId).get();
        const userData = userDoc.data();
        const plan = userData.subscriptionPlan || 'basic';
        const planData = SUBSCRIPTION_PLANS[plan];

        // Get current month's usage
        const now = new Date();
        const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
        const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);

        const usageSnapshot = await collections.usageLogs
            .where('userId', '==', userId)
            .where('timestamp', '>=', startOfMonth)
            .where('timestamp', '<=', endOfMonth)
            .get();

        let totalCalls = 0;
        let successfulCalls = 0;
        let failedCalls = 0;
        const endpointBreakdown = {};

        usageSnapshot.forEach(doc => {
            const data = doc.data();
            totalCalls++;

            if (data.statusCode >= 200 && data.statusCode < 300) {
                successfulCalls++;
            } else {
                failedCalls++;
            }

            const endpoint = data.endpoint;
            endpointBreakdown[endpoint] = (endpointBreakdown[endpoint] || 0) + 1;
        });

        // Get API keys usage
        const apiKeysSnapshot = await collections.apiKeys
            .where('userId', '==', userId)
            .get();

        const apiKeysUsage = [];
        apiKeysSnapshot.forEach(doc => {
            const data = doc.data();
            apiKeysUsage.push({
                label: data.label,
                usageCount: data.usageCount || 0,
                lastUsed: data.lastUsed ? data.lastUsed.toDate() : null,
                isActive: data.isActive
            });
        });

        // Calculate usage percentage
        const usagePercentage = (totalCalls / planData.monthlyApiCalls) * 100;

        res.json({
            currentPlan: plan,
            planData,
            usage: {
                totalCalls,
                successfulCalls,
                failedCalls,
                successRate: totalCalls > 0 ? (successfulCalls / totalCalls) * 100 : 0,
                usagePercentage,
                remainingCalls: Math.max(0, planData.monthlyApiCalls - totalCalls),
                endpointBreakdown
            },
            apiKeysUsage,
            period: {
                start: startOfMonth,
                end: endOfMonth
            }
        });

    } catch (error) {
        console.error('Usage analytics error:', error);
        res.status(500).json({ error: 'Failed to get usage analytics' });
    }
});

// Get usage for specific API key
router.get('/api-key/:apiKey', authenticateFirebaseToken, async (req, res) => {
    try {
        const { apiKey } = req.params;
        const userId = req.user.uid;

        // Verify API key ownership
        const apiKeyDoc = await collections.apiKeys.doc(apiKey).get();
        if (!apiKeyDoc.exists) {
            return res.status(404).json({ error: 'API key not found' });
        }

        const apiKeyData = apiKeyDoc.data();
        if (apiKeyData.userId !== userId) {
            return res.status(403).json({ error: 'Access denied' });
        }

        // Get usage for this API key
        const now = new Date();
        const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
        const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);

        const usageSnapshot = await collections.usageLogs
            .where('apiKey', '==', apiKey)
            .where('timestamp', '>=', startOfMonth)
            .where('timestamp', '<=', endOfMonth)
            .orderBy('timestamp', 'desc')
            .limit(100)
            .get();

        const usageLogs = [];
        usageSnapshot.forEach(doc => {
            const data = doc.data();
            usageLogs.push({
                timestamp: data.timestamp.toDate(),
                endpoint: data.endpoint,
                method: data.method,
                statusCode: data.statusCode,
                userAgent: data.userAgent,
                ipAddress: data.ipAddress
            });
        });

        res.json({
            apiKey: apiKeyData.label,
            usageLogs,
            period: {
                start: startOfMonth,
                end: endOfMonth
            }
        });

    } catch (error) {
        console.error('API key usage error:', error);
        res.status(500).json({ error: 'Failed to get API key usage' });
    }
});

// Get real-time usage statistics
router.get('/realtime', authenticateFirebaseToken, async (req, res) => {
    try {
        const userId = req.user.uid;

        // Get last 24 hours usage
        const now = new Date();
        const yesterday = new Date(now.getTime() - 24 * 60 * 60 * 1000);

        const recentUsageSnapshot = await collections.usageLogs
            .where('userId', '==', userId)
            .where('timestamp', '>=', yesterday)
            .get();

        let totalCalls24h = 0;
        let successfulCalls24h = 0;
        const hourlyBreakdown = {};

        recentUsageSnapshot.forEach(doc => {
            const data = doc.data();
            totalCalls24h++;

            if (data.statusCode >= 200 && data.statusCode < 300) {
                successfulCalls24h++;
            }

            const hour = data.timestamp.toDate().getHours();
            hourlyBreakdown[hour] = (hourlyBreakdown[hour] || 0) + 1;
        });

        // Get current month's total
        const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
        const monthlyUsageSnapshot = await collections.usageLogs
            .where('userId', '==', userId)
            .where('timestamp', '>=', startOfMonth)
            .get();

        let monthlyTotal = 0;
        monthlyUsageSnapshot.forEach(() => {
            monthlyTotal++;
        });

        res.json({
            last24Hours: {
                totalCalls: totalCalls24h,
                successfulCalls: successfulCalls24h,
                successRate: totalCalls24h > 0 ? (successfulCalls24h / totalCalls24h) * 100 : 0,
                hourlyBreakdown
            },
            currentMonth: {
                totalCalls: monthlyTotal
            },
            timestamp: now
        });

    } catch (error) {
        console.error('Real-time usage error:', error);
        res.status(500).json({ error: 'Failed to get real-time usage' });
    }
});

// Enterprise API endpoint for usage (protected by API key)
router.get('/enterprise/usage', authenticateApiKey, rateLimitApiKey, logApiUsage, async (req, res) => {
    try {
        const userId = req.userId;

        // Get user's subscription plan
        const userDoc = await collections.users.doc(userId).get();
        const userData = userDoc.data();
        const plan = userData.subscriptionPlan || 'basic';
        const planData = SUBSCRIPTION_PLANS[plan];

        // Get current month's usage
        const now = new Date();
        const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
        const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);

        const usageSnapshot = await collections.usageLogs
            .where('userId', '==', userId)
            .where('timestamp', '>=', startOfMonth)
            .where('timestamp', '<=', endOfMonth)
            .get();

        let totalCalls = 0;
        usageSnapshot.forEach(() => {
            totalCalls++;
        });

        const usagePercentage = (totalCalls / planData.monthlyApiCalls) * 100;

        res.json({
            userId,
            plan,
            usage: {
                current: totalCalls,
                limit: planData.monthlyApiCalls,
                remaining: Math.max(0, planData.monthlyApiCalls - totalCalls),
                percentage: usagePercentage
            },
            period: {
                start: startOfMonth,
                end: endOfMonth
            }
        });

    } catch (error) {
        console.error('Enterprise usage endpoint error:', error);
        res.status(500).json({ error: 'Failed to get usage data' });
    }
});

module.exports = router; 