const express = require('express');
const path = require('path');
const cors = require('cors');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const app = express();
const PORT = process.env.PORT || 80;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'dist')));

// In-memory storage (replace with database in production)
const users = new Map();
const JWT_SECRET = process.env.JWT_SECRET || 'business-secret-key';

// Generate JWT token
function generateToken(userId) {
    return jwt.sign({ userId }, JWT_SECRET, { expiresIn: '24h' });
}

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        service: 'business',
        timestamp: new Date().toISOString(),
        version: '1.0.0'
    });
});

// API Endpoints for Mobile App Integration
app.get('/api/appointments', (req, res) => {
    res.json({
        appointments: [
            {
                id: 1,
                title: 'Business Meeting',
                start: '2025-08-01T10:00:00Z',
                end: '2025-08-01T11:00:00Z',
                status: 'confirmed'
            },
            {
                id: 2,
                title: 'Client Consultation',
                start: '2025-08-01T14:00:00Z',
                end: '2025-08-01T15:00:00Z',
                status: 'pending'
            }
        ]
    });
});

app.get('/api/customers', (req, res) => {
    res.json({
        customers: [
            {
                id: 1,
                name: 'John Doe',
                email: 'john@example.com',
                phone: '+1234567890'
            },
            {
                id: 2,
                name: 'Jane Smith',
                email: 'jane@example.com',
                phone: '+1234567891'
            }
        ]
    });
});

app.get('/api/analytics', (req, res) => {
    res.json({
        totalAppointments: 150,
        confirmedAppointments: 120,
        pendingAppointments: 30,
        revenue: 15000,
        customers: 45
    });
});

app.get('/api/payments', (req, res) => {
    res.json({
        payments: [
            {
                id: 1,
                amount: 500,
                status: 'completed',
                date: '2025-08-01T09:00:00Z'
            },
            {
                id: 2,
                amount: 750,
                status: 'pending',
                date: '2025-08-01T10:00:00Z'
            }
        ]
    });
});

// Authentication endpoints
app.post('/api/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        // Validate input
        if (!email || !password) {
            return res.status(400).json({ error: 'Email and password are required' });
        }

        // Check if user exists (for demo, accept any valid email/password)
        if (email && password) {
            const userId = Math.floor(Math.random() * 1000);
            const token = generateToken(userId);

            res.json({
                success: true,
                token,
                user: {
                    id: userId,
                    email,
                    name: 'Business User'
                }
            });
        } else {
            res.status(401).json({ error: 'Invalid credentials' });
        }
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/api/auth/register', async (req, res) => {
    try {
        const { email, password, name } = req.body;

        // Validate input
        if (!email || !password || !name) {
            return res.status(400).json({ error: 'Email, password, and name are required' });
        }

        // Check if user already exists
        if (users.has(email)) {
            return res.status(409).json({ error: 'User already exists' });
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create user
        const userId = Math.floor(Math.random() * 1000);
        const user = {
            id: userId,
            email,
            name,
            password: hashedPassword,
            createdAt: new Date().toISOString()
        };

        users.set(email, user);

        // Generate token
        const token = generateToken(userId);

        res.status(201).json({
            success: true,
            token,
            user: {
                id: userId,
                email,
                name
            }
        });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/api/appointments', (req, res) => {
    res.json({
        success: true,
        message: 'Appointment created successfully',
        appointmentId: Math.floor(Math.random() * 1000)
    });
});

// Handle all other routes by serving index.html (SPA)
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Business app server running on port ${PORT}`);
    console.log(`API endpoints available at /api/*`);
    console.log(`Health check available at /health`);
}); 