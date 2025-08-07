'use client'

import { useAuth } from '@/contexts/AuthContext'
import { signOutUser } from '@/services/auth_service'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useEffect, useState } from 'react'

interface DashboardData {
    appointmentsToday: number
    totalCustomers: number
    analyticsEvents: number
    accountStatus: string
    businessPlan: string
}

export default function DashboardPage() {
    const { user, loading, isAuthenticated } = useAuth()
    const router = useRouter()
    const [dashboardData, setDashboardData] = useState<DashboardData>({
        appointmentsToday: 3,
        totalCustomers: 127,
        analyticsEvents: 5,
        accountStatus: 'Active',
        businessPlan: 'Professional'
    })
    const [dataLoading, setDataLoading] = useState(true)

    useEffect(() => {
        if (!loading && !isAuthenticated) {
            router.push('/login')
        }
    }, [loading, isAuthenticated, router])

    useEffect(() => {
        // Simulate loading dashboard data
        const loadDashboardData = async () => {
            setDataLoading(true)
            // Simulate API call delay
            await new Promise(resolve => setTimeout(resolve, 1000))
            setDataLoading(false)
        }

        if (isAuthenticated) {
            loadDashboardData()
        }
    }, [isAuthenticated])

    const handleLogout = async () => {
        try {
            await signOutUser()
            router.push('/')
        } catch (error) {
            console.error('Logout error:', error)
        }
    }

    if (loading) {
        return (
            <div className="min-h-screen gradient-bg flex items-center justify-center">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                    <p className="mt-4 text-gray-600">Loading...</p>
                </div>
            </div>
        )
    }

    if (!isAuthenticated) {
        return null // Will redirect to login
    }

    return (
        <div className="min-h-screen bg-gray-50">
            {/* Header */}
            <header className="bg-white shadow-sm border-b border-gray-200">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div className="flex justify-between items-center py-4">
                        <div className="flex items-center space-x-4">
                            <div className="h-10 w-10 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-xl flex items-center justify-center shadow-lg">
                                <span className="text-white text-lg font-bold">A</span>
                            </div>
                            <div>
                                <h1 className="text-xl font-bold text-gray-900">
                                    App-Oint Business Studio
                                </h1>
                                <p className="text-sm text-gray-500">
                                    Plan: {dashboardData.businessPlan}
                                </p>
                            </div>
                        </div>
                        <div className="flex items-center space-x-4">
                            <Link
                                href="/dashboard/live"
                                className="px-4 py-2 text-sm font-medium text-green-600 hover:text-green-700 bg-green-50 hover:bg-green-100 rounded-lg transition-colors"
                            >
                                📅 Live Calendar
                            </Link>
                            <button className="px-4 py-2 text-sm font-medium text-blue-600 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 rounded-lg transition-colors">
                                Upgrade Plan
                            </button>
                            <div className="flex items-center space-x-3">
                                <div className="h-8 w-8 bg-gradient-to-br from-blue-500 to-purple-500 rounded-full flex items-center justify-center">
                                    <span className="text-white text-sm font-medium">
                                        {user?.displayName?.charAt(0) || user?.email?.charAt(0) || 'U'}
                                    </span>
                                </div>
                                <button
                                    onClick={handleLogout}
                                    className="text-gray-600 hover:text-gray-800 text-sm font-medium"
                                >
                                    Logout
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            {/* Main Content */}
            <main className="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
                {/* Welcome Section */}
                <div className="mb-8">
                    <h2 className="text-3xl font-bold text-gray-900 mb-2">
                        👋 Welcome back, {user?.displayName || 'Business'}!
                    </h2>
                    <p className="text-gray-600">
                        Here's what's happening with your business today.
                    </p>
                </div>

                {/* Summary Tiles */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Appointments Today</p>
                                <p className="text-2xl font-bold text-gray-900">
                                    {dataLoading ? '...' : dashboardData.appointmentsToday}
                                </p>
                            </div>
                            <div className="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center">
                                <span className="text-blue-600 text-xl">📅</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Total Customers</p>
                                <p className="text-2xl font-bold text-gray-900">
                                    {dataLoading ? '...' : dashboardData.totalCustomers}
                                </p>
                            </div>
                            <div className="h-12 w-12 bg-green-100 rounded-lg flex items-center justify-center">
                                <span className="text-green-600 text-xl">👤</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Analytics Events</p>
                                <p className="text-2xl font-bold text-gray-900">
                                    {dataLoading ? '...' : dashboardData.analyticsEvents}
                                </p>
                                <p className="text-xs text-gray-500">new this week</p>
                            </div>
                            <div className="h-12 w-12 bg-purple-100 rounded-lg flex items-center justify-center">
                                <span className="text-purple-600 text-xl">📊</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Account Status</p>
                                <p className="text-2xl font-bold text-green-600">
                                    {dataLoading ? '...' : dashboardData.accountStatus}
                                </p>
                            </div>
                            <div className="h-12 w-12 bg-green-100 rounded-lg flex items-center justify-center">
                                <span className="text-green-600 text-xl">⭐</span>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Feature Grid */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-all duration-200">
                        <div className="flex items-center mb-4">
                            <div className="h-10 w-10 bg-blue-100 rounded-lg flex items-center justify-center mr-3">
                                <span className="text-blue-600 text-lg">🗓</span>
                            </div>
                            <h3 className="text-lg font-semibold text-gray-900">Appointments</h3>
                        </div>
                        <p className="text-gray-600 text-sm mb-4">
                            Schedule and manage your business appointments with ease.
                        </p>
                        <Link
                            href="/dashboard/appointments"
                            className="inline-flex items-center text-blue-600 hover:text-blue-700 text-sm font-medium"
                        >
                            Go to Appointments →
                        </Link>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-all duration-200">
                        <div className="flex items-center mb-4">
                            <div className="h-10 w-10 bg-purple-100 rounded-lg flex items-center justify-center mr-3">
                                <span className="text-purple-600 text-lg">🎨</span>
                            </div>
                            <h3 className="text-lg font-semibold text-gray-900">Branding</h3>
                        </div>
                        <p className="text-gray-600 text-sm mb-4">
                            Customize your business presence and professional branding.
                        </p>
                        <Link
                            href="/dashboard/branding"
                            className="inline-flex items-center text-purple-600 hover:text-purple-700 text-sm font-medium"
                        >
                            Go to Branding →
                        </Link>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-all duration-200">
                        <div className="flex items-center mb-4">
                            <div className="h-10 w-10 bg-green-100 rounded-lg flex items-center justify-center mr-3">
                                <span className="text-green-600 text-lg">📈</span>
                            </div>
                            <h3 className="text-lg font-semibold text-gray-900">Analytics</h3>
                        </div>
                        <p className="text-gray-600 text-sm mb-4">
                            View performance metrics and business insights in real-time.
                        </p>
                        <Link
                            href="/dashboard/analytics"
                            className="inline-flex items-center text-green-600 hover:text-green-700 text-sm font-medium"
                        >
                            Go to Analytics →
                        </Link>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-all duration-200">
                        <div className="flex items-center mb-4">
                            <div className="h-10 w-10 bg-orange-100 rounded-lg flex items-center justify-center mr-3">
                                <span className="text-orange-600 text-lg">👥</span>
                            </div>
                            <h3 className="text-lg font-semibold text-gray-900">Staff</h3>
                        </div>
                        <p className="text-gray-600 text-sm mb-4">
                            Manage your team members and their access permissions.
                        </p>
                        <Link
                            href="/dashboard/staff"
                            className="inline-flex items-center text-orange-600 hover:text-orange-700 text-sm font-medium"
                        >
                            Go to Staff →
                        </Link>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-all duration-200">
                        <div className="flex items-center mb-4">
                            <div className="h-10 w-10 bg-indigo-100 rounded-lg flex items-center justify-center mr-3">
                                <span className="text-indigo-600 text-lg">💬</span>
                            </div>
                            <h3 className="text-lg font-semibold text-gray-900">Messages</h3>
                        </div>
                        <p className="text-gray-600 text-sm mb-4">
                            Communicate with customers and manage conversations.
                        </p>
                        <Link
                            href="/dashboard/messages"
                            className="inline-flex items-center text-indigo-600 hover:text-indigo-700 text-sm font-medium"
                        >
                            Go to Messages →
                        </Link>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-all duration-200">
                        <div className="flex items-center mb-4">
                            <div className="h-10 w-10 bg-pink-100 rounded-lg flex items-center justify-center mr-3">
                                <span className="text-pink-600 text-lg">⚙️</span>
                            </div>
                            <h3 className="text-lg font-semibold text-gray-900">Settings</h3>
                        </div>
                        <p className="text-gray-600 text-sm mb-4">
                            Configure your business preferences and account settings.
                        </p>
                        <Link
                            href="/dashboard/settings"
                            className="inline-flex items-center text-pink-600 hover:text-pink-700 text-sm font-medium"
                        >
                            Go to Settings →
                        </Link>
                    </div>
                </div>

                {/* Tips Section */}
                <div className="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl p-6 mb-8 border border-blue-200">
                    <div className="flex items-start">
                        <div className="h-8 w-8 bg-blue-100 rounded-lg flex items-center justify-center mr-3 mt-1">
                            <span className="text-blue-600 text-sm">🔥</span>
                        </div>
                        <div>
                            <h3 className="text-lg font-semibold text-blue-900 mb-2">What's New</h3>
                            <p className="text-blue-800">
                                You can now invite staff members to help manage your business!
                                <Link href="/dashboard/staff" className="ml-2 text-blue-600 hover:text-blue-700 font-medium">
                                    Invite your first team member →
                                </Link>
                            </p>
                        </div>
                    </div>
                </div>

                {/* Account Info Footer */}
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                    <h3 className="text-lg font-semibold text-gray-900 mb-4">Account Information</h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 text-sm">
                        <div>
                            <p className="text-gray-500">Logged in as</p>
                            <p className="text-gray-900 font-medium">{user?.email}</p>
                        </div>
                        <div>
                            <p className="text-gray-500">Business Name</p>
                            <p className="text-gray-900 font-medium">{user?.displayName || 'Not set'}</p>
                        </div>
                        <div>
                            <p className="text-gray-500">Account Type</p>
                            <p className="text-gray-900 font-medium">Business Studio</p>
                        </div>
                        <div>
                            <p className="text-gray-500">Plan</p>
                            <p className="text-gray-900 font-medium">{dashboardData.businessPlan}</p>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    )
} 