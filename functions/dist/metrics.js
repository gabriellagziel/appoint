"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.metricsMiddleware = void 0;
// Basic metrics middleware
const metricsMiddleware = (req, res, next) => {
    // Add request timing
    const start = Date.now();
    res.on('finish', () => {
        const duration = Date.now() - start;
        console.log(`${req.method} ${req.path} ${res.statusCode} ${duration}ms`);
    });
    next();
};
exports.metricsMiddleware = metricsMiddleware;
// Metrics route
const metricsRoute = (req, res) => {
    res.json({
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        service: 'appoint-functions'
    });
};
exports.default = metricsRoute;
