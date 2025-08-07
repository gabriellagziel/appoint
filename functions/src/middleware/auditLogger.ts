import { NextFunction, Request, Response } from 'express';

export interface AuditLogData {
    action: string;
    userId?: string;
    resourceId?: string;
    details?: any;
    timestamp: Date;
}

export const auditLogMiddleware = (req: Request, res: Response, next: NextFunction) => {
    // Basic audit logging middleware
    const auditData: AuditLogData = {
        action: `${req.method} ${req.path}`,
        userId: req.headers['x-user-id'] as string,
        resourceId: req.params.id,
        details: {
            userAgent: req.headers['user-agent'],
            ip: req.ip,
            query: req.query,
            body: req.method !== 'GET' ? req.body : undefined
        },
        timestamp: new Date()
    };

    // Log to console for now - in production this would go to a proper logging service
    console.log('AUDIT_LOG:', JSON.stringify(auditData, null, 2));

    next();
};
