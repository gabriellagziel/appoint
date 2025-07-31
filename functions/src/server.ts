import cors from 'cors';
import express from 'express';
import metricsRoute, { metricsMiddleware } from './metrics';

const app = express();

// Apply metrics middleware to all routes
app.use(metricsMiddleware);

// CORS
app.use(cors({ origin: true }));

// Routes
app.use('/metrics', metricsRoute);

// Health checks
app.get('/health/liveness', (req, res) => {
  res.status(200).json({ status: 'alive', timestamp: new Date().toISOString() });
});

app.get('/health/readiness', (req, res) => {
  res.status(200).json({ status: 'ready', timestamp: new Date().toISOString() });
});

export default app;
