"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.readiness = exports.liveness = void 0;
// Liveness probe - checks if the application is alive
const liveness = (req, res) => {
    res.status(200).json({
        status: 'ok',
        timestamp: new Date().toISOString(),
        service: 'appoint-functions',
        type: 'liveness'
    });
};
exports.liveness = liveness;
// Readiness probe - checks if the application is ready to serve requests
const readiness = (req, res) => {
    // Add any additional checks here (database connectivity, etc.)
    res.status(200).json({
        status: 'ok',
        timestamp: new Date().toISOString(),
        service: 'appoint-functions',
        type: 'readiness'
    });
};
exports.readiness = readiness;
