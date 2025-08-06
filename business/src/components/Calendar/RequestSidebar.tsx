'use client'

import { useState } from 'react'

interface MeetingRequest {
    id: string
    title: string
    requestedTime: string
    requestedDate: string
    fromUser: {
        name: string
        email: string
        avatar?: string
    }
    reason?: string
    status: 'pending' | 'accepted' | 'declined'
    createdAt: string
}

interface RequestSidebarProps {
    requests: MeetingRequest[]
    onAccept: (requestId: string) => void
    onDecline: (requestId: string) => void
    onSuggestTime: (requestId: string) => void
}

export default function RequestSidebar({ requests, onAccept, onDecline, onSuggestTime }: RequestSidebarProps) {
    const [isLoading, setIsLoading] = useState<string | null>(null)

    const handleAction = async (requestId: string, action: () => void) => {
        setIsLoading(requestId)
        try {
            action()
        } catch (error) {
            console.error('Action failed:', error)
        } finally {
            setIsLoading(null)
        }
    }

    const pendingRequests = requests.filter(req => req.status === 'pending')

    return (
        <div className="h-full bg-white rounded-lg shadow-sm border border-gray-200">
            {/* Header */}
            <div className="p-4 border-b border-gray-200">
                <div className="flex items-center justify-between">
                    <div>
                        <h3 className="text-lg font-semibold text-gray-900">Pending Requests</h3>
                        <p className="text-sm text-gray-500">
                            {pendingRequests.length} request{pendingRequests.length !== 1 ? 's' : ''} waiting
                        </p>
                    </div>
                    {pendingRequests.length > 0 && (
                        <div className="w-6 h-6 bg-red-500 text-white text-xs rounded-full flex items-center justify-center">
                            {pendingRequests.length}
                        </div>
                    )}
                </div>
            </div>

            {/* Requests List */}
            <div className="overflow-y-auto h-[calc(100vh-200px)]">
                {pendingRequests.length === 0 ? (
                    <div className="p-6 text-center">
                        <div className="text-4xl mb-4">🎉</div>
                        <h4 className="text-lg font-medium text-gray-900 mb-2">All Caught Up!</h4>
                        <p className="text-gray-500">No pending requests at the moment</p>
                    </div>
                ) : (
                    <div className="p-4 space-y-4">
                        {pendingRequests.map((request) => (
                            <div
                                key={request.id}
                                className="bg-gray-50 rounded-lg p-4 border border-gray-200 hover:shadow-sm transition-shadow"
                            >
                                {/* Request Header */}
                                <div className="flex items-start space-x-3 mb-3">
                                    <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0">
                                        <span className="text-blue-600 text-sm font-medium">
                                            {request.fromUser.name.charAt(0).toUpperCase()}
                                        </span>
                                    </div>
                                    <div className="flex-1 min-w-0">
                                        <h4 className="text-sm font-medium text-gray-900 truncate">
                                            {request.title}
                                        </h4>
                                        <p className="text-xs text-gray-500">
                                            from {request.fromUser.name}
                                        </p>
                                    </div>
                                </div>

                                {/* Request Details */}
                                <div className="space-y-2 mb-4">
                                    <div className="flex items-center space-x-2 text-sm">
                                        <span className="text-gray-500">📅</span>
                                        <span className="text-gray-900">
                                            {request.requestedDate} at {request.requestedTime}
                                        </span>
                                    </div>

                                    {request.reason && (
                                        <div className="text-sm">
                                            <span className="text-gray-500">💬</span>
                                            <span className="text-gray-900 ml-2">{request.reason}</span>
                                        </div>
                                    )}

                                    <div className="text-xs text-gray-400">
                                        Requested {new Date(request.createdAt).toLocaleDateString()}
                                    </div>
                                </div>

                                {/* Action Buttons */}
                                <div className="flex space-x-2">
                                    <button
                                        onClick={() => handleAction(request.id, () => onAccept(request.id))}
                                        disabled={isLoading === request.id}
                                        className="flex-1 bg-green-600 hover:bg-green-700 disabled:bg-green-400 text-white px-3 py-2 rounded text-xs font-medium transition-colors"
                                    >
                                        {isLoading === request.id ? '...' : '✅ Accept'}
                                    </button>
                                    <button
                                        onClick={() => handleAction(request.id, () => onDecline(request.id))}
                                        disabled={isLoading === request.id}
                                        className="flex-1 bg-red-600 hover:bg-red-700 disabled:bg-red-400 text-white px-3 py-2 rounded text-xs font-medium transition-colors"
                                    >
                                        {isLoading === request.id ? '...' : '❌ Decline'}
                                    </button>
                                    <button
                                        onClick={() => handleAction(request.id, () => onSuggestTime(request.id))}
                                        disabled={isLoading === request.id}
                                        className="flex-1 bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white px-3 py-2 rounded text-xs font-medium transition-colors"
                                    >
                                        {isLoading === request.id ? '...' : '🔄 Suggest'}
                                    </button>
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </div>
        </div>
    )
} 