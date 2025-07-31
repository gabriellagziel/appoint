import express from 'express';
import client from 'prom-client';

// אסוף מדדים מובנים של Node.js
client.collectDefaultMetrics();

// היסטוגרמת זמן תגובה
export const httpRequestDurationMs = new client.Histogram({
    name: 'http_request_duration_ms',
    help: 'Duration of HTTP requests in ms',
    labelNames: ['method', 'route', 'status_code'],
    buckets: [50, 100, 200, 300, 400, 500, 1000],
});

// Counter for total requests
export const httpRequestsTotal = new client.Counter({
    name: 'http_requests_total',
    help: 'Total number of HTTP requests',
    labelNames: ['method', 'route', 'status_code'],
});

// Gauge for active connections
export const activeConnections = new client.Gauge({
    name: 'active_connections',
    help: 'Number of active connections',
});

const router = express.Router();

// Metrics middleware
export function metricsMiddleware(req: any, res: any, next: any) {
    const end = httpRequestDurationMs.startTimer();

    res.on('finish', () => {
        const labels = {
            method: req.method,
            route: req.route?.path || req.url,
            status_code: res.statusCode
        };

        end(labels);
        httpRequestsTotal.inc(labels);
    });

    next();
}

// Metrics endpoint
router.get('/metrics', async (req, res) => {
    try {
        // Record this request
        const end = httpRequestDurationMs.startTimer();
        res.on('finish', () => {
            end({
                method: req.method,
                route: req.route?.path || req.url,
                status_code: res.statusCode
            });
        });

        // Return metrics in Prometheus format
        res.set('Content-Type', client.register.contentType);
        res.send(await client.register.metrics());
    } catch (error) {
        console.error('Metrics endpoint failed:', error);
        res.status(500).json({
            error: 'Failed to generate metrics',
            timestamp: new Date().toISOString()
        });
    }
});

export default router; 