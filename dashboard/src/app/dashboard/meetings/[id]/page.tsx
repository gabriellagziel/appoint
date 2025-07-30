'use client'

import { useState, useEffect } from 'react'
import { useParams } from 'next/navigation'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Separator } from "@/components/ui/separator"
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { Slider } from "@/components/ui/slider"
import { 
  Calendar, 
  Clock, 
  MapPin, 
  Users, 
  MessageCircle, 
  Navigation, 
  Share, 
  CheckCircle, 
  XCircle, 
  AlertCircle,
  UserCheck,
  Phone,
  Mail,
  MoreHorizontal
} from 'lucide-react'

interface MeetingDetails {
  id: string
  title: string
  description: string
  scheduledAt: string
  endTime: string
  type: 'oneOnOne' | 'group' | 'event'
  participants: MeetingParticipant[]
  location?: {
    latitude: number
    longitude: number
    address?: string
  }
  chatId?: string
  customForms: CustomForm[]
  isLocationTrackingEnabled: boolean
  reminderMinutes: number
}

interface MeetingParticipant {
  userId: string
  email: string
  displayName: string
  status: 'pending' | 'confirmed' | 'declined' | 'late' | 'arrived'
  role: 'host' | 'coHost' | 'participant'
  isRunningLate: boolean
  lateReason?: string
  estimatedArrival?: string
  avatarUrl?: string
}

interface CustomForm {
  id: string
  title: string
  description: string
  type: 'rsvp' | 'poll' | 'survey' | 'preferences'
  isRequired: boolean
}

