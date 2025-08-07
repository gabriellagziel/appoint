const express = require('express');
const crypto = require('crypto');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3005;

// Middleware
app.use(express.json());

// Pilot customer management
const pilotCustomers = new Map();
const featureFlags = new Map();
const canaryEndpoints = new Map();

// Pilot customer class
class PilotCustomer {
    constructor(companyName, contactEmail, plan, features = []) {
        this.id = crypto.randomUUID();
        this.companyName = companyName;
        this.contactEmail = contactEmail;
        this.plan = plan;
        this.features = features;
        this.status = 'active';
        this.createdAt = new Date().toISOString();
        this.sandboxId = null;
        this.apiKey = null;
        this.usageMetrics = {
            apiCalls: 0,
            activeUsers: 0,
            lastActivity: new Date().toISOString()
        };
        this.feedback = [];
    }
}

// Feature flag management
class FeatureFlagManager {
    constructor() {
        this.flags = new Map();
        this.initializeFlags();
    }
    
    initializeFlags() {
        // Enterprise features
        this.flags.set('enterprise_sso', { enabled: true, pilotOnly: true });
        this.flags.set('enterprise_audit_logs', { enabled: true, pilotOnly: true });
        this.flags.set('enterprise_bulk_operations', { enabled: true, pilotOnly: true });
        this.flags.set('enterprise_sandbox', { enabled: true, pilotOnly: true });
        this.flags.set('enterprise_webhooks', { enabled: true, pilotOnly: true });
        this.flags.set('enterprise_ip_whitelist', { enabled: true, pilotOnly: true });
        this.flags.set('enterprise_hsm', { enabled: false, pilotOnly: true });
        this.flags.set('enterprise_vpc', { enabled: true, pilotOnly: true });
        
        // Canary features
        this.flags.set('canary_ml_recommendations', { enabled: false, pilotOnly: true });
        this.flags.set('canary_advanced_analytics', { enabled: false, pilotOnly: true });
        this.flags.set('canary_real_time_sync', { enabled: false, pilotOnly: true });
    }
    
    isFeatureEnabled(featureName, customerId = null) {
        const flag = this.flags.get(featureName);
        if (!flag) return false;
        
        if (flag.pilotOnly && customerId) {
            return pilotCustomers.has(customerId) && flag.enabled;
        }
        
        return flag.enabled;
    }
    
    setFeatureFlag(featureName, enabled, pilotOnly = false) {
        this.flags.set(featureName, { enabled, pilotOnly });
    }
    
    getFeatureFlags(customerId = null) {
        const flags = {};
        for (const [name, config] of this.flags.entries()) {
            if (customerId && config.pilotOnly) {
                flags[name] = pilotCustomers.has(customerId) && config.enabled;
            } else {
                flags[name] = config.enabled;
            }
        }
        return flags;
    }
}

const featureFlagManager = new FeatureFlagManager();

// Canary endpoint management
class CanaryEndpointManager {
    constructor() {
        this.endpoints = new Map();
        this.initializeEndpoints();
    }
    
    initializeEndpoints() {
        // ML-powered recommendations
        this.endpoints.set('ml_recommendations', {
            path: '/api/canary/ml/recommendations',
            method: 'POST',
            description: 'ML-powered booking recommendations',
            trafficPercentage: 10,
            pilotOnly: true
        });
        
        // Advanced analytics
        this.endpoints.set('advanced_analytics', {
            path: '/api/canary/analytics/advanced',
            method: 'GET',
            description: 'Advanced analytics and insights',
            trafficPercentage: 15,
            pilotOnly: true
        });
        
        // Real-time sync
        this.endpoints.set('real_time_sync', {
            path: '/api/canary/sync/realtime',
            method: 'POST',
            description: 'Real-time data synchronization',
            trafficPercentage: 5,
            pilotOnly: true
        });
    }
    
    isCanaryEnabled(endpointName, customerId = null) {
        const endpoint = this.endpoints.get(endpointName);
        if (!endpoint) return false;
        
        if (endpoint.pilotOnly && customerId) {
            return pilotCustomers.has(customerId);
        }
        
        // Traffic percentage check
        const random = Math.random() * 100;
        return random <= endpoint.trafficPercentage;
    }
    
    getCanaryEndpoints(customerId = null) {
        const enabledEndpoints = {};
        for (const [name, config] of this.endpoints.entries()) {
            enabledEndpoints[name] = this.isCanaryEnabled(name, customerId);
        }
        return enabledEndpoints;
    }
}

const canaryManager = new CanaryEndpointManager();

// Routes

