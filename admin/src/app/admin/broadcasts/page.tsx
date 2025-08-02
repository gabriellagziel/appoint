"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Textarea } from "@/components/ui/textarea"
import { Clock, Megaphone, Send, Target, TrendingUp, Users } from "lucide-react"
import { useState } from "react"

// Mock broadcast data
const mockBroadcasts = [
    { id: 1, title: "New Feature Announcement", type: "notification", status: "sent", recipients: 1247, delivered: 1189, failed: 58, sentAt: "2024-01-15 10:30" },
    { id: 2, title: "Holiday Promotion", type: "promotion", status: "scheduled", recipients: 0, delivered: 0, failed: 0, sentAt: "2024-01-20 09:00" },
    { id: 3, title: "System Maintenance", type: "alert", status: "draft", recipients: 0, delivered: 0, failed: 0, sentAt: null },
]

export default function BroadcastsPage() {
    const [showComposeForm, setShowComposeForm] = useState(false)
    const [broadcastData, setBroadcastData] = useState({
        title: "",
        message: "",
        type: "notification",
        targetAudience: "all",
        scheduledTime: "",
    })

    const handleComposeBroadcast = () => {
        console.log("Composing broadcast:", broadcastData)
        setShowComposeForm(false)
        setBroadcastData({
            title: "",
            message: "",
            type: "notification",
            targetAudience: "all",
            scheduledTime: "",
        })
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Broadcast Management</h1>
                    <p className="text-gray-600">Send messages to mobile app and business users</p>
                </div>

                {/* Stats Cards */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Broadcasts</CardTitle>
                            <Megaphone className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">156</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +8.2% from last month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Recipients</CardTitle>
                            <Users className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">45,892</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +12.1% from last month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Delivery Rate</CardTitle>
                            <Target className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">95.8%</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +1.2% from last month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Avg Response</CardTitle>
                            <Clock className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">2.3s</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                -0.5s from last month
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Compose Broadcast */}
                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                            <CardTitle>Compose Broadcast</CardTitle>
                            <Button onClick={() => setShowComposeForm(!showComposeForm)}>
                                <Send className="h-4 w-4 mr-2" />
                                {showComposeForm ? "Cancel" : "New Broadcast"}
                            </Button>
                        </div>
                    </CardHeader>
                    {showComposeForm && (
                        <CardContent className="space-y-4">
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div className="space-y-2">
                                    <Label htmlFor="title">Title</Label>
                                    <Input
                                        id="title"
                                        value={broadcastData.title}
                                        onChange={(e) => setBroadcastData({ ...broadcastData, title: e.target.value })}
                                        placeholder="Enter broadcast title"
                                    />
                                </div>

                                <div className="space-y-2">
                                    <Label htmlFor="type">Type</Label>
                                    <Select value={broadcastData.type} onValueChange={(value) => setBroadcastData({ ...broadcastData, type: value })}>
                                        <SelectTrigger>
                                            <SelectValue />
                                        </SelectTrigger>
                                        <SelectContent>
                                            <SelectItem value="notification">Notification</SelectItem>
                                            <SelectItem value="promotion">Promotion</SelectItem>
                                            <SelectItem value="alert">Alert</SelectItem>
                                            <SelectItem value="update">Update</SelectItem>
                                        </SelectContent>
                                    </Select>
                                </div>
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="message">Message</Label>
                                <Textarea
                                    id="message"
                                    value={broadcastData.message}
                                    onChange={(e) => setBroadcastData({ ...broadcastData, message: e.target.value })}
                                    placeholder="Enter your broadcast message..."
                                    rows={4}
                                />
                            </div>

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div className="space-y-2">
                                    <Label htmlFor="targetAudience">Target Audience</Label>
                                    <Select value={broadcastData.targetAudience} onValueChange={(value) => setBroadcastData({ ...broadcastData, targetAudience: value })}>
                                        <SelectTrigger>
                                            <SelectValue />
                                        </SelectTrigger>
                                        <SelectContent>
                                            <SelectItem value="all">All Users</SelectItem>
                                            <SelectItem value="mobile">Mobile Users Only</SelectItem>
                                            <SelectItem value="business">Business Users Only</SelectItem>
                                            <SelectItem value="premium">Premium Users</SelectItem>
                                            <SelectItem value="inactive">Inactive Users</SelectItem>
                                        </SelectContent>
                                    </Select>
                                </div>

                                <div className="space-y-2">
                                    <Label htmlFor="scheduledTime">Scheduled Time (Optional)</Label>
                                    <Input
                                        id="scheduledTime"
                                        type="datetime-local"
                                        value={broadcastData.scheduledTime}
                                        onChange={(e) => setBroadcastData({ ...broadcastData, scheduledTime: e.target.value })}
                                    />
                                </div>
                            </div>

                            <div className="flex gap-2">
                                <Button onClick={handleComposeBroadcast} className="flex-1">
                                    <Send className="h-4 w-4 mr-2" />
                                    Send Broadcast
                                </Button>
                                <Button variant="outline" onClick={handleComposeBroadcast}>
                                    Schedule Broadcast
                                </Button>
                            </div>
                        </CardContent>
                    )}
                </Card>

                {/* Broadcasts Table */}
                <Card>
                    <CardHeader>
                        <CardTitle>Recent Broadcasts</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Title</TableHead>
                                    <TableHead>Type</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Recipients</TableHead>
                                    <TableHead>Delivered</TableHead>
                                    <TableHead>Failed</TableHead>
                                    <TableHead>Sent At</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {mockBroadcasts.map((broadcast) => (
                                    <TableRow key={broadcast.id}>
                                        <TableCell className="font-medium">{broadcast.title}</TableCell>
                                        <TableCell>
                                            <Badge variant={broadcast.type === "alert" ? "destructive" : "default"}>
                                                {broadcast.type}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                broadcast.status === "sent" ? "default" :
                                                    broadcast.status === "scheduled" ? "secondary" : "outline"
                                            }>
                                                {broadcast.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{broadcast.recipients.toLocaleString()}</TableCell>
                                        <TableCell>{broadcast.delivered.toLocaleString()}</TableCell>
                                        <TableCell>{broadcast.failed}</TableCell>
                                        <TableCell>{broadcast.sentAt || "Not sent"}</TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <button className="text-sm text-blue-600 hover:text-blue-800">View</button>
                                                <button className="text-sm text-orange-600 hover:text-orange-800">Edit</button>
                                                <button className="text-sm text-red-600 hover:text-red-800">Cancel</button>
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Quick Actions */}
                <Card>
                    <CardHeader>
                        <CardTitle>Quick Actions</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Megaphone className="h-6 w-6 mx-auto mb-2" />
                                    <div>Send Now</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Clock className="h-6 w-6 mx-auto mb-2" />
                                    <div>Schedule</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Target className="h-6 w-6 mx-auto mb-2" />
                                    <div>Target Users</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <TrendingUp className="h-6 w-6 mx-auto mb-2" />
                                    <div>Analytics</div>
                                </div>
                            </Button>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
} 