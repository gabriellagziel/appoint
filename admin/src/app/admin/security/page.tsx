"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import {
    blockUser,
    fetchAbuseReports,
    fetchSecurityEvents,
    getSecurityStats,
    updateAbuseReportStatus,
    updateSecurityEventStatus,
    type AbuseReport,
    type SecurityEvent,
    type SecurityFilters
} from "@/services/security_service"
import { AlertTriangle, CheckCircle, Eye, Filter, RefreshCw, Shield, TrendingUp } from "lucide-react"
import { useEffect, useState } from "react"

export default function SecurityPage() {
    const [events, setEvents] = useState<SecurityEvent[]>([])
    const [reports, setReports] = useState<AbuseReport[]>([])
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState("")
    const [stats, setStats] = useState({
        totalEvents: 0,
        activeThreats: 0,
        resolvedEvents: 0,
        criticalEvents: 0,
        totalReports: 0,
        pendingReports: 0,
        resolvedReports: 0,
    })
    const [filters, setFilters] = useState<SecurityFilters>({
        severity: "all",
        status: "all",
        type: "all",
        search: "",
    })

    const fetchData = async () => {
        setLoading(true)
        setError("")
        try {
            const [eventsResponse, reportsData, statsData] = await Promise.all([
                fetchSecurityEvents(filters),
                fetchAbuseReports(filters),
                getSecurityStats(),
            ])
            setEvents(eventsResponse.events)
            setReports(reportsData)
            setStats(statsData)
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to fetch security data")
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        fetchData()
    }, [filters])

    const handleEventStatusUpdate = async (eventId: string, newStatus: string) => {
        try {
            await updateSecurityEventStatus(eventId, newStatus)
            await fetchData() // Refresh data
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to update event status")
        }
    }

    const handleReportStatusUpdate = async (reportId: string, newStatus: string, adminNotes?: string) => {
        try {
            await updateAbuseReportStatus(reportId, newStatus, adminNotes)
            await fetchData() // Refresh data
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to update report status")
        }
    }

    const handleBlockUser = async (userId: string, reason: string) => {
        if (!confirm(`Are you sure you want to block user ${userId}?`)) return

        try {
            await blockUser(userId, reason)
            await fetchData() // Refresh data
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to block user")
        }
    }

    const getSeverityColor = (severity: string) => {
        switch (severity) {
            case "critical": return "destructive"
            case "high": return "destructive"
            case "medium": return "secondary"
            case "low": return "default"
            default: return "default"
        }
    }

    const getStatusColor = (status: string) => {
        switch (status) {
            case "resolved": return "default"
            case "investigating": return "secondary"
            case "blocked": return "destructive"
            case "false_positive": return "outline"
            default: return "default"
        }
    }

    if (loading && events.length === 0 && reports.length === 0) {
        return (
            <AdminLayout>
                <div className="space-y-6">
                    <div>
                        <h1 className="text-3xl font-bold text-gray-900">Security & Abuse Monitoring</h1>
                        <p className="text-gray-600">Monitor security threats and handle abuse reports</p>
                    </div>
                    <div className="flex items-center justify-center h-64">
                        <div className="text-center">
                            <RefreshCw className="h-8 w-8 animate-spin text-blue-500 mx-auto mb-4" />
                            <p className="text-gray-600">Loading security data...</p>
                        </div>
                    </div>
                </div>
            </AdminLayout>
        )
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div className="flex items-center justify-between">
                    <div>
                        <h1 className="text-3xl font-bold text-gray-900">Security & Abuse Monitoring</h1>
                        <p className="text-gray-600">Monitor security threats and handle abuse reports</p>
                    </div>
                    <Button onClick={fetchData} disabled={loading}>
                        <RefreshCw className={`h-4 w-4 mr-2 ${loading ? 'animate-spin' : ''}`} />
                        Refresh
                    </Button>
                </div>

                {error && (
                    <Card className="border-red-200 bg-red-50">
                        <CardContent className="pt-6">
                            <p className="text-red-600">{error}</p>
                        </CardContent>
                    </Card>
                )}

                {/* Filters */}
                <Card>
                    <CardHeader>
                        <CardTitle className="flex items-center gap-2">
                            <Filter className="h-5 w-5" />
                            Filters
                        </CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <div>
                                <label className="text-sm font-medium">Search</label>
                                <input
                                    type="text"
                                    placeholder="Search events/reports..."
                                    value={filters.search || ""}
                                    onChange={(e) => setFilters({ ...filters, search: e.target.value })}
                                    className="mt-1 w-full px-3 py-2 border border-gray-300 rounded-md"
                                />
                            </div>
                            <div>
                                <label className="text-sm font-medium">Severity</label>
                                <Select
                                    value={filters.severity || "all"}
                                    onValueChange={(value) => setFilters({ ...filters, severity: value })}
                                >
                                    <SelectTrigger className="mt-1">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Severity</SelectItem>
                                        <SelectItem value="critical">Critical</SelectItem>
                                        <SelectItem value="high">High</SelectItem>
                                        <SelectItem value="medium">Medium</SelectItem>
                                        <SelectItem value="low">Low</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                            <div>
                                <label className="text-sm font-medium">Status</label>
                                <Select
                                    value={filters.status || "all"}
                                    onValueChange={(value) => setFilters({ ...filters, status: value })}
                                >
                                    <SelectTrigger className="mt-1">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Status</SelectItem>
                                        <SelectItem value="investigating">Investigating</SelectItem>
                                        <SelectItem value="resolved">Resolved</SelectItem>
                                        <SelectItem value="blocked">Blocked</SelectItem>
                                        <SelectItem value="false_positive">False Positive</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                            <div>
                                <label className="text-sm font-medium">Type</label>
                                <Select
                                    value={filters.type || "all"}
                                    onValueChange={(value) => setFilters({ ...filters, type: value })}
                                >
                                    <SelectTrigger className="mt-1">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Types</SelectItem>
                                        <SelectItem value="suspicious_login">Suspicious Login</SelectItem>
                                        <SelectItem value="spam_detected">Spam Detected</SelectItem>
                                        <SelectItem value="data_breach_attempt">Data Breach Attempt</SelectItem>
                                        <SelectItem value="unauthorized_access">Unauthorized Access</SelectItem>
                                        <SelectItem value="rate_limit_exceeded">Rate Limit Exceeded</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                        </div>
                    </CardContent>
                </Card>

                {/* Security Stats */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Threats</CardTitle>
                            <AlertTriangle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.activeThreats}</div>
                            <div className="flex items-center text-xs text-red-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +3 from yesterday
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Critical Events</CardTitle>
                            <Shield className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.criticalEvents}</div>
                            <div className="flex items-center text-xs text-red-600">
                                <AlertTriangle className="h-3 w-3 mr-1" />
                                Requires immediate attention
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Resolved Events</CardTitle>
                            <CheckCircle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.resolvedEvents}</div>
                            <div className="flex items-center text-xs text-green-600">
                                <CheckCircle className="h-3 w-3 mr-1" />
                                Successfully handled
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Reports</CardTitle>
                            <Eye className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.totalReports}</div>
                            <div className="flex items-center text-xs text-gray-600">
                                {stats.pendingReports} pending review
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Security Events */}
                <Card>
                    <CardHeader>
                        <CardTitle>Security Events ({events.length})</CardTitle>
                    </CardHeader>
                    <CardContent>
                        {events.length === 0 ? (
                            <div className="text-center py-8">
                                <p className="text-gray-500">No security events found</p>
                            </div>
                        ) : (
                            <Table>
                                <TableHeader>
                                    <TableRow>
                                        <TableHead>Type</TableHead>
                                        <TableHead>User</TableHead>
                                        <TableHead>Description</TableHead>
                                        <TableHead>Severity</TableHead>
                                        <TableHead>Status</TableHead>
                                        <TableHead>Location</TableHead>
                                        <TableHead>Timestamp</TableHead>
                                        <TableHead>Actions</TableHead>
                                    </TableRow>
                                </TableHeader>
                                <TableBody>
                                    {events.map((event) => (
                                        <TableRow key={event.id}>
                                            <TableCell className="font-medium">{event.type.replace('_', ' ')}</TableCell>
                                            <TableCell>{event.user}</TableCell>
                                            <TableCell>{event.description}</TableCell>
                                            <TableCell>
                                                <Badge variant={getSeverityColor(event.severity)}>
                                                    {event.severity}
                                                </Badge>
                                            </TableCell>
                                            <TableCell>
                                                <Select
                                                    value={event.status}
                                                    onValueChange={(value) => handleEventStatusUpdate(event.id, value)}
                                                >
                                                    <SelectTrigger className="w-24">
                                                        <SelectValue />
                                                    </SelectTrigger>
                                                    <SelectContent>
                                                        <SelectItem value="investigating">Investigating</SelectItem>
                                                        <SelectItem value="resolved">Resolved</SelectItem>
                                                        <SelectItem value="blocked">Blocked</SelectItem>
                                                        <SelectItem value="false_positive">False Positive</SelectItem>
                                                    </SelectContent>
                                                </Select>
                                            </TableCell>
                                            <TableCell>{event.location}</TableCell>
                                            <TableCell>
                                                {event.timestamp.toLocaleDateString()}
                                            </TableCell>
                                            <TableCell>
                                                <div className="flex space-x-2">
                                                    <Button
                                                        variant="outline"
                                                        size="sm"
                                                        onClick={() => handleBlockUser(event.user, event.description)}
                                                    >
                                                        Block User
                                                    </Button>
                                                </div>
                                            </TableCell>
                                        </TableRow>
                                    ))}
                                </TableBody>
                            </Table>
                        )}
                    </CardContent>
                </Card>

                {/* Abuse Reports */}
                <Card>
                    <CardHeader>
                        <CardTitle>Abuse Reports ({reports.length})</CardTitle>
                    </CardHeader>
                    <CardContent>
                        {reports.length === 0 ? (
                            <div className="text-center py-8">
                                <p className="text-gray-500">No abuse reports found</p>
                            </div>
                        ) : (
                            <Table>
                                <TableHeader>
                                    <TableRow>
                                        <TableHead>Reporter</TableHead>
                                        <TableHead>Reported User</TableHead>
                                        <TableHead>Reason</TableHead>
                                        <TableHead>Description</TableHead>
                                        <TableHead>Priority</TableHead>
                                        <TableHead>Status</TableHead>
                                        <TableHead>Timestamp</TableHead>
                                        <TableHead>Actions</TableHead>
                                    </TableRow>
                                </TableHeader>
                                <TableBody>
                                    {reports.map((report) => (
                                        <TableRow key={report.id}>
                                            <TableCell>{report.reporter}</TableCell>
                                            <TableCell>{report.reportedUser}</TableCell>
                                            <TableCell className="capitalize">{report.reason.replace('_', ' ')}</TableCell>
                                            <TableCell>{report.description}</TableCell>
                                            <TableCell>
                                                <Badge variant={getSeverityColor(report.priority)}>
                                                    {report.priority}
                                                </Badge>
                                            </TableCell>
                                            <TableCell>
                                                <Select
                                                    value={report.status}
                                                    onValueChange={(value) => handleReportStatusUpdate(report.id, value)}
                                                >
                                                    <SelectTrigger className="w-24">
                                                        <SelectValue />
                                                    </SelectTrigger>
                                                    <SelectContent>
                                                        <SelectItem value="pending">Pending</SelectItem>
                                                        <SelectItem value="investigating">Investigating</SelectItem>
                                                        <SelectItem value="resolved">Resolved</SelectItem>
                                                        <SelectItem value="dismissed">Dismissed</SelectItem>
                                                    </SelectContent>
                                                </Select>
                                            </TableCell>
                                            <TableCell>
                                                {report.timestamp.toLocaleDateString()}
                                            </TableCell>
                                            <TableCell>
                                                <div className="flex space-x-2">
                                                    <Button
                                                        variant="outline"
                                                        size="sm"
                                                        onClick={() => handleBlockUser(report.reportedUser, report.description)}
                                                    >
                                                        Block User
                                                    </Button>
                                                </div>
                                            </TableCell>
                                        </TableRow>
                                    ))}
                                </TableBody>
                            </Table>
                        )}
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
} 