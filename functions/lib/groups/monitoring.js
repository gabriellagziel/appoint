"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getGroupsMetrics = getGroupsMetrics;
// Group metrics aggregation for monitoring and dashboards
const admin_js_1 = require("../lib/admin.js");
async function getGroupsMetrics() {
    const db = (0, admin_js_1.db)();
    const groupsSnap = await db.collection('groups').get();
    let proGroups = 0;
    for (const doc of groupsSnap.docs) {
        const data = doc.data() || {};
        if ((data.plan || '').toLowerCase() === 'pro')
            proGroups += 1;
    }
    const totalGroups = groupsSnap.size;
    const freeGroups = Math.max(0, totalGroups - proGroups);
    const since = new Date();
    since.setDate(since.getDate() - 30);
    const upgradesSnap = await db
        .collection('group_upgrade_intents')
        .where('createdAt', '>=', since)
        .get();
    const upgradesLast30d = upgradesSnap.size;
    return { totalGroups, proGroups, freeGroups, upgradesLast30d };
}
