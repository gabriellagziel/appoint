const express = require('express');
const path = require('path');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 80;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'dist')));

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