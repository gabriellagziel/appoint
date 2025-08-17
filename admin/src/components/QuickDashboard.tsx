"use client"

import { useState, useEffect } from "react"
import { 
  TrendingUp, 
  Users, 
  DollarSign, 
  Globe,
  ArrowUpRight,
  RefreshCw,
  Monitor
} from "lucide-react"
import { LineChart, Line, ResponsiveContainer } from "recharts"
import { Button } from "@/components/ui/button"
import { getDashboardData, type DashboardData } from "@/services/analytics_service"
import { formatNumber, formatCurrency, formatPercentage } from "@/lib/utils"

interface MetricCardProps {
  title: string
  value: string
  change: string
  positive: boolean
  icon: React.ReactNode
  trend?: number[]
}

function MetricCard({ title, value, change, positive, icon, trend }: MetricCardProps) {
  return (
    <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center space-x-2">
          <div className={`p-2 rounded-lg ${positive ? 'bg-green-50' : 'bg-red-50'}`}>
            <div className={positive ? 'text-green-700' : 'text-red-700'}>
              {icon}
            </div>
          </div>
          <span className="text-sm font-medium text-gray-600">{title}</span>
        </div>
        {positive && <ArrowUpRight className="h-4 w-4 text-green-500" />}
      </div>
      
      <div className="space-y-1">
        <div className="text-2xl font-bold text-gray-900">{value}</div>
        <div className="flex items-center justify-between">
          <span className={`text-sm font-medium ${positive ? 'text-green-700' : 'text-red-700'}`}>
            {change}
          </span>
          {trend && (
            <div className="h-8 w-16">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={trend.map((val, idx) => ({ value: val, index: idx }))}>
                  <Line 
                    type="monotone" 
                    dataKey="value" 
                    stroke={positive ? "#10b981" : "#ef4444"} 
                    strokeWidth={2}
                    dot={false}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

export function QuickDashboard() {
  const [data, setData] = useState<DashboardData | null>(null)
  const [loading, setLoading] = useState(true)
  const [lastRefresh, setLastRefresh] = useState<Date>(new Date())

  const fetchData = async () => {
    setLoading(true)
    try {
      const dashboardData = await getDashboardData()
      setData(dashboardData)
      setLastRefresh(new Date())
    } catch (error) {
      console.error('Failed to fetch dashboard data:', error)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchData()
  }, [])

  if (loading && !data) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <RefreshCw className="h-8 w-8 animate-spin text-blue-500 mx-auto mb-4" />
          <p className="text-gray-600">Loading dashboard...</p>
        </div>
      </div>
    )
  }

  if (!data) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <p className="text-gray-600 mb-4">Failed to load dashboard data</p>
          <Button onClick={fetchData}>Retry</Button>
        </div>
      </div>
    )
  }

  // Generate trend data for sparklines
  const userTrend = data.growthData.slice(-7).map(d => d.users)
  const revenueTrend = data.growthData.slice(-7).map(d => d.revenue)

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b border-gray-200">
        <div className="px-4 py-4">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-xl font-bold text-gray-900">Quick Dashboard</h1>
              <p className="text-sm text-gray-500">
                Last updated: {new Date(lastRefresh).toLocaleTimeString()}
              </p>
            </div>
            <div className="flex items-center space-x-2">
              <Button
                variant="outline"
                size="sm"
                onClick={fetchData}
                disabled={loading}
              >
                <RefreshCw className={`h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={() => window.location.href = '/admin'}
              >
                <Monitor className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </div>
      </div>

      {/* Metrics Grid */}
      <div className="p-4 space-y-4">
        {/* User Metrics */}
        <div className="grid grid-cols-1 gap-4">
          <MetricCard
            title="Total Users"
            value={formatNumber(data.users.totalUsers)}
            change={formatPercentage(data.users.userGrowthPercentage)}
            positive={data.users.userGrowthPercentage > 0}
            icon={<Users className="h-4 w-4" />}
            trend={userTrend}
          />
          
          <MetricCard
            title="This Month"
            value={formatNumber(data.users.usersThisMonth)}
            change={`${formatNumber(data.users.usersToday)} today`}
            positive={true}
            icon={<TrendingUp className="h-4 w-4" />}
          />
          
          <MetricCard
            title="Active (7 days)"
            value={formatNumber(data.users.activeUsers7Days)}
            change={`${((data.users.activeUsers7Days / data.users.totalUsers) * 100).toFixed(1)}% of total`}
            positive={true}
            icon={<Users className="h-4 w-4" />}
          />
        </div>

        {/* Revenue Metrics */}
        <div className="grid grid-cols-1 gap-4">
          <MetricCard
            title="Total Revenue"
            value={formatCurrency(data.revenue.totalRevenue)}
            change={formatPercentage(data.revenue.revenueGrowthPercentage)}
            positive={data.revenue.revenueGrowthPercentage > 0}
            icon={<DollarSign className="h-4 w-4" />}
            trend={revenueTrend}
          />
          
          <MetricCard
            title="This Month"
            value={formatCurrency(data.revenue.revenueThisMonth)}
            change={`${formatCurrency(data.revenue.revenueToday)} today`}
            positive={true}
            icon={<DollarSign className="h-4 w-4" />}
          />
        </div>

        {/* Top Countries */}
        <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
          <div className="flex items-center space-x-2 mb-4">
            <div className="p-2 rounded-lg bg-blue-50">
              <Globe className="h-4 w-4 text-blue-600" />
            </div>
            <span className="text-sm font-medium text-gray-600">Top Countries</span>
          </div>
          
          <div className="space-y-3">
            {data.topCountries.map((country, index) => (
              <div key={country.country} className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <span className="text-xs font-medium text-gray-400 w-4">
                    {index + 1}
                  </span>
                  <span className="text-sm font-medium text-gray-900">
                    {country.country}
                  </span>
                </div>
                <div className="text-right">
                  <div className="text-sm font-medium text-gray-900">
                    {formatNumber(country.users)}
                  </div>
                  <div className="text-xs text-gray-500">
                    {country.percentage}%
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Growth Chart */}
        <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
          <div className="flex items-center space-x-2 mb-4">
            <div className="p-2 rounded-lg bg-purple-50">
              <TrendingUp className="h-4 w-4 text-purple-600" />
            </div>
            <span className="text-sm font-medium text-gray-600">30-Day Trend</span>
          </div>
          
          <div className="h-32">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={data.growthData}>
                <Line 
                  type="monotone" 
                  dataKey="users" 
                  stroke="#8b5cf6" 
                  strokeWidth={2}
                  dot={false}
                />
                <Line 
                  type="monotone" 
                  dataKey="revenue" 
                  stroke="#06b6d4" 
                  strokeWidth={2}
                  dot={false}
                />
              </LineChart>
            </ResponsiveContainer>
          </div>
          
          <div className="flex items-center justify-center space-x-4 mt-2">
            <div className="flex items-center space-x-1">
              <div className="w-2 h-2 bg-purple-500 rounded-full"></div>
              <span className="text-xs text-gray-600">Users</span>
            </div>
            <div className="flex items-center space-x-1">
              <div className="w-2 h-2 bg-cyan-500 rounded-full"></div>
              <span className="text-xs text-gray-600">Revenue</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}