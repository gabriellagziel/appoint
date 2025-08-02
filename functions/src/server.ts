import cors from 'cors';
import express from 'express';
import { liveness, readiness } from './health';
import metricsRoute, { metricsMiddleware } from './metrics';

const app = express();
const PORT = parseInt(process.env.PORT || '8080', 10);
const HOST = process.env.HOSTNAME || '0.0.0.0';

// Apply metrics middleware to all routes
app.use(metricsMiddleware);

// CORS
app.use(cors({ origin: true }));

// Routes
app.use('/metrics', metricsRoute);

// Health checks
app.get('/health/liveness', liveness);
app.get('/health/readiness', readiness);
app.get('/health', liveness);
app.get('/api/health', liveness);

// API routes
app.get('/api/status', (req, res) => {
    res.json({
        message: 'App-Oint Functions API is running',
        timestamp: new Date().toISOString(),
        version: process.env.npm_package_version || '1.0.0'
    });
});

// 404 handler
app.use('*', (req, res) => {
    res.status(404).json({
        error: 'Not Found',
        message: `Route ${req.originalUrl} not found`,
        timestamp: new Date().toISOString()
    });
});

// Error handler
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.error('Error:', err);
    res.status(500).json({
        error: 'Internal Server Error',
        message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong',
        timestamp: new Date().toISOString()
    });
});

// Start server only if not in test environment
if (process.env.NODE_ENV !== 'test') {
    app.listen(PORT, HOST, () => {
        console.log(`🚀 Functions API server running on http://${HOST}:${PORT}`);
        console.log(`📊 Health check available at http://${HOST}:${PORT}/health`);
        console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
    });
}

export default app;
