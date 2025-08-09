import cors from 'cors';
import express from 'express';
import { liveness, readiness } from './health';
import metricsRoute, { metricsMiddleware } from './metrics';
import { db as getDb, auth as getAuth } from './lib/admin';
import { onRequest } from 'firebase-functions/v2/https';
import { createProCheckoutSession } from './groups/proUpgrade';
import { getGroupsMetrics } from './groups/monitoring';

const app = express();
const PORT = parseInt(process.env.PORT || '8080', 10);
const HOST = process.env.HOSTNAME || '0.0.0.0';

// Apply metrics middleware to all routes
app.use(metricsMiddleware);

// CORS
app.use(cors({ origin: true }));

// Routes
app.use('/metrics', metricsRoute);

// Groups health endpoint
app.get('/api/groups/healthz', (_req, res) => res.json({ ok: true }));

// Groups metrics endpoint
app.get('/api/groups/metrics', async (_req, res) => {
  try {
    const metrics = await getGroupsMetrics();
    res.json(metrics);
  } catch (e: any) {
    res.status(500).json({ error: e?.message || 'failed' });
  }
});

// Groups upgrade: creates Stripe checkout session
app.post('/api/groups/:groupId/upgrade', express.json(), async (req, res) => {
  try {
    const { groupId } = req.params;
    const { priceId } = req.body || {};
    if (!priceId) {
      res.status(400).json({ error: 'priceId required' });
      return;
    }
    const session = await createProCheckoutSession(groupId, priceId);
    res.json({ url: (session as any).url, id: (session as any).id });
  } catch (e: any) {
    res.status(500).json({ error: e?.message || 'failed' });
  }
});

app.get('/api/groups/:groupId/upgrade', async (req, res) => {
  try {
    const { groupId } = req.params;
    const priceId = (req.query.priceId as string) || process.env.GROUP_PRO_PRICE_ID;
    if (!priceId) {
      res.status(400).json({ error: 'priceId required' });
      return;
    }
    const session = await createProCheckoutSession(groupId, priceId);
    res.json({ url: (session as any).url, id: (session as any).id });
  } catch (e: any) {
    res.status(500).json({ error: e?.message || 'failed' });
  }
});

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
