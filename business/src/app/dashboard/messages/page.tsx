'use client'

import { useAuth } from '@/contexts/AuthContext'
import { signOutUser } from '@/services/auth_service'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useEffect, useState } from 'react'

interface Message {
    id: string
    from: string
    to: string
    subject: string
    content: string
    timestamp: string
    status: 'read' | 'unread' | 'sent' | 'draft'
    type: 'inbox' | 'outbox' | 'draft'
    attachments?: string[]
}

export default function MessagesPage() {
    const { user, loading, isAuthenticated } = useAuth()
    const router = useRouter()
    const [messages, setMessages] = useState<Message[]>([])
    const [selectedMessage, setSelectedMessage] = useState<Message | null>(null)
    const [activeTab, setActiveTab] = useState<'inbox' | 'outbox' | 'draft'>('inbox')
    const [dataLoading, setDataLoading] = useState(true)
    const [showComposeForm, setShowComposeForm] = useState(false)

    useEffect(() => {
        if (!loading && !isAuthenticated) {
            router.push('/login')
        }
    }, [loading, isAuthenticated, router])

    useEffect(() => {
        if (isAuthenticated) {
            loadMessages()
        }
    }, [isAuthenticated])

    const loadMessages = async () => {
        setDataLoading(true)
        try {
            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 1000))

            const mockMessages: Message[] = [
                {
                    id: '1',
                    from: 'john@example.com',
                    to: 'business@app-oint.com',
                    subject: 'Appointment Reschedule Request',
                    content: 'Hi, I need to reschedule our meeting from tomorrow to next week. Is that possible?',
                    timestamp: '2024-08-05T10:30:00Z',
                    status: 'unread',
                    type: 'inbox'
                },
                {
                    id: '2',
                    from: 'business@app-oint.com',
                    to: 'sarah@client.com',
                    subject: 'Meeting Confirmation',
                    content: 'Your appointment has been confirmed for tomorrow at 2 PM. Looking forward to our meeting!',
                    timestamp: '2024-08-05T09:15:00Z',
                    status: 'sent',
                    type: 'outbox'
                },
                {
                    id: '3',
                    from: 'support@company.com',
                    subject: 'Welcome to Business Studio',
                    to: 'business@app-oint.com',
                    content: 'Welcome to App-Oint Business Studio! We\'re excited to help you manage your business more effectively.',
                    timestamp: '2024-08-04T14:20:00Z',
                    status: 'read',
                    type: 'inbox'
                },
                {
                    id: '4',
                    from: 'business@app-oint.com',
                    to: 'team@company.com',
                    subject: 'Weekly Update',
                    content: 'Here\'s our weekly update with key metrics and upcoming tasks...',
                    timestamp: '2024-08-03T16:45:00Z',
                    status: 'draft',
                    type: 'draft'
                }
            ]

            setMessages(mockMessages)
        } catch (error) {
            console.error('Failed to load messages:', error)
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

    const getStatusIcon = (status: string) => {
        switch (status) {
            case 'unread':
                return '🔵'
            case 'read':
                return '⚪'
            case 'sent':
                return '✅'
            case 'draft':
                return '📝'
            default:
                return '📧'
        }
    }

    const getTypeIcon = (type: string) => {
        switch (type) {
            case 'inbox':
                return '📥'
            case 'outbox':
                return '📤'
            case 'draft':
                return '📝'
            default:
                return '📧'
        }
    }

    const formatDate = (timestamp: string) => {
        const date = new Date(timestamp)
        const now = new Date()
        const diffInHours = (now.getTime() - date.getTime()) / (1000 * 60 * 60)

        if (diffInHours < 1) {
            return 'Just now'
        } else if (diffInHours < 24) {
            return `${Math.floor(diffInHours)}h ago`
        } else {
            return date.toLocaleDateString()
        }
    }

    const filteredMessages = messages.filter(msg => msg.type === activeTab)

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
                                    Messages & Communication
                                </h1>
                                <p className="text-sm text-gray-500">
                                    Communicate with customers and manage conversations
                                </p>
                            </div>
                        </div>
                        <div className="flex items-center space-x-4">
                            <button
                                onClick={() => setShowComposeForm(true)}
                                className="px-4 py-2 text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 rounded-lg transition-colors"
                            >
                                + Compose
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
                    {/* Message List */}
                    <div className="lg:col-span-1">
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200">
                            {/* Tabs */}
                            <div className="border-b border-gray-200">
                                <nav className="flex space-x-1 p-2">
                                    {[
                                        { id: 'inbox', name: 'Inbox', icon: '📥', count: messages.filter(m => m.type === 'inbox').length },
                                        { id: 'outbox', name: 'Sent', icon: '📤', count: messages.filter(m => m.type === 'outbox').length },
                                        { id: 'draft', name: 'Drafts', icon: '📝', count: messages.filter(m => m.type === 'draft').length }
                                    ].map((tab) => (
                                        <button
                                            key={tab.id}
                                            onClick={() => setActiveTab(tab.id as any)}
                                            className={`flex-1 py-2 px-3 text-sm font-medium rounded-md ${activeTab === tab.id
                                                    ? 'bg-indigo-100 text-indigo-700'
                                                    : 'text-gray-500 hover:text-gray-700 hover:bg-gray-100'
                                                }`}
                                        >
                                            <div className="flex items-center justify-between">
                                                <span>{tab.icon}</span>
                                                <span className="text-xs bg-gray-200 text-gray-600 px-2 py-1 rounded-full">
                                                    {tab.count}
                                                </span>
                                            </div>
                                        </button>
                                    ))}
                                </nav>
                            </div>

                            {/* Message List */}
                            <div className="p-4">
                                {dataLoading ? (
                                    <div className="flex items-center justify-center py-8">
                                        <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-indigo-600"></div>
                                        <span className="ml-2 text-gray-600">Loading...</span>
                                    </div>
                                ) : filteredMessages.length === 0 ? (
                                    <div className="text-center py-8">
                                        <div className="text-3xl mb-2">{getTypeIcon(activeTab)}</div>
                                        <p className="text-gray-500">No {activeTab} messages</p>
                                    </div>
                                ) : (
                                    <div className="space-y-2">
                                        {filteredMessages.map((message) => (
                                            <div
                                                key={message.id}
                                                onClick={() => setSelectedMessage(message)}
                                                className={`p-3 rounded-lg cursor-pointer transition-colors ${selectedMessage?.id === message.id
                                                        ? 'bg-indigo-50 border border-indigo-200'
                                                        : message.status === 'unread'
                                                            ? 'bg-blue-50 hover:bg-blue-100'
                                                            : 'bg-gray-50 hover:bg-gray-100'
                                                    }`}
                                            >
                                                <div className="flex items-start space-x-3">
                                                    <span className="text-sm">{getStatusIcon(message.status)}</span>
                                                    <div className="flex-1 min-w-0">
                                                        <p className={`text-sm font-medium truncate ${message.status === 'unread' ? 'text-gray-900' : 'text-gray-700'
                                                            }`}>
                                                            {message.subject}
                                                        </p>
                                                        <p className="text-xs text-gray-500 truncate">
                                                            {activeTab === 'inbox' ? message.from : message.to}
                                                        </p>
                                                        <p className="text-xs text-gray-400">
                                                            {formatDate(message.timestamp)}
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        ))}
                                    </div>
                                )}
                            </div>
                        </div>
                    </div>

                    {/* Message Detail */}
                    <div className="lg:col-span-3">
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200">
                            {selectedMessage ? (
                                <div className="p-6">
                                    <div className="flex items-center justify-between mb-6">
                                        <div>
                                            <h2 className="text-xl font-semibold text-gray-900">{selectedMessage.subject}</h2>
                                            <div className="flex items-center space-x-4 mt-2 text-sm text-gray-600">
                                                <span>From: {selectedMessage.from}</span>
                                                <span>To: {selectedMessage.to}</span>
                                                <span>{formatDate(selectedMessage.timestamp)}</span>
                                            </div>
                                        </div>
                                        <div className="flex space-x-2">
                                            <button className="p-2 text-gray-400 hover:text-blue-600 rounded-lg hover:bg-blue-50">
                                                ✏️
                                            </button>
                                            <button className="p-2 text-gray-400 hover:text-red-600 rounded-lg hover:bg-red-50">
                                                🗑️
                                            </button>
                                            <button className="p-2 text-gray-400 hover:text-green-600 rounded-lg hover:bg-green-50">
                                                📤
                                            </button>
                                        </div>
                                    </div>
                                    <div className="prose max-w-none">
                                        <p className="text-gray-700 leading-relaxed">{selectedMessage.content}</p>
                                    </div>
                                    {selectedMessage.attachments && selectedMessage.attachments.length > 0 && (
                                        <div className="mt-6 pt-6 border-t border-gray-200">
                                            <h3 className="text-sm font-medium text-gray-900 mb-3">Attachments</h3>
                                            <div className="space-y-2">
                                                {selectedMessage.attachments.map((attachment, index) => (
                                                    <div key={index} className="flex items-center space-x-3 p-2 bg-gray-50 rounded-lg">
                                                        <span className="text-gray-400">📎</span>
                                                        <span className="text-sm text-gray-700">{attachment}</span>
                                                        <button className="text-blue-600 hover:text-blue-700 text-sm">
                                                            Download
                                                        </button>
                                                    </div>
                                                ))}
                                            </div>
                                        </div>
                                    )}
                                </div>
                            ) : (
                                <div className="p-12 text-center">
                                    <div className="text-4xl mb-4">📧</div>
                                    <h3 className="text-lg font-medium text-gray-900 mb-2">Select a message</h3>
                                    <p className="text-gray-500">Choose a message from the list to view its details</p>
                                </div>
                            )}
                        </div>
                    </div>
                </div>

                {/* Quick Actions */}
                <div className="mt-8 grid grid-cols-1 md:grid-cols-4 gap-6">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center space-x-3">
                            <span className="text-indigo-600 text-xl">📧</span>
                            <div>
                                <h3 className="font-medium text-gray-900">Compose Message</h3>
                                <p className="text-sm text-gray-600">Send a new message</p>
                            </div>
                        </div>
                    </div>
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center space-x-3">
                            <span className="text-blue-600 text-xl">📋</span>
                            <div>
                                <h3 className="font-medium text-gray-900">Templates</h3>
                                <p className="text-sm text-gray-600">Use message templates</p>
                            </div>
                        </div>
                    </div>
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center space-x-3">
                            <span className="text-green-600 text-xl">⚡</span>
                            <div>
                                <h3 className="font-medium text-gray-900">Quick Replies</h3>
                                <p className="text-sm text-gray-600">Send quick responses</p>
                            </div>
                        </div>
                    </div>
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex items-center space-x-3">
                            <span className="text-purple-600 text-xl">📊</span>
                            <div>
                                <h3 className="font-medium text-gray-900">Analytics</h3>
                                <p className="text-sm text-gray-600">Message insights</p>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    )
} 