'use client';

import Button from '@/components/Button';
import Card from '@/components/Card';
import {
  Activity,
  ArrowRight,
  DollarSign,
  Globe,
  Key, Plus,
  TrendingDown,
  TrendingUp,
  Users
} from 'lucide-react';

export default function DashboardPage() {
  const stats = [
    {
      name: 'Total Meetings',
      value: '1,234',
      change: '+12.5%',
      changeType: 'positive' as const,
      icon: Activity,
    },
    {
      name: 'Active Meetings',
      value: '2,847',
      change: '+8.2%',
      changeType: 'positive' as const,
      icon: Users,
    },
    {
      name: 'Revenue',
      value: '$12,847',
      change: '+15.3%',
      changeType: 'positive' as const,
      icon: DollarSign,
    },
    {
      name: 'Uptime',
      value: '99.9%',
      change: '+0.1%',
      changeType: 'positive' as const,
      icon: Globe,
    },
  ];

  const quickActions = [
    {
      title: 'Create Access Key',
      description: 'Generate a new access key for your application',
      icon: Key,
      href: '/dashboard/keys',
      color: 'primary',
    },
    {
      title: 'View Analytics',
      description: 'Check your meeting usage and performance metrics',
      icon: TrendingUp,
      href: '/dashboard/analytics',
      color: 'secondary',
    },
    {
      title: 'Manage Billing',
      description: 'Review invoices and payment information',
      icon: DollarSign,
      href: '/dashboard/billing',
      color: 'success',
    },
    {
      title: 'White Label',
      description: 'Customize your API branding and domains',
      icon: Globe,
      href: '/dashboard/white-label',
      color: 'accent',
    },
  ];

  const recentActivity = [
    {
      id: 1,
      type: 'meeting_created',
      message: 'Meeting created via API',
      time: '2 minutes ago',
      status: 'success',
    },
    {
      id: 2,
      type: 'billing',
      message: 'Invoice #INV-2024-001 generated',
      time: '1 hour ago',
      status: 'info',
    },
    {
      id: 3,
      type: 'key_created',
      message: 'New access key created: sk_live_...',
      time: '3 hours ago',
      status: 'success',
    },
    {
      id: 4,
      type: 'usage_alert',
      message: 'Usage threshold reached (80%)',
      time: '5 hours ago',
      status: 'warning',
    },
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-neutral-900">Dashboard</h1>
          <p className="text-neutral-600 mt-1">Welcome back! Here&apos;s what&apos;s happening with your enterprise account.</p>
        </div>
        <Button variant="primary" icon={Plus}>
          Create Meeting
        </Button>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat) => {
          const Icon = stat.icon;
          return (
            <Card key={stat.name} hover>
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-neutral-600">{stat.name}</p>
                  <p className="text-2xl font-bold text-neutral-900 mt-1">{stat.value}</p>
                  <div className="flex items-center mt-2">
                    {stat.changeType === 'positive' ? (
                      <TrendingUp className="h-4 w-4 text-success-500 mr-1" />
                    ) : (
                      <TrendingDown className="h-4 w-4 text-error-500 mr-1" />
                    )}
                    <span className={`text-sm font-medium ${stat.changeType === 'positive' ? 'text-success-600' : 'text-error-600'
                      }`}>
                      {stat.change}
                    </span>
                    <span className="text-sm text-neutral-500 ml-1">from last month</span>
                  </div>
                </div>
                <div className="p-3 bg-primary-50 rounded-lg">
                  <Icon className="h-6 w-6 text-primary-600" />
                </div>
              </div>
            </Card>
          );
        })}
      </div>

      {/* Quick Actions */}
      <div>
        <h2 className="text-lg font-semibold text-neutral-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          {quickActions.map((action) => {
            const Icon = action.icon;
            return (
              <Card key={action.title} hover className="cursor-pointer">
                <div className="flex items-start space-x-3">
                  <div className={`p-2 rounded-lg bg-${action.color}-50`}>
                    <Icon className={`h-5 w-5 text-${action.color}-600`} />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-medium text-neutral-900">{action.title}</h3>
                    <p className="text-sm text-neutral-600 mt-1">{action.description}</p>
                  </div>
                  <ArrowRight className="h-4 w-4 text-neutral-400" />
                </div>
              </Card>
            );
          })}
        </div>
      </div>

      {/* Recent Activity */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <h3 className="text-lg font-semibold text-neutral-900 mb-4">Recent Activity</h3>
          <div className="space-y-3">
            {recentActivity.map((activity) => (
              <div key={activity.id} className="flex items-center space-x-3 p-3 rounded-lg hover:bg-neutral-50">
                <div className={`w-2 h-2 rounded-full ${activity.status === 'success' ? 'bg-success-500' :
                  activity.status === 'warning' ? 'bg-warning-500' :
                    activity.status === 'error' ? 'bg-error-500' : 'bg-primary-500'
                  }`} />
                <div className="flex-1">
                  <p className="text-sm font-medium text-neutral-900">{activity.message}</p>
                  <p className="text-xs text-neutral-500">{activity.time}</p>
                </div>
              </div>
            ))}
          </div>
        </Card>

        <Card>
          <h3 className="text-lg font-semibold text-neutral-900 mb-4">Meeting Usage Chart</h3>
          <div className="h-48 flex items-center justify-center bg-neutral-50 rounded-lg">
            <div className="text-center">
              <Activity className="h-12 w-12 text-neutral-400 mx-auto mb-2" />
              <p className="text-sm text-neutral-500">Usage chart coming soon</p>
            </div>
          </div>
        </Card>
      </div>
    </div>
  );
} 