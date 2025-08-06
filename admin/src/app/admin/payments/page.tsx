"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import {
    deletePayment,
    fetchPayments,
    getPaymentStats,
    processRefund,
    updatePaymentStatus,
    type Payment,
    type PaymentFilters
} from "@/services/payments_service"
import { CreditCard, DollarSign, Filter, RefreshCw, TrendingUp } from "lucide-react"
import { useEffect, useState } from "react"

export default function PaymentsPage() {
    const [payments, setPayments] = useState<Payment[]>([])
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState("")
    const [stats, setStats] = useState({
        total: 0,
        completed: 0,
        pending: 0,
        failed: 0,
        refunded: 0,
        totalAmount: 0,
        totalFees: 0,
        totalNetAmount: 0,
    })
    const [filters, setFilters] = useState<PaymentFilters>({
        status: "all",
        method: "all",
        search: "",
    })

    const fetchData = async () => {
        setLoading(true)
        setError("")
        try {
            const [paymentsResponse, statsData] = await Promise.all([
                fetchPayments(filters),
                getPaymentStats(),
            ])
            setPayments(paymentsResponse.payments)
            setStats(statsData)
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to fetch payments")
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        fetchData()
    }, [filters])

    const handleStatusUpdate = async (paymentId: string, newStatus: string) => {
        try {
            await updatePaymentStatus(paymentId, newStatus)
            await fetchData() // Refresh data
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to update payment status")
        }
    }

    const handleRefund = async (paymentId: string) => {
        if (!confirm("Are you sure you want to process a refund for this payment?")) return

        try {
            await processRefund(paymentId)
            await fetchData() // Refresh data
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to process refund")
        }
    }

    const handleDeletePayment = async (paymentId: string) => {
        if (!confirm("Are you sure you want to delete this payment?")) return

        try {
            await deletePayment(paymentId)
            await fetchData() // Refresh data
        } catch (err) {
            setError(err instanceof Error ? err.message : "Failed to delete payment")
        }
    }

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
            case "stripe": return <CreditCard className="h-4 w-4" />
            default: return <CreditCard className="h-4 w-4" />
        }
    }

    if (loading && payments.length === 0) {
        return (
            <AdminLayout>
                <div className="space-y-6">
                    <div>
                        <h1 className="text-3xl font-bold text-gray-900">Payments</h1>
                        <p className="text-gray-600">Monitor and manage payment transactions</p>
                    </div>
                    <div className="flex items-center justify-center h-64">
                        <div className="text-center">
                            <RefreshCw className="h-8 w-8 animate-spin text-blue-500 mx-auto mb-4" />
                            <p className="text-gray-600">Loading payments...</p>
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
                        <h1 className="text-3xl font-bold text-gray-900">Payments</h1>
                        <p className="text-gray-600">Monitor and manage payment transactions</p>
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
                                    placeholder="Search payments..."
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
                                        <SelectItem value="completed">Completed</SelectItem>
                                        <SelectItem value="pending">Pending</SelectItem>
                                        <SelectItem value="failed">Failed</SelectItem>
                                        <SelectItem value="refunded">Refunded</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                            <div>
                                <label className="text-sm font-medium">Method</label>
                                <Select
                                    value={filters.method || "all"}
                                    onValueChange={(value) => setFilters({ ...filters, method: value })}
                                >
                                    <SelectTrigger className="mt-1">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Methods</SelectItem>
                                        <SelectItem value="credit_card">Credit Card</SelectItem>
                                        <SelectItem value="paypal">PayPal</SelectItem>
                                        <SelectItem value="bank_transfer">Bank Transfer</SelectItem>
                                        <SelectItem value="stripe">Stripe</SelectItem>
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
                            <CardTitle className="text-sm font-medium">Total Payments</CardTitle>
                            <CreditCard className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.total}</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +12.5% from last month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Completed</CardTitle>
                            <DollarSign className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.completed}</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                {stats.total > 0 ? Math.round((stats.completed / stats.total) * 100) : 0}% success rate
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Amount</CardTitle>
                            <DollarSign className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">${stats.totalAmount.toLocaleString()}</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +8.2% from last month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Net Revenue</CardTitle>
                            <DollarSign className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">${stats.totalNetAmount.toLocaleString()}</div>
                            <div className="flex items-center text-xs text-gray-600">
                                Fees: ${stats.totalFees.toLocaleString()}
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Status Distribution */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader>
                            <CardTitle className="text-sm font-medium">Pending</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.pending}</div>
                            <div className="text-xs text-gray-500">
                                {stats.total > 0 ? Math.round((stats.pending / stats.total) * 100) : 0}% of payments
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle className="text-sm font-medium">Failed</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.failed}</div>
                            <div className="text-xs text-gray-500">
                                {stats.total > 0 ? Math.round((stats.failed / stats.total) * 100) : 0}% of payments
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle className="text-sm font-medium">Refunded</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{stats.refunded}</div>
                            <div className="text-xs text-gray-500">
                                {stats.total > 0 ? Math.round((stats.refunded / stats.total) * 100) : 0}% of payments
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle className="text-sm font-medium">Success Rate</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">
                                {stats.total > 0 ? Math.round((stats.completed / stats.total) * 100) : 0}%
                            </div>
                            <div className="text-xs text-gray-500">
                                Completed payments
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Payments Table */}
                <Card>
                    <CardHeader>
                        <CardTitle>All Payments ({payments.length})</CardTitle>
                    </CardHeader>
                    <CardContent>
                        {payments.length === 0 ? (
                            <div className="text-center py-8">
                                <p className="text-gray-500">No payments found</p>
                            </div>
                        ) : (
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
                                    {payments.map((payment) => (
                                        <TableRow key={payment.id}>
                                            <TableCell className="font-medium">{payment.transactionId}</TableCell>
                                            <TableCell>{payment.businessName}</TableCell>
                                            <TableCell>{payment.customerName}</TableCell>
                                            <TableCell>${payment.amount.toFixed(2)}</TableCell>
                                            <TableCell>
                                                <div className="flex items-center gap-2">
                                                    {getMethodIcon(payment.method)}
                                                    <span className="capitalize">{payment.method.replace('_', ' ')}</span>
                                                </div>
                                            </TableCell>
                                            <TableCell>
                                                <Select
                                                    value={payment.status}
                                                    onValueChange={(value) => handleStatusUpdate(payment.id, value)}
                                                >
                                                    <SelectTrigger className="w-24">
                                                        <SelectValue />
                                                    </SelectTrigger>
                                                    <SelectContent>
                                                        <SelectItem value="completed">Completed</SelectItem>
                                                        <SelectItem value="pending">Pending</SelectItem>
                                                        <SelectItem value="failed">Failed</SelectItem>
                                                        <SelectItem value="refunded">Refunded</SelectItem>
                                                    </SelectContent>
                                                </Select>
                                            </TableCell>
                                            <TableCell>
                                                {payment.date.toLocaleDateString()}
                                            </TableCell>
                                            <TableCell>
                                                <div className="flex space-x-2">
                                                    {payment.status === 'completed' && (
                                                        <Button
                                                            variant="outline"
                                                            size="sm"
                                                            onClick={() => handleRefund(payment.id)}
                                                        >
                                                            Refund
                                                        </Button>
                                                    )}
                                                    <Button
                                                        variant="outline"
                                                        size="sm"
                                                        onClick={() => handleDeletePayment(payment.id)}
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