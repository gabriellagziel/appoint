"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.simpleHealthCheck = exports.healthCheck = void 0;
const healthCheck = async (req, res) => {
    try {
        const healthData = {
            status: 'healthy',
            timestamp: new Date().toISOString(),
            service: 'app-oint-functions',
            version: process.env.npm_package_version || '1.0.0',
            uptime: process.uptime(),
            environment: process.env.NODE_ENV || 'unknown',
        };
        // Optional: Add dependency checks
        if (process.env.NODE_ENV !== 'test') {
            healthData.dependencies = {
                database: 'healthy', // Could add actual DB ping
                redis: 'healthy', // Could add actual Redis ping
                firebase: 'healthy', // Could add actual Firebase check
            };
        }
        res.status(200).json(healthData);
    }
    catch (error) {
        console.error('Health check failed:', error);
        const unhealthyData = {
            status: 'unhealthy',
            timestamp: new Date().toISOString(),
            service: 'app-oint-functions',
            version: process.env.npm_package_version || '1.0.0',
            uptime: process.uptime(),
            environment: process.env.NODE_ENV || 'unknown',
        };
        res.status(500).json(unhealthyData);
    }
};
exports.healthCheck = healthCheck;
// Simple health check for Docker health check
const simpleHealthCheck = (req, res) => {
    res.status(200).send('OK');
};
exports.simpleHealthCheck = simpleHealthCheck;
