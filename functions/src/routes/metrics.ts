import { Router } from 'express';
import { register } from '../middleware/metrics';
import { getGroupsMetrics } from '../groups/monitoring';

const router = Router();
router.get('/metrics', async (_req, res) => {
    res.set('Content-Type', register.contentType);
    res.send(await register.metrics());
});

router.get('/metrics/groups', async (_req, res) => {
    try {
        const metrics = await getGroupsMetrics();
        res.json(metrics);
    } catch (e: any) {
        res.status(500).json({ error: e?.message || 'failed' });
    }
});

export default router;
