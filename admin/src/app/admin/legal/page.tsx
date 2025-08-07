"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { AlertCircle, CheckCircle, Clock, FileText, Gavel, Shield } from "lucide-react"
import { useState } from "react"

// Mock legal data
const mockLegalDocuments = [
    {
        id: 1,
        name: "Privacy Policy",
        type: "policy",
        status: "active",
        version: "2.1",
        lastUpdated: "2024-01-15",
        nextReview: "2024-04-15",
        compliance: "GDPR, CCPA"
    },
    {
        id: 2,
        name: "Terms of Service",
        type: "terms",
        status: "active",
        version: "1.8",
        lastUpdated: "2024-01-10",
        nextReview: "2024-04-10",
        compliance: "General"
    },
    {
        id: 3,
        name: "Data Processing Agreement",
        type: "agreement",
        status: "pending_review",
        version: "1.2",
        lastUpdated: "2024-01-05",
        nextReview: "2024-02-05",
        compliance: "GDPR"
    }
]

const mockComplianceChecks = [
    {
        id: 1,
        requirement: "GDPR Compliance",
        status: "compliant",
        lastChecked: "2024-01-20",
        nextCheck: "2024-04-20",
        score: 95
    },
    {
        id: 2,
        requirement: "CCPA Compliance",
        status: "compliant",
        lastChecked: "2024-01-18",
        nextCheck: "2024-04-18",
        score: 92
    },
    {
        id: 3,
        requirement: "HIPAA Compliance",
        status: "in_progress",
        lastChecked: "2024-01-15",
        nextCheck: "2024-02-15",
        score: 75
    }
]

