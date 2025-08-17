"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.auditLogMiddleware = void 0;
const auditLogMiddleware = (req, res, next) => {
    // Basic audit logging middleware
    const auditData = {
        action: `${req.method} ${req.path}`,
        userId: req.headers['x-user-id'],
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
exports.auditLogMiddleware = auditLogMiddleware;
