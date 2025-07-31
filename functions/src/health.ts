import * as functions from 'firebase-functions';
import { admin } from 'firebase-admin';

// Health check dependencies
let dbConnectionPool: any;
let redisClient: any;

// Initialize connections for health checks
try {
  // Initialize Firebase Admin if not already done
  if (!admin.apps.length) {
    admin.initializeApp();
  }
} catch (error) {
  console.warn('Firebase admin initialization skipped or failed:', error);
}

// Metrics collection
interface HealthMetrics {
  status: 'healthy' | 'degraded' | 'unhealthy';
  timestamp: string;
  service: string;
  version: string;
  environment: string;
  uptime: number;
  memory: NodeJS.MemoryUsage;
  cpu: {
    usage: number;
    loadAverage: number[];
  };
  database: {
    status: 'healthy' | 'unhealthy';
    responseTime: number;
    connections?: number;
  };
  redis: {
    status: 'healthy' | 'unhealthy';
    responseTime: number;
    memory?: number;
  };
  checks: {
    name: string;
    status: 'pass' | 'fail';
    responseTime: number;
    error?: string;
  }[];
}

// Database health check
async function checkDatabase(): Promise<{ status: 'healthy' | 'unhealthy'; responseTime: number; connections?: number }> {
  const startTime = Date.now();
  try {
    // Simple query to test database connectivity
    const db = admin.firestore();
    await db.collection('_health').doc('check').get();
    
    return {
      status: 'healthy',
      responseTime: Date.now() - startTime,
    };
  } catch (error) {
    console.error('Database health check failed:', error);
    return {
      status: 'unhealthy',
      responseTime: Date.now() - startTime,
    };
  }
}

// Redis health check
async function checkRedis(): Promise<{ status: 'healthy' | 'unhealthy'; responseTime: number; memory?: number }> {
  const startTime = Date.now();
  try {
    // If Redis client is available, test it
    if (redisClient) {
      await redisClient.ping();
    }
    
    return {
      status: 'healthy',
      responseTime: Date.now() - startTime,
    };
  } catch (error) {
    console.error('Redis health check failed:', error);
    return {
      status: 'unhealthy',
      responseTime: Date.now() - startTime,
    };
  }
}

// CPU usage calculation
function getCpuUsage(): { usage: number; loadAverage: number[] } {
  const usage = process.cpuUsage();
  const totalUsage = (usage.user + usage.system) / 1000000; // Convert to seconds
  
  return {
    usage: totalUsage,
    loadAverage: require('os').loadavg(),
  };
}

// Liveness probe - basic service availability
export const liveness = functions.https.onRequest((req, res) => {
  // Set CORS headers
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  // Only allow GET requests
  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  // Basic liveness check - service is running
  const livenessStatus = {
    status: 'alive',
    timestamp: new Date().toISOString(),
    service: 'app-oint-api',
    uptime: process.uptime(),
  };

  res.status(200).json(livenessStatus);
});

// Readiness probe - service ready to handle requests
export const readiness = functions.https.onRequest(async (req, res) => {
  // Set CORS headers
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  // Only allow GET requests
  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  try {
    const checks = [];
    let overallStatus = 'ready';

    // Check database connectivity
    const dbCheck = await checkDatabase();
    checks.push({
      name: 'database',
      status: dbCheck.status === 'healthy' ? 'pass' : 'fail',
      responseTime: dbCheck.responseTime,
    });

    // Check Redis connectivity
    const redisCheck = await checkRedis();
    checks.push({
      name: 'redis',
      status: redisCheck.status === 'healthy' ? 'pass' : 'fail',
      responseTime: redisCheck.responseTime,
    });

    // Determine overall readiness
    const failedChecks = checks.filter(check => check.status === 'fail');
    if (failedChecks.length > 0) {
      overallStatus = 'not_ready';
    }

    const readinessStatus = {
      status: overallStatus,
      timestamp: new Date().toISOString(),
      service: 'app-oint-api',
      checks,
    };

    const statusCode = overallStatus === 'ready' ? 200 : 503;
    res.status(statusCode).json(readinessStatus);
  } catch (error) {
    console.error('Readiness check failed:', error);
    res.status(503).json({
      status: 'not_ready',
      timestamp: new Date().toISOString(),
      service: 'app-oint-api',
      error: 'Readiness check failed',
    });
  }
});

// Comprehensive health endpoint with metrics
export const health = functions.https.onRequest(async (req, res) => {
  // Set CORS headers
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  // Only allow GET requests
  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  try {
    const checks = [];

    // Database health check
    const dbCheck = await checkDatabase();
    checks.push({
      name: 'database',
      status: dbCheck.status === 'healthy' ? 'pass' : 'fail',
      responseTime: dbCheck.responseTime,
      error: dbCheck.status === 'unhealthy' ? 'Database connectivity failed' : undefined,
    });

    // Redis health check
    const redisCheck = await checkRedis();
    checks.push({
      name: 'redis',
      status: redisCheck.status === 'healthy' ? 'pass' : 'fail',
      responseTime: redisCheck.responseTime,
      error: redisCheck.status === 'unhealthy' ? 'Redis connectivity failed' : undefined,
    });

    // Memory check
    const memory = process.memoryUsage();
    const memoryUsagePercent = (memory.heapUsed / memory.heapTotal) * 100;
    checks.push({
      name: 'memory',
      status: memoryUsagePercent < 90 ? 'pass' : 'fail',
      responseTime: 0,
      error: memoryUsagePercent >= 90 ? `High memory usage: ${memoryUsagePercent.toFixed(2)}%` : undefined,
    });

    // Determine overall health
    const failedChecks = checks.filter(check => check.status === 'fail');
    let overallStatus: 'healthy' | 'degraded' | 'unhealthy' = 'healthy';
    
    if (failedChecks.length === 1) {
      overallStatus = 'degraded';
    } else if (failedChecks.length > 1) {
      overallStatus = 'unhealthy';
    }

    const healthMetrics: HealthMetrics = {
      status: overallStatus,
      timestamp: new Date().toISOString(),
      service: 'app-oint-api',
      version: process.env.npm_package_version || '1.0.0',
      environment: process.env.NODE_ENV || 'development',
      uptime: process.uptime(),
      memory,
      cpu: getCpuUsage(),
      database: dbCheck,
      redis: redisCheck,
      checks,
    };

    const statusCode = overallStatus === 'healthy' ? 200 : overallStatus === 'degraded' ? 200 : 503;
    res.status(statusCode).json(healthMetrics);
  } catch (error) {
    console.error('Health check failed:', error);
    res.status(503).json({
      status: 'unhealthy',
      timestamp: new Date().toISOString(),
      service: 'app-oint-api',
      error: 'Health check failed',
      checks: [
        {
          name: 'system',
          status: 'fail',
          responseTime: 0,
          error: error instanceof Error ? error.message : 'Unknown error',
        },
      ],
    });
  }
});

// Legacy status endpoint for backward compatibility
export const status = health;