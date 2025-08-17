"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ipWhitelistMiddleware = void 0;
// Configure allowed IPs - in production this would come from environment variables
const ALLOWED_IPS = process.env.ALLOWED_IPS?.split(',') || ['127.0.0.1', '::1'];
const ipWhitelistMiddleware = (req, res, next) => {
    const clientIP = req.ip || req.connection.remoteAddress || req.socket.remoteAddress;
    // Allow localhost and development
    if (process.env.NODE_ENV === 'development') {
        return next();
    }
    if (!clientIP || !ALLOWED_IPS.includes(clientIP)) {
        console.warn(`Blocked request from unauthorized IP: ${clientIP}`);
        return res.status(403).json({
            error: 'Access denied',
            message: 'Your IP address is not authorized to access this resource'
        });
    }
    next();
};
exports.ipWhitelistMiddleware = ipWhitelistMiddleware;
