'use client'

import { useAuth } from '@/contexts/AuthContext'
import { signOutUser } from '@/services/auth_service'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useEffect, useState } from 'react'

interface BrandSettings {
    businessName: string
    logo: string | null
    primaryColor: string
    secondaryColor: string
    accentColor: string
    fontFamily: string
    tagline: string
    website: string
    email: string
    phone: string
    address: string
}

export default function BrandingPage() {
    const { user, loading, isAuthenticated } = useAuth()
    const router = useRouter()
    const [brandSettings, setBrandSettings] = useState<BrandSettings>({
        businessName: 'App-Oint Business Studio',
        logo: null,
        primaryColor: '#3B82F6',
        secondaryColor: '#1E40AF',
        accentColor: '#8B5CF6',
        fontFamily: 'Inter',
        tagline: 'Managing your business has never been easier',
        website: 'https://business.app-oint.com',
        email: 'hello@app-oint.com',
        phone: '+1 (555) 123-4567',
        address: '123 Business St, Suite 100, City, State 12345'
    })
    const [dataLoading, setDataLoading] = useState(true)
    const [activeTab, setActiveTab] = useState('general')

    useEffect(() => {
        if (!loading && !isAuthenticated) {
            router.push('/login')
        }
    }, [loading, isAuthenticated, router])

    useEffect(() => {
        if (isAuthenticated) {
            loadBrandSettings()
        }
    }, [isAuthenticated])

    const loadBrandSettings = async () => {
        setDataLoading(true)
        try {
            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 1000))
            setDataLoading(false)
        } catch (error) {
            console.error('Failed to load brand settings:', error)
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

    const handleColorChange = (field: keyof BrandSettings, value: string) => {
        setBrandSettings(prev => ({ ...prev, [field]: value }))
    }

    const handleLogoUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
        const file = event.target.files?.[0]
        if (file) {
            const reader = new FileReader()
            reader.onload = (e) => {
                setBrandSettings(prev => ({ ...prev, logo: e.target?.result as string }))
            }
            reader.readAsDataURL(file)
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
                                    Branding & Customization
                                </h1>
                                <p className="text-sm text-gray-500">
                                    Customize your business presence and branding
                                </p>
                            </div>
                        </div>
                        <div className="flex items-center space-x-4">
                            <button className="px-4 py-2 text-sm font-medium text-white bg-purple-600 hover:bg-purple-700 rounded-lg transition-colors">
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
                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    {/* Settings Panel */}
                    <div className="lg:col-span-2">
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200">
                            {/* Tabs */}
                            <div className="border-b border-gray-200">
                                <nav className="flex space-x-8 px-6">
                                    {[
                                        { id: 'general', name: 'General', icon: '🏢' },
                                        { id: 'visual', name: 'Visual Identity', icon: '🎨' },
                                        { id: 'contact', name: 'Contact Info', icon: '📞' },
                                        { id: 'templates', name: 'Templates', icon: '📄' }
                                    ].map((tab) => (
                                        <button
                                            key={tab.id}
                                            onClick={() => setActiveTab(tab.id)}
                                            className={`py-4 px-1 border-b-2 font-medium text-sm ${activeTab === tab.id
                                                ? 'border-purple-500 text-purple-600'
                                                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                                                }`}
                                        >
                                            <span className="mr-2">{tab.icon}</span>
                                            {tab.name}
                                        </button>
                                    ))}
                                </nav>
                            </div>

                            {/* Tab Content */}
                            <div className="p-6">
                                {dataLoading ? (
                                    <div className="flex items-center justify-center py-12">
                                        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-purple-600"></div>
                                        <span className="ml-2 text-gray-600">Loading brand settings...</span>
                                    </div>
                                ) : (
                                    <div>
                                        {activeTab === 'general' && (
                                            <div className="space-y-6">
                                                <div>
                                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                                        Business Name
                                                    </label>
                                                    <input
                                                        type="text"
                                                        value={brandSettings.businessName}
                                                        onChange={(e) => setBrandSettings(prev => ({ ...prev, businessName: e.target.value }))}
                                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
                                                    />
                                                </div>
                                                <div>
                                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                                        Tagline
                                                    </label>
                                                    <input
                                                        type="text"
                                                        value={brandSettings.tagline}
                                                        onChange={(e) => setBrandSettings(prev => ({ ...prev, tagline: e.target.value }))}
                                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
                                                    />
                                                </div>
                                                <div>
                                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                                        Website
                                                    </label>
                                                    <input
                                                        type="url"
                                                        value={brandSettings.website}
                                                        onChange={(e) => setBrandSettings(prev => ({ ...prev, website: e.target.value }))}
                                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
                                                    />
                                                </div>
                                            </div>
                                        )}

                                        {activeTab === 'visual' && (
                                            <div className="space-y-6">
                                                <div>
                                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                                        Logo
                                                    </label>
                                                    <div className="flex items-center space-x-4">
                                                        {brandSettings.logo ? (
                                                            <img src={brandSettings.logo} alt="Logo" className="h-16 w-16 object-contain border border-gray-200 rounded-lg" />
                                                        ) : (
                                                            <div className="h-16 w-16 bg-gray-100 border-2 border-dashed border-gray-300 rounded-lg flex items-center justify-center">
                                                                <span className="text-gray-400">📷</span>
                                                            </div>
                                                        )}
                                                        <input
                                                            type="file"
                                                            accept="image/*"
                                                            onChange={handleLogoUpload}
                                                            className="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-medium file:bg-purple-50 file:text-purple-700 hover:file:bg-purple-100"
                                                        />
                                                    </div>
                                                </div>
                                                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                                                    <div>
                                                        <label className="block text-sm font-medium text-gray-700 mb-2">
                                                            Primary Color
                                                        </label>
                                                        <input
                                                            type="color"
                                                            value={brandSettings.primaryColor}
                                                            onChange={(e) => handleColorChange('primaryColor', e.target.value)}
                                                            className="w-full h-10 border border-gray-300 rounded-lg cursor-pointer"
                                                        />
                                                    </div>
                                                    <div>
                                                        <label className="block text-sm font-medium text-gray-700 mb-2">
                                                            Secondary Color
                                                        </label>
                                                        <input
                                                            type="color"
                                                            value={brandSettings.secondaryColor}
                                                            onChange={(e) => handleColorChange('secondaryColor', e.target.value)}
                                                            className="w-full h-10 border border-gray-300 rounded-lg cursor-pointer"
                                                        />
                                                    </div>
                                                    <div>
                                                        <label className="block text-sm font-medium text-gray-700 mb-2">
                                                            Accent Color
                                                        </label>
                                                        <input
                                                            type="color"
                                                            value={brandSettings.accentColor}
                                                            onChange={(e) => handleColorChange('accentColor', e.target.value)}
                                                            className="w-full h-10 border border-gray-300 rounded-lg cursor-pointer"
                                                        />
                                                    </div>
                                                </div>
                                                <div>
                                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                                        Font Family
                                                    </label>
                                                    <select
                                                        value={brandSettings.fontFamily}
                                                        onChange={(e) => setBrandSettings(prev => ({ ...prev, fontFamily: e.target.value }))}
                                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
                                                        aria-label="Select font family"
                                                    >
                                                        <option value="Inter">Inter</option>
                                                        <option value="Roboto">Roboto</option>
                                                        <option value="Open Sans">Open Sans</option>
                                                        <option value="Lato">Lato</option>
                                                        <option value="Poppins">Poppins</option>
                                                    </select>
                                                </div>
                                            </div>
                                        )}

                                        {activeTab === 'contact' && (
                                            <div className="space-y-6">
                                                <div>
                                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                                        Email Address
                                                    </label>
                                                    <input
                                                        type="email"
                                                        value={brandSettings.email}
                                                        onChange={(e) => setBrandSettings(prev => ({ ...prev, email: e.target.value }))}
                                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
                                                    />
                                                </div>
                                                <div>
                                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                                        Phone Number
                                                    </label>
                                                    <input
                                                        type="tel"
                                                        value={brandSettings.phone}
                                                        onChange={(e) => setBrandSettings(prev => ({ ...prev, phone: e.target.value }))}
                                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
                                                    />
                                                </div>
                                                <div>
                                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                                        Address
                                                    </label>
                                                    <textarea
                                                        value={brandSettings.address}
                                                        onChange={(e) => setBrandSettings(prev => ({ ...prev, address: e.target.value }))}
                                                        rows={3}
                                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
                                                    />
                                                </div>
                                            </div>
                                        )}

                                        {activeTab === 'templates' && (
                                            <div className="space-y-6">
                                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                                    <div className="p-4 border border-gray-200 rounded-lg">
                                                        <h4 className="font-medium text-gray-900 mb-2">Email Templates</h4>
                                                        <p className="text-sm text-gray-600 mb-3">Customize your email templates</p>
                                                        <button className="text-purple-600 hover:text-purple-700 text-sm font-medium">
                                                            Manage Templates →
                                                        </button>
                                                    </div>
                                                    <div className="p-4 border border-gray-200 rounded-lg">
                                                        <h4 className="font-medium text-gray-900 mb-2">Invoice Templates</h4>
                                                        <p className="text-sm text-gray-600 mb-3">Design professional invoices</p>
                                                        <button className="text-purple-600 hover:text-purple-700 text-sm font-medium">
                                                            Customize Invoices →
                                                        </button>
                                                    </div>
                                                    <div className="p-4 border border-gray-200 rounded-lg">
                                                        <h4 className="font-medium text-gray-900 mb-2">Business Cards</h4>
                                                        <p className="text-sm text-gray-600 mb-3">Create branded business cards</p>
                                                        <button className="text-purple-600 hover:text-purple-700 text-sm font-medium">
                                                            Design Cards →
                                                        </button>
                                                    </div>
                                                    <div className="p-4 border border-gray-200 rounded-lg">
                                                        <h4 className="font-medium text-gray-900 mb-2">Social Media</h4>
                                                        <p className="text-sm text-gray-600 mb-3">Generate social media assets</p>
                                                        <button className="text-purple-600 hover:text-purple-700 text-sm font-medium">
                                                            Create Assets →
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

                    {/* Preview Panel */}
                    <div className="space-y-6">
                        {/* Brand Preview */}
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                            <h3 className="text-lg font-semibold text-gray-900 mb-4">Brand Preview</h3>
                            <div className="space-y-4">
                                <div className="text-center p-4 bg-gray-50 rounded-lg">
                                    {brandSettings.logo ? (
                                        <img src={brandSettings.logo} alt="Logo" className="h-12 mx-auto mb-2" />
                                    ) : (
                                        <div className="h-12 w-12 bg-gradient-to-br from-blue-600 to-purple-600 rounded-lg mx-auto mb-2 flex items-center justify-center">
                                            <span className="text-white text-lg font-bold">A</span>
                                        </div>
                                    )}
                                    <h4 className="font-semibold text-gray-900">{brandSettings.businessName}</h4>
                                    <p className="text-sm text-gray-600">{brandSettings.tagline}</p>
                                </div>
                                <div className="space-y-2">
                                    <div className="flex items-center space-x-2">
                                        <div className="w-4 h-4 rounded" style={{ backgroundColor: brandSettings.primaryColor }}></div>
                                        <span className="text-sm text-gray-600">Primary Color</span>
                                    </div>
                                    <div className="flex items-center space-x-2">
                                        <div className="w-4 h-4 rounded" style={{ backgroundColor: brandSettings.secondaryColor }}></div>
                                        <span className="text-sm text-gray-600">Secondary Color</span>
                                    </div>
                                    <div className="flex items-center space-x-2">
                                        <div className="w-4 h-4 rounded" style={{ backgroundColor: brandSettings.accentColor }}></div>
                                        <span className="text-sm text-gray-600">Accent Color</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Quick Actions */}
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                            <h3 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h3>
                            <div className="space-y-3">
                                <button className="w-full text-left p-3 bg-purple-50 rounded-lg hover:bg-purple-100 transition-colors">
                                    <div className="flex items-center space-x-3">
                                        <span className="text-purple-600">📤</span>
                                        <span className="font-medium">Export Brand Kit</span>
                                    </div>
                                </button>
                                <button className="w-full text-left p-3 bg-blue-50 rounded-lg hover:bg-blue-100 transition-colors">
                                    <div className="flex items-center space-x-3">
                                        <span className="text-blue-600">🎨</span>
                                        <span className="font-medium">Design Templates</span>
                                    </div>
                                </button>
                                <button className="w-full text-left p-3 bg-green-50 rounded-lg hover:bg-green-100 transition-colors">
                                    <div className="flex items-center space-x-3">
                                        <span className="text-green-600">📱</span>
                                        <span className="font-medium">Social Media Kit</span>
                                    </div>
                                </button>
                                <button className="w-full text-left p-3 bg-yellow-50 rounded-lg hover:bg-yellow-100 transition-colors">
                                    <div className="flex items-center space-x-3">
                                        <span className="text-yellow-600">📄</span>
                                        <span className="font-medium">Business Cards</span>
                                    </div>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    )
} 