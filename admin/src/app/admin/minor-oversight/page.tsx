"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { AlertTriangle, CheckCircle, Clock, Eye, Shield, Users } from "lucide-react"
import { useState } from "react"

// Mock minor oversight data
const mockMinorUsers = [
    {
        id: 1,
        name: "Alex Johnson",
        age: 15,
        parent: "Sarah Johnson",
        parentEmail: "sarah@example.com",
        status: "active",
        restrictions: "time_limit, content_filter",
        lastActivity: "2024-01-20 16:30",
        totalTime: "2h 15m"
    },
    {
        id: 2,
        name: "Emma Davis",
        age: 14,
        parent: "Michael Davis",
        parentEmail: "michael@example.com",
        status: "suspended",
        restrictions: "full_restriction",
        lastActivity: "2024-01-19 10:15",
        totalTime: "0h 0m"
    }
]

const mockParentalRequests = [
    {
        id: 1,
        parent: "Sarah Johnson",
        child: "Alex Johnson",
        requestType: "time_extension",
        status: "pending",
        requestedAt: "2024-01-20 14:30",
        reason: "School project deadline"
    },
    {
        id: 2,
        parent: "Michael Davis",
        child: "Emma Davis",
        requestType: "account_reactivation",
        status: "approved",
        requestedAt: "2024-01-18 09:45",
        reason: "Behavior improved"
    }
]

export default function MinorOversightPage() {
    const [selectedStatus, setSelectedStatus] = useState("all")

    const filteredMinors = mockMinorUsers.filter(user => {
        if (selectedStatus !== "all" && user.status !== selectedStatus) return false
        return true
    })

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Minor–Adult Oversight</h1>
                    <p className="text-gray-600">Manage parental controls and minor user protection</p>
                </div>

                {/* Oversight Stats */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Minor Users</CardTitle>
                            <Users className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">247</div>
                            <div className="flex items-center text-xs text-green-600">
                                <CheckCircle className="h-3 w-3 mr-1" />
                                All protected
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Restrictions</CardTitle>
                            <Shield className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">189</div>
                            <div className="flex items-center text-xs text-blue-600">
                                <Shield className="h-3 w-3 mr-1" />
                                76% of minors
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Pending Requests</CardTitle>
                            <Clock className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">12</div>
                            <div className="flex items-center text-xs text-orange-600">
                                <AlertTriangle className="h-3 w-3 mr-1" />
                                Requires review
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Safety Alerts</CardTitle>
                            <AlertTriangle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">3</div>
                            <div className="flex items-center text-xs text-red-600">
                                <AlertTriangle className="h-3 w-3 mr-1" />
                                This week
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Minor Users */}
                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                            <CardTitle>Minor Users</CardTitle>
                            <div className="flex space-x-2">
                                <Select value={selectedStatus} onValueChange={setSelectedStatus}>
                                    <SelectTrigger className="w-32">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Status</SelectItem>
                                        <SelectItem value="active">Active</SelectItem>
                                        <SelectItem value="suspended">Suspended</SelectItem>
                                        <SelectItem value="restricted">Restricted</SelectItem>
                                    </SelectContent>
                                </Select>
                                <Button>
                                    <Shield className="h-4 w-4 mr-2" />
                                    Add Minor User
                                </Button>
                            </div>
                        </div>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Name</TableHead>
                                    <TableHead>Age</TableHead>
                                    <TableHead>Parent</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Restrictions</TableHead>
                                    <TableHead>Last Activity</TableHead>
                                    <TableHead>Total Time</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredMinors.map((user) => (
                                    <TableRow key={user.id}>
                                        <TableCell className="font-medium">{user.name}</TableCell>
                                        <TableCell>{user.age}</TableCell>
                                        <TableCell>{user.parent}</TableCell>
                                        <TableCell>
                                            <Badge variant={user.status === "active" ? "default" : "destructive"}>
                                                {user.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>
                                            <div className="flex space-x-1">
                                                {user.restrictions.split(', ').map(restriction => (
                                                    <Badge key={restriction} variant="outline" className="text-xs">
                                                        {restriction.replace('_', ' ')}
                                                    </Badge>
                                                ))}
                                            </div>
                                        </TableCell>
                                        <TableCell>{user.lastActivity}</TableCell>
                                        <TableCell>{user.totalTime}</TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <button className="text-sm text-blue-600 hover:text-blue-800">View</button>
                                                <button className="text-sm text-orange-600 hover:text-orange-800">Edit</button>
                                                <button className="text-sm text-red-600 hover:text-red-800">Suspend</button>
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Parental Requests */}
                <Card>
                    <CardHeader>
                        <CardTitle>Parental Requests</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Parent</TableHead>
                                    <TableHead>Child</TableHead>
                                    <TableHead>Request Type</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Reason</TableHead>
                                    <TableHead>Requested At</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {mockParentalRequests.map((request) => (
                                    <TableRow key={request.id}>
                                        <TableCell className="font-medium">{request.parent}</TableCell>
                                        <TableCell>{request.child}</TableCell>
                                        <TableCell>
                                            <Badge variant="outline">{request.requestType.replace('_', ' ')}</Badge>
                                        </TableCell>
                                        <TableCell>
                                            <Badge variant={request.status === "approved" ? "default" : "secondary"}>
                                                {request.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{request.reason}</TableCell>
                                        <TableCell>{request.requestedAt}</TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <button className="text-sm text-blue-600 hover:text-blue-800">Review</button>
                                                <button className="text-sm text-green-600 hover:text-green-800">Approve</button>
                                                <button className="text-sm text-red-600 hover:text-red-800">Deny</button>
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Safety Monitoring */}
                <Card>
                    <CardHeader>
                        <CardTitle>Safety Monitoring</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div className="space-y-4">
                                <h3 className="font-semibold">Content Filtering</h3>
                                <div className="space-y-2">
                                    <div className="flex justify-between">
                                        <span>Inappropriate Content</span>
                                        <span className="font-medium">0 blocked</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Age Restrictions</span>
                                        <span className="font-medium">100% enforced</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Parental Controls</span>
                                        <span className="font-medium">Active</span>
                                    </div>
                                </div>
                            </div>

                            <div className="space-y-4">
                                <h3 className="font-semibold">Time Management</h3>
                                <div className="space-y-2">
                                    <div className="flex justify-between">
                                        <span>Daily Limits</span>
                                        <span className="font-medium">2 hours</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Bedtime Restrictions</span>
                                        <span className="font-medium">10 PM - 6 AM</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Break Reminders</span>
                                        <span className="font-medium">Every 30 min</span>
                                    </div>
                                </div>
                            </div>

                            <div className="space-y-4">
                                <h3 className="font-semibold">Safety Alerts</h3>
                                <div className="space-y-2">
                                    <div className="flex justify-between">
                                        <span>This Week</span>
                                        <span className="font-medium">3 alerts</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>This Month</span>
                                        <span className="font-medium">12 alerts</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Response Time</span>
                                        <span className="font-medium">2.3 hours</span>
                                    </div>
                                </div>
                            </div>
                        </div>
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
                                    <Shield className="h-6 w-6 mx-auto mb-2" />
                                    <div>Add Minor User</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Eye className="h-6 w-6 mx-auto mb-2" />
                                    <div>Review Requests</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <AlertTriangle className="h-6 w-6 mx-auto mb-2" />
                                    <div>Safety Alerts</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <CheckCircle className="h-6 w-6 mx-auto mb-2" />
                                    <div>Generate Report</div>
                                </div>
                            </Button>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
} 