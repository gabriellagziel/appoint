const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const path = require('path');
const crypto = require('crypto');

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.static('public'));

// Environment variables for security
const JWT_SECRET = process.env.JWT_SECRET || crypto.randomBytes(64).toString('hex');
const EMAIL_USER = process.env.EMAIL_USER || 'noreply@appoint.com';
const EMAIL_PASS = process.env.EMAIL_PASS || 'secure-password';
const DATABASE_URL = process.env.DATABASE_URL || 'mongodb://localhost:27017/appoint-enterprise';

// Email configuration with security
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: EMAIL_USER,
        pass: EMAIL_PASS
    },
    secure: true,
    tls: {
        rejectUnauthorized: false
    }
});

// In-memory storage (replace with database in production)
const users = new Map();
const apiKeys = new Map();

// Security middleware
app.use((req, res, next) => {
    // Add security headers
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('X-XSS-Protection', '1; mode=block');
    res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
    next();
});

// Rate limiting
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100 // limit each IP to 100 requests per windowMs
});
app.use(limiter);

// Authentication middleware
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ error: 'Access token required' });
    }

    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            return res.status(403).json({ error: 'Invalid token' });
        }
        req.user = user;
        next();
    });
};

// Routes
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

// API Routes
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

        // Check if user already exists
        if (users.has(email)) {
            return res.status(409).json({ error: 'User already exists' });
        }

        // Hash password with salt
        const hashedPassword = await bcrypt.hash(password, 12);
        
        // Generate secure API key
        const apiKey = crypto.randomBytes(32).toString('hex');
        
        // Create user
        const user = {
            id: crypto.randomUUID(),
            companyName,
            email,
            password: hashedPassword,
            plan,
            apiKey,
            createdAt: new Date(),
            isActive: true
        };

        users.set(email, user);
        apiKeys.set(apiKey, user);

        // Generate JWT token
        const token = jwt.sign(
            { userId: user.id, email: user.email, companyName: user.companyName },
            JWT_SECRET,
            { expiresIn: '24h' }
        );

        // Send welcome email
        const mailOptions = {
            from: EMAIL_USER,
            to: email,
            subject: 'Welcome to Appoint Enterprise',
            html: `
                <h2>Welcome to Appoint Enterprise!</h2>
                <p>Your account has been successfully created.</p>
                <p><strong>Company:</strong> ${companyName}</p>
                <p><strong>Plan:</strong> ${plan}</p>
                <p>Your API key: <code>${apiKey}</code></p>
                <p>Keep this API key secure and don't share it with anyone.</p>
            `
        };

        await transporter.sendMail(mailOptions);

        res.status(201).json({
            message: 'Registration successful',
            token,
            apiKey,
            user: {
                id: user.id,
                companyName: user.companyName,
                email: user.email,
                plan: user.plan
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

        const user = users.get(email);
        if (!user) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const isValidPassword = await bcrypt.compare(password, user.password);
        if (!isValidPassword) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const token = jwt.sign(
            { userId: user.id, email: user.email, companyName: user.companyName },
            JWT_SECRET,
            { expiresIn: '24h' }
        );

        res.json({
            message: 'Login successful',
            token,
            user: {
                id: user.id,
                companyName: user.companyName,
                email: user.email,
                plan: user.plan
            }
        });

    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Protected routes
app.get('/api/user', authenticateToken, (req, res) => {
    const user = users.get(req.user.email);
    if (!user) {
        return res.status(404).json({ error: 'User not found' });
    }

    res.json({
        id: user.id,
        companyName: user.companyName,
        email: user.email,
        plan: user.plan,
        createdAt: user.createdAt
    });
});

app.get('/api/analytics', authenticateToken, (req, res) => {
    // Mock analytics data
    res.json({
        totalAppointments: 1247,
        monthlyRevenue: 45230,
        activeLocations: 12,
        uptimeSLA: 99.9,
        recentActivity: [
            { type: 'appointment', count: 45, date: new Date() },
            { type: 'revenue', amount: 1250, date: new Date() },
            { type: 'location', name: 'New Branch', date: new Date() }
        ]
    });
});

app.get('/api/locations', authenticateToken, (req, res) => {
    // Mock locations data
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
    console.log(`🔒 Security features enabled`);
    console.log(`📧 Email configured: ${EMAIL_USER}`);
}); 