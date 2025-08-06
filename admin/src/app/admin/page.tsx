
export default function AdminDashboard() {
  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="bg-white shadow rounded-lg p-6">
        <div className="mb-6">
          <h1 className="text-2xl font-bold text-gray-900 mb-2">
            Welcome to App-Oint Admin Panel
          </h1>
          <p className="text-gray-600">
            Manage users, businesses, payments, and platform analytics from this centralized dashboard.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div className="bg-blue-50 p-6 rounded-lg">
            <h3 className="text-lg font-semibold text-blue-900 mb-2">User Management</h3>
            <p className="text-blue-700 text-sm mb-4">
              View and manage user accounts, permissions, and activity.
            </p>
            <a
              href="/admin/users"
              className="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-blue-700 bg-blue-100 hover:bg-blue-200"
            >
              Manage Users
            </a>
          </div>

          <div className="bg-green-50 p-6 rounded-lg">
            <h3 className="text-lg font-semibold text-green-900 mb-2">Business Management</h3>
            <p className="text-green-700 text-sm mb-4">
              Oversee business accounts, verification, and settings.
            </p>
            <a
              href="/admin/business"
              className="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-green-700 bg-green-100 hover:bg-green-200"
            >
              Manage Businesses
            </a>
          </div>

          <div className="bg-purple-50 p-6 rounded-lg">
            <h3 className="text-lg font-semibold text-purple-900 mb-2">Analytics</h3>
            <p className="text-purple-700 text-sm mb-4">
              View platform metrics, usage statistics, and insights.
            </p>
            <a
              href="/admin/analytics"
              className="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-purple-700 bg-purple-100 hover:bg-purple-200"
            >
              View Analytics
            </a>
          </div>

          <div className="bg-yellow-50 p-6 rounded-lg">
            <h3 className="text-lg font-semibold text-yellow-900 mb-2">Payments</h3>
            <p className="text-yellow-700 text-sm mb-4">
              Monitor transactions, billing, and payment status.
            </p>
            <a
              href="/admin/payments"
              className="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-yellow-700 bg-yellow-100 hover:bg-yellow-200"
            >
              View Payments
            </a>
          </div>

          <div className="bg-red-50 p-6 rounded-lg">
            <h3 className="text-lg font-semibold text-red-900 mb-2">Security</h3>
            <p className="text-red-700 text-sm mb-4">
              Monitor security events, suspicious activity, and access logs.
            </p>
            <a
              href="/admin/security"
              className="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-red-700 bg-red-100 hover:bg-red-200"
            >
              Security Dashboard
            </a>
          </div>

          <div className="bg-indigo-50 p-6 rounded-lg">
            <h3 className="text-lg font-semibold text-indigo-900 mb-2">Content Moderation</h3>
            <p className="text-indigo-700 text-sm mb-4">
              Review flagged content, reports, and moderation actions.
            </p>
            <a
              href="/admin/flags"
              className="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-indigo-700 bg-indigo-100 hover:bg-indigo-200"
            >
              Review Flags
            </a>
          </div>
        </div>

        <div className="mt-8 p-4 bg-gray-50 rounded-lg">
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Quick Actions</h3>
          <div className="flex flex-wrap gap-2">
            <a
              href="/admin/users"
              className="inline-flex items-center px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Users
            </a>
            <a
              href="/admin/business"
              className="inline-flex items-center px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Businesses
            </a>
            <a
              href="/admin/analytics"
              className="inline-flex items-center px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Analytics
            </a>
            <a
              href="/admin/payments"
              className="inline-flex items-center px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Payments
            </a>
            <a
              href="/admin/security"
              className="inline-flex items-center px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Security
            </a>
            <a
              href="/admin/flags"
              className="inline-flex items-center px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Flags
            </a>
          </div>
        </div>
      </div>
    </div>
  );
} 