// Pilot customer onboarding
app.post('/api/pilot/onboard', async (req, res) => {
    try {
        const { companyName, contactEmail, plan, features } = req.body;
        
        if (!companyName || !contactEmail || !plan) {
            return res.status(400).json({ error: 'Company name, contact email, and plan are required' });
        }
        
        // Create pilot customer
        const customer = new PilotCustomer(companyName, contactEmail, plan, features);
        
        // Generate sandbox
        customer.sandboxId = `sandbox_${customer.id}_${Date.now()}`;
        
        // Generate API key
        customer.apiKey = `appoint_pilot_${crypto.randomBytes(32).toString('hex')}`;
        
        // Store customer
        pilotCustomers.set(customer.id, customer);
        
        // Send welcome email (mock)
        console.log(`Welcome email sent to ${contactEmail}`);
        
        res.status(201).json({
            success: true,
            customer: {
                id: customer.id,
                companyName: customer.companyName,
                sandboxId: customer.sandboxId,
                apiKey: customer.apiKey,
                features: customer.features,
                status: customer.status
            }
        });
        
    } catch (error) {
        console.error('Pilot onboarding error:', error);
        res.status(500).json({ error: 'Failed to onboard pilot customer' });
    }
});

// Get pilot customers
app.get('/api/pilot/customers', (req, res) => {
    try {
        const customers = Array.from(pilotCustomers.values()).map(customer => ({
            id: customer.id,
            companyName: customer.companyName,
            contactEmail: customer.contactEmail,
            plan: customer.plan,
            features: customer.features,
            status: customer.status,
            createdAt: customer.createdAt,
            usageMetrics: customer.usageMetrics
        }));
        
        res.json({
            customers,
            total: customers.length
        });
        
    } catch (error) {
        console.error('Pilot customers error:', error);
        res.status(500).json({ error: 'Failed to retrieve pilot customers' });
    }
});

// Feature flag management
app.get('/api/pilot/feature-flags', (req, res) => {
    try {
        const { customerId } = req.query;
        const flags = featureFlagManager.getFeatureFlags(customerId);
        
        res.json({
            flags,
            customerId,
            timestamp: new Date().toISOString()
        });
        
    } catch (error) {
        console.error('Feature flags error:', error);
        res.status(500).json({ error: 'Failed to retrieve feature flags' });
    }
});

app.post('/api/pilot/feature-flags', (req, res) => {
    try {
        const { featureName, enabled, pilotOnly = false } = req.body;
        
        if (!featureName) {
            return res.status(400).json({ error: 'Feature name is required' });
        }
        
        featureFlagManager.setFeatureFlag(featureName, enabled, pilotOnly);
        
        res.json({
            success: true,
            feature: featureName,
            enabled,
            pilotOnly
        });
        
    } catch (error) {
        console.error('Feature flag update error:', error);
        res.status(500).json({ error: 'Failed to update feature flag' });
    }
});

// Canary endpoint management
app.get('/api/pilot/canary-endpoints', (req, res) => {
    try {
        const { customerId } = req.query;
        const endpoints = canaryManager.getCanaryEndpoints(customerId);
        
        res.json({
            endpoints,
            customerId,
            timestamp: new Date().toISOString()
        });
        
    } catch (error) {
        console.error('Canary endpoints error:', error);
        res.status(500).json({ error: 'Failed to retrieve canary endpoints' });
    }
});

// Usage tracking
app.post('/api/pilot/usage', (req, res) => {
    try {
        const { customerId, apiCalls, activeUsers } = req.body;
        
        if (!customerId || !pilotCustomers.has(customerId)) {
            return res.status(404).json({ error: 'Pilot customer not found' });
        }
        
        const customer = pilotCustomers.get(customerId);
        customer.usageMetrics.apiCalls += apiCalls || 0;
        customer.usageMetrics.activeUsers = activeUsers || customer.usageMetrics.activeUsers;
        customer.usageMetrics.lastActivity = new Date().toISOString();
        
        res.json({
            success: true,
            usageMetrics: customer.usageMetrics
        });
        
    } catch (error) {
        console.error('Usage tracking error:', error);
        res.status(500).json({ error: 'Failed to track usage' });
    }
});

