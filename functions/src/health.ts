import { Request, Response } from 'express';

// Liveness probe - checks if the application is alive
export const liveness = (req: Request, res: Response) => {
  res.status(200).json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    service: 'appoint-functions',
    type: 'liveness'
  });
};

// Readiness probe - checks if the application is ready to serve requests
export const readiness = (req: Request, res: Response) => {
  // Add any additional checks here (database connectivity, etc.)
  res.status(200).json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    service: 'appoint-functions',
    type: 'readiness'
  });
};