export default function LegalPage() {
    const [selectedType, setSelectedType] = useState("all")
    const [selectedStatus, setSelectedStatus] = useState("all")

    const filteredDocuments = mockLegalDocuments.filter(doc => {
        if (selectedType !== "all" && doc.type !== selectedType) return false
        if (selectedStatus !== "all" && doc.status !== selectedStatus) return false
        return true
    })

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Legal & Compliance</h1>
                    <p className="text-gray-600">Manage legal documents and compliance requirements</p>
                </div>

                {/* Legal Stats */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Documents</CardTitle>
                            <FileText className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">12</div>
                            <div className="flex items-center text-xs text-green-600">
                                <CheckCircle className="h-3 w-3 mr-1" />
                                All up to date
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Compliance Score</CardTitle>
                            <Shield className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">94%</div>
                            <div className="flex items-center text-xs text-green-600">
                                <CheckCircle className="h-3 w-3 mr-1" />
                                +2% from last month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Pending Reviews</CardTitle>
                            <Clock className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">3</div>
                            <div className="flex items-center text-xs text-orange-600">
                                <AlertCircle className="h-3 w-3 mr-1" />
                                Due this month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Legal Issues</CardTitle>
                            <Gavel className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">0</div>
                            <div className="flex items-center text-xs text-green-600">
                                <CheckCircle className="h-3 w-3 mr-1" />
                                No active issues
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Legal Documents */}
                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                            <CardTitle>Legal Documents</CardTitle>
                            <div className="flex space-x-2">
                                <Select value={selectedType} onValueChange={setSelectedType}>
                                    <SelectTrigger className="w-32">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Types</SelectItem>
                                        <SelectItem value="policy">Policy</SelectItem>
                                        <SelectItem value="terms">Terms</SelectItem>
                                        <SelectItem value="agreement">Agreement</SelectItem>
                                    </SelectContent>
                                </Select>
                                <Select value={selectedStatus} onValueChange={setSelectedStatus}>
                                    <SelectTrigger className="w-32">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Status</SelectItem>
                                        <SelectItem value="active">Active</SelectItem>
                                        <SelectItem value="pending_review">Pending Review</SelectItem>
                                        <SelectItem value="expired">Expired</SelectItem>
                                    </SelectContent>
                                </Select>
                                <Button>
                                    <FileText className="h-4 w-4 mr-2" />
                                    Add Document
                                </Button>
                            </div>
                        </div>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Document Name</TableHead>
                                    <TableHead>Type</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Version</TableHead>
                                    <TableHead>Last Updated</TableHead>
                                    <TableHead>Next Review</TableHead>
                                    <TableHead>Compliance</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredDocuments.map((document) => (
                                    <TableRow key={document.id}>
                                        <TableCell className="font-medium">{document.name}</TableCell>
                                        <TableCell>
                                            <Badge variant="outline">{document.type}</Badge>
                                        </TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                document.status === "active" ? "default" :
                                                    document.status === "pending_review" ? "secondary" : "destructive"
                                            }>
                                                {document.status.replace('_', ' ')}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{document.version}</TableCell>
                                        <TableCell>{document.lastUpdated}</TableCell>
                                        <TableCell>{document.nextReview}</TableCell>
                                        <TableCell>{document.compliance}</TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <button className="text-sm text-blue-600 hover:text-blue-800">View</button>
                                                <button className="text-sm text-orange-600 hover:text-orange-800">Edit</button>
                                                <button className="text-sm text-red-600 hover:text-red-800">Archive</button>
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Compliance Monitoring */}
                <Card>
                    <CardHeader>
                        <CardTitle>Compliance Monitoring</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Requirement</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Score</TableHead>
                                    <TableHead>Last Checked</TableHead>
                                    <TableHead>Next Check</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {mockComplianceChecks.map((check) => (
                                    <TableRow key={check.id}>
                                        <TableCell className="font-medium">{check.requirement}</TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                check.status === "compliant" ? "default" :
                                                    check.status === "in_progress" ? "secondary" : "destructive"
                                            }>
                                                {check.status.replace('_', ' ')}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>
                                            <div className="flex items-center space-x-2">
                                                <div className="w-full bg-gray-200 rounded-full h-2">
                                                    <div
                                                        className="bg-blue-600 h-2 rounded-full"
                                                        style={{ width: `${check.score}%` }}
                                                    ></div>
                                                </div>
                                                <span className="text-sm">{check.score}%</span>
                                            </div>
                                        </TableCell>
                                        <TableCell>{check.lastChecked}</TableCell>
                                        <TableCell>{check.nextCheck}</TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <button className="text-sm text-blue-600 hover:text-blue-800">Run Check</button>
                                                <button className="text-sm text-orange-600 hover:text-orange-800">Report</button>
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Legal Tools */}
                <Card>
                    <CardHeader>
                        <CardTitle>Legal Tools</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div className="space-y-4">
                                <h3 className="font-semibold">Document Management</h3>
                                <div className="space-y-2">
                                    <Button variant="outline" className="w-full">
                                        <FileText className="h-4 w-4 mr-2" />
                                        Generate Document
                                    </Button>
                                    <Button variant="outline" className="w-full">
                                        <Gavel className="h-4 w-4 mr-2" />
                                        Legal Review
                                    </Button>
                                </div>
                            </div>

                            <div className="space-y-4">
                                <h3 className="font-semibold">Compliance</h3>
                                <div className="space-y-2">
                                    <Button variant="outline" className="w-full">
                                        <Shield className="h-4 w-4 mr-2" />
                                        Run Compliance Check
                                    </Button>
                                    <Button variant="outline" className="w-full">
                                        <AlertCircle className="h-4 w-4 mr-2" />
                                        Generate Report
                                    </Button>
                                </div>
                            </div>

                            <div className="space-y-4">
                                <h3 className="font-semibold">Monitoring</h3>
                                <div className="space-y-2">
                                    <Button variant="outline" className="w-full">
                                        <Clock className="h-4 w-4 mr-2" />
                                        Set Reminders
                                    </Button>
                                    <Button variant="outline" className="w-full">
                                        <CheckCircle className="h-4 w-4 mr-2" />
                                        Audit Trail
                                    </Button>
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
                                    <FileText className="h-6 w-6 mx-auto mb-2" />
                                    <div>Add Document</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Shield className="h-6 w-6 mx-auto mb-2" />
                                    <div>Compliance Check</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Gavel className="h-6 w-6 mx-auto mb-2" />
                                    <div>Legal Review</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <AlertCircle className="h-6 w-6 mx-auto mb-2" />
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