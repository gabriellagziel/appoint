import cors from 'cors';
import express from 'express';
import { liveness, readiness } from './health.js';
import metricsRoute, { metricsMiddleware } from './metrics.js';
import { db as getDb } from './lib/admin.js';
import fetch from 'node-fetch';
import { v4 as uuidv4 } from 'uuid';
// Stripe route is optional in local dev; we will require it dynamically in handler
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
// Groups metrics endpoint (optional in local dev)
app.get('/api/groups/metrics', async (_req, res) => {
    try {
        // eslint-disable-next-line @typescript-eslint/no-var-requires
        const mod = require('./groups/monitoring');
        const metrics = await mod.getGroupsMetrics();
        res.json(metrics);
    }
    catch (e) {
        res.status(501).json({ error: 'metrics_disabled_in_local_dev', details: e?.message });
    }
});
// Groups upgrade: creates Stripe checkout session (optional in local dev)
app.post('/api/groups/:groupId/upgrade', express.json(), async (req, res) => {
    try {
        const { groupId } = req.params;
        const { priceId } = req.body || {};
        if (!priceId) {
            res.status(400).json({ error: 'priceId required' });
            return;
        }
        // eslint-disable-next-line @typescript-eslint/no-var-requires
        const mod = require('./groups/proUpgrade');
        const session = await mod.createProCheckoutSession(groupId, priceId);
        res.json({ url: session.url, id: session.id });
    }
    catch (e) {
        res.status(501).json({ error: 'stripe_disabled_in_local_dev', details: e?.message });
    }
});
app.get('/api/groups/:groupId/upgrade', async (req, res) => {
    try {
        const { groupId } = req.params;
        const priceId = req.query.priceId || process.env.GROUP_PRO_PRICE_ID;
        if (!priceId) {
            res.status(400).json({ error: 'priceId required' });
            return;
        }
        // eslint-disable-next-line @typescript-eslint/no-var-requires
        const mod = require('./groups/proUpgrade');
        const session = await mod.createProCheckoutSession(groupId, priceId);
        res.json({ url: session.url, id: session.id });
    }
    catch (e) {
        res.status(501).json({ error: 'stripe_disabled_in_local_dev', details: e?.message });
    }
});
// Personal premium: lightweight wrapper to reuse existing createCheckoutSession
app.post('/api/user/premium/checkout', express.json(), async (req, res) => {
    try {
        const { userId, priceId, successUrl, cancelUrl } = req.body || {};
        if (!userId || !priceId) {
            res.status(400).json({ error: 'userId and priceId required' });
            return;
        }
        // Reuse Stripe handler by mapping studioId -> userId
        // Prefix with user: so the webhook can route to users collection
        req.body = { studioId: `user:${userId}`, priceId, successUrl, cancelUrl };
        try {
            // eslint-disable-next-line @typescript-eslint/no-var-requires
            const stripeModule = require('./stripe');
            await stripeModule.createCheckoutSession({ ...req }, res);
        }
        catch (e) {
            res.status(501).json({ error: 'stripe_disabled_in_local_dev', details: e?.message });
        }
    }
    catch (e) {
        res.status(500).json({ error: e?.message || 'failed' });
    }
});
// Places autocomplete via Frrm/OSM Nominatim (lightweight proxy)
app.get('/api/places/autocomplete', async (req, res) => {
    try {
        const q = req.query.q || '';
        if (!q || q.trim().length < 2) {
            res.json({ predictions: [] });
            return;
        }
        const url = `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(q)}&format=json&limit=5`;
        const resp = await fetch(url, {
            headers: { 'User-Agent': 'App-Oint/1.0 (personal PWA)' },
        });
        if (!resp.ok) {
            res.status(502).json({ error: 'upstream_failed' });
            return;
        }
        const data = await resp.json();
        const predictions = Array.isArray(data)
            ? data.map((m) => ({
                description: m.display_name,
                lat: parseFloat(m.lat),
                lng: parseFloat(m.lon),
            }))
            : [];
        res.json({ predictions });
    }
    catch (e) {
        res.status(500).json({ error: e?.message || 'failed' });
    }
});
// Create invite code for participants joining
app.post('/api/groups/invite/create', express.json(), async (req, res) => {
    try {
        const groupId = req.body?.groupId || '';
        if (!groupId) {
            res.status(400).json({ error: 'groupId required' });
            return;
        }
        const code = uuidv4().slice(0, 8);
        await getDb().collection('group_invites').doc(code).set({
            groupId,
            createdAt: Date.now(),
            usedBy: [],
        }, { merge: true });
        res.json({ code, url: `https://app.app-oint.com/join?code=${code}` });
    }
    catch (e) {
        res.status(500).json({ error: e?.message || 'failed' });
    }
});
// Resolve invite code use (append uid to usedBy list)
app.post('/api/groups/invite/use', express.json(), async (req, res) => {
    try {
        const code = req.body?.code || '';
        const uid = req.body?.uid || '';
        if (!code || !uid) {
            res.status(400).json({ error: 'code and uid required' });
            return;
        }
        const ref = getDb().collection('group_invites').doc(code);
        const snap = await ref.get();
        if (!snap.exists) {
            res.status(404).json({ error: 'invalid_code' });
            return;
        }
        const data = snap.data() || {};
        const usedBy = Array.isArray(data.usedBy) ? data.usedBy : [];
        if (!usedBy.includes(uid))
            usedBy.push(uid);
        await ref.update({ usedBy });
        res.json({ groupId: data.groupId });
    }
    catch (e) {
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
app.use((err, req, res, next) => {
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
