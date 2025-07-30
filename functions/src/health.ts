import { Request, Response } from 'express';

export interface HealthStatus {
  status: 'healthy' | 'unhealthy';
  timestamp: string;
  service: string;
  version: string;
  uptime: number;
  environment: string;
  dependencies?: {
    database?: 'healthy' | 'unhealthy';
    redis?: 'healthy' | 'unhealthy';
    firebase?: 'healthy' | 'unhealthy';
  };
}

export const healthCheck = async (req: Request, res: Response): Promise<void> => {
  try {
    const healthData: HealthStatus = {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      service: 'app-oint-functions',
      version: process.env.npm_package_version || '1.0.0',
      uptime: process.uptime(),
      environment: process.env.NODE_ENV || 'unknown',
    };

    // Optional: Add dependency checks
    if (process.env.NODE_ENV !== 'test') {
      healthData.dependencies = {
        database: 'healthy', // Could add actual DB ping
        redis: 'healthy',    // Could add actual Redis ping
        firebase: 'healthy', // Could add actual Firebase check
      };
    }

    res.status(200).json(healthData);
  } catch (error) {
    console.error('Health check failed:', error);
    
    const unhealthyData: HealthStatus = {
      status: 'unhealthy',
      timestamp: new Date().toISOString(),
      service: 'app-oint-functions',
      version: process.env.npm_package_version || '1.0.0',
      uptime: process.uptime(),
      environment: process.env.NODE_ENV || 'unknown',
    };

    res.status(500).json(unhealthyData);
  }
};

// Simple health check for Docker health check
export const simpleHealthCheck = (req: Request, res: Response): void => {
  res.status(200).send('OK');
};