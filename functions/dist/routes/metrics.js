"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const metrics_1 = require("../middleware/metrics");
const router = (0, express_1.Router)();
router.get('/metrics', async (_req, res) => {
    res.set('Content-Type', metrics_1.register.contentType);
    res.send(await metrics_1.register.metrics());
});
exports.default = router;
