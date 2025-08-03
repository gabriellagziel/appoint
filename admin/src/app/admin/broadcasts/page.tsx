"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Textarea } from "@/components/ui/textarea"
import { AlertTriangle, CheckCircle, Clock, MessageSquare, Send } from "lucide-react"
import { useState } from "react"

interface Broadcast {
    id: string
    title: string
    message: string
    type: 'info' | 'warning' | 'alert' | 'success'
    target: 'all' | 'business' | 'users' | 'specific'
    status: 'draft' | 'scheduled' | 'sent' | 'failed'
    createdAt: string
    scheduledFor?: string
    sentAt?: string
    recipients: number
    opened: number
}

const mockBroadcasts: Broadcast[] = [
    {
        id: "1",
        title: "System Maintenance Notice",
        message: "Scheduled maintenance on Sunday 2-4 AM. Service may be temporarily unavailable.",
        type: "warning",
        target: "all",
        status: "sent",
        createdAt: "2024-01-15T10:00:00Z",
        sentAt: "2024-01-15T10:05:00Z",
        recipients: 15420,
        opened: 12340
    },
    {
        id: "2",
        title: "New Feature Available",
        message: "Advanced analytics dashboard is now available for all business users.",
        type: "success",
        target: "business",
        status: "scheduled",
        createdAt: "2024-01-14T15:30:00Z",
        scheduledFor: "2024-01-16T09:00:00Z",
        recipients: 0,
        opened: 0
    },
    {
        id: "3",
        title: "Security Alert",
        message: "Please update your password if you haven't done so in the last 90 days.",
        type: "alert",
        target: "users",
        status: "draft",
        createdAt: "2024-01-14T12:00:00Z",
        recipients: 0,
        opened: 0
    }
]

