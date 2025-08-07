import { NextFunction, Request, Response } from 'express';

interface RateLimitStore {
    [key: string]: {
        count: number;
        resetTime: number;
    };
}

const rateLimitStore: RateLimitStore = {};

export const rateLimitMiddleware = (
    windowMs: number = 15 * 60 * 1000, // 15 minutes
    maxRequests: number = 100
) => {
    return (req: Request, res: Response, next: NextFunction) => {
        const key = req.ip || req.connection.remoteAddress || 'unknown';
        const now = Date.now();

        if (!rateLimitStore[key] || now > rateLimitStore[key].resetTime) {
            rateLimitStore[key] = {
                count: 1,
                resetTime: now + windowMs
            };
        } else {
            rateLimitStore[key].count++;
        }

        if (rateLimitStore[key].count > maxRequests) {
            return res.status(429).json({
                error: 'Too many requests',
                message: 'Rate limit exceeded. Please try again later.',
                retryAfter: Math.ceil((rateLimitStore[key].resetTime - now) / 1000)
            });
        }

        // Add rate limit headers
        res.set({
            'X-RateLimit-Limit': maxRequests.toString(),
            'X-RateLimit-Remaining': Math.max(0, maxRequests - rateLimitStore[key].count).toString(),
            'X-RateLimit-Reset': new Date(rateLimitStore[key].resetTime).toISOString()
        });

        next();
    };
};
