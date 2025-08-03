"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { CheckCircle, FileText, Shield } from "lucide-react"

const mockConsentLogs = [
    {
        id: "1",
        userEmail: "john@example.com",
        consentType: "privacy",
        action: "granted",
        timestamp: "2024-01-15T10:30:00Z",
        version: "v2.1"
    },
    {
        id: "2",
        userEmail: "jane@example.com",
        consentType: "marketing",
        action: "revoked",
        timestamp: "2024-01-15T09:15:00Z",
        version: "v2.1"
    }
]

const mockTermsVersions = [
    {
        id: "1",
        version: "v2.1",
        title: "Updated Privacy Policy & Terms of Service",
        effectiveDate: "2024-01-01T00:00:00Z",
        status: "active",
        usersAccepted: 15420,
        usersPending: 2340
    },
    {
        id: "2",
        version: "v2.0",
        title: "Privacy Policy & Terms of Service",
        effectiveDate: "2023-06-01T00:00:00Z",
        status: "deprecated",
        usersAccepted: 12340,
        usersPending: 0
    }
]

export default function LegalPage() {
    const getConsentTypeBadge = (type: string) => {
        const colors = {
            privacy: "bg-blue-100 text-blue-800",
            terms: "bg-green-100 text-green-800",
            marketing: "bg-purple-100 text-purple-800",
            cookies: "bg-orange-100 text-orange-800"
        }
        return <Badge className={colors[type as keyof typeof colors]}>{type}</Badge>
    }

    const getActionBadge = (action: string) => {
        const colors = {
            granted: "bg-green-100 text-green-800",
            revoked: "bg-red-100 text-red-800",
            updated: "bg-yellow-100 text-yellow-800"
        }
        return <Badge className={colors[action as keyof typeof colors]}>{action}</Badge>
    }

    const getStatusBadge = (status: string) => {
        const colors = {
            active: "bg-green-100 text-green-800",
            draft: "bg-yellow-100 text-yellow-800",
            deprecated: "bg-gray-100 text-gray-800"
        }
        return <Badge className={colors[status as keyof typeof colors]}>{status}</Badge>
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Legal & Compliance</h1>
                    <p className="text-gray-600">Manage consent logs, terms versions, and compliance tracking</p>
                </div>

                {/* Stats Overview */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Consents</CardTitle>
                            <Shield className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{mockConsentLogs.length}</div>
                        </CardContent>
                    </Card>
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Terms</CardTitle>
                            <FileText className="h-4 w-4 text-purple-600" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{mockTermsVersions.filter(t => t.status === 'active').length}</div>
                        </CardContent>
                    </Card>
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">GDPR Compliant</CardTitle>
                            <CheckCircle className="h-4 w-4 text-green-600" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">✅</div>
                        </CardContent>
                    </Card>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <Card>
                        <CardHeader>
                            <CardTitle>Consent Logs</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <Table>
                                <TableHeader>
                                    <TableRow>
                                        <TableHead>User</TableHead>
                                        <TableHead>Type</TableHead>
                                        <TableHead>Action</TableHead>
                                        <TableHead>Date</TableHead>
                                    </TableRow>
                                </TableHeader>
                                <TableBody>
                                    {mockConsentLogs.map((log) => (
                                        <TableRow key={log.id}>
                                            <TableCell className="font-medium">{log.userEmail}</TableCell>
                                            <TableCell>{getConsentTypeBadge(log.consentType)}</TableCell>
                                            <TableCell>{getActionBadge(log.action)}</TableCell>
                                            <TableCell>{new Date(log.timestamp).toLocaleDateString()}</TableCell>
                                        </TableRow>
                                    ))}
                                </TableBody>
                            </Table>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle>Terms Versions</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <Table>
                                <TableHeader>
                                    <TableRow>
                                        <TableHead>Version</TableHead>
                                        <TableHead>Status</TableHead>
                                        <TableHead>Accepted</TableHead>
                                        <TableHead>Pending</TableHead>
                                    </TableRow>
                                </TableHeader>
                                <TableBody>
                                    {mockTermsVersions.map((version) => (
                                        <TableRow key={version.id}>
                                            <TableCell>
                                                <Badge variant="outline">{version.version}</Badge>
                                            </TableCell>
                                            <TableCell>{getStatusBadge(version.status)}</TableCell>
                                            <TableCell>{version.usersAccepted.toLocaleString()}</TableCell>
                                            <TableCell>{version.usersPending.toLocaleString()}</TableCell>
                                        </TableRow>
                                    ))}
                                </TableBody>
                            </Table>
                        </CardContent>
                    </Card>
                </div>
            </div>
        </AdminLayout>
    )
} 