const express = require('express');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer');
const path = require('path');
const crypto = require('crypto');
require('dotenv').config();

// Import Firebase configuration and middleware
const { admin, collections, SUBSCRIPTION_PLANS } = require('./firebase-dev');
const { authenticateFirebaseToken, authenticateApiKey, rateLimitApiKey, logApiUsage } = require('./middleware/auth');

// Import route modules
const apiKeysRouter = require('./routes/api_keys');
const usageRouter = require('./routes/usage');
const invoicesRouter = require('./routes/invoices');

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.static(__dirname));

// Email configuration
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER || 'noreply@appoint.com',
        pass: process.env.EMAIL_PASS || 'secure-password'
    },
    secure: true,
    tls: {
        rejectUnauthorized: false
    }
});

// Security headers middleware
app.use((req, res, next) => {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('X-XSS-Protection', '1; mode=block');
    res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
    next();
});

// Rate limiting
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000,
    max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100
});
app.use(limiter);

// HTML Routes (serve static pages)
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/dashboard', (req, res) => {
    res.sendFile(path.join(__dirname, 'dashboard.html'));
});

app.get('/api-keys', (req, res) => {
    res.sendFile(path.join(__dirname, 'api-keys.html'));
});

app.get('/settings', (req, res) => {
    res.sendFile(path.join(__dirname, 'settings.html'));
});

app.get('/locations', (req, res) => {
    res.sendFile(path.join(__dirname, 'locations.html'));
});

app.get('/analytics', (req, res) => {
    res.sendFile(path.join(__dirname, 'analytics.html'));
});

app.get('/integrations', (req, res) => {
    res.sendFile(path.join(__dirname, 'integrations.html'));
});

app.get('/white-label', (req, res) => {
    res.sendFile(path.join(__dirname, 'white-label.html'));
});

app.get('/login', (req, res) => {
    res.sendFile(path.join(__dirname, 'login.html'));
});

app.get('/billing', (req, res) => {
    res.sendFile(path.join(__dirname, 'billing.html'));
});

// API Routes
app.use('/api/keys', apiKeysRouter);
app.use('/api/usage', usageRouter);
app.use('/api/invoices', invoicesRouter);

// Firebase Authentication Routes
app.post('/api/register', async (req, res) => {
    try {
        const { companyName, email, password, plan } = req.body;

        // Input validation
        if (!companyName || !email || !password || !plan) {
            return res.status(400).json({ error: 'All fields are required' });
        }

        // Email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            return res.status(400).json({ error: 'Invalid email format' });
        }

        // Password strength validation
        if (password.length < 8) {
            return res.status(400).json({ error: 'Password must be at least 8 characters long' });
        }

        // Check if user already exists in Firebase Auth
        try {
            await admin.auth().getUserByEmail(email);
            return res.status(409).json({ error: 'User already exists' });
        } catch (error) {
            // User doesn't exist, continue with registration
        }

        // Create user in Firebase Auth
        const userRecord = await admin.auth().createUser({
            email,
            password,
            displayName: companyName
        });

        // Create user document in Firestore
        const userData = {
            uid: userRecord.uid,
            companyName,
            email,
            subscriptionPlan: plan,
            createdAt: new Date(),
            isActive: true,
            isAdmin: false
        };

        await collections.users.doc(userRecord.uid).set(userData);

        // Generate custom token for client-side authentication
        const customToken = await admin.auth().createCustomToken(userRecord.uid);

        // Send welcome email
        const mailOptions = {
            from: process.env.EMAIL_USER || 'noreply@appoint.com',
            to: email,
            subject: 'Welcome to Appoint Enterprise',
            html: `
                <h2>Welcome to Appoint Enterprise!</h2>
                <p>Your account has been successfully created.</p>
                <p><strong>Company:</strong> ${companyName}</p>
                <p><strong>Plan:</strong> ${plan}</p>
                <p>You can now log in to your dashboard and start using our API services.</p>
            `
        };

        await transporter.sendMail(mailOptions);

        res.status(201).json({
            message: 'Registration successful',
            customToken,
            user: {
                uid: userRecord.uid,
                companyName,
                email,
                plan
            }
        });

    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/api/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ error: 'Email and password required' });
        }

        // Get user from Firebase Auth
        const userRecord = await admin.auth().getUserByEmail(email);

        // Get user data from Firestore
        const userDoc = await collections.users.doc(userRecord.uid).get();
        if (!userDoc.exists) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const userData = userDoc.data();
        if (!userData.isActive) {
            return res.status(401).json({ error: 'Account is suspended' });
        }

        // Generate custom token for client-side authentication
        const customToken = await admin.auth().createCustomToken(userRecord.uid);

        res.json({
            message: 'Login successful',
            customToken,
            user: {
                uid: userRecord.uid,
                companyName: userData.companyName,
                email: userData.email,
                plan: userData.subscriptionPlan
            }
        });

    } catch (error) {
        console.error('Login error:', error);
        res.status(401).json({ error: 'Invalid credentials' });
    }
});

