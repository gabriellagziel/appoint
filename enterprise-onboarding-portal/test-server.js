const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Body parser for JSON
app.use(express.json());

// Serve static files
app.use(express.static(__dirname));

// Serve HTML files
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
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

app.get('/success.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'success.html'));
});

app.get('/login.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'login.html'));
});

// Redirect /login to /login.html
app.get('/login', (req, res) => {
    res.redirect('/login.html');
});

// Register Business endpoint - proxy to Firebase function
app.post('/registerBusiness', async (req, res) => {
    try {
        // For local development, simulate the Firebase function
        const {
            companyName,
            website,
            address,
            vat,
            registration,
            country,
            currency,
            billingEmail,
            rep,
            taxId,
            firstName,
            lastName,
            email,
            phone,
            usage,
            intent,
            industry,
            size,
            tos,
            marketing
        } = req.body;

        // Validate required fields
        const requiredFields = ['companyName', 'website', 'address', 'country', 'currency', 'billingEmail', 'firstName', 'lastName', 'email', 'intent', 'tos'];
        const missingFields = requiredFields.filter(field => !req.body[field]);

        if (missingFields.length > 0) {
            return res.status(400).json({
                error: 'Missing required fields',
                missingFields
            });
        }

        // Validate terms of service acceptance
        if (!tos) {
            return res.status(400).json({ error: 'Terms of Service must be accepted' });
        }

        // Generate mock API key
        const apiKey = 'demo_' + Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
        const businessId = 'demo_' + Date.now();

        // Simulate successful registration
        console.log('New business registration:', {
            companyName,
            email,
            businessId,
            apiKey
        });

        res.status(201).json({
            success: true,
            id: businessId,
            apiKey,
            quota: 1000,
            status: 'pending',
            message: 'Registration submitted successfully. You will receive API access within 24 hours.'
        });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

// Mock API endpoints for testing
app.get('/api/user', (req, res) => {
    res.json({
        uid: 'test-user-123',
        email: 'test@enterprise.com',
        companyName: 'Test Enterprise'
    });
});

app.get('/api/analytics', (req, res) => {
    res.json({
        totalAppointments: 1247,
        monthlyRevenue: 45230,
        activeLocations: 12,
        uptimeSLA: 99.9,
        apiUsage: {
            totalCalls: 123456,
            successRate: 98.7,
            remainingCalls: 876544
        },
        recentActivity: [
            { type: 'appointment', count: 45, date: new Date() },
            { type: 'revenue', amount: 1250, date: new Date() },
            { type: 'location', name: 'New Branch', date: new Date() }
        ]
    });
});

app.get('/api/keys/list', (req, res) => {
    res.json({
        apiKeys: [
            {
                id: 'appoint_test_key_1',
                label: 'Dashboard Key',
                userId: 'test-user-123',
                permissions: ['read'],
                createdAt: new Date(),
                isActive: true,
                usageCount: 1234
            },
            {
                id: 'appoint_test_key_2',
                label: 'API Integration',
                userId: 'test-user-123',
                permissions: ['read', 'write'],
                createdAt: new Date(),
                isActive: true,
                usageCount: 5678
            }
        ]
    });
});

app.get('/api/invoices/user', (req, res) => {
    res.json({
        invoices: [
            {
                invoiceNumber: 'INV-2024-001',
                clientName: 'Test Enterprise',
                clientEmail: 'test@enterprise.com',
                invoiceDate: new Date(),
                dueDate: new Date(Date.now() + 15 * 24 * 60 * 60 * 1000),
                planName: 'Pro',
                planPrice: 100.00,
                totalUsage: 150000,
                overageCalls: 50000,
                overageAmount: 50.00,
                totalAmount: 150.00,
                status: 'pending'
            }
        ]
    });
});

app.listen(PORT, () => {
    console.log(`🚀 Test server running on port ${PORT}`);
    console.log(`📁 Serving static files from ${__dirname}`);
    console.log(`🌐 Open http://localhost:${PORT} to test the frontend`);
}); 