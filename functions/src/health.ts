import * as functions from 'firebase-functions';

// Named exports for health endpoints
export function liveness(req: any, res: any) {
  res.status(200).json({
    status: 'alive',
    timestamp: new Date().toISOString(),
    service: 'firebase-functions',
    uptime: process.uptime()
  });
}

export function readiness(req: any, res: any) {
  // Perform readiness checks
  try {
    // Check if Firestore is accessible
    const db = functions.firestore;
    if (!db) {
      throw new Error('Firestore not available');
    }

    const healthStatus = {
      status: 'ready',
      timestamp: new Date().toISOString(),
      service: 'firebase-functions',
      version: '1.0.0',
      environment: process.env.NODE_ENV || 'development',
      uptime: process.uptime(),
      memory: process.memoryUsage(),
    };

    res.status(200).json(healthStatus);
  } catch (error) {
    console.error('Readiness check failed:', error);
    res.status(503).json({
      status: 'not ready',
      timestamp: new Date().toISOString(),
      message: 'Readiness check failed'
    });
  }
}

export const status = functions.https.onRequest((req, res) => {
  // Set CORS headers
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  // Only allow GET requests for health checks
  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  try {
    const healthStatus = {
      status: 'ok',
      timestamp: new Date().toISOString(),
      service: 'firebase-functions',
      version: '1.0.0',
      environment: process.env.NODE_ENV || 'development',
      uptime: process.uptime(),
      memory: process.memoryUsage(),
    };

    res.status(200).json(healthStatus);
  } catch (error) {
    console.error('Health check failed:', error);
    res.status(500).json({
      status: 'error',
      timestamp: new Date().toISOString(),
      message: 'Health check failed'
    });
  }
});