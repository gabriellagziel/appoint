"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { AlertTriangle, Ban, CheckCircle, Eye, Shield, TrendingUp } from "lucide-react"
import { useState } from "react"

// Mock security data
const mockSecurityEvents = [
    {
        id: 1,
        type: "suspicious_login",
        severity: "medium",
        user: "john@example.com",
        description: "Multiple failed login attempts from unknown IP",
        timestamp: "2024-01-20 14:30",
        status: "investigating",
        location: "192.168.1.100"
    },
    {
        id: 2,
        type: "spam_detected",
        severity: "high",
        user: "spammer@fake.com",
        description: "Mass message sending detected",
        timestamp: "2024-01-20 13:15",
        status: "blocked",
        location: "10.0.0.50"
    },
    {
        id: 3,
        type: "data_breach_attempt",
        severity: "critical",
        user: "admin@system.com",
        description: "Unauthorized access attempt to admin panel",
        timestamp: "2024-01-20 12:45",
        status: "resolved",
        location: "203.0.113.0"
    }
]

const mockAbuseReports = [
    {
        id: 1,
        reporter: "user123@example.com",
        reportedUser: "abuser@spam.com",
        reason: "Harassment",
        description: "Sending inappropriate messages",
        timestamp: "2024-01-20 15:30",
        status: "pending",
        priority: "high"
    },
    {
        id: 2,
        reporter: "business@company.com",
        reportedUser: "fake@scam.com",
        reason: "Fraud",
        description: "Attempting to scam users",
        timestamp: "2024-01-20 14:20",
        status: "investigating",
        priority: "critical"
    }
]

