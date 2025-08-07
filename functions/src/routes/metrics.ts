import { Router } from 'express';
import { register } from '../middleware/metrics';

const router = Router();
router.get('/metrics', async (_req, res) => {
    res.set('Content-Type', register.contentType);
    res.send(await register.metrics());
});

export default router;
