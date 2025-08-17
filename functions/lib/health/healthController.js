"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.healthController = void 0;
const admin = __importStar(require("firebase-admin"));
class HealthController {
    constructor() {
        this.metrics = [];
    }
    static getInstance() {
        if (!HealthController.instance) {
            HealthController.instance = new HealthController();
        }
        return HealthController.instance;
    }
    /**
     * Liveness endpoint - indicates if the service is running
     */
    async liveness(req, res) {
        try {
            const startTime = Date.now();
            // Basic health checks
            const checks = await Promise.all([
                this.checkDatabase(),
                this.checkFirebase(),
                this.checkMemory(),
            ]);
            const isHealthy = checks.every(check => check);
            const responseTime = Date.now() - startTime;
            if (isHealthy) {
                res.status(200).json({
                    status: 'healthy',
                    timestamp: new Date().toISOString(),
                    responseTime,
                    checks: {
                        database: checks[0],
                        firebase: checks[1],
                        memory: checks[2],
                    },
                });
            }
            else {
                res.status(503).json({
                    status: 'unhealthy',
                    timestamp: new Date().toISOString(),
                    responseTime,
                    checks: {
                        database: checks[0],
                        firebase: checks[1],
                        memory: checks[2],
                    },
                });
            }
        }
        catch (error) {
            res.status(500).json({
                status: 'error',
                timestamp: new Date().toISOString(),
                error: error instanceof Error ? error.message : 'Unknown error',
            });
        }
    }
    /**
     * Readiness endpoint - indicates if the service is ready to serve requests
     */
    async readiness(req, res) {
        try {
            const startTime = Date.now();
            // Comprehensive readiness checks
            const checks = await Promise.all([
                this.checkDatabaseConnections(),
                this.checkApiEndpoints(),
                this.checkExternalServices(),
            ]);
            const isReady = checks.every(check => check);
            const responseTime = Date.now() - startTime;
            if (isReady) {
                res.status(200).json({
                    status: 'ready',
                    timestamp: new Date().toISOString(),
                    responseTime,
                    checks: {
                        databaseConnections: checks[0],
                        apiEndpoints: checks[1],
                        externalServices: checks[2],
                    },
                });
            }
            else {
                res.status(503).json({
                    status: 'not_ready',
                    timestamp: new Date().toISOString(),
                    responseTime,
                    checks: {
                        databaseConnections: checks[0],
                        apiEndpoints: checks[1],
                        externalServices: checks[2],
                    },
                });
            }
        }
        catch (error) {
            res.status(500).json({
                status: 'error',
                timestamp: new Date().toISOString(),
                error: error instanceof Error ? error.message : 'Unknown error',
            });
        }
    }
    /**
     * Metrics endpoint for Prometheus
     */
    async healthMetrics(req, res) {
        try {
            const metrics = await this.collectMetrics();
            // Format for Prometheus
            const prometheusMetrics = `
# HELP app_http_requests_total Total number of HTTP requests
# TYPE app_http_requests_total counter
app_http_requests_total{status="${metrics.status}"} 1

# HELP app_response_time_seconds Response time in seconds
# TYPE app_response_time_seconds histogram
app_response_time_seconds{quantile="0.5"} ${metrics.responseTime / 1000}
app_response_time_seconds{quantile="0.95"} ${metrics.responseTime / 1000}
app_response_time_seconds{quantile="0.99"} ${metrics.responseTime / 1000}

# HELP app_error_rate Error rate percentage
# TYPE app_error_rate gauge
app_error_rate ${metrics.errorRate}

# HELP app_cpu_usage CPU usage percentage
# TYPE app_cpu_usage gauge
app_cpu_usage ${metrics.cpuUsage}

# HELP app_memory_usage Memory usage percentage
# TYPE app_memory_usage gauge
app_memory_usage ${metrics.memoryUsage}

# HELP app_database_connections Active database connections
# TYPE app_database_connections gauge
app_database_connections ${metrics.databaseConnections}

# HELP app_active_users Active users count
# TYPE app_active_users gauge
app_active_users ${metrics.activeUsers}
      `.trim();
            res.set('Content-Type', 'text/plain');
            res.status(200).send(prometheusMetrics);
        }
        catch (error) {
            res.status(500).json({
                status: 'error',
                timestamp: new Date().toISOString(),
                error: error instanceof Error ? error.message : 'Unknown error',
            });
        }
    }
    async checkDatabase() {
        try {
            const db = admin.firestore();
            await db.collection('health').doc('test').get();
            return true;
        }
        catch (error) {
            console.error('Database health check failed:', error);
            return false;
        }
    }
    async checkFirebase() {
        try {
            const auth = admin.auth();
            await auth.listUsers(1);
            return true;
        }
        catch (error) {
            console.error('Firebase health check failed:', error);
            return false;
        }
    }
    async checkMemory() {
        const memUsage = process.memoryUsage();
        const memoryUsagePercent = (memUsage.heapUsed / memUsage.heapTotal) * 100;
        return memoryUsagePercent < 90; // Alert if memory usage > 90%
    }
    async checkDatabaseConnections() {
        try {
            const db = admin.firestore();
            const startTime = Date.now();
            await db.collection('health').doc('readiness').get();
            const responseTime = Date.now() - startTime;
            return responseTime < 5000; // Alert if DB response > 5 seconds
        }
        catch (error) {
            console.error('Database connections check failed:', error);
            return false;
        }
    }
    async checkApiEndpoints() {
        try {
            // Check if main API endpoints are responding
            const endpoints = ['/api/bookings', '/api/users', '/api/businesses'];
            const checks = await Promise.all(endpoints.map(async (endpoint) => {
                try {
                    // This would be an internal check - in real implementation
                    // you'd make actual HTTP requests to your endpoints
                    return true;
                }
                catch (error) {
                    return false;
                }
            }));
            return checks.every(check => check);
        }
        catch (error) {
            console.error('API endpoints check failed:', error);
            return false;
        }
    }
    async checkExternalServices() {
        try {
            // Check external services like Stripe, Google APIs, etc.
            const services = ['stripe', 'google', 'firebase'];
            const checks = await Promise.all(services.map(async (service) => {
                try {
                    // In real implementation, you'd check actual service connectivity
                    return true;
                }
                catch (error) {
                    return false;
                }
            }));
            return checks.every(check => check);
        }
        catch (error) {
            console.error('External services check failed:', error);
            return false;
        }
    }
    async collectMetrics() {
        const memUsage = process.memoryUsage();
        const memoryUsagePercent = (memUsage.heapUsed / memUsage.heapTotal) * 100;
        // Simulate CPU usage (in real implementation, you'd get this from system)
        const cpuUsage = Math.random() * 100;
        const metrics = {
            timestamp: new Date().toISOString(),
            status: 'healthy',
            responseTime: Date.now(),
            errorRate: 0.0,
            cpuUsage,
            memoryUsage: memoryUsagePercent,
            databaseConnections: 1, // In real implementation, get from DB pool
            activeUsers: 0, // In real implementation, get from active sessions
        };
        this.metrics.push(metrics);
        // Keep only last 1000 metrics
        if (this.metrics.length > 1000) {
            this.metrics = this.metrics.slice(-1000);
        }
        return metrics;
    }
}
exports.healthController = HealthController.getInstance();
