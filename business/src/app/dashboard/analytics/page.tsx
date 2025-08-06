'use client'

import { useAuth } from '@/contexts/AuthContext'
import { signOutUser } from '@/services/auth_service'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useEffect, useState } from 'react'

interface AnalyticsData {
    totalRevenue: number
    totalAppointments: number
    conversionRate: number
    averageRating: number
    monthlyGrowth: number
    topServices: Array<{ name: string; revenue: number; appointments: number }>
    recentActivity: Array<{ type: string; description: string; time: string; value: number }>
}

export default function AnalyticsPage() {
    const { user, loading, isAuthenticated } = useAuth()
    const router = useRouter()
    const [analyticsData, setAnalyticsData] = useState<AnalyticsData | null>(null)
    const [dataLoading, setDataLoading] = useState(true)
    const [selectedPeriod, setSelectedPeriod] = useState('30d')

    useEffect(() => {
        if (!loading && !isAuthenticated) {
            router.push('/login')
        }
    }, [loading, isAuthenticated, router])

    useEffect(() => {
        if (isAuthenticated) {
            loadAnalyticsData()
        }
    }, [isAuthenticated, selectedPeriod])

    const loadAnalyticsData = async () => {
        setDataLoading(true)
        try {
            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 1000))

            const mockData: AnalyticsData = {
                totalRevenue: 15420,
                totalAppointments: 127,
                conversionRate: 68.5,
                averageRating: 4.8,
                monthlyGrowth: 23.4,
                topServices: [
                    { name: 'Consultation', revenue: 5200, appointments: 45 },
                    { name: 'Product Demo', revenue: 3800, appointments: 32 },
                    { name: 'Support Call', revenue: 2400, appointments: 28 },
                    { name: 'Training Session', revenue: 1800, appointments: 15 }
                ],
                recentActivity: [
                    { type: 'revenue', description: 'New appointment booked', time: '2 hours ago', value: 150 },
                    { type: 'appointment', description: 'Client consultation completed', time: '4 hours ago', value: 1 },
                    { type: 'rating', description: '5-star review received', time: '6 hours ago', value: 5 },
                    { type: 'conversion', description: 'Lead converted to customer', time: '1 day ago', value: 1 }
                ]
            }

            setAnalyticsData(mockData)
        } catch (error) {
            console.error('Failed to load analytics data:', error)
        } finally {
            setDataLoading(false)
        }
    }

    const handleLogout = async () => {
        try {
            await signOutUser()
            router.push('/')
        } catch (error) {
            console.error('Logout error:', error)
        }
    }

    const formatCurrency = (amount: number) => {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(amount)
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
                                    Analytics & Reports
                                </h1>
                                <p className="text-sm text-gray-500">
                                    View performance metrics and business insights
                                </p>
                            </div>
                        </div>
                        <div className="flex items-center space-x-4">
                            <select
                                value={selectedPeriod}
                                onChange={(e) => setSelectedPeriod(e.target.value)}
                                className="px-3 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                aria-label="Select time period"
                            >
                                <option value="7d">Last 7 days</option>
                                <option value="30d">Last 30 days</option>
                                <option value="90d">Last 90 days</option>
                                <option value="1y">Last year</option>
                            </select>
                            <Link
                                href="/dashboard/live"
                                className="px-4 py-2 text-sm font-medium text-green-600 hover:text-green-700 bg-green-50 hover:bg-green-100 rounded-lg transition-colors"
                            >
                                📅 Live Calendar
                            </Link>
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
                {/* Key Metrics */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Total Revenue</p>
                                <p className="text-2xl font-bold text-gray-900">
                                    {dataLoading ? '...' : formatCurrency(analyticsData?.totalRevenue || 0)}
                                </p>
                                <p className="text-sm text-green-600">+{analyticsData?.monthlyGrowth}% vs last month</p>
                            </div>
                            <div className="h-12 w-12 bg-green-100 rounded-lg flex items-center justify-center">
                                <span className="text-green-600 text-xl">💰</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Total Appointments</p>
                                <p className="text-2xl font-bold text-gray-900">
                                    {dataLoading ? '...' : analyticsData?.totalAppointments || 0}
                                </p>
                                <p className="text-sm text-blue-600">+12% vs last month</p>
                            </div>
                            <div className="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center">
                                <span className="text-blue-600 text-xl">📅</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Conversion Rate</p>
                                <p className="text-2xl font-bold text-gray-900">
                                    {dataLoading ? '...' : analyticsData?.conversionRate || 0}%
                                </p>
                                <p className="text-sm text-purple-600">+5.2% vs last month</p>
                            </div>
                            <div className="h-12 w-12 bg-purple-100 rounded-lg flex items-center justify-center">
                                <span className="text-purple-600 text-xl">📈</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Average Rating</p>
                                <p className="text-2xl font-bold text-gray-900">
                                    {dataLoading ? '...' : analyticsData?.averageRating || 0}/5
                                </p>
                                <p className="text-sm text-yellow-600">+0.3 vs last month</p>
                            </div>
                            <div className="h-12 w-12 bg-yellow-100 rounded-lg flex items-center justify-center">
                                <span className="text-yellow-600 text-xl">⭐</span>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Charts and Insights */}
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                    {/* Revenue Chart */}
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4">Revenue Trend</h3>
                        <div className="h-64 bg-gray-50 rounded-lg flex items-center justify-center">
                            <div className="text-center">
                                <div className="text-4xl mb-2">📊</div>
                                <p className="text-gray-600">Revenue chart will appear here</p>
                                <p className="text-sm text-gray-500">Chart integration coming soon</p>
                            </div>
                        </div>
                    </div>

                    {/* Top Services */}
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4">Top Services</h3>
                        <div className="space-y-4">
                            {analyticsData?.topServices.map((service, index) => (
                                <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <div className="flex items-center space-x-3">
                                        <div className="h-8 w-8 bg-blue-100 rounded-full flex items-center justify-center">
                                            <span className="text-blue-600 text-sm font-medium">{index + 1}</span>
                                        </div>
                                        <div>
                                            <p className="font-medium text-gray-900">{service.name}</p>
                                            <p className="text-sm text-gray-600">{service.appointments} appointments</p>
                                        </div>
                                    </div>
                                    <div className="text-right">
                                        <p className="font-medium text-gray-900">{formatCurrency(service.revenue)}</p>
                                        <p className="text-sm text-gray-600">{service.revenue / service.appointments} avg</p>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>

                {/* Recent Activity and Quick Actions */}
                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    {/* Recent Activity */}
                    <div className="lg:col-span-2 bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4">Recent Activity</h3>
                        <div className="space-y-4">
                            {analyticsData?.recentActivity.map((activity, index) => (
                                <div key={index} className="flex items-center space-x-4 p-3 bg-gray-50 rounded-lg">
                                    <div className="h-8 w-8 bg-blue-100 rounded-full flex items-center justify-center">
                                        <span className="text-blue-600 text-sm">
                                            {activity.type === 'revenue' ? '💰' :
                                                activity.type === 'appointment' ? '📅' :
                                                    activity.type === 'rating' ? '⭐' : '📈'}
                                        </span>
                                    </div>
                                    <div className="flex-1">
                                        <p className="font-medium text-gray-900">{activity.description}</p>
                                        <p className="text-sm text-gray-600">{activity.time}</p>
                                    </div>
                                    <div className="text-right">
                                        <p className="font-medium text-gray-900">
                                            {activity.type === 'revenue' ? formatCurrency(activity.value) :
                                                activity.type === 'rating' ? `${activity.value}/5` :
                                                    activity.value}
                                        </p>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>

                    {/* Quick Actions */}
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h3>
                        <div className="space-y-3">
                            <button
                                onClick={() => router.push('/dashboard/appointments')}
                                className="w-full text-left p-3 bg-blue-50 rounded-lg hover:bg-blue-100 transition-colors"
                            >
                                <div className="flex items-center space-x-3">
                                    <span className="text-blue-600">📊</span>
                                    <span className="font-medium">Generate Report</span>
                                </div>
                            </button>
                            <button
                                onClick={() => router.push('/dashboard/messages')}
                                className="w-full text-left p-3 bg-green-50 rounded-lg hover:bg-green-100 transition-colors"
                            >
                                <div className="flex items-center space-x-3">
                                    <span className="text-green-600">📧</span>
                                    <span className="font-medium">Export Data</span>
                                </div>
                            </button>
                            <button
                                onClick={() => router.push('/dashboard/appointments')}
                                className="w-full text-left p-3 bg-purple-50 rounded-lg hover:bg-purple-100 transition-colors"
                            >
                                <div className="flex items-center space-x-3">
                                    <span className="text-purple-600">📈</span>
                                    <span className="font-medium">View Trends</span>
                                </div>
                            </button>
                            <button
                                onClick={() => router.push('/dashboard/settings')}
                                className="w-full text-left p-3 bg-yellow-50 rounded-lg hover:bg-yellow-100 transition-colors"
                            >
                                <div className="flex items-center space-x-3">
                                    <span className="text-yellow-600">⚙️</span>
                                    <span className="font-medium">Analytics Settings</span>
                                </div>
                            </button>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    )
} 