export default function MeetingDetailsPage() {
  const params = useParams()
  const meetingId = params.id as string
  
  const [meeting, setMeeting] = useState<MeetingDetails | null>(null)
  const [loading, setLoading] = useState(true)
  const [currentUser] = useState({ id: 'user-1', name: 'John Doe' }) // Mock current user
  const [isLateDialogOpen, setIsLateDialogOpen] = useState(false)
  const [lateReason, setLateReason] = useState('')
  const [delayMinutes, setDelayMinutes] = useState([15])

  useEffect(() => {
    // Mock data - in real app, fetch from API
    const mockMeeting: MeetingDetails = {
      id: meetingId,
      title: 'Product Strategy Review',
      description: 'Quarterly review of product roadmap and upcoming features. We\'ll discuss Q4 priorities and resource allocation.',
      scheduledAt: '2024-01-15T14:00:00Z',
      endTime: '2024-01-15T15:30:00Z',
      type: 'group',
      participants: [
        {
          userId: 'user-1',
          email: 'john.doe@company.com',
          displayName: 'John Doe',
          status: 'confirmed',
          role: 'host',
          isRunningLate: false,
          avatarUrl: undefined
        },
        {
          userId: 'user-2',
          email: 'jane.smith@company.com',
          displayName: 'Jane Smith',
          status: 'confirmed',
          role: 'participant',
          isRunningLate: false,
          avatarUrl: undefined
        },
        {
          userId: 'user-3',
          email: 'mike.johnson@company.com',
          displayName: 'Mike Johnson',
          status: 'late',
          role: 'participant',
          isRunningLate: true,
          lateReason: 'Traffic jam on highway',
          estimatedArrival: '2024-01-15T14:15:00Z',
          avatarUrl: undefined
        },
        {
          userId: 'user-4',
          email: 'sarah.wilson@company.com',
          displayName: 'Sarah Wilson',
          status: 'pending',
          role: 'participant',
          isRunningLate: false,
          avatarUrl: undefined
        }
      ],
      location: {
        latitude: 37.7749,
        longitude: -122.4194,
        address: 'Conference Room A, 123 Business St, San Francisco, CA'
      },
      chatId: 'chat-123',
      customForms: [
        {
          id: 'form-1',
          title: 'Pre-meeting Survey',
          description: 'Please share your priorities for this meeting',
          type: 'survey',
          isRequired: false
        }
      ],
      isLocationTrackingEnabled: true,
      reminderMinutes: 60
    }

    setTimeout(() => {
      setMeeting(mockMeeting)
      setLoading(false)
    }, 1000)
  }, [meetingId])

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900"></div>
      </div>
    )
  }

  if (!meeting) {
    return (
      <div className="text-center py-8">
        <h2 className="text-xl font-semibold">Meeting not found</h2>
        <p className="text-gray-600 mt-2">The meeting you're looking for doesn't exist.</p>
      </div>
    )
  }

  const currentParticipant = meeting.participants.find(p => p.userId === currentUser.id)
  const isUpcoming = new Date(meeting.scheduledAt) > new Date()
  const isActive = new Date() >= new Date(meeting.scheduledAt) && new Date() <= new Date(meeting.endTime)
  const isCompleted = new Date() > new Date(meeting.endTime)

  const getMeetingStatusBadge = () => {
    if (isCompleted) return <Badge variant="secondary">Completed</Badge>
    if (isActive) return <Badge className="bg-green-500">Live</Badge>
    if (isUpcoming) return <Badge className="bg-blue-500">Upcoming</Badge>
    return <Badge variant="outline">Past</Badge>
  }

  const getParticipantStatusIcon = (participant: MeetingParticipant) => {
    switch (participant.status) {
      case 'confirmed':
        return participant.isRunningLate ? 
          <AlertCircle className="h-4 w-4 text-orange-500" /> : 
          <CheckCircle className="h-4 w-4 text-green-500" />
      case 'declined':
        return <XCircle className="h-4 w-4 text-red-500" />
      case 'late':
        return <AlertCircle className="h-4 w-4 text-orange-500" />
      case 'arrived':
        return <UserCheck className="h-4 w-4 text-green-600" />
      default:
        return <Clock className="h-4 w-4 text-gray-400" />
    }
  }

  const getParticipantStatusText = (participant: MeetingParticipant) => {
    if (participant.isRunningLate) return 'Running late'
    switch (participant.status) {
      case 'confirmed': return 'Confirmed'
      case 'declined': return 'Declined'
      case 'late': return 'Running late'
      case 'arrived': return 'Arrived'
      default: return 'Pending'
    }
  }

  const handleStatusChange = async (status: string) => {
    // Mock API call
    console.log(`Updating status to: ${status}`)
    if (currentParticipant) {
      currentParticipant.status = status as any
      setMeeting({...meeting})
    }
  }

  const handleMarkAsLate = async () => {
    // Mock API call
    console.log(`Marking as late: ${lateReason}, ${delayMinutes[0]} minutes`)
    if (currentParticipant) {
      currentParticipant.status = 'late'
      currentParticipant.isRunningLate = true
      currentParticipant.lateReason = lateReason
      setMeeting({...meeting})
    }
    setIsLateDialogOpen(false)
    setLateReason('')
    setDelayMinutes([15])
  }

  const openDirections = () => {
    if (meeting.location) {
      const url = `https://www.google.com/maps/dir/?api=1&destination=${meeting.location.latitude},${meeting.location.longitude}`
      window.open(url, '_blank')
    }
  }

  const formatDateTime = (dateTime: string) => {
    const date = new Date(dateTime)
    return date.toLocaleDateString() + ' at ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
  }

  const formatDuration = () => {
    const start = new Date(meeting.scheduledAt)
    const end = new Date(meeting.endTime)
    const duration = (end.getTime() - start.getTime()) / (1000 * 60) // minutes
    const hours = Math.floor(duration / 60)
    const minutes = duration % 60
    return hours > 0 ? `${hours}h ${minutes}m` : `${minutes}m`
  }

  return (
    <div className="container mx-auto p-6 max-w-6xl">
      {/* Header */}
      <div className="flex items-start justify-between mb-6">
        <div>
          <div className="flex items-center gap-3 mb-2">
            <h1 className="text-3xl font-bold">{meeting.title}</h1>
            {getMeetingStatusBadge()}
          </div>
          <p className="text-gray-600 max-w-2xl">{meeting.description}</p>
        </div>
        <div className="flex gap-2">
          {meeting.chatId && (
            <Button variant="outline" size="sm">
              <MessageCircle className="h-4 w-4 mr-2" />
              Chat
            </Button>
          )}
          <Button variant="outline" size="sm">
            <Share className="h-4 w-4 mr-2" />
            Share
          </Button>
          <Button variant="outline" size="sm">
            <MoreHorizontal className="h-4 w-4" />
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main Content */}
        <div className="lg:col-span-2">
          <Tabs defaultValue="details" className="w-full">
            <TabsList className="grid w-full grid-cols-4">
              <TabsTrigger value="details">Details</TabsTrigger>
              <TabsTrigger value="participants">Participants</TabsTrigger>
              {meeting.location && <TabsTrigger value="location">Location</TabsTrigger>}
              {meeting.customForms.length > 0 && <TabsTrigger value="forms">Forms</TabsTrigger>}
            </TabsList>

            <TabsContent value="details" className="space-y-6">
              {/* Meeting Info */}
              <Card>
                <CardHeader>
                  <CardTitle>Meeting Information</CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="flex items-center gap-3">
                    <Calendar className="h-5 w-5 text-gray-500" />
                    <div>
                      <p className="font-medium">Date & Time</p>
                      <p className="text-sm text-gray-600">{formatDateTime(meeting.scheduledAt)} - {formatDateTime(meeting.endTime)}</p>
                    </div>
                  </div>
                  <Separator />
                  <div className="flex items-center gap-3">
                    <Clock className="h-5 w-5 text-gray-500" />
                    <div>
                      <p className="font-medium">Duration</p>
                      <p className="text-sm text-gray-600">{formatDuration()}</p>
                    </div>
                  </div>
                  <Separator />
                  <div className="flex items-center gap-3">
                    <Users className="h-5 w-5 text-gray-500" />
                    <div>
                      <p className="font-medium">Participants</p>
                      <p className="text-sm text-gray-600">{meeting.participants.length} people</p>
                    </div>
                  </div>
                  {meeting.location && (
                    <>
                      <Separator />
                      <div className="flex items-center gap-3">
                        <MapPin className="h-5 w-5 text-gray-500" />
                        <div className="flex-1">
                          <p className="font-medium">Location</p>
                          <p className="text-sm text-gray-600">{meeting.location.address}</p>
                        </div>
                        <Button variant="outline" size="sm" onClick={openDirections}>
                          <Navigation className="h-4 w-4 mr-2" />
                          Directions
                        </Button>
                      </div>
                    </>
                  )}
                </CardContent>
              </Card>

              {/* Participants Summary for Group Meetings */}
              {meeting.type !== 'oneOnOne' && (
                <Card>
                  <CardHeader>
                    <CardTitle>Participant Status</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="flex gap-8">
                      <div className="text-center">
                        <div className="text-2xl font-bold text-green-600">
                          {meeting.participants.filter(p => p.status === 'confirmed').length}
                        </div>
                        <div className="text-sm text-gray-600">Confirmed</div>
                      </div>
                      <div className="text-center">
                        <div className="text-2xl font-bold text-orange-600">
                          {meeting.participants.filter(p => p.isRunningLate).length}
                        </div>
                        <div className="text-sm text-gray-600">Late</div>
                      </div>
                      <div className="text-center">
                        <div className="text-2xl font-bold text-gray-600">
                          {meeting.participants.filter(p => p.status === 'pending').length}
                        </div>
                        <div className="text-sm text-gray-600">Pending</div>
                      </div>
                      <div className="text-center">
                        <div className="text-2xl font-bold text-red-600">
                          {meeting.participants.filter(p => p.status === 'declined').length}
                        </div>
                        <div className="text-sm text-gray-600">Declined</div>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              )}
            </TabsContent>

            <TabsContent value="participants" className="space-y-4">
              {meeting.participants.map((participant) => (
                <Card key={participant.userId}>
                  <CardContent className="p-4">
                    <div className="flex items-center gap-4">
                      <Avatar>
                        <AvatarImage src={participant.avatarUrl} />
                        <AvatarFallback>{participant.displayName[0]}</AvatarFallback>
                      </Avatar>
                      <div className="flex-1">
                        <div className="flex items-center gap-2">
                          <h3 className="font-medium">{participant.displayName}</h3>
                          {participant.userId === currentUser.id && (
                            <Badge variant="outline" className="text-xs">You</Badge>
                          )}
                          {participant.role === 'host' && (
                            <Badge className="text-xs bg-orange-500">Host</Badge>
                          )}
                          {participant.role === 'coHost' && (
                            <Badge className="text-xs bg-blue-500">Co-Host</Badge>
                          )}
                        </div>
                        <div className="flex items-center gap-2 text-sm text-gray-600">
                          <Mail className="h-3 w-3" />
                          {participant.email}
                        </div>
                        <div className="flex items-center gap-2 mt-1">
                          {getParticipantStatusIcon(participant)}
                          <span className="text-sm">{getParticipantStatusText(participant)}</span>
                        </div>
                        {participant.isRunningLate && participant.lateReason && (
                          <p className="text-xs text-orange-600 mt-1">
                            Reason: {participant.lateReason}
                          </p>
                        )}
                        {participant.estimatedArrival && (
                          <p className="text-xs text-gray-500 mt-1">
                            ETA: {formatDateTime(participant.estimatedArrival)}
                          </p>
                        )}
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </TabsContent>

            {meeting.location && (
              <TabsContent value="location">
                <Card>
                  <CardHeader>
                    <CardTitle>Meeting Location</CardTitle>
                    <CardDescription>{meeting.location.address}</CardDescription>
                  </CardHeader>
                  <CardContent>
                    <div className="bg-gray-100 h-64 rounded-lg flex items-center justify-center mb-4">
                      {/* In a real app, integrate with Google Maps */}
                      <div className="text-center">
                        <MapPin className="h-8 w-8 mx-auto mb-2 text-gray-500" />
                        <p className="text-sm text-gray-600">Interactive map would be here</p>
                        <p className="text-xs text-gray-500 mt-1">
                          {meeting.location.latitude}, {meeting.location.longitude}
                        </p>
                      </div>
                    </div>
                    <Button onClick={openDirections} className="w-full">
                      <Navigation className="h-4 w-4 mr-2" />
                      Get Directions
                    </Button>
                  </CardContent>
                </Card>
              </TabsContent>
            )}

            {meeting.customForms.length > 0 && (
              <TabsContent value="forms" className="space-y-4">
                {meeting.customForms.map((form) => (
                  <Card key={form.id}>
                    <CardHeader>
                      <div className="flex items-center justify-between">
                        <div>
                          <CardTitle className="text-lg">{form.title}</CardTitle>
                          <CardDescription>{form.description}</CardDescription>
                        </div>
                        {form.isRequired && (
                          <Badge variant="destructive">Required</Badge>
                        )}
                      </div>
                    </CardHeader>
                    <CardContent>
                      <Button>Fill Form</Button>
                    </CardContent>
                  </Card>
                ))}
              </TabsContent>
            )}
          </Tabs>
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          {/* Your Status */}
          {currentParticipant && (
            <Card>
              <CardHeader>
                <CardTitle>Your Status</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-center gap-2">
                  {getParticipantStatusIcon(currentParticipant)}
                  <span>{getParticipantStatusText(currentParticipant)}</span>
                </div>
                
                {currentParticipant.isRunningLate && (
                  <div className="p-3 bg-orange-50 rounded-lg">
                    <p className="text-sm text-orange-800">
                      You're marked as running late
                    </p>
                    {currentParticipant.lateReason && (
                      <p className="text-xs text-orange-600 mt-1">
                        Reason: {currentParticipant.lateReason}
                      </p>
                    )}
                  </div>
                )}

                {!isCompleted && (
                  <div className="space-y-2">
                    {currentParticipant.status === 'pending' && (
                      <>
                        <Button 
                          className="w-full" 
                          onClick={() => handleStatusChange('confirmed')}
                        >
                          <CheckCircle className="h-4 w-4 mr-2" />
                          Confirm Attendance
                        </Button>
                        <Button 
                          variant="outline" 
                          className="w-full"
                          onClick={() => handleStatusChange('declined')}
                        >
                          <XCircle className="h-4 w-4 mr-2" />
                          Decline
                        </Button>
                      </>
                    )}
                    
                    {currentParticipant.status === 'confirmed' && !currentParticipant.isRunningLate && (
                      <Dialog open={isLateDialogOpen} onOpenChange={setIsLateDialogOpen}>
                        <DialogTrigger asChild>
                          <Button variant="outline" className="w-full">
                            <AlertCircle className="h-4 w-4 mr-2" />
                            I'm Running Late
                          </Button>
                        </DialogTrigger>
                        <DialogContent>
                          <DialogHeader>
                            <DialogTitle>Update Your Status</DialogTitle>
                            <DialogDescription>
                              Let other participants know you're running late
                            </DialogDescription>
                          </DialogHeader>
                          <div className="space-y-4">
                            <div>
                              <Label htmlFor="reason">Reason (optional)</Label>
                              <Textarea
                                id="reason"
                                placeholder="Traffic, delayed train, etc."
                                value={lateReason}
                                onChange={(e) => setLateReason(e.target.value)}
                              />
                            </div>
                            <div>
                              <Label>Expected delay: {delayMinutes[0]} minutes</Label>
                              <Slider
                                value={delayMinutes}
                                onValueChange={setDelayMinutes}
                                max={60}
                                min={5}
                                step={5}
                                className="mt-2"
                              />
                            </div>
                          </div>
                          <DialogFooter>
                            <Button variant="outline" onClick={() => setIsLateDialogOpen(false)}>
                              Cancel
                            </Button>
                            <Button onClick={handleMarkAsLate}>
                              Notify Participants
                            </Button>
                          </DialogFooter>
                        </DialogContent>
                      </Dialog>
                    )}
                    
                    {currentParticipant.isRunningLate && isUpcoming && (
                      <Button 
                        className="w-full" 
                        onClick={() => handleStatusChange('arrived')}
                      >
                        <UserCheck className="h-4 w-4 mr-2" />
                        I've Arrived
                      </Button>
                    )}
                  </div>
                )}
              </CardContent>
            </Card>
          )}

          {/* Quick Actions */}
          <Card>
            <CardHeader>
              <CardTitle>Quick Actions</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              {meeting.chatId && (
                <Button variant="outline" className="w-full justify-start">
                  <MessageCircle className="h-4 w-4 mr-2" />
                  Open Chat
                </Button>
              )}
              {meeting.location && (
                <Button variant="outline" className="w-full justify-start" onClick={openDirections}>
                  <Navigation className="h-4 w-4 mr-2" />
                  Get Directions
                </Button>
              )}
              <Button variant="outline" className="w-full justify-start">
                <Calendar className="h-4 w-4 mr-2" />
                Add to Calendar
              </Button>
              <Button variant="outline" className="w-full justify-start">
                <Share className="h-4 w-4 mr-2" />
                Share Meeting
              </Button>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}