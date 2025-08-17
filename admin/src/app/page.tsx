import { AdminLayout } from '@/components/AdminLayout'
import { isMobileOrTablet } from '@/utils/deviceDetection'
import { Activity, ArrowRight, BarChart3, Shield, TrendingUp, Users } from 'lucide-react'
import { headers } from 'next/headers'
import Link from 'next/link'
import { redirect } from 'next/navigation'

export default async function HomePage() {
  // Server-side device detection
  const headersList = await headers()
  const userAgent = headersList.get('user-agent') || ''

  // Redirect mobile/tablet users to quick dashboard
  if (isMobileOrTablet(userAgent)) {
    redirect('/quick')
  }

  return (
    <AdminLayout>
      <div className="space-y-8">
        {/* Header with consistent styling */}
        <div className="bg-white rounded-xl p-8 shadow-lg border border-gray-200/50">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-4xl font-bold text-gray-900 mb-4">Admin Dashboard</h1>
              <p className="text-xl text-gray-600">Manage your App-Oint platform with total control</p>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
              <span className="text-lg text-green-700 font-semibold">System Online</span>
            </div>
          </div>
        </div>

        {/* Stats Grid with consistent styling */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          <div className="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-all duration-200 hover:scale-[1.02] border border-gray-200/50">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-semibold text-gray-600">Total Users</h3>
              <div className="p-3 bg-blue-100 rounded-xl">
                <Users className="h-6 w-6 text-blue-600" />
              </div>
            </div>
            <div className="text-3xl font-bold text-gray-900 mb-2">12,543</div>
            <div className="flex items-center gap-2">
              <TrendingUp className="h-4 w-4 text-green-500" />
              <p className="text-sm text-green-700 font-medium">+12.3% from last month</p>
            </div>
          </div>

          <div className="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-all duration-200 hover:scale-[1.02] border border-gray-200/50">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-semibold text-gray-600">Revenue</h3>
              <div className="p-3 bg-green-100 rounded-xl">
                <BarChart3 className="h-6 w-6 text-green-600" />
              </div>
            </div>
            <div className="text-3xl font-bold text-gray-900 mb-2">$285,420</div>
            <div className="flex items-center gap-2">
              <TrendingUp className="h-4 w-4 text-green-500" />
              <p className="text-sm text-green-700 font-medium">+8.7% from last month</p>
            </div>
          </div>

          <div className="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-all duration-200 hover:scale-[1.02] border border-gray-200/50">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-semibold text-gray-600">Active Sessions</h3>
              <div className="p-3 bg-purple-100 rounded-xl">
                <Activity className="h-6 w-6 text-purple-600" />
              </div>
            </div>
            <div className="text-3xl font-bold text-gray-900 mb-2">3,421</div>
            <div className="flex items-center gap-2">
              <TrendingUp className="h-4 w-4 text-green-500" />
              <p className="text-sm text-green-700 font-medium">Last 7 days</p>
            </div>
          </div>

          <div className="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-all duration-200 hover:scale-[1.02] border border-gray-200/50">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-semibold text-gray-600">System Status</h3>
              <div className="p-3 bg-green-100 rounded-xl">
                <Shield className="h-6 w-6 text-green-600" />
              </div>
            </div>
            <div className="text-3xl font-bold text-green-700 mb-2">Online</div>
            <p className="text-sm text-gray-500">All systems operational</p>
          </div>
        </div>

        {/* Quick Actions with consistent styling */}
        <div className="bg-white rounded-xl shadow-lg p-8 border border-gray-200/50">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Quick Actions</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <Link
              href="/admin/users"
              className="p-6 border border-gray-200 rounded-xl hover:bg-gray-50 text-left transition-all duration-200 group hover:shadow-md"
            >
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-xl font-semibold text-gray-900 mb-2">Manage Users</h3>
                  <p className="text-gray-600">View and manage user accounts</p>
                </div>
                <ArrowRight className="h-5 w-5 text-gray-400 group-hover:text-gray-600 transition-colors" />
              </div>
            </Link>
            <Link
              href="/admin/analytics"
              className="p-6 border border-gray-200 rounded-xl hover:bg-gray-50 text-left transition-all duration-200 group hover:shadow-md"
            >
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-xl font-semibold text-gray-900 mb-2">Analytics</h3>
                  <p className="text-gray-600">View detailed analytics and reports</p>
                </div>
                <ArrowRight className="h-5 w-5 text-gray-400 group-hover:text-gray-600 transition-colors" />
              </div>
            </Link>
            <Link
              href="/admin/settings"
              className="p-6 border border-gray-200 rounded-xl hover:bg-gray-50 text-left transition-all duration-200 group hover:shadow-md"
            >
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-xl font-semibold text-gray-900 mb-2">Settings</h3>
                  <p className="text-gray-600">Configure system settings</p>
                </div>
                <ArrowRight className="h-5 w-5 text-gray-400 group-hover:text-gray-600 transition-colors" />
              </div>
            </Link>
          </div>
        </div>

        {/* Mobile Access with consistent styling */}
        <div className="bg-gradient-to-br from-blue-50 to-indigo-100 border border-blue-200 rounded-xl p-6">
          <h3 className="text-xl font-semibold text-blue-900 mb-3">Mobile Access</h3>
          <p className="text-blue-700 mb-4 text-lg">
            For mobile access, visit <code className="bg-blue-100 px-2 py-1 rounded font-mono">/quick</code> for an optimized dashboard experience.
          </p>
          <Link
            href="/quick"
            className="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors"
          >
            View Quick Dashboard
          </Link>
        </div>
      </div>
    </AdminLayout>
  )
}
