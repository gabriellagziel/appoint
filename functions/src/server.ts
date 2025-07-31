import cors from 'cors';
import express from 'express';
import { liveness, readiness } from './health';
import metricsRoute, { metricsMiddleware } from './metrics';

const app = express();

// Apply metrics middleware to all routes
app.use(metricsMiddleware);

// CORS
app.use(cors({ origin: true }));

// Routes
app.use('/metrics', metricsRoute);

// Health checks
app.get('/health/liveness', liveness);
app.get('/health/readiness', readiness);

export default app;
