'use client'

import { useState } from 'react'

interface Meeting {
    id: string
    title: string
    startTime: string
    endTime: string
    participants: string[]
    status: 'confirmed' | 'pending' | 'canceled'
    location?: string
    virtualLink?: string
    notes?: string
    requestReason?: string
}

interface MeetingDetailPanelProps {
    meeting: Meeting | null
    onAccept: (meetingId: string) => void
    onDecline: (meetingId: string) => void
    onSuggestTime: (meetingId: string) => void
    onMessage: (meetingId: string) => void
}

export default function MeetingDetailPanel({
    meeting,
    onAccept,
    onDecline,
    onSuggestTime,
    onMessage
}: MeetingDetailPanelProps) {
    const [isLoading, setIsLoading] = useState(false)

    const handleAction = async (action: () => void) => {
        if (!meeting) return

        setIsLoading(true)
        try {
            action()
        } catch (error) {
            console.error('Action failed:', error)
        } finally {
            setIsLoading(false)
        }
    }

    if (!meeting) {
        return (
            <div className="h-full bg-white rounded-lg shadow-sm border border-gray-200 flex items-center justify-center">
                <div className="text-center">
                    <div className="text-4xl mb-4">📅</div>
                    <h3 className="text-lg font-medium text-gray-900 mb-2">No Meeting Selected</h3>
                    <p className="text-gray-500">Click on a meeting from the timeline to view details</p>
                </div>
            </div>
        )
    }

    const getStatusColor = (status: string) => {
        switch (status) {
            case 'confirmed':
                return 'bg-green-100 text-green-800 border-green-300'
            case 'pending':
                return 'bg-yellow-100 text-yellow-800 border-yellow-300'
            case 'canceled':
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
            case 'canceled':
                return '❌'
            default:
                return '📅'
        }
    }

    return (
        <div className="h-full bg-white rounded-lg shadow-sm border border-gray-200 overflow-y-auto">
            {/* Header */}
            <div className="p-6 border-b border-gray-200">
                <div className="flex items-start justify-between mb-4">
                    <div className="flex-1">
                        <h2 className="text-xl font-semibold text-gray-900 mb-2">
                            {meeting.title}
                        </h2>
                        <div className="flex items-center space-x-4 text-sm text-gray-600">
                            <span>🕐 {meeting.startTime} - {meeting.endTime}</span>
                            <span className={`px-2 py-1 rounded-full text-xs font-medium border ${getStatusColor(meeting.status)}`}>
                                {getStatusIcon(meeting.status)} {meeting.status}
                            </span>
                        </div>
                    </div>
                </div>

                {/* Action Buttons */}
                {meeting.status === 'pending' && (
                    <div className="flex space-x-3">
                        <button
                            onClick={() => handleAction(() => onAccept(meeting.id))}
                            disabled={isLoading}
                            className="flex-1 bg-green-600 hover:bg-green-700 disabled:bg-green-400 text-white px-4 py-2 rounded-lg font-medium transition-colors"
                        >
                            {isLoading ? 'Processing...' : '✅ Accept'}
                        </button>
                        <button
                            onClick={() => handleAction(() => onDecline(meeting.id))}
                            disabled={isLoading}
                            className="flex-1 bg-red-600 hover:bg-red-700 disabled:bg-red-400 text-white px-4 py-2 rounded-lg font-medium transition-colors"
                        >
                            {isLoading ? 'Processing...' : '❌ Decline'}
                        </button>
                        <button
                            onClick={() => handleAction(() => onSuggestTime(meeting.id))}
                            disabled={isLoading}
                            className="flex-1 bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white px-4 py-2 rounded-lg font-medium transition-colors"
                        >
                            {isLoading ? 'Processing...' : '🔄 Suggest Time'}
                        </button>
                    </div>
                )}
            </div>

            {/* Meeting Details */}
            <div className="p-6 space-y-6">
                {/* Participants */}
                <div>
                    <h3 className="text-sm font-medium text-gray-700 mb-2">Participants</h3>
                    <div className="space-y-2">
                        {meeting.participants.map((participant, index) => (
                            <div key={index} className="flex items-center space-x-3 p-3 bg-gray-50 rounded-lg">
                                <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
                                    <span className="text-blue-600 text-sm font-medium">
                                        {participant.charAt(0).toUpperCase()}
                                    </span>
                                </div>
                                <span className="text-gray-900">{participant}</span>
                            </div>
                        ))}
                    </div>
                </div>

                {/* Location/Virtual Link */}
                {(meeting.location || meeting.virtualLink) && (
                    <div>
                        <h3 className="text-sm font-medium text-gray-700 mb-2">Location</h3>
                        <div className="p-3 bg-gray-50 rounded-lg">
                            {meeting.location && (
                                <div className="flex items-center space-x-2 mb-2">
                                    <span>📍</span>
                                    <span className="text-gray-900">{meeting.location}</span>
                                </div>
                            )}
                            {meeting.virtualLink && (
                                <div className="flex items-center space-x-2">
                                    <span>🔗</span>
                                    <a
                                        href={meeting.virtualLink}
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        className="text-blue-600 hover:text-blue-700 underline"
                                    >
                                        Join Virtual Meeting
                                    </a>
                                </div>
                            )}
                        </div>
                    </div>
                )}

                {/* Request Reason (if pending) */}
                {meeting.status === 'pending' && meeting.requestReason && (
                    <div>
                        <h3 className="text-sm font-medium text-gray-700 mb-2">Request Reason</h3>
                        <div className="p-3 bg-yellow-50 rounded-lg border border-yellow-200">
                            <p className="text-gray-900">{meeting.requestReason}</p>
                        </div>
                    </div>
                )}

                {/* Notes */}
                {meeting.notes && (
                    <div>
                        <h3 className="text-sm font-medium text-gray-700 mb-2">Notes</h3>
                        <div className="p-3 bg-gray-50 rounded-lg">
                            <p className="text-gray-900">{meeting.notes}</p>
                        </div>
                    </div>
                )}

                {/* Message Button */}
                <div className="pt-4 border-t border-gray-200">
                    <button
                        onClick={() => handleAction(() => onMessage(meeting.id))}
                        disabled={isLoading}
                        className="w-full bg-indigo-600 hover:bg-indigo-700 disabled:bg-indigo-400 text-white px-4 py-2 rounded-lg font-medium transition-colors"
                    >
                        {isLoading ? 'Processing...' : '📩 Message Participants'}
                    </button>
                </div>
            </div>
        </div>
    )
} 