export default function SecurityPage() {
    const [selectedSeverity, setSelectedSeverity] = useState("all")
    const [selectedStatus, setSelectedStatus] = useState("all")

    const filteredEvents = mockSecurityEvents.filter(event => {
        if (selectedSeverity !== "all" && event.severity !== selectedSeverity) return false
        if (selectedStatus !== "all" && event.status !== selectedStatus) return false
        return true
    })

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Security & Abuse Monitoring</h1>
                    <p className="text-gray-600">Monitor security threats and handle abuse reports</p>
                </div>

                {/* Security Stats */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Threats</CardTitle>
                            <AlertTriangle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">12</div>
                            <div className="flex items-center text-xs text-red-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +3 from yesterday
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Blocked Users</CardTitle>
                            <Ban className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">89</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +5 this week
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Abuse Reports</CardTitle>
                            <Shield className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">23</div>
                            <div className="flex items-center text-xs text-orange-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +7 from last week
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Resolved Issues</CardTitle>
                            <CheckCircle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">156</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +12 this month
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Security Events */}
                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                            <CardTitle>Security Events</CardTitle>
                            <div className="flex space-x-2">
                                <Select value={selectedSeverity} onValueChange={setSelectedSeverity}>
                                    <SelectTrigger className="w-32">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Severity</SelectItem>
                                        <SelectItem value="low">Low</SelectItem>
                                        <SelectItem value="medium">Medium</SelectItem>
                                        <SelectItem value="high">High</SelectItem>
                                        <SelectItem value="critical">Critical</SelectItem>
                                    </SelectContent>
                                </Select>
                                <Select value={selectedStatus} onValueChange={setSelectedStatus}>
                                    <SelectTrigger className="w-32">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Status</SelectItem>
                                        <SelectItem value="investigating">Investigating</SelectItem>
                                        <SelectItem value="resolved">Resolved</SelectItem>
                                        <SelectItem value="blocked">Blocked</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                        </div>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Type</TableHead>
                                    <TableHead>Severity</TableHead>
                                    <TableHead>User</TableHead>
                                    <TableHead>Description</TableHead>
                                    <TableHead>Location</TableHead>
                                    <TableHead>Timestamp</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredEvents.map((event) => (
                                    <TableRow key={event.id}>
                                        <TableCell className="font-medium">{event.type.replace('_', ' ')}</TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                event.severity === "critical" ? "destructive" :
                                                    event.severity === "high" ? "default" :
                                                        event.severity === "medium" ? "secondary" : "outline"
                                            }>
                                                {event.severity}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{event.user}</TableCell>
                                        <TableCell>{event.description}</TableCell>
                                        <TableCell>{event.location}</TableCell>
                                        <TableCell>{event.timestamp}</TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                event.status === "resolved" ? "default" :
                                                    event.status === "investigating" ? "secondary" : "destructive"
                                            }>
                                                {event.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <button className="text-sm text-blue-600 hover:text-blue-800">Investigate</button>
                                                <button className="text-sm text-red-600 hover:text-red-800">Block</button>
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Abuse Reports */}
                <Card>
                    <CardHeader>
                        <CardTitle>Abuse Reports</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Reporter</TableHead>
                                    <TableHead>Reported User</TableHead>
                                    <TableHead>Reason</TableHead>
                                    <TableHead>Description</TableHead>
                                    <TableHead>Priority</TableHead>
                                    <TableHead>Timestamp</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {mockAbuseReports.map((report) => (
                                    <TableRow key={report.id}>
                                        <TableCell className="font-medium">{report.reporter}</TableCell>
                                        <TableCell>{report.reportedUser}</TableCell>
                                        <TableCell>{report.reason}</TableCell>
                                        <TableCell>{report.description}</TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                report.priority === "critical" ? "destructive" :
                                                    report.priority === "high" ? "default" : "secondary"
                                            }>
                                                {report.priority}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{report.timestamp}</TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                report.status === "resolved" ? "default" :
                                                    report.status === "investigating" ? "secondary" : "outline"
                                            }>
                                                {report.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <button className="text-sm text-blue-600 hover:text-blue-800">Review</button>
                                                <button className="text-sm text-red-600 hover:text-red-800">Ban</button>
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Security Dashboard */}
                <Card>
                    <CardHeader>
                        <CardTitle>Security Dashboard</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div className="space-y-4">
                                <h3 className="font-semibold">Threat Types</h3>
                                <div className="space-y-2">
                                    <div className="flex justify-between">
                                        <span>Login Attempts</span>
                                        <span className="font-medium">45%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Spam/Abuse</span>
                                        <span className="font-medium">32%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Data Breach</span>
                                        <span className="font-medium">18%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Other</span>
                                        <span className="font-medium">5%</span>
                                    </div>
                                </div>
                            </div>

                            <div className="space-y-4">
                                <h3 className="font-semibold">Geographic Threats</h3>
                                <div className="space-y-2">
                                    <div className="flex justify-between">
                                        <span>North America</span>
                                        <span className="font-medium">38%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Europe</span>
                                        <span className="font-medium">29%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Asia</span>
                                        <span className="font-medium">25%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Other</span>
                                        <span className="font-medium">8%</span>
                                    </div>
                                </div>
                            </div>

                            <div className="space-y-4">
                                <h3 className="font-semibold">Response Times</h3>
                                <div className="space-y-2">
                                    <div className="flex justify-between">
                                        <span>Critical Issues</span>
                                        <span className="font-medium">2.3 min</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>High Priority</span>
                                        <span className="font-medium">15.7 min</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Medium Priority</span>
                                        <span className="font-medium">1.2 hours</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Low Priority</span>
                                        <span className="font-medium">4.5 hours</span>
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
                                    <Eye className="h-6 w-6 mx-auto mb-2" />
                                    <div>Monitor Activity</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Ban className="h-6 w-6 mx-auto mb-2" />
                                    <div>Block User</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Shield className="h-6 w-6 mx-auto mb-2" />
                                    <div>Security Scan</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <AlertTriangle className="h-6 w-6 mx-auto mb-2" />
                                    <div>Report Issue</div>
                                </div>
                            </Button>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
} 