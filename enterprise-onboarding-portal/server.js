const express = require('express');
const cors = require('cors');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const nodemailer = require('nodemailer');

const app = express();
const PORT = process.env.PORT || 80;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('.'));

// In-memory storage (replace with database in production)
const users = new Map();
const verificationCodes = new Map();
const apiKeys = new Map();

// Email configuration (replace with actual SMTP settings)
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER || 'noreply@appoint.com',
        pass: process.env.EMAIL_PASS || 'password'
    }
});

// JWT secret (use environment variable in production)
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// Generate API key
function generateApiKey() {
    return `appoint_${crypto.randomBytes(32).toString('hex')}`;
}

// Generate verification code
function generateVerificationCode() {
    return Math.floor(100000 + Math.random() * 900000).toString();
}

// Send verification email
async function sendVerificationEmail(email, code) {
    const mailOptions = {
        from: 'noreply@appoint.com',
        to: email,
        subject: 'Verify your App-Oint Enterprise account',
        html: `
            <h2>Welcome to App-Oint Enterprise!</h2>
            <p>Your verification code is: <strong>${code}</strong></p>
            <p>This code will expire in 10 minutes.</p>
        `
    };

    try {
        await transporter.sendMail(mailOptions);
        return true;
    } catch (error) {
        console.error('Email sending failed:', error);
        return false;
    }
}

// Routes
app.post('/api/enterprise/signup', async (req, res) => {
    try {
        const { companyName, email, password, plan } = req.body;

        // Validate input
        if (!companyName || !email || !password || !plan) {
            return res.status(400).json({ error: 'All fields are required' });
        }

        // Check if user already exists
        if (users.has(email)) {
            return res.status(409).json({ error: 'User already exists' });
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create user
        const user = {
            id: crypto.randomUUID(),
            companyName,
            email,
            password: hashedPassword,
            plan,
            status: 'pending',
            createdAt: new Date().toISOString()
        };

        users.set(email, user);

        // Generate and store verification code
        const verificationCode = generateVerificationCode();
        verificationCodes.set(email, {
            code: verificationCode,
            expiresAt: new Date(Date.now() + 10 * 60 * 1000) // 10 minutes
        });

        // Send verification email
        const emailSent = await sendVerificationEmail(email, verificationCode);
        if (!emailSent) {
            return res.status(500).json({ error: 'Failed to send verification email' });
        }

        res.json({ success: true, message: 'Verification email sent' });
    } catch (error) {
        console.error('Signup error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/api/enterprise/verify', async (req, res) => {
    try {
        const { email, verificationCode } = req.body;

        // Validate input
        if (!email || !verificationCode) {
            return res.status(400).json({ error: 'Email and verification code are required' });
        }

        // Check if user exists
        const user = users.get(email);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        // Check verification code
        const storedVerification = verificationCodes.get(email);
        if (!storedVerification || storedVerification.code !== verificationCode) {
            return res.status(400).json({ error: 'Invalid verification code' });
        }

        if (new Date() > storedVerification.expiresAt) {
            return res.status(400).json({ error: 'Verification code expired' });
        }

        // Update user status
        user.status = 'verified';
        user.verifiedAt = new Date().toISOString();

        // Generate API key
        const apiKey = generateApiKey();
        apiKeys.set(apiKey, {
            userId: user.id,
            email: user.email,
            plan: user.plan,
            createdAt: new Date().toISOString()
        });

        // Clean up verification code
        verificationCodes.delete(email);

        res.json({
            success: true,
            apiKey,
            message: 'Account verified successfully'
        });
    } catch (error) {
        console.error('Verification error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.get('/api/enterprise/usage/:apiKey', (req, res) => {
    try {
        const { apiKey } = req.params;
        const keyData = apiKeys.get(apiKey);

        if (!keyData) {
            return res.status(404).json({ error: 'Invalid API key' });
        }

        // Mock usage data (replace with actual usage tracking)
        const usage = {
            apiKey,
            plan: keyData.plan,
            currentMonth: {
                calls: Math.floor(Math.random() * 1000),
                limit: getPlanLimit(keyData.plan)
            },
            lastUpdated: new Date().toISOString()
        };

        res.json(usage);
    } catch (error) {
        console.error('Usage error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

function getPlanLimit(plan) {
    const limits = {
        free: 1000,
        starter: 10000,
        professional: 100000,
        enterprise: 1000000
    };
    return limits[plan] || 1000;
}

// Serve the main application
app.get('*', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

app.listen(PORT, () => {
    console.log(`Enterprise onboarding portal running on port ${PORT}`);
}); 