// Protected user profile route
app.get('/api/user', authenticateFirebaseToken, async (req, res) => {
    try {
        const userDoc = await collections.users.doc(req.user.uid).get();
        if (!userDoc.exists) {
            return res.status(404).json({ error: 'User not found' });
        }

        const userData = userDoc.data();
        res.json({
            uid: userData.uid,
            companyName: userData.companyName,
            email: userData.email,
            subscriptionPlan: userData.subscriptionPlan,
            createdAt: userData.createdAt,
            isAdmin: userData.isAdmin || false
        });

    } catch (error) {
        console.error('Get user error:', error);
        res.status(500).json({ error: 'Failed to get user data' });
    }
});

// Analytics endpoint (protected)
app.get('/api/analytics', authenticateFirebaseToken, async (req, res) => {
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
        usageSnapshot.forEach(doc => {
            const data = doc.data();
            totalCalls++;
            if (data.statusCode >= 200 && data.statusCode < 300) {
                successfulCalls++;
            }
        });

        // Mock analytics data (replace with real data)
        res.json({
            totalAppointments: 1247,
            monthlyRevenue: 45230,
            activeLocations: 12,
            uptimeSLA: 99.9,
            apiUsage: {
                totalCalls,
                successfulCalls,
                successRate: totalCalls > 0 ? (successfulCalls / totalCalls) * 100 : 0,
                planLimit: planData.monthlyApiCalls,
                remainingCalls: Math.max(0, planData.monthlyApiCalls - totalCalls)
            },
            recentActivity: [
                { type: 'appointment', count: 45, date: new Date() },
                { type: 'revenue', amount: 1250, date: new Date() },
                { type: 'location', name: 'New Branch', date: new Date() }
            ]
        });

    } catch (error) {
        console.error('Analytics error:', error);
        res.status(500).json({ error: 'Failed to get analytics' });
    }
});

// Locations endpoint (protected)
app.get('/api/locations', authenticateFirebaseToken, async (req, res) => {
    try {
        // Mock locations data (replace with real data from Firestore)
        res.json([
            {
                id: 1,
                name: 'Headquarters',
                address: '123 Main St, New York, NY',
                status: 'active',
                appointments: 456
            },
            {
                id: 2,
                name: 'West Coast Office',
                address: '456 Tech Ave, San Francisco, CA',
                status: 'active',
                appointments: 234
            },
            {
                id: 3,
                name: 'European Branch',
                address: '789 Innovation St, London, UK',
                status: 'active',
                appointments: 567
            }
        ]);

    } catch (error) {
        console.error('Locations error:', error);
        res.status(500).json({ error: 'Failed to get locations' });
    }
});

// Health check endpoint
app.get('/api/status', (req, res) => {
    res.json({
        status: 'operational',
        service: 'enterprise-onboarding',
        version: '2.0.0',
        timestamp: new Date().toISOString(),
        firebase: 'connected'
    });
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Something went wrong!' });
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({ error: 'Route not found' });
});

app.listen(PORT, () => {
    console.log(`🚀 Enterprise portal running on port ${PORT}`);
    console.log(`🔒 Firebase integration enabled`);
    console.log(`📧 Email configured: ${process.env.EMAIL_USER || 'noreply@appoint.com'}`);
    console.log(`🌐 Environment: ${process.env.NODE_ENV || 'development'}`);
}); 
