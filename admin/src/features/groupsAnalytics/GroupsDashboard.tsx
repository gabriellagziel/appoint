"use client";

import RevenueChart from './RevenueChart';
import GroupUsageTable from './GroupUsageTable';

type Metrics = {
  totalGroups: number;
  totalRevenue: number;
  totalUsers: number;
  avgEventsPerGroup: number;
};

type Group = {
  id: string;
  name: string;
  type: string;
  members: string[];
  events: string[];
  usageScore: number;
  totalRevenue?: number;
};

export default function GroupsDashboard({ metrics, groups }: { metrics: Metrics; groups: Group[] }) {
  return (
    <div>
      <h1>קבוצות – סקירה</h1>
      <p>סה״כ קבוצות: {metrics.totalGroups}</p>
      <p>סה״כ הכנסות: €{metrics.totalRevenue}</p>
      <p>משתמשים בקבוצות: {metrics.totalUsers}</p>
      <p>ממוצע פגישות: {metrics.avgEventsPerGroup}</p>
      <RevenueChart data={groups} />
      <GroupUsageTable groups={groups} />
    </div>
  );
}



