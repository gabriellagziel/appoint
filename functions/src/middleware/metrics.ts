import { NextFunction, Request, Response } from 'express';
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

export function metricsMiddleware(req: Request, res: Response, next: NextFunction) {
  const end = httpRequestDurationMs.startTimer();
  res.on('finish', () => {
    end({ method: req.method, route: req.route?.path || req.url, status_code: res.statusCode });
  });
  next();
}

export const register = client.register;
