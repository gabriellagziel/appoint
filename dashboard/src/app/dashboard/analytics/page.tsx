'use client'
export const dynamic = 'force-dynamic'

import { LineChart } from '@/components/Charts/LineChart'
import { Alert, AlertDescription } from '@/components/ui/alert'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { useAuth } from '@/contexts/AuthContext'
import { AnalyticsData, getAnalyticsData } from '@/services/analytics_service'
import { getUsageSummary } from '@/services/usage_service'
import { exportAnalyticsToCSV, exportUsageToCSV } from '@/utils/exportToCSV'
import {
    AlertTriangle,
    Calendar,
    Clock,
    DollarSign,
    Download,
    Loader2,
    Users
} from 'lucide-react'
import { useEffect, useState } from 'react'

export default function AnalyticsPage() {
    const { user } = useAuth()
    const [analyticsData, setAnalyticsData] = useState<AnalyticsData | null>(null)
    const [usageSummary, setUsageSummary] = useState<any>(null)
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState<string | null>(null)

    useEffect(() => {
        if (user?.businessId) {
            loadData()
        }
    }, [user?.businessId])

    const loadData = async () => {
        try {
            setLoading(true)
            setError(null)

            const [analytics, usage] = await Promise.all([
                getAnalyticsData(user!.businessId!),
                getUsageSummary(user!.businessId!)
            ])

            setAnalyticsData(analytics)
            setUsageSummary(usage)
        } catch (error) {
            console.error('Error loading analytics data:', error)
            setError('Failed to load analytics data')
        } finally {
            setLoading(false)
        }
    }

    const handleExportAnalytics = () => {
        if (analyticsData) {
            const exportData = [
                { Metric: 'Total Appointments', Value: analyticsData.totalAppointments },
                { Metric: 'Confirmed Appointments', Value: analyticsData.confirmedAppointments },
                { Metric: 'Cancelled Appointments', Value: analyticsData.cancelledAppointments },
                { Metric: 'Total Customers', Value: analyticsData.totalCustomers },
                { Metric: 'Active Customers', Value: analyticsData.activeCustomers },
                { Metric: 'Total Revenue', Value: `$${analyticsData.totalRevenue.toFixed(2)}` },
                { Metric: 'Average Meeting Duration', Value: `${analyticsData.averageMeetingDuration} minutes` }
            ]
            exportAnalyticsToCSV(exportData, 'analytics-report')
        }
    }

    const handleExportUsage = () => {
        if (usageSummary) {
            exportUsageToCSV(usageSummary)
        }
    }

    if (loading) {
        return (
            <div className="p-6">
                <div className="flex justify-center items-center h-64">
                    <div className="flex items-center space-x-2">
                        <Loader2 className="h-6 w-6 animate-spin" />
                        <span>Loading analytics...</span>
                    </div>
                </div>
            </div>
        )
    }

    if (error) {
        return (
            <div className="p-6">
                <Alert variant="destructive">
                    <AlertTriangle className="h-4 w-4" />
                    <AlertDescription>{error}</AlertDescription>
                </Alert>
            </div>
        )
    }

    if (!analyticsData) {
        return (
            <div className="p-6">
                <Alert>
                    <AlertDescription>No analytics data available</AlertDescription>
                </Alert>
            </div>
        )
    }

    return (
        <div className="p-6">
            <div className="max-w-7xl mx-auto">
                {/* Header */}
                <div className="flex justify-between items-center mb-8">
                    <div>
                        <h1 className="text-3xl font-bold text-gray-900">Analytics Dashboard</h1>
                        <p className="text-gray-600">Business insights and performance metrics</p>
                    </div>
                    <div className="flex space-x-2">
                        <Button onClick={handleExportAnalytics} variant="outline">
                            <Download className="w-4 h-4 mr-2" />
                            Export Analytics
                        </Button>
                        <Button onClick={handleExportUsage} variant="outline">
                            <Download className="w-4 h-4 mr-2" />
                            Export Usage
                        </Button>
                    </div>
                </div>

                {/* Key Metrics */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Appointments</CardTitle>
                            <Calendar className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{analyticsData.totalAppointments}</div>
                            <p className="text-xs text-muted-foreground">
                                {analyticsData.confirmedAppointments} confirmed
                            </p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
                            <DollarSign className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">${analyticsData.totalRevenue.toFixed(2)}</div>
                            <p className="text-xs text-muted-foreground">
                                CRM tracking only
                            </p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Customers</CardTitle>
                            <Users className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{analyticsData.activeCustomers}</div>
                            <p className="text-xs text-muted-foreground">
                                of {analyticsData.totalCustomers} total
                            </p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Avg. Duration</CardTitle>
                            <Clock className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{Math.round(analyticsData.averageMeetingDuration)}m</div>
                            <p className="text-xs text-muted-foreground">
                                per appointment
                            </p>
                        </CardContent>
                    </Card>
                </div>

                {/* Charts */}
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                    <LineChart
                        data={analyticsData.monthlyStats.map(stat => ({
                            label: stat.month,
                            value: stat.appointments
                        }))}
                        title="Appointments by Month"
                        color="#3B82F6"
                    />

                    <LineChart
                        data={analyticsData.monthlyStats.map(stat => ({
                            label: stat.month,
                            value: stat.revenue
                        }))}
                        title="Revenue by Month"
                        color="#10B981"
                    />
                </div>

                {/* Top Services */}
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                    <Card>
                        <CardHeader>
                            <CardTitle>Top Services</CardTitle>
                            <CardDescription>Most popular services by appointment count</CardDescription>
                        </CardHeader>
                        <CardContent>
                            <div className="space-y-4">
                                {analyticsData.topServices.map((service, index) => (
                                    <div key={service.service} className="flex items-center justify-between">
                                        <div className="flex items-center space-x-2">
                                            <Badge variant="outline">{index + 1}</Badge>
                                            <span className="font-medium">{service.service}</span>
                                        </div>
                                        <span className="text-sm text-gray-600">{service.count} appointments</span>
                                    </div>
                                ))}
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle>Usage Summary</CardTitle>
                            <CardDescription>Current usage vs. plan limits</CardDescription>
                        </CardHeader>
                        <CardContent>
                            {usageSummary && (
                                <div className="space-y-4">
                                    {Object.entries(usageSummary.limits).map(([key, limit]: [string, any]) => (
                                        <div key={key} className="space-y-2">
                                            <div className="flex justify-between text-sm">
                                                <span className="capitalize">{key}</span>
                                                <span>{limit.current} / {limit.limit === Infinity ? '∞' : limit.limit}</span>
                                            </div>
                                            <div className="w-full bg-gray-200 rounded-full h-2">
                                                <div
                                                    className={`h-2 rounded-full ${limit.exceeded ? 'bg-red-500' :
                                                            limit.percentage > 80 ? 'bg-yellow-500' : 'bg-green-500'
                                                        }`}
                                                    style={{ width: `${Math.min(limit.percentage, 100)}%` }}
                                                />
                                            </div>
                                            {limit.exceeded && (
                                                <p className="text-xs text-red-600">{limit.message}</p>
                                            )}
                                        </div>
                                    ))}
                                </div>
                            )}
                        </CardContent>
                    </Card>
                </div>

                {/* Usage Stats */}
                <Card>
                    <CardHeader>
                        <CardTitle>Usage Statistics</CardTitle>
                        <CardDescription>Platform usage metrics</CardDescription>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <div className="text-center">
                                <div className="text-2xl font-bold text-blue-600">{analyticsData.usageStats.mapLoads}</div>
                                <div className="text-sm text-gray-600">Map Loads</div>
                            </div>
                            <div className="text-center">
                                <div className="text-2xl font-bold text-green-600">{analyticsData.usageStats.meetingsCreated}</div>
                                <div className="text-sm text-gray-600">Meetings Created</div>
                            </div>
                            <div className="text-center">
                                <div className="text-2xl font-bold text-purple-600">{analyticsData.usageStats.customersAdded}</div>
                                <div className="text-sm text-gray-600">Customers Added</div>
                            </div>
                            <div className="text-center">
                                <div className="text-2xl font-bold text-orange-600">{analyticsData.usageStats.staffMembers}</div>
                                <div className="text-sm text-gray-600">Staff Members</div>
                            </div>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </div>
    )
} 