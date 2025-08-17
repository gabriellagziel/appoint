// Basic metrics middleware
export const metricsMiddleware = (req, res, next) => {
    // Add request timing
    const start = Date.now();
    res.on('finish', () => {
        const duration = Date.now() - start;
        console.log(`${req.method} ${req.path} ${res.statusCode} ${duration}ms`);
    });
    next();
};
// Metrics route
const metricsRoute = (req, res) => {
    res.json({
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        service: 'appoint-functions'
    });
};
export default metricsRoute;