export default function BroadcastsPage() {
    const [broadcasts, setBroadcasts] = useState<Broadcast[]>(mockBroadcasts)
    const [newBroadcast, setNewBroadcast] = useState({
        title: "",
        message: "",
        type: "info" as const,
        target: "all" as const,
        scheduledFor: ""
    })

    const handleSendBroadcast = () => {
        const broadcast: Broadcast = {
            id: Date.now().toString(),
            title: newBroadcast.title,
            message: newBroadcast.message,
            type: newBroadcast.type,
            target: newBroadcast.target,
            status: newBroadcast.scheduledFor ? "scheduled" : "draft",
            createdAt: new Date().toISOString(),
            scheduledFor: newBroadcast.scheduledFor || undefined,
            recipients: 0,
            opened: 0
        }

        setBroadcasts([broadcast, ...broadcasts])
        setNewBroadcast({ title: "", message: "", type: "info", target: "all", scheduledFor: "" })
    }

    const getStatusIcon = (status: string) => {
        switch (status) {
            case 'sent': return <CheckCircle className="h-4 w-4 text-green-600" />
            case 'scheduled': return <Clock className="h-4 w-4 text-blue-600" />
            case 'draft': return <MessageSquare className="h-4 w-4 text-gray-600" />
            case 'failed': return <AlertTriangle className="h-4 w-4 text-red-600" />
            default: return <MessageSquare className="h-4 w-4 text-gray-600" />
        }
    }

    const getTypeBadge = (type: string) => {
        const colors = {
            info: "bg-blue-100 text-blue-800",
            warning: "bg-yellow-100 text-yellow-800",
            alert: "bg-red-100 text-red-800",
            success: "bg-green-100 text-green-800"
        }
        return <Badge className={colors[type as keyof typeof colors]}>{type}</Badge>
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Broadcasts</h1>
                    <p className="text-gray-600">Send global messages to users and businesses</p>
                </div>

                <Tabs defaultValue="compose" className="space-y-6">
                    <TabsList>
                        <TabsTrigger value="compose">Compose</TabsTrigger>
                        <TabsTrigger value="history">History</TabsTrigger>
                        <TabsTrigger value="templates">Templates</TabsTrigger>
                    </TabsList>

                    <TabsContent value="compose">
                        <Card>
                            <CardHeader>
                                <CardTitle>Compose New Broadcast</CardTitle>
                            </CardHeader>
                            <CardContent className="space-y-4">
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div className="space-y-2">
                                        <Label htmlFor="title">Title</Label>
                                        <Input
                                            id="title"
                                            value={newBroadcast.title}
                                            onChange={(e) => setNewBroadcast({ ...newBroadcast, title: e.target.value })}
                                            placeholder="Enter broadcast title"
                                        />
                                    </div>
                                    <div className="space-y-2">
                                        <Label htmlFor="type">Type</Label>
                                        <Select
                                            value={newBroadcast.type}
                                            onValueChange={(value) => setNewBroadcast({ ...newBroadcast, type: value as any })}
                                        >
                                            <SelectTrigger>
                                                <SelectValue />
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="info">Info</SelectItem>
                                                <SelectItem value="warning">Warning</SelectItem>
                                                <SelectItem value="alert">Alert</SelectItem>
                                                <SelectItem value="success">Success</SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </div>
                                </div>

                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div className="space-y-2">
                                        <Label htmlFor="target">Target Audience</Label>
                                        <Select
                                            value={newBroadcast.target}
                                            onValueChange={(value) => setNewBroadcast({ ...newBroadcast, target: value as any })}
                                        >
                                            <SelectTrigger>
                                                <SelectValue />
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="all">All Users</SelectItem>
                                                <SelectItem value="business">Business Users</SelectItem>
                                                <SelectItem value="users">Regular Users</SelectItem>
                                                <SelectItem value="specific">Specific Users</SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </div>
                                    <div className="space-y-2">
                                        <Label htmlFor="scheduledFor">Schedule (Optional)</Label>
                                        <Input
                                            id="scheduledFor"
                                            type="datetime-local"
                                            value={newBroadcast.scheduledFor}
                                            onChange={(e) => setNewBroadcast({ ...newBroadcast, scheduledFor: e.target.value })}
                                        />
                                    </div>
                                </div>

                                <div className="space-y-2">
                                    <Label htmlFor="message">Message</Label>
                                    <Textarea
                                        id="message"
                                        value={newBroadcast.message}
                                        onChange={(e) => setNewBroadcast({ ...newBroadcast, message: e.target.value })}
                                        placeholder="Enter your broadcast message..."
                                        rows={4}
                                    />
                                </div>

                                <div className="flex justify-end space-x-2">
                                    <Button variant="outline">Save Draft</Button>
                                    <Button onClick={handleSendBroadcast} disabled={!newBroadcast.title || !newBroadcast.message}>
                                        <Send className="h-4 w-4 mr-2" />
                                        Send Broadcast
                                    </Button>
                                </div>
                            </CardContent>
                        </Card>
                    </TabsContent>

                    <TabsContent value="history">
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
                                            <TableHead>Target</TableHead>
                                            <TableHead>Status</TableHead>
                                            <TableHead>Recipients</TableHead>
                                            <TableHead>Opened</TableHead>
                                            <TableHead>Date</TableHead>
                                        </TableRow>
                                    </TableHeader>
                                    <TableBody>
                                        {broadcasts.map((broadcast) => (
                                            <TableRow key={broadcast.id}>
                                                <TableCell className="font-medium">{broadcast.title}</TableCell>
                                                <TableCell>{getTypeBadge(broadcast.type)}</TableCell>
                                                <TableCell>
                                                    <Badge variant="outline">{broadcast.target}</Badge>
                                                </TableCell>
                                                <TableCell>
                                                    <div className="flex items-center space-x-2">
                                                        {getStatusIcon(broadcast.status)}
                                                        <span className="capitalize">{broadcast.status}</span>
                                                    </div>
                                                </TableCell>
                                                <TableCell>{broadcast.recipients.toLocaleString()}</TableCell>
                                                <TableCell>{broadcast.opened.toLocaleString()}</TableCell>
                                                <TableCell>
                                                    {new Date(broadcast.createdAt).toLocaleDateString()}
                                                </TableCell>
                                            </TableRow>
                                        ))}
                                    </TableBody>
                                </Table>
                            </CardContent>
                        </Card>
                    </TabsContent>

                    <TabsContent value="templates">
                        <Card>
                            <CardHeader>
                                <CardTitle>Broadcast Templates</CardTitle>
                            </CardHeader>
                            <CardContent>
                                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                    <Card>
                                        <CardHeader>
                                            <CardTitle className="text-sm">System Maintenance</CardTitle>
                                        </CardHeader>
                                        <CardContent>
                                            <p className="text-sm text-gray-600 mb-2">
                                                Notify users about scheduled maintenance
                                            </p>
                                            <Button size="sm" variant="outline">Use Template</Button>
                                        </CardContent>
                                    </Card>
                                    <Card>
                                        <CardHeader>
                                            <CardTitle className="text-sm">Feature Announcement</CardTitle>
                                        </CardHeader>
                                        <CardContent>
                                            <p className="text-sm text-gray-600 mb-2">
                                                Announce new features to users
                                            </p>
                                            <Button size="sm" variant="outline">Use Template</Button>
                                        </CardContent>
                                    </Card>
                                    <Card>
                                        <CardHeader>
                                            <CardTitle className="text-sm">Security Alert</CardTitle>
                                        </CardHeader>
                                        <CardContent>
                                            <p className="text-sm text-gray-600 mb-2">
                                                Important security notifications
                                            </p>
                                            <Button size="sm" variant="outline">Use Template</Button>
                                        </CardContent>
                                    </Card>
                                </div>
                            </CardContent>
                        </Card>
                    </TabsContent>
                </Tabs>
            </div>
        </AdminLayout>
    )
} 