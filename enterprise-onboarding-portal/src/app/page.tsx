import Link from 'next/link'
import { ArrowRightIcon, BuildingOfficeIcon, ShieldCheckIcon, ChartBarIcon } from '@heroicons/react/24/outline'

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-50 to-blue-50">
      {/* Navigation */}
      <nav className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <BuildingOfficeIcon className="h-8 w-8 text-primary-600" />
              <span className="ml-2 text-xl font-bold text-gray-900">App-Oint Enterprise</span>
            </div>
            <div className="flex items-center space-x-4">
              <Link href="/login" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                Sign In
              </Link>
              <Link href="/register" className="btn-primary">
                Get Started
              </Link>
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 sm:text-6xl">
            Enterprise Appointment
            <span className="text-primary-600"> Management</span>
          </h1>
          <p className="mt-6 text-xl text-gray-600 max-w-3xl mx-auto">
            Streamline your business operations with our comprehensive enterprise solution. 
            Manage appointments, customers, and analytics all in one powerful platform.
          </p>
          <div className="mt-10 flex justify-center space-x-4">
            <Link href="/register" className="btn-primary text-lg px-8 py-3">
              Start Free Trial
              <ArrowRightIcon className="ml-2 h-5 w-5" />
            </Link>
            <Link href="/dashboard" className="btn-secondary text-lg px-8 py-3">
              View Demo
            </Link>
          </div>
        </div>
      </div>

      {/* Features Section */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="card text-center">
            <div className="flex justify-center">
              <BuildingOfficeIcon className="h-12 w-12 text-primary-600" />
            </div>
            <h3 className="mt-4 text-xl font-semibold text-gray-900">Business Management</h3>
            <p className="mt-2 text-gray-600">
              Complete control over your business operations with advanced scheduling and customer management tools.
            </p>
          </div>
          
          <div className="card text-center">
            <div className="flex justify-center">
              <ShieldCheckIcon className="h-12 w-12 text-primary-600" />
            </div>
            <h3 className="mt-4 text-xl font-semibold text-gray-900">Enterprise Security</h3>
            <p className="mt-2 text-gray-600">
              Bank-level security with SSO integration, role-based access, and comprehensive audit trails.
            </p>
          </div>
          
          <div className="card text-center">
            <div className="flex justify-center">
              <ChartBarIcon className="h-12 w-12 text-primary-600" />
            </div>
            <h3 className="mt-4 text-xl font-semibold text-gray-900">Advanced Analytics</h3>
            <p className="mt-2 text-gray-600">
              Powerful insights and reporting to optimize your business performance and growth.
            </p>
          </div>
        </div>
      </div>

      {/* CTA Section */}
      <div className="bg-primary-600">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
          <div className="text-center">
            <h2 className="text-3xl font-bold text-white">
              Ready to Transform Your Business?
            </h2>
            <p className="mt-4 text-xl text-primary-100">
              Join thousands of businesses already using App-Oint Enterprise
            </p>
            <div className="mt-8">
              <Link href="/register" className="bg-white text-primary-600 hover:bg-gray-100 font-semibold py-3 px-8 rounded-lg text-lg transition-colors duration-200">
                Get Started Today
              </Link>
            </div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <footer className="bg-gray-900">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div className="text-center text-gray-400">
            <p>&copy; 2024 App-Oint Enterprise. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  )
} 