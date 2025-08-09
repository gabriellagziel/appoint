"use client";
import { useEffect, useState } from 'react';
import GroupsDashboard from '../../../features/groupsAnalytics/GroupsDashboard';

export default function GroupsPage() {
  const [metrics, setMetrics] = useState<any>({ totalGroups: 0, totalRevenue: 0, avgEventsPerGroup: 0, totalUsers: 0, groups: [] });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const load = async () => {
      try {
        const base = process.env.NEXT_PUBLIC_FUNCTIONS_URL || '';
        const res = await fetch(`${base}/api/groups/metrics`);
        const json = await res.json();
        setMetrics(json);
      } catch (e) {
        console.error(e);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  if (loading) return <div>Loading groups analytics…</div>;
  return <GroupsDashboard metrics={metrics} groups={metrics.groups || []} />;
}



