const express = require('express');
const cors = require('cors');
const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Health endpoints
app.get('/api/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        service: 'app-oint-api',
        timestamp: new Date().toISOString()
    });
});

app.get('/api/status', (req, res) => {
    res.status(200).json({
        status: 'operational',
        uptime: process.uptime(),
        timestamp: new Date().toISOString()
    });
});

// Business endpoints
app.get('/api/auth', (req, res) => {
    res.status(200).json({ status: 'auth-ready', service: 'authentication' });
});

app.get('/api/bookings', (req, res) => {
    res.status(200).json({ status: 'bookings-ready', service: 'booking-system' });
});

app.get('/api/users', (req, res) => {
    res.status(200).json({ status: 'users-ready', service: 'user-management' });
});

app.get('/api/services', (req, res) => {
    res.status(200).json({ status: 'services-ready', service: 'service-catalog' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`App-oint API server running on port ${PORT}`);
});

module.exports = app;
