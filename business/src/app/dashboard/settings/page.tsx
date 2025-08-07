'use client'

import { useAuth } from '@/contexts/AuthContext'
import { signOutUser } from '@/services/auth_service'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useEffect, useState } from 'react'

interface Settings {
    notifications: {
        email: boolean
        sms: boolean
        push: boolean
        appointmentReminders: boolean
        marketingUpdates: boolean
    }
    privacy: {
        profileVisibility: 'public' | 'private'
        dataSharing: boolean
        analyticsTracking: boolean
    }
    preferences: {
        timezone: string
        language: string
        dateFormat: string
        currency: string
    }
    security: {
        twoFactorAuth: boolean
        sessionTimeout: number
        passwordExpiry: number
    }
}

export default function SettingsPage() {
    const { user, loading, isAuthenticated } = useAuth()
    const router = useRouter()
    const [settings, setSettings] = useState<Settings>({
        notifications: {
            email: true,
            sms: false,
            push: true,
            appointmentReminders: true,
            marketingUpdates: false
        },
        privacy: {
            profileVisibility: 'public',
            dataSharing: true,
            analyticsTracking: true
        },
        preferences: {
            timezone: 'America/New_York',
            language: 'en',
            dateFormat: 'MM/DD/YYYY',
            currency: 'USD'
        },
        security: {
            twoFactorAuth: false,
            sessionTimeout: 30,
            passwordExpiry: 90
        }
    })
    const [dataLoading, setDataLoading] = useState(true)
    const [activeTab, setActiveTab] = useState('account')
    const [showPasswordModal, setShowPasswordModal] = useState(false)

    useEffect(() => {
        if (!loading && !isAuthenticated) {
            router.push('/login')
        }
    }, [loading, isAuthenticated, router])

    useEffect(() => {
        if (isAuthenticated) {
            loadSettings()
        }
    }, [isAuthenticated])

    const loadSettings = async () => {
        setDataLoading(true)
        try {
            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 1000))
            setDataLoading(false)
        } catch (error) {
            console.error('Failed to load settings:', error)
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

    const handleSettingChange = (category: keyof Settings, key: string, value: any) => {
        setSettings(prev => ({
            ...prev,
            [category]: {
                ...prev[category],
                [key]: value
            }
        }))
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
                                    Settings & Preferences
                                </h1>
                                <p className="text-sm text-gray-500">
                                    Configure your business preferences and account settings
                                </p>
                            </div>
                        </div>
                        <div className="flex items-center space-x-4">
                            <button className="px-4 py-2 text-sm font-medium text-white bg-pink-600 hover:bg-pink-700 rounded-lg transition-colors">
                                Save Changes
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
                <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
                    {/* Settings Navigation */}
                    <div className="lg:col-span-1">
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                            <h3 className="text-lg font-semibold text-gray-900 mb-4">Settings</h3>
                            <nav className="space-y-2">
                                {[
                                    { id: 'account', name: 'Account', icon: '👤' },
                                    { id: 'notifications', name: 'Notifications', icon: '🔔' },
                                    { id: 'privacy', name: 'Privacy', icon: '🔒' },
                                    { id: 'preferences', name: 'Preferences', icon: '⚙️' },
                                    { id: 'security', name: 'Security', icon: '🛡️' },
                                    { id: 'billing', name: 'Billing', icon: '💳' },
                                    { id: 'integrations', name: 'Integrations', icon: '🔗' }
                                ].map((tab) => (
                                    <button
                                        key={tab.id}
                                        onClick={() => setActiveTab(tab.id)}
                                        className={`w-full text-left px-3 py-2 rounded-lg text-sm font-medium transition-colors ${activeTab === tab.id
                                                ? 'bg-pink-100 text-pink-700'
                                                : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
                                            }`}
                                    >
                                        <div className="flex items-center space-x-3">
                                            <span>{tab.icon}</span>
                                            <span>{tab.name}</span>
                                        </div>
                                    </button>
                                ))}
                            </nav>
                        </div>
                    </div>

                    {/* Settings Content */}
                    <div className="lg:col-span-3">
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200">
                            <div className="p-6">
                                {dataLoading ? (
                                    <div className="flex items-center justify-center py-12">
                                        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-pink-600"></div>
                                        <span className="ml-2 text-gray-600">Loading settings...</span>
                                    </div>
                                ) : (
                                    <div>
                                        {activeTab === 'account' && (
                                            <div className="space-y-6">
                                                <h2 className="text-xl font-semibold text-gray-900">Account Information</h2>
                                                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                                    <div>
                                                        <label className="block text-sm font-medium text-gray-700 mb-2">
                                                            Business Name
                                                        </label>
                                                        <input
                                                            type="text"
                                                            value={user?.displayName || 'App-Oint Business Studio'}
                                                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500"
                                                        />
                                                    </div>
                                                    <div>
                                                        <label className="block text-sm font-medium text-gray-700 mb-2">
                                                            Email Address
                                                        </label>
                                                        <input
                                                            type="email"
                                                            value={user?.email || 'business@app-oint.com'}
                                                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500"
                                                        />
                                                    </div>
                                                    <div>
                                                        <label className="block text-sm font-medium text-gray-700 mb-2">
                                                            Phone Number
                                                        </label>
                                                        <input
                                                            type="tel"
                                                            value="+1 (555) 123-4567"
                                                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500"
                                                        />
                                                    </div>
                                                    <div>
                                                        <label className="block text-sm font-medium text-gray-700 mb-2">
                                                            Business Address
                                                        </label>
                                                        <input
                                                            type="text"
                                                            value="123 Business St, Suite 100, City, State 12345"
                                                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500"
                                                        />
                                                    </div>
                                                </div>
                                                <div className="flex space-x-4">
                                                    <button
                                                        onClick={() => setShowPasswordModal(true)}
                                                        className="px-4 py-2 bg-pink-600 text-white rounded-lg hover:bg-pink-700"
                                                    >
                                                        Change Password
                                                    </button>
                                                    <button className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50">
                                                        Update Profile
                                                    </button>
                                                </div>
                                            </div>
                                        )}

                                        {activeTab === 'notifications' && (
                                            <div className="space-y-6">
                                                <h2 className="text-xl font-semibold text-gray-900">Notification Settings</h2>
                                                <div className="space-y-4">
                                                    {Object.entries(settings.notifications).map(([key, value]) => (
                                                        <div key={key} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                                                            <div>
                                                                <h3 className="font-medium text-gray-900 capitalize">
                                                                    {key.replace(/([A-Z])/g, ' $1').trim()}
                                                                </h3>
                                                                <p className="text-sm text-gray-600">
                                                                    Receive notifications via {key === 'email' ? 'email' : key === 'sms' ? 'SMS' : key === 'push' ? 'push notifications' : key === 'appointmentReminders' ? 'appointment reminders' : 'marketing updates'}
                                                                </p>
                                                            </div>
                                                            <button
                                                                onClick={() => handleSettingChange('notifications', key, !value)}
                                                                className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${value ? 'bg-pink-600' : 'bg-gray-200'
                                                                    }`}
                                                            >
                                                                <span
                                                                    className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${value ? 'translate-x-6' : 'translate-x-1'
                                                                        }`}
                                                                />
                                                            </button>
                                                        </div>
                                                    ))}
                                                </div>
                                            </div>
                                        )}

                                        {activeTab === 'privacy' && (
                                            <div className="space-y-6">
                                                <h2 className="text-xl font-semibold text-gray-900">Privacy Settings</h2>
                                                <div className="space-y-4">
                                                    <div className="p-4 bg-gray-50 rounded-lg">
                                                        <div className="flex items-center justify-between mb-2">
                                                            <h3 className="font-medium text-gray-900">Profile Visibility</h3>
                                                            <select
                                                                value={settings.privacy.profileVisibility}
                                                                onChange={(e) => handleSettingChange('privacy', 'profileVisibility', e.target.value)}
                                                                className="px-3 py-1 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-pink-500"
                                                                aria-label="Select profile visibility"
                                                            >
                                                                <option value="public">Public</option>
                                                                <option value="private">Private</option>
                                                            </select>
                                                        </div>
                                                        <p className="text-sm text-gray-600">
                                                            Control who can see your business profile
                                                        </p>
                                                    </div>
                                                    {Object.entries(settings.privacy).filter(([key]) => key !== 'profileVisibility').map(([key, value]) => (
                                                        <div key={key} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                                                            <div>
                                                                <h3 className="font-medium text-gray-900 capitalize">
                                                                    {key.replace(/([A-Z])/g, ' $1').trim()}
                                                                </h3>
                                                                <p className="text-sm text-gray-600">
                                                                    {key === 'dataSharing' ? 'Allow data sharing for improved services' : 'Enable analytics tracking'}
                                                                </p>
                                                            </div>
                                                            <button
                                                                onClick={() => handleSettingChange('privacy', key, !value)}
                                                                className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${value ? 'bg-pink-600' : 'bg-gray-200'
                                                                    }`}
                                                            >
                                                                <span
                                                                    className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${value ? 'translate-x-6' : 'translate-x-1'
                                                                        }`}
                                                                />
                                                            </button>
                                                        </div>
                                                    ))}
                                                </div>
                                            </div>
                                        )}

                                        {activeTab === 'preferences' && (
                                            <div className="space-y-6">
                                                <h2 className="text-xl font-semibold text-gray-900">Preferences</h2>
                                                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                                    <div>
                                                        <label className="block text-sm font-medium text-gray-700 mb-2">
                                                            Timezone
                                                        </label>
                                                        <select
                                                            value={settings.preferences.timezone}
                                                            onChange={(e) => handleSettingChange('preferences', 'timezone', e.target.value)}
                                                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500"
                                                            aria-label="Select timezone"
                                                        >
                                                            <option value="America/New_York">Eastern Time</option>
                                                            <option value="America/Chicago">Central Time</option>
                                                            <option value="America/Denver">Mountain Time</option>
                                                            <option value="America/Los_Angeles">Pacific Time</option>
                                                        </select>
                                                    </div>
                                                    <div>
                                                        <label className="block text-sm font-medium text-gray-700 mb-2">
                                                            Language
                                                        </label>
                                                        <select
                                                            value={settings.preferences.language}
                                                            onChange={(e) => handleSettingChange('preferences', 'language', e.target.value)}
                                                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500"
                                                            aria-label="Select language"
                                                        >
                                                            <option value="en">English</option>
                                                            <option value="es">Spanish</option>
                                                            <option value="fr">French</option>
                                                            <option value="de">German</option>
                                                        </select>
                                                    </div>
                                                    <div>
                                                        <label className="block text-sm font-medium text-gray-700 mb-2">
                                                            Date Format
                                                        </label>
                                                        <select
                                                            value={settings.preferences.dateFormat}
                                                            onChange={(e) => handleSettingChange('preferences', 'dateFormat', e.target.value)}
                                                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500"
                                                            aria-label="Select date format"
                                                        >
                                                            <option value="MM/DD/YYYY">MM/DD/YYYY</option>
                                                            <option value="DD/MM/YYYY">DD/MM/YYYY</option>
                                                            <option value="YYYY-MM-DD">YYYY-MM-DD</option>
                                                        </select>
                                                    </div>
                                                    <div>
                                                        <label className="block text-sm font-medium text-gray-700 mb-2">
                                                            Currency
                                                        </label>
                                                        <select
                                                            value={settings.preferences.currency}
                                                            onChange={(e) => handleSettingChange('preferences', 'currency', e.target.value)}
                                                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500"
                                                            aria-label="Select currency"
                                                        >
                                                            <option value="USD">USD ($)</option>
                                                            <option value="EUR">EUR (€)</option>
                                                            <option value="GBP">GBP (£)</option>
                                                            <option value="CAD">CAD (C$)</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        )}

                                        {activeTab === 'security' && (
                                            <div className="space-y-6">
                                                <h2 className="text-xl font-semibold text-gray-900">Security Settings</h2>
                                                <div className="space-y-4">
                                                    <div className="p-4 bg-gray-50 rounded-lg">
                                                        <div className="flex items-center justify-between mb-2">
                                                            <h3 className="font-medium text-gray-900">Two-Factor Authentication</h3>
                                                            <button
                                                                onClick={() => handleSettingChange('security', 'twoFactorAuth', !settings.security.twoFactorAuth)}
                                                                className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${settings.security.twoFactorAuth ? 'bg-pink-600' : 'bg-gray-200'
                                                                    }`}
                                                            >
                                                                <span
                                                                    className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${settings.security.twoFactorAuth ? 'translate-x-6' : 'translate-x-1'
                                                                        }`}
                                                                />
                                                            </button>
                                                        </div>
                                                        <p className="text-sm text-gray-600">
                                                            Add an extra layer of security to your account
                                                        </p>
                                                    </div>
                                                    <div className="p-4 bg-gray-50 rounded-lg">
                                                        <h3 className="font-medium text-gray-900 mb-2">Session Timeout</h3>
                                                        <select
                                                            value={settings.security.sessionTimeout}
                                                            onChange={(e) => handleSettingChange('security', 'sessionTimeout', parseInt(e.target.value))}
                                                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500"
                                                            aria-label="Select session timeout"
                                                        >
                                                            <option value={15}>15 minutes</option>
                                                            <option value={30}>30 minutes</option>
                                                            <option value={60}>1 hour</option>
                                                            <option value={120}>2 hours</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        )}

                                        {activeTab === 'billing' && (
                                            <div className="space-y-6">
                                                <h2 className="text-xl font-semibold text-gray-900">Billing & Subscription</h2>
                                                <div className="p-6 bg-gradient-to-r from-blue-50 to-purple-50 rounded-lg">
                                                    <div className="flex items-center justify-between">
                                                        <div>
                                                            <h3 className="text-lg font-semibold text-gray-900">Business Studio Plan</h3>
                                                            <p className="text-gray-600">$29/month</p>
                                                        </div>
                                                        <button className="px-4 py-2 bg-pink-600 text-white rounded-lg hover:bg-pink-700">
                                                            Upgrade Plan
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        )}

                                        {activeTab === 'integrations' && (
                                            <div className="space-y-6">
                                                <h2 className="text-xl font-semibold text-gray-900">Integrations</h2>
                                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                                    <div className="p-4 border border-gray-200 rounded-lg">
                                                        <div className="flex items-center space-x-3 mb-3">
                                                            <span className="text-2xl">📅</span>
                                                            <h3 className="font-medium text-gray-900">Google Calendar</h3>
                                                        </div>
                                                        <p className="text-sm text-gray-600 mb-3">Sync your appointments with Google Calendar</p>
                                                        <button className="text-pink-600 hover:text-pink-700 text-sm font-medium">
                                                            Connect →
                                                        </button>
                                                    </div>
                                                    <div className="p-4 border border-gray-200 rounded-lg">
                                                        <div className="flex items-center space-x-3 mb-3">
                                                            <span className="text-2xl">📧</span>
                                                            <h3 className="font-medium text-gray-900">Gmail</h3>
                                                        </div>
                                                        <p className="text-sm text-gray-600 mb-3">Send emails directly from the platform</p>
                                                        <button className="text-pink-600 hover:text-pink-700 text-sm font-medium">
                                                            Connect →
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        )}
                                    </div>
                                )}
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    )
} 