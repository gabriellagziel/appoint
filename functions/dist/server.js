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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const cors_1 = __importDefault(require("cors"));
const express_1 = __importDefault(require("express"));
const health_1 = require("./health");
const metrics_1 = __importStar(require("./metrics"));
const app = (0, express_1.default)();
const PORT = parseInt(process.env.PORT || '8080', 10);
const HOST = process.env.HOSTNAME || '0.0.0.0';
// Apply metrics middleware to all routes
app.use(metrics_1.metricsMiddleware);
// CORS
app.use((0, cors_1.default)({ origin: true }));
// Routes
app.use('/metrics', metrics_1.default);
// Health checks
app.get('/health/liveness', health_1.liveness);
app.get('/health/readiness', health_1.readiness);
app.get('/health', health_1.liveness);
app.get('/api/health', health_1.liveness);
// API routes
app.get('/api/status', (req, res) => {
    res.json({
        message: 'App-Oint Functions API is running',
        timestamp: new Date().toISOString(),
        version: process.env.npm_package_version || '1.0.0'
    });
});
// 404 handler
app.use('*', (req, res) => {
    res.status(404).json({
        error: 'Not Found',
        message: `Route ${req.originalUrl} not found`,
        timestamp: new Date().toISOString()
    });
});
// Error handler
app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).json({
        error: 'Internal Server Error',
        message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong',
        timestamp: new Date().toISOString()
    });
});
// Start server only if not in test environment
if (process.env.NODE_ENV !== 'test') {
    app.listen(PORT, HOST, () => {
        console.log(`🚀 Functions API server running on http://${HOST}:${PORT}`);
        console.log(`📊 Health check available at http://${HOST}:${PORT}/health`);
        console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
    });
}
exports.default = app;
