"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { AlertTriangle, Building2, CheckCircle, Shield, TrendingUp, Users } from "lucide-react"
import { useState } from "react"

// Mock business accounts data
const mockBusinessAccounts = [
    {
        id: 1,
        name: "Tech Solutions Inc",
        owner: "John Smith",
        email: "john@techsolutions.com",
        plan: "premium",
        status: "active",
        employees: 25,
        locations: 3,
        monthlyRevenue: 15000,
        joinedAt: "2024-01-15",
        lastActive: "2024-01-20"
    },
    {
        id: 2,
        name: "Beauty Salon Pro",
        owner: "Maria Garcia",
        email: "maria@beautysalon.com",
        plan: "basic",
        status: "active",
        employees: 8,
        locations: 1,
        monthlyRevenue: 5000,
        joinedAt: "2024-01-10",
        lastActive: "2024-01-19"
    },
    {
        id: 3,
        name: "Fitness Center Plus",
        owner: "David Wilson",
        email: "david@fitnesscenter.com",
        plan: "enterprise",
        status: "suspended",
        employees: 45,
        locations: 5,
        monthlyRevenue: 25000,
        joinedAt: "2024-01-05",
        lastActive: "2024-01-15"
    }
]

export default function BusinessAccountsPage() {
    const [selectedPlan, setSelectedPlan] = useState("all")
    const [selectedStatus, setSelectedStatus] = useState("all")

    const filteredAccounts = mockBusinessAccounts.filter(account => {
        if (selectedPlan !== "all" && account.plan !== selectedPlan) return false
        if (selectedStatus !== "all" && account.status !== selectedStatus) return false
        return true
    })

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Business Accounts</h1>
                    <p className="text-gray-600">Manage business users and their subscription plans</p>
                </div>

                {/* Stats Cards */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Businesses</CardTitle>
                            <Building2 className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">1,247</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +15.2% from last month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Accounts</CardTitle>
                            <CheckCircle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">1,189</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                95.3% active rate
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Premium Plans</CardTitle>
                            <Shield className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">456</div>
                            <div className="flex items-center text-xs text-blue-600">
                                36.6% conversion rate
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Suspended</CardTitle>
                            <AlertTriangle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">58</div>
                            <div className="flex items-center text-xs text-red-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +3 from last month
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Filters */}
                <Card>
                    <CardHeader>
                        <CardTitle>Filters</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div className="space-y-2">
                                <Label htmlFor="plan">Plan Type</Label>
                                <Select value={selectedPlan} onValueChange={setSelectedPlan}>
                                    <SelectTrigger>
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Plans</SelectItem>
                                        <SelectItem value="basic">Basic</SelectItem>
                                        <SelectItem value="premium">Premium</SelectItem>
                                        <SelectItem value="enterprise">Enterprise</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="status">Status</Label>
                                <Select value={selectedStatus} onValueChange={setSelectedStatus}>
                                    <SelectTrigger>
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Status</SelectItem>
                                        <SelectItem value="active">Active</SelectItem>
                                        <SelectItem value="suspended">Suspended</SelectItem>
                                        <SelectItem value="pending">Pending</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="search">Search</Label>
                                <Input placeholder="Search businesses..." />
                            </div>
                        </div>
                    </CardContent>
                </Card>

                {/* Business Accounts Table */}
                <Card>
                    <CardHeader>
                        <CardTitle>Business Accounts</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Business Name</TableHead>
                                    <TableHead>Owner</TableHead>
                                    <TableHead>Plan</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Employees</TableHead>
                                    <TableHead>Locations</TableHead>
                                    <TableHead>Revenue</TableHead>
                                    <TableHead>Last Active</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredAccounts.map((account) => (
                                    <TableRow key={account.id}>
                                        <TableCell className="font-medium">{account.name}</TableCell>
                                        <TableCell>{account.owner}</TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                account.plan === "enterprise" ? "default" :
                                                    account.plan === "premium" ? "secondary" : "outline"
                                            }>
                                                {account.plan}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>
                                            <Badge variant={account.status === "active" ? "default" : "destructive"}>
                                                {account.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{account.employees}</TableCell>
                                        <TableCell>{account.locations}</TableCell>
                                        <TableCell>${account.monthlyRevenue.toLocaleString()}</TableCell>
                                        <TableCell>{account.lastActive}</TableCell>
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

                {/* Quick Actions */}
                <Card>
                    <CardHeader>
                        <CardTitle>Quick Actions</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Building2 className="h-6 w-6 mx-auto mb-2" />
                                    <div>Add Business</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Shield className="h-6 w-6 mx-auto mb-2" />
                                    <div>Upgrade Plans</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Users className="h-6 w-6 mx-auto mb-2" />
                                    <div>Bulk Actions</div>
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