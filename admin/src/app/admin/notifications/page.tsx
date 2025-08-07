"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Bell, MessageSquare, Search, Users } from "lucide-react"
import { useState } from "react"

// Mock notification data
const mockNotifications = [
    {
        id: 1,
        type: "push",
        title: "New appointment confirmed",
        message: "Your appointment with Downtown Dental has been confirmed for tomorrow at 10:00 AM.",
        recipient: "user123",
        status: "sent",
        timestamp: "2024-01-15 14:30",
        read: true
    },
    {
        id: 2,
        type: "email",
        title: "Payment received",
        message: "Payment of $150.00 has been received for your dental appointment.",
        recipient: "user456",
        status: "delivered",
        timestamp: "2024-01-15 13:45",
        read: false
    },
    {
        id: 3,
        type: "sms",
        title: "Appointment reminder",
        message: "Reminder: You have an appointment tomorrow at 2:30 PM with City Spa.",
        recipient: "user789",
        status: "failed",
        timestamp: "2024-01-15 12:20",
        read: false
    },
    {
        id: 4,
        type: "push",
        title: "Service update",
        message: "We've added new features to help you manage your appointments better.",
        recipient: "user101",
        status: "sent",
        timestamp: "2024-01-15 11:15",
        read: true
    },
    {
        id: 5,
        type: "email",
        title: "Welcome to App-Oint",
        message: "Welcome to App-Oint! We're excited to help you manage your appointments.",
        recipient: "user202",
        status: "delivered",
        timestamp: "2024-01-15 10:00",
        read: false
    }
]

export default function NotificationsPage() {
    const [filterType, setFilterType] = useState("all")
    const [filterStatus, setFilterStatus] = useState("all")
    const [searchTerm, setSearchTerm] = useState("")

    const getStatusColor = (status: string) => {
        switch (status) {
            case "sent": return "default"
            case "delivered": return "default"
            case "failed": return "destructive"
            case "pending": return "secondary"
            default: return "default"
        }
    }

    const getTypeIcon = (type: string) => {
        switch (type) {
            case "push": return <Bell className="h-4 w-4" />
            case "email": return <MessageSquare className="h-4 w-4" />
            case "sms": return <MessageSquare className="h-4 w-4" />
            default: return <Bell className="h-4 w-4" />
        }
    }

    const filteredNotifications = mockNotifications.filter(notification => {
        if (filterType !== "all" && notification.type !== filterType) return false
        if (filterStatus !== "all" && notification.status !== filterStatus) return false
        if (searchTerm && !notification.title.toLowerCase().includes(searchTerm.toLowerCase()) &&
            !notification.message.toLowerCase().includes(searchTerm.toLowerCase())) return false
        return true
    })

    const handleResend = (notificationId: number) => {
        console.log(`Resending notification ${notificationId}`)
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Notification Management</h1>
                    <p className="text-gray-600">Monitor and manage all user notifications</p>
                </div>

                {/* Stats */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Notifications</CardTitle>
                            <Bell className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{mockNotifications.length}</div>
                            <p className="text-xs text-gray-500">This month</p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Delivered</CardTitle>
                            <MessageSquare className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">
                                {mockNotifications.filter(n => n.status === "delivered").length}
                            </div>
                            <p className="text-xs text-gray-500">Successfully delivered</p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Failed</CardTitle>
                            <Bell className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">
                                {mockNotifications.filter(n => n.status === "failed").length}
                            </div>
                            <p className="text-xs text-gray-500">Delivery failed</p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Read Rate</CardTitle>
                            <Users className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">
                                {Math.round((mockNotifications.filter(n => n.read).length / mockNotifications.length) * 100)}%
                            </div>
                            <p className="text-xs text-gray-500">User engagement</p>
                        </CardContent>
                    </Card>
                </div>

                {/* Filters */}
                <Card>
                    <CardHeader>
                        <CardTitle>Filters</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="flex gap-4">
                            <div className="flex-1">
                                <label className="text-sm font-medium">Type</label>
                                <Select value={filterType} onValueChange={setFilterType}>
                                    <SelectTrigger>
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Types</SelectItem>
                                        <SelectItem value="push">Push Notifications</SelectItem>
                                        <SelectItem value="email">Email</SelectItem>
                                        <SelectItem value="sms">SMS</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                            <div className="flex-1">
                                <label className="text-sm font-medium">Status</label>
                                <Select value={filterStatus} onValueChange={setFilterStatus}>
                                    <SelectTrigger>
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Status</SelectItem>
                                        <SelectItem value="sent">Sent</SelectItem>
                                        <SelectItem value="delivered">Delivered</SelectItem>
                                        <SelectItem value="failed">Failed</SelectItem>
                                        <SelectItem value="pending">Pending</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                            <div className="flex-1">
                                <label className="text-sm font-medium">Search</label>
                                <div className="relative">
                                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                                    <Input
                                        placeholder="Search notifications..."
                                        value={searchTerm}
                                        onChange={(e) => setSearchTerm(e.target.value)}
                                        className="pl-10"
                                    />
                                </div>
                            </div>
                        </div>
                    </CardContent>
                </Card>

                {/* Notifications Table */}
                <Card>
                    <CardHeader>
                        <CardTitle>Notifications</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>ID</TableHead>
                                    <TableHead>Type</TableHead>
                                    <TableHead>Title</TableHead>
                                    <TableHead>Recipient</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Read</TableHead>
                                    <TableHead>Timestamp</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredNotifications.map((notification) => (
                                    <TableRow key={notification.id}>
                                        <TableCell className="font-medium">#{notification.id}</TableCell>
                                        <TableCell>
                                            <div className="flex items-center gap-2">
                                                {getTypeIcon(notification.type)}
                                                <span className="capitalize">{notification.type}</span>
                                            </div>
                                        </TableCell>
                                        <TableCell>
                                            <div className="font-medium">{notification.title}</div>
                                            <div className="text-sm text-gray-500 max-w-xs truncate">
                                                {notification.message}
                                            </div>
                                        </TableCell>
                                        <TableCell>{notification.recipient}</TableCell>
                                        <TableCell>
                                            <Badge variant={getStatusColor(notification.status)}>
                                                {notification.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>
                                            <Badge variant={notification.read ? "default" : "secondary"}>
                                                {notification.read ? "Read" : "Unread"}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{notification.timestamp}</TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                {notification.status === "failed" && (
                                                    <Button
                                                        variant="outline"
                                                        size="sm"
                                                        onClick={() => handleResend(notification.id)}
                                                    >
                                                        Resend
                                                    </Button>
                                                )}
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
} 