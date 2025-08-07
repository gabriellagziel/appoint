'use client'

import { useAuth } from '@/contexts/AuthContext'
import { signOutUser } from '@/services/auth_service'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useEffect, useState } from 'react'

interface TeamMember {
    id: string
    name: string
    email: string
    role: 'admin' | 'manager' | 'staff' | 'viewer'
    status: 'active' | 'pending' | 'inactive'
    avatar?: string
    lastActive: string
    permissions: string[]
}

export default function StaffPage() {
    const { user, loading, isAuthenticated } = useAuth()
    const router = useRouter()
    const [teamMembers, setTeamMembers] = useState<TeamMember[]>([])
    const [showInviteForm, setShowInviteForm] = useState(false)
    const [dataLoading, setDataLoading] = useState(true)
    const [selectedMember, setSelectedMember] = useState<TeamMember | null>(null)

    useEffect(() => {
        if (!loading && !isAuthenticated) {
            router.push('/login')
        }
    }, [loading, isAuthenticated, router])

    useEffect(() => {
        if (isAuthenticated) {
            loadTeamMembers()
        }
    }, [isAuthenticated])

    const loadTeamMembers = async () => {
        setDataLoading(true)
        try {
            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 1000))

            const mockTeamMembers: TeamMember[] = [
                {
                    id: '1',
                    name: 'Sarah Johnson',
                    email: 'sarah@company.com',
                    role: 'admin',
                    status: 'active',
                    lastActive: '2 hours ago',
                    permissions: ['manage_appointments', 'manage_staff', 'view_analytics', 'manage_branding']
                },
                {
                    id: '2',
                    name: 'Mike Chen',
                    email: 'mike@company.com',
                    role: 'manager',
                    status: 'active',
                    lastActive: '1 day ago',
                    permissions: ['manage_appointments', 'view_analytics']
                },
                {
                    id: '3',
                    name: 'Emily Davis',
                    email: 'emily@company.com',
                    role: 'staff',
                    status: 'pending',
                    lastActive: 'Never',
                    permissions: ['view_appointments']
                },
                {
                    id: '4',
                    name: 'Alex Wilson',
                    email: 'alex@company.com',
                    role: 'viewer',
                    status: 'active',
                    lastActive: '3 days ago',
                    permissions: ['view_appointments']
                }
            ]

            setTeamMembers(mockTeamMembers)
        } catch (error) {
            console.error('Failed to load team members:', error)
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

    const getRoleColor = (role: string) => {
        switch (role) {
            case 'admin':
                return 'bg-red-100 text-red-800 border-red-300'
            case 'manager':
                return 'bg-blue-100 text-blue-800 border-blue-300'
            case 'staff':
                return 'bg-green-100 text-green-800 border-green-300'
            case 'viewer':
                return 'bg-gray-100 text-gray-800 border-gray-300'
            default:
                return 'bg-gray-100 text-gray-800 border-gray-300'
        }
    }

    const getStatusColor = (status: string) => {
        switch (status) {
            case 'active':
                return 'bg-green-100 text-green-800'
            case 'pending':
                return 'bg-yellow-100 text-yellow-800'
            case 'inactive':
                return 'bg-red-100 text-red-800'
            default:
                return 'bg-gray-100 text-gray-800'
        }
    }

    const getRoleIcon = (role: string) => {
        switch (role) {
            case 'admin':
                return '👑'
            case 'manager':
                return '👔'
            case 'staff':
                return '👤'
            case 'viewer':
                return '👁️'
            default:
                return '👤'
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
                                    Staff Management
                                </h1>
                                <p className="text-sm text-gray-500">
                                    Manage your team members and their access permissions
                                </p>
                            </div>
                        </div>
                        <div className="flex items-center space-x-4">
                            <button
                                onClick={() => setShowInviteForm(true)}
                                className="px-4 py-2 text-sm font-medium text-white bg-orange-600 hover:bg-orange-700 rounded-lg transition-colors"
                            >
                                + Invite Member
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
                                <p className="text-sm font-medium text-gray-600">Total Team Members</p>
                                <p className="text-2xl font-bold text-gray-900">
                                    {dataLoading ? '...' : teamMembers.length}
                                </p>
                            </div>
                            <div className="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center">
                                <span className="text-blue-600 text-xl">👥</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm font-medium text-gray-600">Active Members</p>
                                <p className="text-2xl font-bold text-green-600">
                                    {dataLoading ? '...' : teamMembers.filter(m => m.status === 'active').length}
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
                                <p className="text-sm font-medium text-gray-600">Pending Invites</p>
                                <p className="text-2xl font-bold text-yellow-600">
                                    {dataLoading ? '...' : teamMembers.filter(m => m.status === 'pending').length}
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
                                <p className="text-sm font-medium text-gray-600">Admins</p>
                                <p className="text-2xl font-bold text-red-600">
                                    {dataLoading ? '...' : teamMembers.filter(m => m.role === 'admin').length}
                                </p>
                            </div>
                            <div className="h-12 w-12 bg-red-100 rounded-lg flex items-center justify-center">
                                <span className="text-red-600 text-xl">👑</span>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Team Members List */}
                <div className="bg-white rounded-xl shadow-sm border border-gray-200">
                    <div className="p-6 border-b border-gray-200">
                        <div className="flex items-center justify-between">
                            <h2 className="text-lg font-semibold text-gray-900">Team Members</h2>
                            <div className="flex space-x-2">
                                <button className="px-3 py-1 text-sm bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200">
                                    All
                                </button>
                                <button className="px-3 py-1 text-sm bg-blue-100 text-blue-700 rounded-md hover:bg-blue-200">
                                    Active
                                </button>
                                <button className="px-3 py-1 text-sm bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200">
                                    Pending
                                </button>
                            </div>
                        </div>
                    </div>

                    <div className="p-6">
                        {dataLoading ? (
                            <div className="flex items-center justify-center py-12">
                                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-orange-600"></div>
                                <span className="ml-2 text-gray-600">Loading team members...</span>
                            </div>
                        ) : teamMembers.length === 0 ? (
                            <div className="text-center py-12">
                                <div className="text-4xl mb-4">👥</div>
                                <h3 className="text-lg font-medium text-gray-900 mb-2">No team members yet</h3>
                                <p className="text-gray-500 mb-4">Invite your first team member to get started</p>
                                <button
                                    onClick={() => setShowInviteForm(true)}
                                    className="px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700"
                                >
                                    Invite Team Member
                                </button>
                            </div>
                        ) : (
                            <div className="space-y-4">
                                {teamMembers.map((member) => (
                                    <div
                                        key={member.id}
                                        className="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors cursor-pointer"
                                        onClick={() => setSelectedMember(member)}
                                    >
                                        <div className="flex items-center space-x-4">
                                            <div className="h-10 w-10 bg-gradient-to-br from-blue-500 to-purple-500 rounded-full flex items-center justify-center">
                                                <span className="text-white text-sm font-medium">
                                                    {member.name.charAt(0).toUpperCase()}
                                                </span>
                                            </div>
                                            <div>
                                                <h3 className="font-medium text-gray-900">{member.name}</h3>
                                                <p className="text-sm text-gray-600">{member.email}</p>
                                            </div>
                                        </div>
                                        <div className="flex items-center space-x-4">
                                            <span className={`px-2 py-1 rounded-full text-xs font-medium border ${getRoleColor(member.role)}`}>
                                                {getRoleIcon(member.role)} {member.role}
                                            </span>
                                            <span className={`px-2 py-1 rounded-full text-xs font-medium ${getStatusColor(member.status)}`}>
                                                {member.status}
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

                {/* Quick Actions and Permissions */}
                <div className="mt-8 grid grid-cols-1 lg:grid-cols-3 gap-8">
                    {/* Quick Actions */}
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h3>
                        <div className="space-y-3">
                            <button className="w-full text-left p-3 bg-orange-50 rounded-lg hover:bg-orange-100 transition-colors">
                                <div className="flex items-center space-x-3">
                                    <span className="text-orange-600">📧</span>
                                    <span className="font-medium">Invite New Member</span>
                                </div>
                            </button>
                            <button className="w-full text-left p-3 bg-blue-50 rounded-lg hover:bg-blue-100 transition-colors">
                                <div className="flex items-center space-x-3">
                                    <span className="text-blue-600">👥</span>
                                    <span className="font-medium">Manage Roles</span>
                                </div>
                            </button>
                            <button className="w-full text-left p-3 bg-green-50 rounded-lg hover:bg-green-100 transition-colors">
                                <div className="flex items-center space-x-3">
                                    <span className="text-green-600">🔐</span>
                                    <span className="font-medium">Set Permissions</span>
                                </div>
                            </button>
                            <button className="w-full text-left p-3 bg-purple-50 rounded-lg hover:bg-purple-100 transition-colors">
                                <div className="flex items-center space-x-3">
                                    <span className="text-purple-600">📊</span>
                                    <span className="font-medium">Activity Log</span>
                                </div>
                            </button>
                        </div>
                    </div>

                    {/* Role Permissions */}
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4">Role Permissions</h3>
                        <div className="space-y-4">
                            <div className="p-3 bg-red-50 rounded-lg">
                                <div className="flex items-center space-x-2 mb-2">
                                    <span className="text-red-600">👑</span>
                                    <span className="font-medium text-gray-900">Admin</span>
                                </div>
                                <p className="text-sm text-gray-600">Full access to all features and settings</p>
                            </div>
                            <div className="p-3 bg-blue-50 rounded-lg">
                                <div className="flex items-center space-x-2 mb-2">
                                    <span className="text-blue-600">👔</span>
                                    <span className="font-medium text-gray-900">Manager</span>
                                </div>
                                <p className="text-sm text-gray-600">Can manage appointments and view analytics</p>
                            </div>
                            <div className="p-3 bg-green-50 rounded-lg">
                                <div className="flex items-center space-x-2 mb-2">
                                    <span className="text-green-600">👤</span>
                                    <span className="font-medium text-gray-900">Staff</span>
                                </div>
                                <p className="text-sm text-gray-600">Can view and manage appointments</p>
                            </div>
                            <div className="p-3 bg-gray-50 rounded-lg">
                                <div className="flex items-center space-x-2 mb-2">
                                    <span className="text-gray-600">👁️</span>
                                    <span className="font-medium text-gray-900">Viewer</span>
                                </div>
                                <p className="text-sm text-gray-600">Read-only access to appointments</p>
                            </div>
                        </div>
                    </div>

                    {/* Recent Activity */}
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4">Recent Activity</h3>
                        <div className="space-y-3">
                            <div className="flex items-center space-x-3 p-3 bg-green-50 rounded-lg">
                                <span className="text-green-600">✅</span>
                                <div>
                                    <p className="text-sm font-medium">Sarah Johnson joined</p>
                                    <p className="text-xs text-gray-600">2 hours ago</p>
                                </div>
                            </div>
                            <div className="flex items-center space-x-3 p-3 bg-blue-50 rounded-lg">
                                <span className="text-blue-600">👔</span>
                                <div>
                                    <p className="text-sm font-medium">Mike Chen role updated</p>
                                    <p className="text-xs text-gray-600">1 day ago</p>
                                </div>
                            </div>
                            <div className="flex items-center space-x-3 p-3 bg-yellow-50 rounded-lg">
                                <span className="text-yellow-600">⏳</span>
                                <div>
                                    <p className="text-sm font-medium">Emily Davis invited</p>
                                    <p className="text-xs text-gray-600">3 days ago</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    )
} 