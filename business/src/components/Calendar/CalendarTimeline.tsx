'use client'

import { useEffect, useState } from 'react'

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
}

interface CalendarTimelineProps {
    meetings: Meeting[]
    onMeetingSelect: (meeting: Meeting) => void
    selectedMeetingId?: string
    onTimeSlotClick?: (time: string) => void
}

export default function CalendarTimeline({ meetings, onMeetingSelect, selectedMeetingId, onTimeSlotClick }: CalendarTimelineProps) {
    const [currentTime, setCurrentTime] = useState(new Date())
    const [viewMode, setViewMode] = useState<'daily' | 'weekly' | 'monthly'>('daily')

    // Update current time every minute
    useEffect(() => {
        const interval = setInterval(() => {
            setCurrentTime(new Date())
        }, 60000) // Update every minute

        return () => clearInterval(interval)
    }, [])

    // Generate hourly slots from 8 AM to 10 PM
    const generateTimeSlots = () => {
        const slots = []
        for (let hour = 8; hour <= 22; hour++) {
            slots.push({
                hour,
                time: `${hour.toString().padStart(2, '0')}:00`,
                meetings: meetings.filter(meeting => {
                    const meetingHour = parseInt(meeting.startTime.split(':')[0])
                    return meetingHour === hour
                })
            })
        }
        return slots
    }

    const timeSlots = generateTimeSlots()
    const currentHour = currentTime.getHours()

    const getStatusColor = (status: string) => {
        switch (status) {
            case 'confirmed':
                return 'bg-green-100 border-green-300 text-green-800'
            case 'pending':
                return 'bg-yellow-100 border-yellow-300 text-yellow-800'
            case 'canceled':
                return 'bg-red-100 border-red-300 text-red-800'
            default:
                return 'bg-gray-100 border-gray-300 text-gray-800'
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
        <div className="h-full bg-white rounded-lg shadow-sm border border-gray-200">
            {/* Header */}
            <div className="p-4 border-b border-gray-200">
                <div className="flex items-center justify-between">
                    <div>
                        <h2 className="text-lg font-semibold text-gray-900">Today's Schedule</h2>
                        <p className="text-sm text-gray-500">
                            {currentTime.toLocaleDateString('en-US', {
                                weekday: 'long',
                                year: 'numeric',
                                month: 'long',
                                day: 'numeric'
                            })}
                        </p>
                    </div>
                    <div className="flex items-center space-x-2">
                        <select
                            value={viewMode}
                            onChange={(e) => setViewMode(e.target.value as 'daily' | 'weekly' | 'monthly')}
                            className="text-sm border border-gray-300 rounded-md px-3 py-1 focus:outline-none focus:ring-2 focus:ring-blue-500"
                            aria-label="Calendar view mode"
                        >
                            <option value="daily">Daily</option>
                            <option value="weekly">Weekly</option>
                            <option value="monthly">Monthly</option>
                        </select>
                        <div className="text-sm text-gray-500">
                            {currentTime.toLocaleTimeString('en-US', {
                                hour: '2-digit',
                                minute: '2-digit'
                            })}
                        </div>
                    </div>
                </div>
            </div>

            {/* Timeline */}
            <div className="overflow-y-auto h-[calc(100vh-200px)]">
                <div className="relative">
                    {/* Current time indicator */}
                    <div
                        className="absolute left-0 right-0 z-10 pointer-events-none"
                        style={{
                            top: `${((currentHour - 8) * 60 + currentTime.getMinutes()) * 0.8}px`
                        }}
                    >
                        <div className="flex items-center">
                            <div className="w-2 h-2 bg-red-500 rounded-full mr-2"></div>
                            <div className="flex-1 h-0.5 bg-red-500"></div>
                        </div>
                    </div>

                    {/* Time slots */}
                    {timeSlots.map((slot) => (
                        <div key={slot.hour} className="relative">
                            {/* Time label */}
                            <div className="sticky top-0 bg-white z-20 px-4 py-2 border-b border-gray-100">
                                <div className="flex items-center justify-between">
                                    <span className="text-sm font-medium text-gray-700">
                                        {slot.time}
                                    </span>
                                    {slot.hour === currentHour && (
                                        <span className="text-xs text-red-600 font-medium">NOW</span>
                                    )}
                                </div>
                            </div>

                            {/* Meetings for this hour */}
                            <div className="px-4 py-2 min-h-[60px]">
                                {slot.meetings.length === 0 ? (
                                    <div
                                        onClick={() => onTimeSlotClick?.(slot.time)}
                                        className="text-xs text-gray-400 italic cursor-pointer hover:text-blue-600 hover:bg-blue-50 p-2 rounded transition-colors"
                                    >
                                        Click to add appointment at {slot.time}
                                    </div>
                                ) : (
                                    slot.meetings.map((meeting) => (
                                        <div
                                            key={meeting.id}
                                            onClick={() => onMeetingSelect(meeting)}
                                            className={`mb-2 p-3 rounded-lg border cursor-pointer transition-all duration-200 hover:shadow-md ${selectedMeetingId === meeting.id
                                                ? 'ring-2 ring-blue-500 shadow-md'
                                                : ''
                                                } ${getStatusColor(meeting.status)}`}
                                        >
                                            <div className="flex items-start justify-between">
                                                <div className="flex-1">
                                                    <div className="flex items-center space-x-2 mb-1">
                                                        <span className="text-sm">
                                                            {getStatusIcon(meeting.status)}
                                                        </span>
                                                        <h3 className="text-sm font-medium">
                                                            {meeting.title}
                                                        </h3>
                                                    </div>
                                                    <div className="text-xs opacity-75">
                                                        {meeting.startTime} - {meeting.endTime}
                                                    </div>
                                                    {meeting.participants.length > 0 && (
                                                        <div className="text-xs opacity-75 mt-1">
                                                            👥 {meeting.participants.join(', ')}
                                                        </div>
                                                    )}
                                                </div>
                                                <div className="text-xs opacity-75">
                                                    {meeting.status}
                                                </div>
                                            </div>
                                        </div>
                                    ))
                                )}
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    )
} 