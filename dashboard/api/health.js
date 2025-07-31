// Health check endpoint for API
const express = require('express');
const router = express.Router();

router.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        service: 'app-oint-api',
        version: '1.0.0',
        environment: process.env.NODE_ENV || 'production'
    });
});

router.get('/status', (req, res) => {
    res.status(200).json({
        status: 'operational',
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        timestamp: new Date().toISOString()
    });
});

module.exports = router;
