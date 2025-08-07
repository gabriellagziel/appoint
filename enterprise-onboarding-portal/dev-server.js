const express = require('express');
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(__dirname));

// Security headers
app.use((req, res, next) => {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('X-XSS-Protection', '1; mode=block');
    next();
});

// HTML Routes
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/register-business.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'register-business.html'));
});

app.get('/login.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'login.html'));
});

app.get('/dashboard.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'dashboard.html'));
});

app.get('/api-keys.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'api-keys.html'));
});

app.get('/billing.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'billing.html'));
});

app.get('/settings.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'settings.html'));
});

app.get('/locations.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'locations.html'));
});

app.get('/analytics.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'analytics.html'));
});

app.get('/integrations.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'integrations.html'));
});

app.get('/white-label.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'white-label.html'));
});

app.get('/success.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'success.html'));
});

app.get('/terms.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'terms.html'));
});

app.get('/privacy.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'privacy.html'));
});

// API Routes (Mock responses for development)
app.get('/api/status', (req, res) => {
    res.json({
        status: 'operational',
        service: 'enterprise-onboarding-dev',
        version: '2.0.0',
        timestamp: new Date().toISOString(),
        firebase: 'mock'
    });
});

app.post('/registerBusiness', (req, res) => {
    // Mock registration response
    const mockApiKey = 'appoint_' + Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);

    res.status(201).json({
        success: true,
        id: 'mock-business-id-' + Date.now(),
        apiKey: mockApiKey,
        quota: 1000,
        status: 'active',
        message: 'Registration successful! Check your email for API access details.'
    });
});

app.get('/api/analytics', (req, res) => {
    res.json({
        totalAppointments: 1247,
        monthlyRevenue: 45230,
        activeLocations: 12,
        uptimeSLA: 99.9,
        apiUsage: {
            totalCalls: 1500,
            successfulCalls: 1480,
            successRate: 98.7,
            planLimit: 10000,
            remainingCalls: 8500
        },
        recentActivity: [
            { type: 'appointment', count: 45, date: new Date() },
            { type: 'revenue', amount: 1250, date: new Date() },
            { type: 'location', name: 'New Branch', date: new Date() }
        ]
    });
});

app.get('/api/user', (req, res) => {
    res.json({
        uid: 'mock-user-id',
        companyName: 'Demo Enterprise',
        email: 'demo@enterprise.com',
        subscriptionPlan: 'enterprise',
        createdAt: new Date(),
        isAdmin: false
    });
});

app.get('/api/keys/list', (req, res) => {
    res.json({
        apiKeys: [
            {
                id: 'key-1',
                label: 'Production API Key',
                permissions: 'admin',
                isActive: true,
                createdAt: new Date(),
                usageCount: 1500,
                lastUsed: new Date()
            },
            {
                id: 'key-2',
                label: 'Development API Key',
                permissions: 'read',
                isActive: true,
                createdAt: new Date(),
                usageCount: 250,
                lastUsed: new Date()
            }
        ]
    });
});

app.get('/api/invoices/user', (req, res) => {
    res.json({
        invoices: [
            {
                number: 'INV-2025-001',
                date: new Date(),
                amount: 999.00,
                status: 'paid',
                dueDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)
            },
            {
                number: 'INV-2025-002',
                date: new Date(),
                amount: 1247.50,
                status: 'pending',
                dueDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)
            }
        ]
    });
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        service: 'appoint-enterprise-dev'
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Development server running on http://localhost:${PORT}`);
    console.log(`📋 Available endpoints:`);
    console.log(`   - Landing page: http://localhost:${PORT}/`);
    console.log(`   - Registration: http://localhost:${PORT}/register-business.html`);
    console.log(`   - Login: http://localhost:${PORT}/login.html`);
    console.log(`   - Dashboard: http://localhost:${PORT}/dashboard.html`);
    console.log(`   - API Keys: http://localhost:${PORT}/api-keys.html`);
    console.log(`   - Billing: http://localhost:${PORT}/billing.html`);
    console.log(`   - Health check: http://localhost:${PORT}/api/status`);
    console.log(`\n🔧 Development mode - using mock data`);
}); 