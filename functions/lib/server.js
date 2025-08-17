"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const cors_1 = __importDefault(require("cors"));
const express_1 = __importDefault(require("express"));
const health_js_1 = require("./health.js");
const metrics_js_1 = __importStar(require("./metrics.js"));
const admin_js_1 = require("./lib/admin.js");
const node_fetch_1 = __importDefault(require("node-fetch"));
const uuid_1 = require("uuid");
// Stripe route is optional in local dev; we will require it dynamically in handler
const app = (0, express_1.default)();
const PORT = parseInt(process.env.PORT || '8080', 10);
const HOST = process.env.HOSTNAME || '0.0.0.0';
// Apply metrics middleware to all routes
app.use(metrics_js_1.metricsMiddleware);
// CORS
const corsOptions = {
    origin: [
        'https://marketing.app-oint.com',
        'https://business.app-oint.com',
        'https://enterprise.app-oint.com',
        'https://personal.app-oint.com',
        'https://admin.app-oint.com',
        'https://app.app-oint.com',
        // Allow localhost for development
        'http://localhost:3000',
        'http://localhost:3001',
        'http://localhost:3002',
        'http://localhost:3003',
        'http://localhost:8080'
    ],
    credentials: true,
    optionsSuccessStatus: 200
};
app.use((0, cors_1.default)(corsOptions));
// Routes
app.use('/metrics', metrics_js_1.default);
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
app.post('/api/groups/:groupId/upgrade', express_1.default.json(), async (req, res) => {
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
app.post('/api/user/premium/checkout', express_1.default.json(), async (req, res) => {
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
        const resp = await (0, node_fetch_1.default)(url, {
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
app.post('/api/groups/invite/create', express_1.default.json(), async (req, res) => {
    try {
        const groupId = req.body?.groupId || '';
        if (!groupId) {
            res.status(400).json({ error: 'groupId required' });
            return;
        }
        const code = (0, uuid_1.v4)().slice(0, 8);
        await (0, admin_js_1.db)().collection('group_invites').doc(code).set({
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
app.post('/api/groups/invite/use', express_1.default.json(), async (req, res) => {
    try {
        const code = req.body?.code || '';
        const uid = req.body?.uid || '';
        if (!code || !uid) {
            res.status(400).json({ error: 'code and uid required' });
            return;
        }
        const ref = (0, admin_js_1.db)().collection('group_invites').doc(code);
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
app.get('/health/liveness', health_js_1.liveness);
app.get('/health/readiness', health_js_1.readiness);
app.get('/health', health_js_1.liveness);
app.get('/api/health', health_js_1.liveness);
// API routes
app.get('/api/status', (req, res) => {
    res.json({
        ok: true,
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
exports.default = app;
