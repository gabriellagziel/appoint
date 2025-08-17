'use client'

import CalendarTimeline from '@/components/calendar/CalendarTimeline'
import MeetingDetailPanel from '@/components/calendar/MeetingDetailPanel'
import MessagingPanel from '@/components/calendar/MessagingPanel'
import NewAppointmentModal from '@/components/calendar/NewAppointmentModal'
import RequestSidebar from '@/components/calendar/RequestSidebar'
import { useAuth } from '@/contexts/AuthContext'
import { signOutUser } from '@/services/auth_service'
import { useRouter } from 'next/navigation'
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
    requestReason?: string
}

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

interface Message {
    id: string
    from: string
    to: string
    content: string
    timestamp: string
    type: 'inbox' | 'outbox'
}

export default function LiveCalendarDashboard() {
    const { user, loading, isAuthenticated } = useAuth()
    const router = useRouter()

    // State management
    const [meetings, setMeetings] = useState<Meeting[]>([])
    const [requests, setRequests] = useState<MeetingRequest[]>([])
    const [messages, setMessages] = useState<Message[]>([])
    const [selectedMeeting, setSelectedMeeting] = useState<Meeting | null>(null)
    const [isMessagingOpen, setIsMessagingOpen] = useState(false)
    const [isAppointmentModalOpen, setIsAppointmentModalOpen] = useState(false)
    const [prefillTime, setPrefillTime] = useState<{ date: string; time: string } | undefined>()
    const [dataLoading, setDataLoading] = useState(true)

    useEffect(() => {
        if (!loading && !isAuthenticated) {
            router.push('/login')
        }
    }, [loading, isAuthenticated, router])

    useEffect(() => {
        if (isAuthenticated) {
            loadDashboardData()
        }
    }, [isAuthenticated])

    const loadDashboardData = async () => {
        setDataLoading(true)
        try {
            // Simulate API calls with mock data
            await new Promise(resolve => setTimeout(resolve, 1000))

            // Mock meetings data
            const mockMeetings: Meeting[] = [
                {
                    id: '1',
                    title: 'Client Consultation - John Smith',
                    startTime: '09:00',
                    endTime: '10:00',
                    participants: ['John Smith', 'Sarah Johnson'],
                    status: 'confirmed',
                    location: 'Conference Room A',
                    notes: 'Initial consultation for new project requirements'
                },
                {
                    id: '2',
                    title: 'Team Standup',
                    startTime: '11:00',
                    endTime: '11:30',
                    participants: ['Team Lead', 'Developer 1', 'Developer 2'],
                    status: 'confirmed',
                    virtualLink: 'https://meet.google.com/abc-defg-hij',
                    notes: 'Daily standup meeting'
                },
                {
                    id: '3',
                    title: 'Project Review - Marketing Campaign',
                    startTime: '14:00',
                    endTime: '15:30',
                    participants: ['Marketing Manager', 'Designer'],
                    status: 'pending',
                    location: 'Meeting Room B',
                    requestReason: 'Need to discuss new campaign strategy and budget allocation'
                },
                {
                    id: '4',
                    title: 'Sales Call - ABC Corp',
                    startTime: '16:00',
                    endTime: '17:00',
                    participants: ['Sales Rep', 'ABC Corp Contact'],
                    status: 'confirmed',
                    virtualLink: 'https://zoom.us/j/123456789',
                    notes: 'Product demo and pricing discussion'
                }
            ]

            // Mock requests data
            const mockRequests: MeetingRequest[] = [
                {
                    id: 'req1',
                    title: 'Product Demo Request',
                    requestedTime: '13:00',
                    requestedDate: '2024-08-05',
                    fromUser: {
                        name: 'Alice Johnson',
                        email: 'alice@example.com'
                    },
                    reason: 'Interested in learning more about your premium features',
                    status: 'pending',
                    createdAt: '2024-08-05T10:30:00Z'
                },
                {
                    id: 'req2',
                    title: 'Consultation Call',
                    requestedTime: '15:00',
                    requestedDate: '2024-08-05',
                    fromUser: {
                        name: 'Bob Wilson',
                        email: 'bob@example.com'
                    },
                    reason: 'Need technical consultation for implementation',
                    status: 'pending',
                    createdAt: '2024-08-05T11:15:00Z'
                }
            ]

            // Mock messages data
            const mockMessages: Message[] = [
                {
                    id: 'msg1',
                    from: 'john@example.com',
                    to: 'business@app-oint.com',
                    content: 'Hi, I need to reschedule our meeting to tomorrow. Is that possible?',
                    timestamp: '2024-08-05T09:30:00Z',
                    type: 'inbox'
                },
                {
                    id: 'msg2',
                    from: 'business@app-oint.com',
                    to: 'sarah@example.com',
                    content: 'Sure, I can accommodate that. What time works for you?',
                    timestamp: '2024-08-05T10:15:00Z',
                    type: 'outbox'
                }
            ]

            setMeetings(mockMeetings)
            setRequests(mockRequests)
            setMessages(mockMessages)
        } catch (error) {
            console.error('Failed to load dashboard data:', error)
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

    const handleMeetingSelect = (meeting: Meeting) => {
        setSelectedMeeting(meeting)
    }

    const handleAcceptMeeting = (meetingId: string) => {
        setMeetings(prev => prev.map(meeting =>
            meeting.id === meetingId
                ? { ...meeting, status: 'confirmed' as const }
                : meeting
        ))
        setSelectedMeeting(prev => prev?.id === meetingId ? { ...prev, status: 'confirmed' } : prev)
    }

    const handleDeclineMeeting = (meetingId: string) => {
        setMeetings(prev => prev.map(meeting =>
            meeting.id === meetingId
                ? { ...meeting, status: 'canceled' as const }
                : meeting
        ))
        setSelectedMeeting(prev => prev?.id === meetingId ? { ...prev, status: 'canceled' } : prev)
    }

    const handleSuggestTime = (meetingId: string) => {
        // Implementation for suggesting new time
        console.log('Suggest new time for meeting:', meetingId)
    }

    const handleMessage = (meetingId: string) => {
        setIsMessagingOpen(true)
    }

    const handleAcceptRequest = (requestId: string) => {
        setRequests(prev => prev.map(req =>
            req.id === requestId
                ? { ...req, status: 'accepted' as const }
                : req
        ))
    }

    const handleDeclineRequest = (requestId: string) => {
        setRequests(prev => prev.map(req =>
            req.id === requestId
                ? { ...req, status: 'declined' as const }
                : req
        ))
    }

    const handleSuggestRequestTime = (requestId: string) => {
        // Implementation for suggesting time for request
        console.log('Suggest time for request:', requestId)
    }

    const handleSendMessage = async (to: string, content: string) => {
        const newMessage: Message = {
            id: Date.now().toString(),
            from: 'You',
            to,
            content,
            timestamp: new Date().toISOString(),
            type: 'outbox'
        }
        setMessages(prev => [...prev, newMessage])
    }

    const handleAppointmentCreated = (newAppointment: any) => {
        // Add the new appointment to the meetings list
        setMeetings(prev => [...prev, newAppointment])

        // Show success message (you can implement toast here)
        console.log('Appointment created and added to calendar:', newAppointment)
    }

    const handleTimeSlotClick = (time: string) => {
        const today = new Date().toISOString().split('T')[0]
        setPrefillTime({ date: today, time })
        setIsAppointmentModalOpen(true)
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
                                    Live Calendar Dashboard
                                </h1>
                                <p className="text-sm text-gray-500">
                                    Real-time meeting management
                                </p>
                            </div>
                        </div>
                        <div className="flex items-center space-x-4">
                            <button
                                onClick={() => {
                                    setPrefillTime(undefined)
                                    setIsAppointmentModalOpen(true)
                                }}
                                className="px-4 py-2 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 rounded-lg transition-colors"
                            >
                                + Create Appointment
                            </button>
                            <button
                                onClick={() => setIsMessagingOpen(true)}
                                className="px-4 py-2 text-sm font-medium text-blue-600 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 rounded-lg transition-colors"
                            >
                                📩 Messages
                            </button>
                            <button
                                onClick={() => router.push('/dashboard')}
                                className="px-4 py-2 text-sm font-medium text-gray-600 hover:text-gray-700 bg-gray-50 hover:bg-gray-100 rounded-lg transition-colors"
                            >
                                📊 Overview
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
            <main className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                {dataLoading ? (
                    <div className="flex items-center justify-center h-96">
                        <div className="text-center">
                            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                            <p className="mt-4 text-gray-600">Loading calendar data...</p>
                        </div>
                    </div>
                ) : (
                    <div className="grid grid-cols-1 lg:grid-cols-4 gap-6 h-[calc(100vh-200px)]">
                        {/* Left Panel - Calendar Timeline */}
                        <div className="lg:col-span-2">
                            <CalendarTimeline
                                meetings={meetings}
                                onMeetingSelect={handleMeetingSelect}
                                selectedMeetingId={selectedMeeting?.id}
                                onTimeSlotClick={handleTimeSlotClick}
                            />
                        </div>

                        {/* Right Panel - Meeting Details */}
                        <div className="lg:col-span-1">
                            <MeetingDetailPanel
                                meeting={selectedMeeting}
                                onAccept={handleAcceptMeeting}
                                onDecline={handleDeclineMeeting}
                                onSuggestTime={handleSuggestTime}
                                onMessage={handleMessage}
                            />
                        </div>

                        {/* Right Sidebar - Requests */}
                        <div className="lg:col-span-1">
                            <RequestSidebar
                                requests={requests}
                                onAccept={handleAcceptRequest}
                                onDecline={handleDeclineRequest}
                                onSuggestTime={handleSuggestRequestTime}
                            />
                        </div>
                    </div>
                )}
            </main>

            {/* Messaging Panel */}
            <MessagingPanel
                messages={messages}
                onSendMessage={handleSendMessage}
                onClose={() => setIsMessagingOpen(false)}
                isOpen={isMessagingOpen}
            />

            {/* Appointment Creation Modal */}
            <NewAppointmentModal
                isOpen={isAppointmentModalOpen}
                onClose={() => setIsAppointmentModalOpen(false)}
                onAppointmentCreated={handleAppointmentCreated}
                prefillTime={prefillTime}
            />
        </div>
    )
} 