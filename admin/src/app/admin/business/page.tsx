"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import {
    deleteBusiness,
    fetchBusinesses,
    getBusinessStats,
    updateBusinessPlan,
    updateBusinessStatus,
    type Business,
    type BusinessFilters
} from "@/services/business_service"
import { AlertTriangle, Building2, CheckCircle, Filter, RefreshCw, Shield, TrendingUp } from "lucide-react"
import { useEffect, useState } from "react"

export default function BusinessAccountsPage() {
    const [businesses, setBusinesses] = useState<Business[]>([])
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState("")
    const [stats, setStats] = useState({
        total: 0,
        active: 0,
        suspended: 0,
        basic: 0,
        premium: 0,
        enterprise: 0,
        totalRevenue: 0,
    })
    const [filters, setFilters] = useState<BusinessFilters>({
        status: "all",
        plan: "all",
        search: "",
    })

    const fetchData = async () => {
        setLoading(true)
        setError("")
        try {
            const [businessesResponse, statsData] = await Promise.all([
                fetchBusinesses(filters),
                getBusinessStats(),
            ])
            setBusinesses(businessesResponse.businesses)
            setStats(statsData)
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to fetch businesses")
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        fetchData()
    }, [filters])

    const handleStatusUpdate = async (businessId: string, newStatus: string) => {
        try {
            await updateBusinessStatus(businessId, newStatus)
            await fetchData() // Refresh data
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to update business status")
        }
    }

    const handlePlanUpdate = async (businessId: string, newPlan: string) => {
        try {
            await updateBusinessPlan(businessId, newPlan)
            await fetchData() // Refresh data
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to update business plan")
        }
    }

    const handleDeleteBusiness = async (businessId: string) => {
        if (!confirm("Are you sure you want to delete this business?")) return

        try {
            await deleteBusiness(businessId)
            await fetchData() // Refresh data
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to delete business")
        }
    }

    const getStatusColor = (status: string) => {
        switch (status) {
            case "active": return "default"
            case "suspended": return "destructive"
            case "pending": return "secondary"
            default: return "default"
        }
    }

    const getPlanColor = (plan: string) => {
        switch (plan) {
            case "enterprise": return "destructive"
            case "premium": return "secondary"
            case "basic": return "default"
            default: return "default"
        }
    }

    if (loading && businesses.length === 0) {
        return (
            <AdminLayout>
                <div className="space-y-6">
                    <div>
                        <h1 className="text-3xl font-bold text-gray-900">Business Accounts</h1>
                        <p className="text-gray-600">Manage business users and their subscription plans</p>
                    </div>
                    <div className="flex items-center justify-center h-64">
                        <div className="text-center">
                            <RefreshCw className="h-8 w-8 animate-spin text-blue-500 mx-auto mb-4" />
                            <p className="text-gray-600">Loading businesses...</p>
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
                        <h1 className="text-3xl font-bold text-gray-900">Business Accounts</h1>
                        <p className="text-gray-600">Manage business users and their subscription plans</p>
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
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div>
                                <label className="text-sm font-medium">Search</label>
                                <Input
                                    placeholder="Search businesses..."
                                    value={filters.search || ""}
                                    onChange={(e) => setFilters({ ...filters, search: e.target.value })}
                                    className="mt-1"
                                />
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
                                        <SelectItem value="active">Active</SelectItem>
                                        <SelectItem value="suspended">Suspended</SelectItem>
                                        <SelectItem value="pending">Pending</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                            <div>
                                <label className="text-sm font-medium">Plan</label>
                                <Select
                                    value={filters.plan || "all"}
                                    onValueChange={(value) => setFilters({ ...filters, plan: value })}
                                >
                                    <SelectTrigger className="mt-1">
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
                        </div>
                    </CardContent>
                </Card>

                {/* Stats Cards */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Businesses</CardTitle>
                            <Building2 className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.total}</div>
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
                            <div className="text-2xl font-bold">{stats.active}</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                {stats.total > 0 ? Math.round((stats.active / stats.total) * 100) : 0}% active rate
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Suspended</CardTitle>
                            <AlertTriangle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.suspended}</div>
                            <div className="flex items-center text-xs text-red-600">
                                <AlertTriangle className="h-3 w-3 mr-1" />
                                {stats.total > 0 ? Math.round((stats.suspended / stats.total) * 100) : 0}% of total
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
                            <Shield className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">${stats.totalRevenue.toLocaleString()}</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +23.1% from last month
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Plan Distribution */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <Card>
                        <CardHeader>
                            <CardTitle className="text-sm font-medium">Basic Plan</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.basic}</div>
                            <div className="text-xs text-gray-500">
                                {stats.total > 0 ? Math.round((stats.basic / stats.total) * 100) : 0}% of businesses
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle className="text-sm font-medium">Premium Plan</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.premium}</div>
                            <div className="text-xs text-gray-500">
                                {stats.total > 0 ? Math.round((stats.premium / stats.total) * 100) : 0}% of businesses
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle className="text-sm font-medium">Enterprise Plan</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.enterprise}</div>
                            <div className="text-xs text-gray-500">
                                {stats.total > 0 ? Math.round((stats.enterprise / stats.total) * 100) : 0}% of businesses
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Businesses Table */}
                <Card>
                    <CardHeader>
                        <CardTitle>All Businesses ({businesses.length})</CardTitle>
                    </CardHeader>
                    <CardContent>
                        {businesses.length === 0 ? (
                            <div className="text-center py-8">
                                <p className="text-gray-500">No businesses found</p>
                            </div>
                        ) : (
                            <Table>
                                <TableHeader>
                                    <TableRow>
                                        <TableHead>ID</TableHead>
                                        <TableHead>Name</TableHead>
                                        <TableHead>Owner</TableHead>
                                        <TableHead>Email</TableHead>
                                        <TableHead>Plan</TableHead>
                                        <TableHead>Status</TableHead>
                                        <TableHead>Employees</TableHead>
                                        <TableHead>Revenue</TableHead>
                                        <TableHead>Actions</TableHead>
                                    </TableRow>
                                </TableHeader>
                                <TableBody>
                                    {businesses.map((business) => (
                                        <TableRow key={business.id}>
                                            <TableCell className="font-medium">{business.id}</TableCell>
                                            <TableCell>{business.name}</TableCell>
                                            <TableCell>{business.owner}</TableCell>
                                            <TableCell>{business.email}</TableCell>
                                            <TableCell>
                                                <Select
                                                    value={business.plan}
                                                    onValueChange={(value) => handlePlanUpdate(business.id, value)}
                                                >
                                                    <SelectTrigger className="w-24">
                                                        <SelectValue />
                                                    </SelectTrigger>
                                                    <SelectContent>
                                                        <SelectItem value="basic">Basic</SelectItem>
                                                        <SelectItem value="premium">Premium</SelectItem>
                                                        <SelectItem value="enterprise">Enterprise</SelectItem>
                                                    </SelectContent>
                                                </Select>
                                            </TableCell>
                                            <TableCell>
                                                <Select
                                                    value={business.status}
                                                    onValueChange={(value) => handleStatusUpdate(business.id, value)}
                                                >
                                                    <SelectTrigger className="w-24">
                                                        <SelectValue />
                                                    </SelectTrigger>
                                                    <SelectContent>
                                                        <SelectItem value="active">Active</SelectItem>
                                                        <SelectItem value="suspended">Suspended</SelectItem>
                                                        <SelectItem value="pending">Pending</SelectItem>
                                                    </SelectContent>
                                                </Select>
                                            </TableCell>
                                            <TableCell>{business.employees}</TableCell>
                                            <TableCell>${business.monthlyRevenue.toLocaleString()}</TableCell>
                                            <TableCell>
                                                <div className="flex space-x-2">
                                                    <Button
                                                        variant="outline"
                                                        size="sm"
                                                        onClick={() => handleDeleteBusiness(business.id)}
                                                    >
                                                        Delete
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