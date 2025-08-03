"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { AlertTriangle, CheckCircle, Clock, Eye, Flag } from "lucide-react"
import { useState } from "react"

interface Flag {
    id: string
    type: 'abuse' | 'gdpr' | 'coppa' | 'spam' | 'security'
    severity: 'low' | 'medium' | 'high' | 'critical'
    status: 'pending' | 'reviewing' | 'resolved' | 'dismissed'
    title: string
    description: string
    reportedBy: string
    reportedAt: string
    assignedTo?: string
}

const mockFlags: Flag[] = [
    {
        id: "1",
        type: "abuse",
        severity: "high",
        status: "pending",
        title: "Inappropriate content in business profile",
        description: "User reported inappropriate content in business profile ID: biz_12345",
        reportedBy: "user_67890",
        reportedAt: "2024-01-15T10:30:00Z"
    },
    {
        id: "2",
        type: "gdpr",
        severity: "critical",
        status: "reviewing",
        title: "Data deletion request",
        description: "GDPR data deletion request for user ID: user_12345",
        reportedBy: "system",
        reportedAt: "2024-01-15T09:15:00Z",
        assignedTo: "admin_001"
    },
    {
        id: "3",
        type: "coppa",
        severity: "critical",
        status: "pending",
        title: "Underage user detected",
        description: "User appears to be under 13 years old based on registration data",
        reportedBy: "system",
        reportedAt: "2024-01-15T08:45:00Z"
    }
]

export default function FlagsPage() {
    const [flags] = useState<Flag[]>(mockFlags)

    const getSeverityBadge = (severity: string) => {
        const colors = {
            critical: "bg-red-100 text-red-800",
            high: "bg-orange-100 text-orange-800",
            medium: "bg-yellow-100 text-yellow-800",
            low: "bg-blue-100 text-blue-800"
        }
        return <Badge className={colors[severity as keyof typeof colors]}>{severity}</Badge>
    }

    const getTypeBadge = (type: string) => {
        const colors = {
            abuse: "bg-red-100 text-red-800",
            gdpr: "bg-blue-100 text-blue-800",
            coppa: "bg-purple-100 text-purple-800",
            spam: "bg-yellow-100 text-yellow-800",
            security: "bg-orange-100 text-orange-800"
        }
        return <Badge className={colors[type as keyof typeof colors]}>{type.toUpperCase()}</Badge>
    }

    const getStatusBadge = (status: string) => {
        const colors = {
            pending: "bg-yellow-100 text-yellow-800",
            reviewing: "bg-blue-100 text-blue-800",
            resolved: "bg-green-100 text-green-800",
            dismissed: "bg-gray-100 text-gray-800"
        }
        return <Badge className={colors[status as keyof typeof colors]}>{status}</Badge>
    }

    const stats = {
        total: flags.length,
        pending: flags.filter(f => f.status === 'pending').length,
        reviewing: flags.filter(f => f.status === 'reviewing').length,
        resolved: flags.filter(f => f.status === 'resolved').length,
        critical: flags.filter(f => f.severity === 'critical').length
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Flags & Alerts</h1>
                    <p className="text-gray-600">Manage abuse reports, GDPR requests, and security alerts</p>
                </div>

                {/* Stats Overview */}
                <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Flags</CardTitle>
                            <Flag className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.total}</div>
                        </CardContent>
                    </Card>
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Pending</CardTitle>
                            <Clock className="h-4 w-4 text-yellow-600" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.pending}</div>
                        </CardContent>
                    </Card>
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Under Review</CardTitle>
                            <Eye className="h-4 w-4 text-blue-600" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.reviewing}</div>
                        </CardContent>
                    </Card>
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Resolved</CardTitle>
                            <CheckCircle className="h-4 w-4 text-green-600" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.resolved}</div>
                        </CardContent>
                    </Card>
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Critical</CardTitle>
                            <AlertTriangle className="h-4 w-4 text-red-600" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.critical}</div>
                        </CardContent>
                    </Card>
                </div>

                <Card>
                    <CardHeader>
                        <CardTitle>All Flags</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Flag</TableHead>
                                    <TableHead>Type</TableHead>
                                    <TableHead>Severity</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Reported</TableHead>
                                    <TableHead>Assigned</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {flags.map((flag) => (
                                    <TableRow key={flag.id}>
                                        <TableCell>
                                            <div>
                                                <div className="font-medium">{flag.title}</div>
                                                <div className="text-sm text-muted-foreground">{flag.description}</div>
                                            </div>
                                        </TableCell>
                                        <TableCell>{getTypeBadge(flag.type)}</TableCell>
                                        <TableCell>{getSeverityBadge(flag.severity)}</TableCell>
                                        <TableCell>{getStatusBadge(flag.status)}</TableCell>
                                        <TableCell>
                                            <div className="text-sm">
                                                <div>{new Date(flag.reportedAt).toLocaleDateString()}</div>
                                                <div className="text-muted-foreground">
                                                    by {flag.reportedBy === 'system' ? 'System' : flag.reportedBy}
                                                </div>
                                            </div>
                                        </TableCell>
                                        <TableCell>
                                            {flag.assignedTo ? (
                                                <Badge variant="outline">{flag.assignedTo}</Badge>
                                            ) : (
                                                <span className="text-muted-foreground">Unassigned</span>
                                            )}
                                        </TableCell>
                                        <TableCell>
                                            <div className="flex space-x-1">
                                                {!flag.assignedTo && (
                                                    <Button size="sm">Assign</Button>
                                                )}
                                                {flag.status !== 'resolved' && (
                                                    <Button size="sm" variant="outline">Resolve</Button>
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