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
          email: 'sarah.smith@company.com',
          displayName: 'Sarah Smith',
          status: 'confirmed',
          role: 'participant',
          isRunningLate: true,
          lateReason: 'Traffic delay',
          estimatedArrival: '2024-01-15T14:15:00Z',
          avatarUrl: undefined
        },
        {
          userId: 'user-3',
          email: 'mike.johnson@company.com',
          displayName: 'Mike Johnson',
          status: 'confirmed',
          role: 'coHost',
          isRunningLate: false,
          avatarUrl: undefined
        }
      ],
      location: {
        latitude: 37.7749,
        longitude: -122.4194,
        address: '123 Main Street, San Francisco, CA 94105'
      },
      chatId: 'chat-123',
      customForms: [
        {
          id: 'form-1',
          title: 'Meeting Preferences',
          description: 'Please indicate your preferences for the meeting format',
          type: 'survey',
          isRequired: true
        }
      ],
      isLocationTrackingEnabled: true,
      reminderMinutes: 15
    }

    setMeeting(mockMeeting)
    setLoading(false)
  }, [meetingId])

  const getMeetingStatusBadge = () => {
    const now = new Date()
    const startTime = new Date(meeting?.scheduledAt || '')
    const endTime = new Date(meeting?.endTime || '')

    if (now < startTime) {
      return <Badge className="bg-blue-500">Upcoming</Badge>
    } else if (now >= startTime && now <= endTime) {
      return <Badge className="bg-green-500">In Progress</Badge>
    } else {
      return <Badge className="bg-gray-500">Completed</Badge>
    }
  }

  const getParticipantStatusIcon = (participant: MeetingParticipant) => {
    switch (participant.status) {
      case 'confirmed':
        return <CheckCircle className="h-4 w-4 text-green-500" />
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
    switch (participant.status) {
      case 'confirmed':
        return 'Confirmed'
      case 'declined':
        return 'Declined'
      case 'late':
        return 'Running Late'
      case 'arrived':
        return 'Arrived'
      default:
        return 'Pending'
    }
  }

  const handleStatusChange = async (status: string) => {
    // In real app, update status via API
    console.log('Status changed to:', status)
  }

  const handleMarkAsLate = async () => {
    // In real app, update late status via API
    console.log('Marked as late:', { reason: lateReason, delay: delayMinutes[0] })
    setIsLateDialogOpen(false)
    setLateReason('')
    setDelayMinutes([15])
  }

  const openDirections = () => {
    if (meeting?.location) {
      const url = `https://www.google.com/maps/dir/?api=1&destination=${meeting.location.latitude},${meeting.location.longitude}`
      window.open(url, '_blank')
    }
  }

  const formatDateTime = (dateTime: string) => {
    const date = new Date(dateTime)
    return date.toLocaleDateString() + ' at ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
  }

  const formatDuration = () => {
    if (!meeting) return ''
    const start = new Date(meeting.scheduledAt)
    const end = new Date(meeting.endTime)
    const duration = (end.getTime() - start.getTime()) / (1000 * 60) // minutes
    const hours = Math.floor(duration / 60)
    const minutes = duration % 60
    return hours > 0 ? `${hours}h ${minutes}m` : `${minutes}m`
  }

  if (loading) {
    return (
      <div className="container mx-auto p-6 max-w-6xl">
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/3 mb-4"></div>
          <div className="h-4 bg-gray-200 rounded w-1/2 mb-6"></div>
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div className="lg:col-span-2">
              <div className="h-64 bg-gray-200 rounded"></div>
            </div>
            <div className="space-y-4">
              <div className="h-32 bg-gray-200 rounded"></div>
              <div className="h-32 bg-gray-200 rounded"></div>
            </div>
          </div>
        </div>
      </div>
    )
  }

  if (!meeting) {
    return (
      <div className="container mx-auto p-6 max-w-6xl">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Meeting Not Found</h1>
          <p className="text-gray-600">The meeting you're looking for doesn't exist or you don't have permission to view it.</p>
        </div>
      </div>
    )
  }

  const currentParticipant = meeting.participants.find(p => p.userId === currentUser.id)

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
            </TabsContent>

            <TabsContent value="participants" className="space-y-4">
              {meeting.participants.map((participant) => (
                <Card key={participant.userId}>
                  <CardContent className="p-4">
                    <div className="flex items-start gap-4">
                      <Avatar className="h-10 w-10">
                        <AvatarImage src={participant.avatarUrl} />
                        <AvatarFallback>{participant.displayName.charAt(0)}</AvatarFallback>
                      </Avatar>
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <span className="font-medium">{participant.displayName}</span>
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
                    <div className="mb-4">
                      <iframe
                        src={`/widgets/map-preview.html?lat=${meeting.location.latitude}&lng=${meeting.location.longitude}&zoom=15&address=${encodeURIComponent(meeting.location.address || 'Meeting location')}`}
                        width="100%"
                        height="300"
                        style={{ border: 'none', borderRadius: '8px' }}
                        title="Map Preview"
                      />
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

                <div className="space-y-2">
                  <Button 
                    variant="outline" 
                    size="sm" 
                    className="w-full"
                    onClick={() => handleStatusChange('arrived')}
                  >
                    Mark as Arrived
                  </Button>
                  
                  <Dialog open={isLateDialogOpen} onOpenChange={setIsLateDialogOpen}>
                    <DialogTrigger asChild>
                      <Button variant="outline" size="sm" className="w-full">
                        Mark as Running Late
                      </Button>
                    </DialogTrigger>
                    <DialogContent>
                      <DialogHeader>
                        <DialogTitle>Mark as Running Late</DialogTitle>
                        <DialogDescription>
                          Let others know you'll be late and provide a reason.
                        </DialogDescription>
                      </DialogHeader>
                      <div className="space-y-4">
                        <div>
                          <Label htmlFor="delay">Delay (minutes)</Label>
                          <Slider
                            id="delay"
                            value={delayMinutes}
                            onValueChange={setDelayMinutes}
                            max={60}
                            min={5}
                            step={5}
                            className="mt-2"
                          />
                          <p className="text-sm text-gray-500 mt-1">
                            {delayMinutes[0]} minutes delay
                          </p>
                        </div>
                        <div>
                          <Label htmlFor="reason">Reason (optional)</Label>
                          <Textarea
                            id="reason"
                            placeholder="e.g., Traffic, public transport delay..."
                            value={lateReason}
                            onChange={(e) => setLateReason(e.target.value)}
                            className="mt-2"
                          />
                        </div>
                      </div>
                      <DialogFooter>
                        <Button variant="outline" onClick={() => setIsLateDialogOpen(false)}>
                          Cancel
                        </Button>
                        <Button onClick={handleMarkAsLate}>
                          Mark as Late
                        </Button>
                      </DialogFooter>
                    </DialogContent>
                  </Dialog>
                </div>
              </CardContent>
            </Card>
          )}

          {/* Quick Actions */}
          <Card>
            <CardHeader>
              <CardTitle>Quick Actions</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              <Button variant="outline" size="sm" className="w-full justify-start">
                <Phone className="h-4 w-4 mr-2" />
                Call Host
              </Button>
              <Button variant="outline" size="sm" className="w-full justify-start">
                <MessageCircle className="h-4 w-4 mr-2" />
                Send Message
              </Button>
              <Button variant="outline" size="sm" className="w-full justify-start">
                <Calendar className="h-4 w-4 mr-2" />
                Reschedule
              </Button>
            </CardContent>
          </Card>

          {/* Meeting Notes */}
          <Card>
            <CardHeader>
              <CardTitle>Notes</CardTitle>
            </CardHeader>
            <CardContent>
              <Textarea 
                placeholder="Add your meeting notes here..."
                className="min-h-[100px]"
              />
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}