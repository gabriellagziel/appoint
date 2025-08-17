"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.metricsMiddleware = void 0;
// Minimal metrics route for functions express server, exporting a router
const express_1 = __importDefault(require("express"));
const monitoring_js_1 = require("../groups/monitoring.js");
const router = express_1.default.Router();
router.get('/', async (_req, res) => {
    // Inline comment: expose system metrics; extend with counters/histograms if using Prometheus
    const groups = await (0, monitoring_js_1.getGroupsMetrics)();
    res.json({ ok: true, groups });
});
exports.default = router;
const metricsMiddleware = (_req, _res, next) => {
    // Inline comment: place to add correlation IDs, request timing, etc.
    next();
};
exports.metricsMiddleware = metricsMiddleware;
