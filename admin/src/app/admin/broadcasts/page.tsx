"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Textarea } from "@/components/ui/textarea"
import { Bell, Calendar, Megaphone, Send, Users } from "lucide-react"
import { useState } from "react"

// Mock broadcast data
const mockBroadcasts = [
  {
    id: 1,
    title: "System Maintenance Notice",
    type: "notification",
    status: "sent",
    recipients: 1247,
    sentAt: "2024-01-15 10:30",
    content: "Scheduled maintenance will occur on January 20th from 2-4 AM EST."
  },
  {
    id: 2,
    title: "New Feature Announcement",
    type: "announcement",
    status: "scheduled",
    recipients: 0,
    sentAt: "2024-01-18 09:00",
    content: "We're excited to announce our new AI-powered scheduling features!"
  },
  {
    id: 3,
    title: "Security Update",
    type: "alert",
    status: "draft",
    recipients: 0,
    sentAt: null,
    content: "Important security updates have been applied to your account."
  },
  {
    id: 4,
    title: "Holiday Schedule",
    type: "notification",
    status: "sent",
    recipients: 892,
    sentAt: "2024-01-10 14:15",
    content: "Our support team will have limited hours during the holiday season."
  }
]

const broadcastTypes = [
  { value: "notification", label: "Notification" },
  { value: "announcement", label: "Announcement" },
  { value: "alert", label: "Alert" },
  { value: "update", label: "Update" }
]

const recipientGroups = [
  { value: "all", label: "All Users" },
  { value: "active", label: "Active Users" },
  { value: "premium", label: "Premium Users" },
  { value: "enterprise", label: "Enterprise Users" }
]

export default function BroadcastsPage() {
  const [selectedType, setSelectedType] = useState("notification")
  const [selectedRecipients, setSelectedRecipients] = useState("all")
  const [broadcastTitle, setBroadcastTitle] = useState("")
  const [broadcastContent, setBroadcastContent] = useState("")

  const getStatusColor = (status: string) => {
    switch (status) {
      case "sent": return "default"
      case "scheduled": return "secondary"
      case "draft": return "outline"
      default: return "default"
    }
  }

  const getTypeIcon = (type: string) => {
    switch (type) {
      case "notification": return <Bell className="h-4 w-4" />
      case "announcement": return <Megaphone className="h-4 w-4" />
      case "alert": return <Bell className="h-4 w-4" />
      default: return <Bell className="h-4 w-4" />
    }
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Broadcasts</h1>
          <p className="text-gray-600">Send notifications and announcements to users</p>
        </div>

        {/* Create New Broadcast */}
        <Card>
          <CardHeader>
            <CardTitle>Create New Broadcast</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="broadcast-type">Broadcast Type</Label>
                <select
                  id="broadcast-type"
                  value={selectedType}
                  onChange={(e) => setSelectedType(e.target.value)}
                  className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                >
                  {broadcastTypes.map((type) => (
                    <option key={type.value} value={type.value}>
                      {type.label}
                    </option>
                  ))}
                </select>
              </div>

              <div className="space-y-2">
                <Label htmlFor="recipients">Recipients</Label>
                <select
                  id="recipients"
                  value={selectedRecipients}
                  onChange={(e) => setSelectedRecipients(e.target.value)}
                  className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                >
                  {recipientGroups.map((group) => (
                    <option key={group.value} value={group.value}>
                      {group.label}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="broadcast-title">Title</Label>
              <Input
                id="broadcast-title"
                placeholder="Enter broadcast title"
                value={broadcastTitle}
                onChange={(e) => setBroadcastTitle(e.target.value)}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="broadcast-content">Content</Label>
              <Textarea
                id="broadcast-content"
                placeholder="Enter broadcast content"
                value={broadcastContent}
                onChange={(e) => setBroadcastContent(e.target.value)}
                rows={4}
              />
            </div>

            <div className="flex gap-2">
              <Button>
                <Send className="h-4 w-4 mr-2" />
                Send Now
              </Button>
              <Button variant="outline">
                <Calendar className="h-4 w-4 mr-2" />
                Schedule
              </Button>
              <Button variant="outline">
                Save Draft
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Broadcast History */}
        <Card>
          <CardHeader>
            <CardTitle>Broadcast History</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Title</TableHead>
                  <TableHead>Type</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Recipients</TableHead>
                  <TableHead>Sent At</TableHead>
                  <TableHead>Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {mockBroadcasts.map((broadcast) => (
                  <TableRow key={broadcast.id}>
                    <TableCell className="font-medium">{broadcast.title}</TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        {getTypeIcon(broadcast.type)}
                        <Badge variant="outline">{broadcast.type}</Badge>
                      </div>
                    </TableCell>
                    <TableCell>
                      <Badge variant={getStatusColor(broadcast.status)}>
                        {broadcast.status}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-1">
                        <Users className="h-4 w-4" />
                        {broadcast.recipients}
                      </div>
                    </TableCell>
                    <TableCell>
                      {broadcast.sentAt ? broadcast.sentAt : "Not sent"}
                    </TableCell>
                    <TableCell>
                      <div className="flex space-x-2">
                        <Button variant="outline" size="sm">
                          View
                        </Button>
                        <Button variant="outline" size="sm">
                          Edit
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        {/* Broadcast Stats */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total Broadcasts</CardTitle>
              <Megaphone className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">24</div>
              <p className="text-xs text-muted-foreground">
                +12% from last month
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Sent Today</CardTitle>
              <Send className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">3</div>
              <p className="text-xs text-muted-foreground">
                +1 from yesterday
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total Recipients</CardTitle>
              <Users className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">2,139</div>
              <p className="text-xs text-muted-foreground">
                Across all broadcasts
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Open Rate</CardTitle>
              <Bell className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">78.5%</div>
              <p className="text-xs text-muted-foreground">
                Average open rate
              </p>
            </CardContent>
          </Card>
        </div>
      </div>
    </AdminLayout>
  )
} 