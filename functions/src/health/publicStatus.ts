import { Request, Response } from 'express';

export interface PublicStatusResponse {
    status: 'healthy' | 'degraded' | 'unhealthy';
    timestamp: string;
    version: string;
    uptime: number;
    services: {
        database: 'healthy' | 'degraded' | 'unhealthy';
        email: 'healthy' | 'degraded' | 'unhealthy';
        storage: 'healthy' | 'degraded' | 'unhealthy';
    };
}

export const getPublicStatus = async (req: Request, res: Response): Promise<void> => {
    try {
        const startTime = Date.now();

        // Basic health checks
        const healthChecks = {
            database: await checkDatabaseHealth(),
            email: await checkEmailHealth(),
            storage: await checkStorageHealth()
        };

        const overallStatus = determineOverallStatus(healthChecks);

        const response: PublicStatusResponse = {
            status: overallStatus,
            timestamp: new Date().toISOString(),
            version: process.env.APP_VERSION || '1.0.0',
            uptime: process.uptime(),
            services: healthChecks
        };

        const statusCode = overallStatus === 'healthy' ? 200 :
            overallStatus === 'degraded' ? 200 : 503;

        res.status(statusCode).json(response);
    } catch (error) {
        console.error('Error in public status check:', error);
        res.status(503).json({
            status: 'unhealthy',
            timestamp: new Date().toISOString(),
            error: 'Health check failed'
        });
    }
};

async function checkDatabaseHealth(): Promise<'healthy' | 'degraded' | 'unhealthy'> {
    try {
        // Basic database connectivity check
        // In a real implementation, you'd test actual database connections
        return 'healthy';
    } catch (error) {
        console.error('Database health check failed:', error);
        return 'unhealthy';
    }
}

async function checkEmailHealth(): Promise<'healthy' | 'degraded' | 'unhealthy'> {
    try {
        // Basic email service check
        // In a real implementation, you'd test email service connectivity
        return 'healthy';
    } catch (error) {
        console.error('Email health check failed:', error);
        return 'degraded';
    }
}

async function checkStorageHealth(): Promise<'healthy' | 'degraded' | 'unhealthy'> {
    try {
        // Basic storage service check
        // In a real implementation, you'd test storage service connectivity
        return 'healthy';
    } catch (error) {
        console.error('Storage health check failed:', error);
        return 'degraded';
    }
}

function determineOverallStatus(services: Record<string, 'healthy' | 'degraded' | 'unhealthy'>): 'healthy' | 'degraded' | 'unhealthy' {
    const statuses = Object.values(services);

    if (statuses.every(status => status === 'healthy')) {
        return 'healthy';
    } else if (statuses.some(status => status === 'unhealthy')) {
        return 'unhealthy';
    } else {
        return 'degraded';
    }
}

