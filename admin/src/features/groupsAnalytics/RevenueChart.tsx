"use client";
import { ResponsiveContainer, BarChart, XAxis, YAxis, Tooltip, Bar } from 'recharts';

export default function RevenueChart({ data }: { data: Array<{ name: string; totalRevenue?: number }> }) {
  const chartData = data.map((g) => ({ name: g.name, revenue: g.totalRevenue || 0 }));
  return (
    <div style={{ width: '100%', height: 300 }}>
      <ResponsiveContainer>
        <BarChart data={chartData}>
          <XAxis dataKey="name" hide />
          <YAxis />
          <Tooltip />
          <Bar dataKey="revenue" fill="#82ca9d" />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}



