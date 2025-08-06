import Layout from '@/components/Layout'
import { 
  UsersIcon, 
  CalendarIcon, 
  CurrencyDollarIcon, 
  ChartBarIcon,
  ArrowUpIcon,
  ArrowDownIcon
} from '@heroicons/react/24/outline'

const stats = [
  { name: 'Total Customers', value: '2,847', change: '+12%', changeType: 'positive', icon: UsersIcon },
  { name: 'Appointments Today', value: '156', change: '+8%', changeType: 'positive', icon: CalendarIcon },
  { name: 'Revenue This Month', value: '$45,231', change: '+23%', changeType: 'positive', icon: CurrencyDollarIcon },
  { name: 'Conversion Rate', value: '3.2%', change: '-1%', changeType: 'negative', icon: ChartBarIcon },
]

const recentActivity = [
  { id: 1, name: 'John Smith', action: 'Booked appointment', time: '2 minutes ago', type: 'appointment' },
  { id: 2, name: 'Sarah Johnson', action: 'Updated profile', time: '5 minutes ago', type: 'profile' },
  { id: 3, name: 'Mike Wilson', action: 'Cancelled appointment', time: '10 minutes ago', type: 'cancellation' },
  { id: 4, name: 'Lisa Brown', action: 'Made payment', time: '15 minutes ago', type: 'payment' },
]

export default function DashboardPage() {
  return (
    <Layout>
      <div className="space-y-6">
        {/* Header */}
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
          <p className="mt-1 text-sm text-gray-500">
            Welcome back! Here's what's happening with your business today.
          </p>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
          {stats.map((item) => (
            <div key={item.name} className="card">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <item.icon className="h-8 w-8 text-gray-400" />
                </div>
                <div className="ml-4 flex-1">
                  <p className="text-sm font-medium text-gray-500">{item.name}</p>
                  <p className="text-2xl font-semibold text-gray-900">{item.value}</p>
                </div>
              </div>
              <div className="mt-4">
                <div className={`flex items-center text-sm ${
                  item.changeType === 'positive' ? 'text-green-600' : 'text-red-600'
                }`}>
                  {item.changeType === 'positive' ? (
                    <ArrowUpIcon className="h-4 w-4" />
                  ) : (
                    <ArrowDownIcon className="h-4 w-4" />
                  )}
                  <span className="ml-1">{item.change}</span>
                  <span className="ml-1">from last month</span>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Recent Activity */}
        <div className="card">
          <h3 className="text-lg font-medium text-gray-900 mb-4">Recent Activity</h3>
          <div className="space-y-4">
            {recentActivity.map((activity) => (
              <div key={activity.id} className="flex items-center space-x-4">
                <div className="flex-shrink-0">
                  <div className="h-8 w-8 rounded-full bg-primary-100 flex items-center justify-center">
                    <span className="text-sm font-medium text-primary-600">
                      {activity.name.charAt(0)}
                    </span>
                  </div>
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-gray-900">
                    {activity.name}
                  </p>
                  <p className="text-sm text-gray-500">
                    {activity.action}
                  </p>
                </div>
                <div className="flex-shrink-0">
                  <p className="text-sm text-gray-500">{activity.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Quick Actions */}
        <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
          <div className="card">
            <h3 className="text-lg font-medium text-gray-900 mb-4">Quick Actions</h3>
            <div className="space-y-3">
              <button className="w-full btn-primary">
                Add New Customer
              </button>
              <button className="w-full btn-secondary">
                Schedule Appointment
              </button>
              <button className="w-full btn-secondary">
                View Reports
              </button>
            </div>
          </div>

          <div className="card">
            <h3 className="text-lg font-medium text-gray-900 mb-4">Today's Schedule</h3>
            <div className="space-y-3">
              <div className="flex items-center justify-between p-3 bg-primary-50 rounded-lg">
                <div>
                  <p className="text-sm font-medium text-gray-900">9:00 AM - John Smith</p>
                  <p className="text-xs text-gray-500">Haircut & Styling</p>
                </div>
                <span className="text-xs text-primary-600 bg-primary-100 px-2 py-1 rounded-full">
                  Confirmed
                </span>
              </div>
              <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div>
                  <p className="text-sm font-medium text-gray-900">11:30 AM - Sarah Johnson</p>
                  <p className="text-xs text-gray-500">Manicure & Pedicure</p>
                </div>
                <span className="text-xs text-yellow-600 bg-yellow-100 px-2 py-1 rounded-full">
                  Pending
                </span>
              </div>
            </div>
          </div>

          <div className="card">
            <h3 className="text-lg font-medium text-gray-900 mb-4">Notifications</h3>
            <div className="space-y-3">
              <div className="flex items-start space-x-3 p-3 bg-red-50 rounded-lg">
                <div className="flex-shrink-0">
                  <div className="h-2 w-2 bg-red-400 rounded-full"></div>
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-900">Payment Failed</p>
                  <p className="text-xs text-gray-500">Invoice #1234 payment failed</p>
                </div>
              </div>
              <div className="flex items-start space-x-3 p-3 bg-green-50 rounded-lg">
                <div className="flex-shrink-0">
                  <div className="h-2 w-2 bg-green-400 rounded-full"></div>
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-900">New Customer</p>
                  <p className="text-xs text-gray-500">Mike Wilson registered</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  )
} 