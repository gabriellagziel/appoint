"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.register = exports.httpRequestDurationMs = void 0;
exports.metricsMiddleware = metricsMiddleware;
const prom_client_1 = __importDefault(require("prom-client"));
// אסוף מדדים מובנים של Node.js
prom_client_1.default.collectDefaultMetrics();
// היסטוגרמת זמן תגובה
exports.httpRequestDurationMs = new prom_client_1.default.Histogram({
    name: 'http_request_duration_ms',
    help: 'Duration of HTTP requests in ms',
    labelNames: ['method', 'route', 'status_code'],
    buckets: [50, 100, 200, 300, 400, 500, 1000],
});
function metricsMiddleware(req, res, next) {
    const end = exports.httpRequestDurationMs.startTimer();
    res.on('finish', () => {
        end({ method: req.method, route: req.route?.path || req.url, status_code: res.statusCode });
    });
    next();
}
exports.register = prom_client_1.default.register;
