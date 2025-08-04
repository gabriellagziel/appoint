import { AdminLayout } from "@/components/AdminLayout"
import { Activity, ArrowRight, BarChart3, Settings, Shield, TrendingUp, Users, Zap } from "lucide-react"

export default function AdminDashboard() {
  return (
    <AdminLayout>
      <div className="space-y-8">
        {/* Header */}
        <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-200/50">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-gray-900 mb-2">Admin Dashboard</h1>
              <p className="text-gray-600">Welcome to the App-Oint admin panel. Monitor and manage the platform.</p>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
              <span className="text-sm text-green-600 font-medium">System Online</span>
            </div>
          </div>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-lg transition-all duration-200 hover:scale-[1.02]">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-sm font-medium text-gray-600">Total Users</h3>
              <div className="p-2 bg-blue-100 rounded-lg">
                <Users className="h-4 w-4 text-blue-600" />
              </div>
            </div>
            <div className="text-2xl font-bold text-gray-900">1,234</div>
            <div className="flex items-center gap-1 mt-1">
              <TrendingUp className="h-3 w-3 text-green-500" />
              <p className="text-xs text-green-600 font-medium">+12% from last month</p>
            </div>
          </div>

          <div className="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-lg transition-all duration-200 hover:scale-[1.02]">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-sm font-medium text-gray-600">Active Sessions</h3>
              <div className="p-2 bg-green-100 rounded-lg">
                <Activity className="h-4 w-4 text-green-600" />
              </div>
            </div>
            <div className="text-2xl font-bold text-gray-900">567</div>
            <div className="flex items-center gap-1 mt-1">
              <TrendingUp className="h-3 w-3 text-green-500" />
              <p className="text-xs text-green-600 font-medium">+8% from last hour</p>
            </div>
          </div>

          <div className="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-lg transition-all duration-200 hover:scale-[1.02]">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-sm font-medium text-gray-600">Revenue</h3>
              <div className="p-2 bg-purple-100 rounded-lg">
                <BarChart3 className="h-4 w-4 text-purple-600" />
              </div>
            </div>
            <div className="text-2xl font-bold text-gray-900">$12,345</div>
            <div className="flex items-center gap-1 mt-1">
              <TrendingUp className="h-3 w-3 text-green-500" />
              <p className="text-xs text-green-600 font-medium">+23% from last month</p>
            </div>
          </div>

          <div className="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-lg transition-all duration-200 hover:scale-[1.02]">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-sm font-medium text-gray-600">System Status</h3>
              <div className="p-2 bg-green-100 rounded-lg">
                <Shield className="h-4 w-4 text-green-600" />
              </div>
            </div>
            <div className="text-2xl font-bold text-green-600">Online</div>
            <p className="text-xs text-gray-500 mt-1">All systems operational</p>
          </div>
        </div>

        {/* Content Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div className="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-lg transition-all duration-200">
            <div className="flex items-center gap-2 mb-4">
              <Activity className="h-5 w-5 text-blue-600" />
              <h2 className="text-lg font-semibold">Recent Activity</h2>
            </div>
            <div className="space-y-4">
              <div className="flex items-center space-x-4 p-3 rounded-lg bg-green-50 border border-green-200">
                <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                <div className="flex-1">
                  <p className="text-sm font-medium text-gray-900">New user registered</p>
                  <p className="text-xs text-gray-500">2 minutes ago</p>
                </div>
              </div>
              <div className="flex items-center space-x-4 p-3 rounded-lg bg-blue-50 border border-blue-200">
                <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                <div className="flex-1">
                  <p className="text-sm font-medium text-gray-900">Payment processed</p>
                  <p className="text-xs text-gray-500">5 minutes ago</p>
                </div>
              </div>
              <div className="flex items-center space-x-4 p-3 rounded-lg bg-yellow-50 border border-yellow-200">
                <div className="w-2 h-2 bg-yellow-500 rounded-full"></div>
                <div className="flex-1">
                  <p className="text-sm font-medium text-gray-900">System maintenance</p>
                  <p className="text-xs text-gray-500">1 hour ago</p>
                </div>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-lg transition-all duration-200">
            <div className="flex items-center gap-2 mb-4">
              <Zap className="h-5 w-5 text-purple-600" />
              <h2 className="text-lg font-semibold">Quick Actions</h2>
            </div>
            <div className="space-y-3">
              <a href="/admin/users" className="flex items-center w-full p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors">
                <Users className="h-4 w-4 mr-2" />
                <div className="text-left flex-1">
                  <p className="font-medium">View All Users</p>
                  <p className="text-sm text-gray-500">Manage user accounts</p>
                </div>
                <ArrowRight className="h-4 w-4 ml-auto" />
              </a>
              <a href="/admin/analytics" className="flex items-center w-full p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors">
                <BarChart3 className="h-4 w-4 mr-2" />
                <div className="text-left flex-1">
                  <p className="font-medium">Analytics Report</p>
                  <p className="text-sm text-gray-500">View detailed analytics</p>
                </div>
                <ArrowRight className="h-4 w-4 ml-auto" />
              </a>
              <a href="/admin/settings" className="flex items-center w-full p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors">
                <Settings className="h-4 w-4 mr-2" />
                <div className="text-left flex-1">
                  <p className="font-medium">System Settings</p>
                  <p className="text-sm text-gray-500">Configure system options</p>
                </div>
                <ArrowRight className="h-4 w-4 ml-auto" />
              </a>
            </div>
          </div>
        </div>
      </div>
    </AdminLayout>
  )
} 