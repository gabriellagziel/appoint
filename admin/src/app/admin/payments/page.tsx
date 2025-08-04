"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { CreditCard, DollarSign, Search, TrendingUp } from "lucide-react"
import { useState } from "react"

// Mock payment data
const mockPayments = [
    {
        id: 1,
        transactionId: "TXN_001234",
        businessName: "Downtown Dental",
        customerName: "John Smith",
        amount: 150.00,
        currency: "USD",
        status: "completed",
        method: "credit_card",
        date: "2024-01-15 10:30",
        fee: 4.50,
        netAmount: 145.50
    },
    {
        id: 2,
        transactionId: "TXN_001235",
        businessName: "City Spa",
        customerName: "Sarah Johnson",
        amount: 120.00,
        currency: "USD",
        status: "pending",
        method: "paypal",
        date: "2024-01-15 11:45",
        fee: 3.60,
        netAmount: 116.40
    },
    {
        id: 3,
        transactionId: "TXN_001236",
        businessName: "Tech Solutions",
        customerName: "Mike Davis",
        amount: 200.00,
        currency: "USD",
        status: "failed",
        method: "bank_transfer",
        date: "2024-01-15 14:20",
        fee: 6.00,
        netAmount: 194.00
    },
    {
        id: 4,
        transactionId: "TXN_001237",
        businessName: "Green Gardens",
        customerName: "Lisa Wilson",
        amount: 300.00,
        currency: "USD",
        status: "completed",
        method: "credit_card",
        date: "2024-01-15 16:15",
        fee: 9.00,
        netAmount: 291.00
    },
    {
        id: 5,
        transactionId: "TXN_001238",
        businessName: "Legal Associates",
        customerName: "Robert Brown",
        amount: 250.00,
        currency: "USD",
        status: "refunded",
        method: "credit_card",
        date: "2024-01-15 09:00",
        fee: 7.50,
        netAmount: 242.50
    }
]

export default function PaymentsPage() {
    const [filterStatus, setFilterStatus] = useState("all")
    const [filterMethod, setFilterMethod] = useState("all")
    const [searchTerm, setSearchTerm] = useState("")

    const getStatusColor = (status: string) => {
        switch (status) {
            case "completed": return "default"
            case "pending": return "secondary"
            case "failed": return "destructive"
            case "refunded": return "default"
            default: return "default"
        }
    }

    const getMethodIcon = (method: string) => {
        switch (method) {
            case "credit_card": return <CreditCard className="h-4 w-4" />
            case "paypal": return <CreditCard className="h-4 w-4" />
            case "bank_transfer": return <CreditCard className="h-4 w-4" />
            default: return <CreditCard className="h-4 w-4" />
        }
    }

    const filteredPayments = mockPayments.filter(payment => {
        if (filterStatus !== "all" && payment.status !== filterStatus) return false
        if (filterMethod !== "all" && payment.method !== filterMethod) return false
        if (searchTerm && !payment.customerName.toLowerCase().includes(searchTerm.toLowerCase()) &&
            !payment.businessName.toLowerCase().includes(searchTerm.toLowerCase()) &&
            !payment.transactionId.toLowerCase().includes(searchTerm.toLowerCase())) return false
        return true
    })

    const totalRevenue = mockPayments
        .filter(p => p.status === "completed")
        .reduce((sum, p) => sum + p.amount, 0)

    const totalFees = mockPayments
        .filter(p => p.status === "completed")
        .reduce((sum, p) => sum + p.fee, 0)

    const handleViewDetails = (paymentId: number) => {
        console.log(`Viewing payment ${paymentId}`)
    }

    const handleRefund = (paymentId: number) => {
        console.log(`Processing refund for payment ${paymentId}`)
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Payment Management</h1>
                    <p className="text-gray-600">Monitor transactions, refunds, and payment processing</p>
                </div>

                {/* Stats */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
                            <DollarSign className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">${totalRevenue.toFixed(2)}</div>
                            <p className="text-xs text-gray-500">This month</p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Processing Fees</CardTitle>
                            <TrendingUp className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">${totalFees.toFixed(2)}</div>
                            <p className="text-xs text-gray-500">This month</p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Successful Transactions</CardTitle>
                            <CreditCard className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">
                                {mockPayments.filter(p => p.status === "completed").length}
                            </div>
                            <p className="text-xs text-gray-500">This month</p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Failed Transactions</CardTitle>
                            <CreditCard className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">
                                {mockPayments.filter(p => p.status === "failed").length}
                            </div>
                            <p className="text-xs text-gray-500">This month</p>
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
                                <label className="text-sm font-medium">Status</label>
                                <Select value={filterStatus} onValueChange={setFilterStatus}>
                                    <SelectTrigger>
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Status</SelectItem>
                                        <SelectItem value="completed">Completed</SelectItem>
                                        <SelectItem value="pending">Pending</SelectItem>
                                        <SelectItem value="failed">Failed</SelectItem>
                                        <SelectItem value="refunded">Refunded</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                            <div className="flex-1">
                                <label className="text-sm font-medium">Payment Method</label>
                                <Select value={filterMethod} onValueChange={setFilterMethod}>
                                    <SelectTrigger>
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Methods</SelectItem>
                                        <SelectItem value="credit_card">Credit Card</SelectItem>
                                        <SelectItem value="paypal">PayPal</SelectItem>
                                        <SelectItem value="bank_transfer">Bank Transfer</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                            <div className="flex-1">
                                <label className="text-sm font-medium">Search</label>
                                <div className="relative">
                                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                                    <Input
                                        placeholder="Search transactions..."
                                        value={searchTerm}
                                        onChange={(e) => setSearchTerm(e.target.value)}
                                        className="pl-10"
                                    />
                                </div>
                            </div>
                        </div>
                    </CardContent>
                </Card>

                {/* Payments Table */}
                <Card>
                    <CardHeader>
                        <CardTitle>Transactions</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Transaction ID</TableHead>
                                    <TableHead>Business</TableHead>
                                    <TableHead>Customer</TableHead>
                                    <TableHead>Amount</TableHead>
                                    <TableHead>Method</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Date</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredPayments.map((payment) => (
                                    <TableRow key={payment.id}>
                                        <TableCell className="font-medium">{payment.transactionId}</TableCell>
                                        <TableCell>{payment.businessName}</TableCell>
                                        <TableCell>{payment.customerName}</TableCell>
                                        <TableCell>
                                            <div className="font-medium">${payment.amount.toFixed(2)}</div>
                                            <div className="text-sm text-gray-500">Fee: ${payment.fee.toFixed(2)}</div>
                                        </TableCell>
                                        <TableCell>
                                            <div className="flex items-center gap-2">
                                                {getMethodIcon(payment.method)}
                                                <span className="capitalize">{payment.method.replace('_', ' ')}</span>
                                            </div>
                                        </TableCell>
                                        <TableCell>
                                            <Badge variant={getStatusColor(payment.status)}>
                                                {payment.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{payment.date}</TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <Button
                                                    variant="outline"
                                                    size="sm"
                                                    onClick={() => handleViewDetails(payment.id)}
                                                >
                                                    View
                                                </Button>
                                                {payment.status === "completed" && (
                                                    <Button
                                                        variant="outline"
                                                        size="sm"
                                                        onClick={() => handleRefund(payment.id)}
                                                    >
                                                        Refund
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