"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { AlertCircle, CreditCard, DollarSign, TrendingUp, Users } from "lucide-react"
import { useState } from "react"

// Mock billing data
const mockSubscriptions = [
    {
        id: 1,
        customer: "Tech Solutions Inc",
        plan: "premium",
        amount: 99.99,
        status: "active",
        nextBilling: "2024-02-15",
        lastPayment: "2024-01-15",
        paymentMethod: "Visa ****1234"
    },
    {
        id: 2,
        customer: "Beauty Salon Pro",
        plan: "basic",
        amount: 29.99,
        status: "active",
        nextBilling: "2024-02-10",
        lastPayment: "2024-01-10",
        paymentMethod: "Mastercard ****5678"
    },
    {
        id: 3,
        customer: "Fitness Center Plus",
        plan: "enterprise",
        amount: 299.99,
        status: "past_due",
        nextBilling: "2024-01-25",
        lastPayment: "2024-01-05",
        paymentMethod: "Amex ****9012"
    }
]

const mockRevenueData = {
    monthlyRevenue: 125000,
    monthlyGrowth: 12.5,
    activeSubscriptions: 1247,
    churnRate: 2.3,
    averageRevenuePerUser: 89.50
}

export default function BillingPage() {
    const [selectedPlan, setSelectedPlan] = useState("all")
    const [selectedStatus, setSelectedStatus] = useState("all")

    const filteredSubscriptions = mockSubscriptions.filter(subscription => {
        if (selectedPlan !== "all" && subscription.plan !== selectedPlan) return false
        if (selectedStatus !== "all" && subscription.status !== selectedStatus) return false
        return true
    })

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Billing & Revenue</h1>
                    <p className="text-gray-600">Manage subscriptions and track revenue performance</p>
                </div>

                {/* Revenue Stats */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Monthly Revenue</CardTitle>
                            <DollarSign className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">${mockRevenueData.monthlyRevenue.toLocaleString()}</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +{mockRevenueData.monthlyGrowth}% from last month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Subscriptions</CardTitle>
                            <Users className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{mockRevenueData.activeSubscriptions.toLocaleString()}</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +8.2% from last month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">ARPU</CardTitle>
                            <CreditCard className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">${mockRevenueData.averageRevenuePerUser}</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +5.1% from last month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Churn Rate</CardTitle>
                            <AlertCircle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{mockRevenueData.churnRate}%</div>
                            <div className="flex items-center text-xs text-red-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +0.3% from last month
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Revenue Overview */}
                <Card>
                    <CardHeader>
                        <CardTitle>Revenue Overview</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div className="space-y-2">
                                <h3 className="font-semibold">Plan Distribution</h3>
                                <div className="space-y-2">
                                    <div className="flex justify-between">
                                        <span>Basic Plan</span>
                                        <span className="font-medium">45.2%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Premium Plan</span>
                                        <span className="font-medium">38.7%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Enterprise Plan</span>
                                        <span className="font-medium">16.1%</span>
                                    </div>
                                </div>
                            </div>

                            <div className="space-y-2">
                                <h3 className="font-semibold">Payment Methods</h3>
                                <div className="space-y-2">
                                    <div className="flex justify-between">
                                        <span>Credit Cards</span>
                                        <span className="font-medium">78.3%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>PayPal</span>
                                        <span className="font-medium">15.2%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Bank Transfer</span>
                                        <span className="font-medium">6.5%</span>
                                    </div>
                                </div>
                            </div>

                            <div className="space-y-2">
                                <h3 className="font-semibold">Geographic Revenue</h3>
                                <div className="space-y-2">
                                    <div className="flex justify-between">
                                        <span>North America</span>
                                        <span className="font-medium">52.1%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Europe</span>
                                        <span className="font-medium">28.7%</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span>Asia Pacific</span>
                                        <span className="font-medium">19.2%</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </CardContent>
                </Card>

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
                                        <SelectItem value="past_due">Past Due</SelectItem>
                                        <SelectItem value="cancelled">Cancelled</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="search">Search</Label>
                                <Input placeholder="Search subscriptions..." />
                            </div>
                        </div>
                    </CardContent>
                </Card>

                {/* Subscriptions Table */}
                <Card>
                    <CardHeader>
                        <CardTitle>Active Subscriptions</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Customer</TableHead>
                                    <TableHead>Plan</TableHead>
                                    <TableHead>Amount</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Next Billing</TableHead>
                                    <TableHead>Last Payment</TableHead>
                                    <TableHead>Payment Method</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredSubscriptions.map((subscription) => (
                                    <TableRow key={subscription.id}>
                                        <TableCell className="font-medium">{subscription.customer}</TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                subscription.plan === "enterprise" ? "default" :
                                                    subscription.plan === "premium" ? "secondary" : "outline"
                                            }>
                                                {subscription.plan}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>${subscription.amount}</TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                subscription.status === "active" ? "default" :
                                                    subscription.status === "past_due" ? "destructive" : "secondary"
                                            }>
                                                {subscription.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{subscription.nextBilling}</TableCell>
                                        <TableCell>{subscription.lastPayment}</TableCell>
                                        <TableCell>{subscription.paymentMethod}</TableCell>
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
                                    <CreditCard className="h-6 w-6 mx-auto mb-2" />
                                    <div>Process Payments</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <DollarSign className="h-6 w-6 mx-auto mb-2" />
                                    <div>Generate Invoice</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <AlertCircle className="h-6 w-6 mx-auto mb-2" />
                                    <div>Handle Disputes</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <TrendingUp className="h-6 w-6 mx-auto mb-2" />
                                    <div>Revenue Report</div>
                                </div>
                            </Button>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
} 