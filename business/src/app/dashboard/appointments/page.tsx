'use client'

import { useAuth } from '@/contexts/AuthContext'
import { signOutUser } from '@/services/auth_service'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useEffect, useState } from 'react'

interface Appointment {
    id: string
    title: string
    date: string
    time: string
    duration: number
    clientName: string
    clientEmail: string
    status: 'confirmed' | 'pending' | 'cancelled'
    notes?: string
}

export default function AppointmentsPage() {
    const { user, loading, isAuthenticated } = useAuth()
    const router = useRouter()
    const [appointments, setAppointments] = useState<Appointment[]>([])
    const [selectedDate, setSelectedDate] = useState(new Date())
    const [showBookingForm, setShowBookingForm] = useState(false)
    const [dataLoading, setDataLoading] = useState(true)

    useEffect(() => {
        if (!loading && !isAuthenticated) {
            router.push('/login')
        }
    }, [loading, isAuthenticated, router])

    useEffect(() => {
        if (isAuthenticated) {
            loadAppointments()
        }
    }, [isAuthenticated])

    const loadAppointments = async () => {
        setDataLoading(true)
        try {
            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 1000))

            const mockAppointments: Appointment[] = [
                {
                    id: '1',
                    title: 'Client Consultation - John Smith',
                    date: '2024-08-05',
                    time: '09:00',
                    duration: 60,
                    clientName: 'John Smith',
                    clientEmail: 'john@example.com',
                    status: 'confirmed',
                    notes: 'Initial consultation for new project'
                },
                {
                    id: '2',
                    title: 'Team Meeting',
                    date: '2024-08-05',
                    time: '14:00',
                    duration: 30,
                    clientName: 'Internal Team',
                    clientEmail: 'team@company.com',
                    status: 'confirmed',
                    notes: 'Weekly standup meeting'
                },
                {
                    id: '3',
                    title: 'Sales Call - ABC Corp',
                    date: '2024-08-06',
                    time: '11:00',
                    duration: 45,
                    clientName: 'Sarah Johnson',
                    clientEmail: 'sarah@abccorp.com',
                    status: 'pending',
                    notes: 'Product demo and pricing discussion'
                }
            ]

            setAppointments(mockAppointments)
        } catch (error) {
            console.error('Failed to load appointments:', error)
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

    const getStatusColor = (status: string) => {
        switch (status) {
            case 'confirmed':
                return 'bg-green-100 text-green-800 border-green-300'
            case 'pending':
                return 'bg-yellow-100 text-yellow-800 border-yellow-300'
            case 'cancelled':
                return 'bg-red-100 text-red-800 border-red-300'
            default:
                return 'bg-gray-100 text-gray-800 border-gray-300'
        }
    }

    const getStatusIcon = (status: string) => {
        switch (status) {
            case 'confirmed':
                return '✅'
            case 'pending':
                return '⏳'
            case 'cancelled':
                return '❌'
            default:
                return '📅'
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
                                    Appointments Management
                                </h1>
                                <p className="text-sm text-gray-500">
                                    Schedule and manage your business appointments
                                </p>
                            </div>
                        </div>
                        <div className="flex items-center space-x-4">
                            <button
                                onClick={() => router.push('/dashboard/appointments/new')}
                                className="px-4 py-2 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 rounded-lg transition-colors"
                            >
                                + New Appointment
                            </button>
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
                {/* Stats Cards */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Total Appointments</p>
                                <p className="text-2xl font-bold text-gray-900">
                                    {dataLoading ? '...' : appointments.length}
                                </p>
                            </div>
                            <div className="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center">
                                <span className="text-blue-600 text-xl">📅</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Confirmed</p>
                                <p className="text-2xl font-bold text-green-600">
                                    {dataLoading ? '...' : appointments.filter(a => a.status === 'confirmed').length}
                                </p>
                            </div>
                            <div className="h-12 w-12 bg-green-100 rounded-lg flex items-center justify-center">
                                <span className="text-green-600 text-xl">✅</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Pending</p>
                                <p className="text-2xl font-bold text-yellow-600">
                                    {dataLoading ? '...' : appointments.filter(a => a.status === 'pending').length}
                                </p>
                            </div>
                            <div className="h-12 w-12 bg-yellow-100 rounded-lg flex items-center justify-center">
                                <span className="text-yellow-600 text-xl">⏳</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Today</p>
                                <p className="text-2xl font-bold text-blue-600">
                                    {dataLoading ? '...' : appointments.filter(a => a.date === '2024-08-05').length}
                                </p>
                            </div>
                            <div className="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center">
                                <span className="text-blue-600 text-xl">📅</span>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Appointments List */}
                <div className="bg-white rounded-xl shadow-sm border border-gray-200">
                    <div className="p-6 border-b border-gray-200">
                        <div className="flex items-center justify-between">
                            <h2 className="text-lg font-semibold text-gray-900">Upcoming Appointments</h2>
                            <div className="flex space-x-2">
                                <button className="px-3 py-1 text-sm bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200">
                                    All
                                </button>
                                <button className="px-3 py-1 text-sm bg-blue-100 text-blue-700 rounded-md hover:bg-blue-200">
                                    Today
                                </button>
                                <button className="px-3 py-1 text-sm bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200">
                                    This Week
                                </button>
                            </div>
                        </div>
                    </div>

                    <div className="p-6">
                        {dataLoading ? (
                            <div className="flex items-center justify-center py-12">
                                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                                <span className="ml-2 text-gray-600">Loading appointments...</span>
                            </div>
                        ) : appointments.length === 0 ? (
                            <div className="text-center py-12">
                                <div className="text-4xl mb-4">📅</div>
                                <h3 className="text-lg font-medium text-gray-900 mb-2">No appointments yet</h3>
                                <p className="text-gray-500 mb-4">Create your first appointment to get started</p>
                                <button
                                    onClick={() => router.push('/dashboard/appointments/new')}
                                    className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                                >
                                    Create Appointment
                                </button>
                            </div>
                        ) : (
                            <div className="space-y-4">
                                {appointments.map((appointment) => (
                                    <div
                                        key={appointment.id}
                                        className="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
                                    >
                                        <div className="flex items-center space-x-4">
                                            <div className="h-10 w-10 bg-blue-100 rounded-lg flex items-center justify-center">
                                                <span className="text-blue-600 text-sm font-medium">
                                                    {appointment.time}
                                                </span>
                                            </div>
                                            <div>
                                                <h3 className="font-medium text-gray-900">{appointment.title}</h3>
                                                <p className="text-sm text-gray-600">
                                                    {appointment.clientName} • {appointment.duration}min
                                                </p>
                                            </div>
                                        </div>
                                        <div className="flex items-center space-x-4">
                                            <span className={`px-2 py-1 rounded-full text-xs font-medium border ${getStatusColor(appointment.status)}`}>
                                                {getStatusIcon(appointment.status)} {appointment.status}
                                            </span>
                                            <div className="flex space-x-2">
                                                <button className="p-1 text-gray-400 hover:text-blue-600">
                                                    ✏️
                                                </button>
                                                <button className="p-1 text-gray-400 hover:text-red-600">
                                                    🗑️
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>
                </div>

                {/* Quick Actions */}
                <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h3>
                        <div className="space-y-3">
                            <button
                                onClick={() => router.push('/dashboard/appointments/new')}
                                className="w-full text-left p-3 bg-blue-50 rounded-lg hover:bg-blue-100 transition-colors"
                            >
                                <div className="flex items-center space-x-3">
                                    <span className="text-blue-600">📅</span>
                                    <span className="font-medium">Schedule New Appointment</span>
                                </div>
                            </button>
                            <button
                                onClick={() => router.push('/dashboard/messages')}
                                className="w-full text-left p-3 bg-green-50 rounded-lg hover:bg-green-100 transition-colors"
                            >
                                <div className="flex items-center space-x-3">
                                    <span className="text-green-600">📧</span>
                                    <span className="font-medium">Send Reminders</span>
                                </div>
                            </button>
                            <button
                                onClick={() => router.push('/dashboard/analytics')}
                                className="w-full text-left p-3 bg-purple-50 rounded-lg hover:bg-purple-100 transition-colors"
                            >
                                <div className="flex items-center space-x-3">
                                    <span className="text-purple-600">📊</span>
                                    <span className="font-medium">View Reports</span>
                                </div>
                            </button>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4">Today's Schedule</h3>
                        <div className="space-y-3">
                            {appointments.filter(a => a.date === '2024-08-05').map((appointment) => (
                                <div key={appointment.id} className="flex items-center space-x-3 p-3 bg-gray-50 rounded-lg">
                                    <div className="h-8 w-8 bg-blue-100 rounded-full flex items-center justify-center">
                                        <span className="text-blue-600 text-xs font-medium">{appointment.time}</span>
                                    </div>
                                    <div className="flex-1">
                                        <p className="font-medium text-sm">{appointment.title}</p>
                                        <p className="text-xs text-gray-600">{appointment.clientName}</p>
                                    </div>
                                    <span className={`px-2 py-1 rounded-full text-xs font-medium ${getStatusColor(appointment.status)}`}>
                                        {getStatusIcon(appointment.status)}
                                    </span>
                                </div>
                            ))}
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4">Recent Activity</h3>
                        <div className="space-y-3">
                            <div className="flex items-center space-x-3 p-3 bg-green-50 rounded-lg">
                                <span className="text-green-600">✅</span>
                                <div>
                                    <p className="text-sm font-medium">Appointment confirmed</p>
                                    <p className="text-xs text-gray-600">John Smith - 2 hours ago</p>
                                </div>
                            </div>
                            <div className="flex items-center space-x-3 p-3 bg-yellow-50 rounded-lg">
                                <span className="text-yellow-600">⏳</span>
                                <div>
                                    <p className="text-sm font-medium">New appointment request</p>
                                    <p className="text-xs text-gray-600">Sarah Johnson - 4 hours ago</p>
                                </div>
                            </div>
                            <div className="flex items-center space-x-3 p-3 bg-blue-50 rounded-lg">
                                <span className="text-blue-600">📧</span>
                                <div>
                                    <p className="text-sm font-medium">Reminder sent</p>
                                    <p className="text-xs text-gray-600">Team Meeting - 1 day ago</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    )
} 