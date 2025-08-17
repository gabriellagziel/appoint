// Minimal metrics route for functions express server, exporting a router
import express from 'express';
import { getGroupsMetrics } from '../groups/monitoring.js';
const router = express.Router();
router.get('/', async (_req, res) => {
    // Inline comment: expose system metrics; extend with counters/histograms if using Prometheus
    const groups = await getGroupsMetrics();
    res.json({ ok: true, groups });
});
export default router;
export const metricsMiddleware = (_req, _res, next) => {
    // Inline comment: place to add correlation IDs, request timing, etc.
    next();
};
