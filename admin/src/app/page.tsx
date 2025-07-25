import { headers } from 'next/headers'
import { redirect } from 'next/navigation'
import { isMobileOrTablet } from '@/utils/deviceDetection'
import { AdminLayout } from '@/components/AdminLayout'

export default function HomePage() {
  // Server-side device detection
  const headersList = headers()
  const userAgent = headersList.get('user-agent') || ''
  
  // Redirect mobile/tablet users to quick dashboard
  if (isMobileOrTablet(userAgent)) {
    redirect('/quick')
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Admin Dashboard</h1>
          <p className="text-gray-600">Manage your App-Oint platform</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Total Users</h3>
            <p className="text-3xl font-bold text-blue-600">12,543</p>
            <p className="text-sm text-gray-500">+12.3% from last month</p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Revenue</h3>
            <p className="text-3xl font-bold text-green-600">$285,420</p>
            <p className="text-sm text-gray-500">+8.7% from last month</p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Active Sessions</h3>
            <p className="text-3xl font-bold text-purple-600">3,421</p>
            <p className="text-sm text-gray-500">Last 7 days</p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Growth Rate</h3>
            <p className="text-3xl font-bold text-orange-600">15.2%</p>
            <p className="text-sm text-gray-500">Monthly average</p>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold text-gray-900 mb-4">Quick Actions</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <button className="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 text-left">
              <h3 className="font-medium text-gray-900">Manage Users</h3>
              <p className="text-sm text-gray-500">View and manage user accounts</p>
            </button>
            <button className="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 text-left">
              <h3 className="font-medium text-gray-900">Analytics</h3>
              <p className="text-sm text-gray-500">View detailed analytics and reports</p>
            </button>
            <button className="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 text-left">
              <h3 className="font-medium text-gray-900">Settings</h3>
              <p className="text-sm text-gray-500">Configure system settings</p>
            </button>
          </div>
        </div>

        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
          <h3 className="text-lg font-semibold text-blue-900 mb-2">Mobile Access</h3>
          <p className="text-blue-700 mb-3">
            For mobile access, visit <code className="bg-blue-100 px-1 rounded">/quick</code> for an optimized dashboard experience.
          </p>
          <a 
            href="/quick" 
            className="inline-block bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors"
          >
            View Quick Dashboard
          </a>
        </div>
      </div>
    </AdminLayout>
  )
}
