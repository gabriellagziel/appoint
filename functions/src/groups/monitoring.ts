import * as admin from 'firebase-admin';
import { Group } from './groupTypes';

if (!admin.apps.length) {
  admin.initializeApp();
}

export const getGroupsMetrics = async () => {
  const snap = await admin.firestore().collection('groups').get();
  const groups = snap.docs.map((d) => ({ id: d.id, ...(d.data() as any) })) as Group[];
  const revenue = groups.reduce((sum, g) => sum + (g.totalRevenue || 0), 0);
  const avgEvents = groups.length
    ? groups.reduce((sum, g) => sum + (g.events?.length || 0), 0) / groups.length
    : 0;
  return {
    totalGroups: groups.length,
    totalRevenue: revenue,
    avgEventsPerGroup: avgEvents,
    totalUsers: groups.reduce((sum, g) => sum + (g.members?.length || 0), 0),
    groups,
  };
};

export const notifyDashboardIfNeeded = async (group: Group) => {
  if (group.usageScore > 90) {
    const dashboardHook = process.env.DASHBOARD_ALERTS_HOOK;
    if (!dashboardHook) return;
    try {
      const maybeFetch: any = (globalThis as any).fetch;
      if (typeof maybeFetch === 'function') {
        await maybeFetch(dashboardHook, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ type: 'HIGH_USAGE', groupId: group.id, score: group.usageScore }),
        });
      } else {
        console.log('Dashboard alert (no fetch available):', group.id, group.usageScore);
      }
    } catch (e) {
      console.error('Failed to notify dashboard', e);
    }
  }
};


