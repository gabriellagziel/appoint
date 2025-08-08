'use client';

import React from 'react';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';
import { Line, Bar, Pie } from 'react-chartjs-2';
import { useEnterpriseUsage } from '@/lib/hooks/useEnterpriseUsage';
import { formatDateForChart, getChartColors } from '@/lib/usageTransforms';
import Card from '@/components/Card';
import { Activity, BarChart3, PieChart, Download } from 'lucide-react';
import Button from '@/components/Button';

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend
);

interface UsageChartsProps {
  clientId: string;
  dateRange: '7d' | '30d' | '90d';
  onExportCSV: () => void;
  onExportJSON: () => void;
}

const UsageCharts: React.FC<UsageChartsProps> = ({
  clientId,
  dateRange,
  onExportCSV,
  onExportJSON,
}) => {
  const { loading, error, byDay, byEndpoint, byError, raw } = useEnterpriseUsage(clientId, dateRange);

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="animate-pulse">
          <div className="h-64 bg-gray-200 rounded-lg mb-6"></div>
          <div className="h-64 bg-gray-200 rounded-lg mb-6"></div>
          <div className="h-64 bg-gray-200 rounded-lg"></div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <Card>
        <div className="text-center py-8">
          <Activity className="w-12 h-12 text-gray-400 mx-auto mb-4" />
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Error Loading Usage Data</h3>
          <p className="text-gray-600">{error}</p>
        </div>
      </Card>
    );
  }

  if (raw.length === 0) {
    return (
      <Card>
        <div className="text-center py-8">
          <Activity className="w-12 h-12 text-gray-400 mx-auto mb-4" />
          <h3 className="text-lg font-semibold text-gray-900 mb-2">No Usage Data</h3>
          <p className="text-gray-600">No usage data available for the selected time period.</p>
        </div>
      </Card>
    );
  }

  const lineChartData = {
    labels: byDay.map(item => formatDateForChart(item.date)),
    datasets: [
      {
        label: 'Total API Calls',
        data: byDay.map(item => item.total),
        borderColor: '#3B82F6',
        backgroundColor: 'rgba(59, 130, 246, 0.1)',
        tension: 0.4,
      },
    ],
  };

  const barChartData = {
    labels: Object.keys(byEndpoint),
    datasets: [
      {
        label: 'Calls by Endpoint',
        data: Object.values(byEndpoint),
        backgroundColor: getChartColors(Object.keys(byEndpoint).length),
      },
    ],
  };

  const pieChartData = {
    labels: Object.keys(byError),
    datasets: [
      {
        data: Object.values(byError),
        backgroundColor: getChartColors(Object.keys(byError).length),
        borderWidth: 2,
        borderColor: '#ffffff',
      },
    ],
  };

  const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'top' as const,
      },
    },
  };

  return (
    <div className="space-y-6">
      {/* Export Controls */}
      <div className="flex justify-between items-center">
        <h2 className="text-xl font-semibold text-gray-900">Usage Analytics</h2>
        <div className="flex space-x-2">
          <Button
            variant="outline"
            size="sm"
            onClick={onExportCSV}
            disabled={raw.length === 0}
          >
            <Download className="w-4 h-4 mr-2" />
            Export CSV
          </Button>
          <Button
            variant="outline"
            size="sm"
            onClick={onExportJSON}
            disabled={raw.length === 0}
          >
            <Download className="w-4 h-4 mr-2" />
            Export JSON
          </Button>
        </div>
      </div>

      {/* Charts Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Line Chart - Daily Usage */}
        <Card>
          <div className="flex items-center mb-4">
            <Activity className="w-5 h-5 text-blue-600 mr-2" />
            <h3 className="text-lg font-semibold text-gray-900">Daily API Calls</h3>
          </div>
          <div className="h-64">
            <Line data={lineChartData} options={chartOptions} />
          </div>
        </Card>

        {/* Bar Chart - Endpoint Usage */}
        <Card>
          <div className="flex items-center mb-4">
            <BarChart3 className="w-5 h-5 text-green-600 mr-2" />
            <h3 className="text-lg font-semibold text-gray-900">Calls by Endpoint</h3>
          </div>
          <div className="h-64">
            <Bar data={barChartData} options={chartOptions} />
          </div>
        </Card>

        {/* Pie Chart - Error Breakdown */}
        <Card className="lg:col-span-2">
          <div className="flex items-center mb-4">
            <PieChart className="w-5 h-5 text-red-600 mr-2" />
            <h3 className="text-lg font-semibold text-gray-900">Error Breakdown</h3>
          </div>
          <div className="h-64">
            <Pie data={pieChartData} options={chartOptions} />
          </div>
        </Card>
      </div>

      {/* Summary Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card>
          <div className="text-center">
            <p className="text-sm text-gray-600">Total Calls</p>
            <p className="text-2xl font-bold text-gray-900">
              {raw.reduce((sum, record) => sum + record.calls, 0).toLocaleString()}
            </p>
          </div>
        </Card>
        <Card>
          <div className="text-center">
            <p className="text-sm text-gray-600">Success Rate</p>
            <p className="text-2xl font-bold text-green-600">
              {((raw.reduce((sum, record) => sum + record.success, 0) / 
                 raw.reduce((sum, record) => sum + record.calls, 0)) * 100).toFixed(1)}%
            </p>
          </div>
        </Card>
        <Card>
          <div className="text-center">
            <p className="text-sm text-gray-600">Avg Response Time</p>
            <p className="text-2xl font-bold text-blue-600">
              {(raw.reduce((sum, record) => sum + record.avgResponseTime, 0) / raw.length).toFixed(0)}ms
            </p>
          </div>
        </Card>
        <Card>
          <div className="text-center">
            <p className="text-sm text-gray-600">Total Errors</p>
            <p className="text-2xl font-bold text-red-600">
              {raw.reduce((sum, record) => sum + record.errors, 0).toLocaleString()}
            </p>
          </div>
        </Card>
      </div>
    </div>
  );
};

export default UsageCharts;