// Feedback collection
app.post('/api/pilot/feedback', (req, res) => {
    try {
        const { customerId, feature, rating, comments, category } = req.body;
        
        if (!customerId || !pilotCustomers.has(customerId)) {
            return res.status(404).json({ error: 'Pilot customer not found' });
        }
        
        const customer = pilotCustomers.get(customerId);
        const feedback = {
            id: crypto.randomUUID(),
            feature,
            rating,
            comments,
            category,
            timestamp: new Date().toISOString()
        };
        
        customer.feedback.push(feedback);
        
        res.json({
            success: true,
            feedback
        });
        
    } catch (error) {
        console.error('Feedback error:', error);
        res.status(500).json({ error: 'Failed to submit feedback' });
    }
});

// Get feedback
app.get('/api/pilot/feedback', (req, res) => {
    try {
        const { customerId, feature, category } = req.query;
        
        let allFeedback = [];
        
        if (customerId) {
            const customer = pilotCustomers.get(customerId);
            if (customer) {
                allFeedback = customer.feedback;
            }
        } else {
            // Get all feedback from all customers
            for (const customer of pilotCustomers.values()) {
                allFeedback.push(...customer.feedback);
            }
        }
        
        // Apply filters
        if (feature) {
            allFeedback = allFeedback.filter(f => f.feature === feature);
        }
        
        if (category) {
            allFeedback = allFeedback.filter(f => f.category === category);
        }
        
        res.json({
            feedback: allFeedback,
            total: allFeedback.length
        });
        
    } catch (error) {
        console.error('Feedback retrieval error:', error);
        res.status(500).json({ error: 'Failed to retrieve feedback' });
    }
});

// Analytics and metrics
app.get('/api/pilot/analytics', (req, res) => {
    try {
        const analytics = {
            totalCustomers: pilotCustomers.size,
            activeCustomers: Array.from(pilotCustomers.values()).filter(c => c.status === 'active').length,
            totalApiCalls: Array.from(pilotCustomers.values()).reduce((sum, c) => sum + c.usageMetrics.apiCalls, 0),
            totalActiveUsers: Array.from(pilotCustomers.values()).reduce((sum, c) => sum + c.usageMetrics.activeUsers, 0),
            averageRating: calculateAverageRating(),
            featureAdoption: calculateFeatureAdoption(),
            canaryUsage: calculateCanaryUsage()
        };
        
        res.json(analytics);
        
    } catch (error) {
        console.error('Analytics error:', error);
        res.status(500).json({ error: 'Failed to retrieve analytics' });
    }
});

function calculateAverageRating() {
    let totalRating = 0;
    let totalFeedback = 0;
    
    for (const customer of pilotCustomers.values()) {
        for (const feedback of customer.feedback) {
            totalRating += feedback.rating;
            totalFeedback++;
        }
    }
    
    return totalFeedback > 0 ? totalRating / totalFeedback : 0;
}

function calculateFeatureAdoption() {
    const adoption = {};
    
    for (const [featureName, config] of featureFlagManager.flags.entries()) {
        if (config.pilotOnly) {
            const enabledCustomers = Array.from(pilotCustomers.values()).filter(customer => 
                customer.features.includes(featureName)
            ).length;
            
            adoption[featureName] = {
                enabled: enabledCustomers,
                total: pilotCustomers.size,
                percentage: pilotCustomers.size > 0 ? (enabledCustomers / pilotCustomers.size) * 100 : 0
            };
        }
    }
    
    return adoption;
}

function calculateCanaryUsage() {
    const usage = {};
    
    for (const [endpointName, config] of canaryManager.endpoints.entries()) {
        const enabledCustomers = Array.from(pilotCustomers.values()).filter(customer => 
            canaryManager.isCanaryEnabled(endpointName, customer.id)
        ).length;
        
        usage[endpointName] = {
            enabled: enabledCustomers,
            total: pilotCustomers.size,
            percentage: pilotCustomers.size > 0 ? (enabledCustomers / pilotCustomers.size) * 100 : 0
        };
    }
    
    return usage;
}

// Health check
app.get('/health', (req, res) => {
    res.json({ 
        status: 'healthy', 
        timestamp: new Date().toISOString(),
        pilot_customers: pilotCustomers.size,
        feature_flags: featureFlagManager.flags.size,
        canary_endpoints: canaryManager.endpoints.size
    });
});

app.listen(PORT, () => {
    console.log(`Pilot canary program server running on port ${PORT}`);
    console.log('Available endpoints:');
    console.log('- Pilot Management: /api/pilot/onboard, /api/pilot/customers');
    console.log('- Feature Flags: /api/pilot/feature-flags');
    console.log('- Canary Endpoints: /api/pilot/canary-endpoints');
    console.log('- Usage Tracking: /api/pilot/usage');
    console.log('- Feedback: /api/pilot/feedback');
    console.log('- Analytics: /api/pilot/analytics');
}); 