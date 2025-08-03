"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Progress } from "@/components/ui/progress"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import {
    Activity,
    AlertTriangle,
    CheckCircle,
    TrendingDown,
    TrendingUp
} from "lucide-react"
import { useState } from "react"

interface SystemMetric {
    name: string
    value: number
    unit: string
    status: 'healthy' | 'warning' | 'critical'
    trend: 'up' | 'down' | 'stable'
    lastUpdated: string
}

interface Quota {
    service: string
    used: number
    limit: number
    unit: string
    percentage: number
    status: 'healthy' | 'warning' | 'critical'
}

const mockSystemMetrics: SystemMetric[] = [
    {
        name: "CPU Usage",
        value: 45,
        unit: "%",
        status: "healthy",
        trend: "up",
        lastUpdated: "2024-01-15T10:30:00Z"
    },
    {
        name: "Memory Usage",
        value: 78,
        unit: "%",
        status: "warning",
        trend: "up",
        lastUpdated: "2024-01-15T10:30:00Z"
    },
    {
        name: "Disk Usage",
        value: 65,
        unit: "%",
        status: "healthy",
        trend: "stable",
        lastUpdated: "2024-01-15T10:30:00Z"
    },
    {
        name: "Network I/O",
        value: 2.3,
        unit: "GB/s",
        status: "healthy",
        trend: "down",
        lastUpdated: "2024-01-15T10:30:00Z"
    }
]

const mockQuotas: Quota[] = [
    {
        service: "Database Connections",
        used: 850,
        limit: 1000,
        unit: "connections",
        percentage: 85,
        status: "warning"
    },
    {
        service: "API Requests",
        used: 45000,
        limit: 50000,
        unit: "requests/hour",
        percentage: 90,
        status: "warning"
    },
    {
        service: "Storage",
        used: 750,
        limit: 1000,
        unit: "GB",
        percentage: 75,
        status: "healthy"
    },
    {
        service: "Email Sends",
        used: 8000,
        limit: 10000,
        unit: "emails/day",
        percentage: 80,
        status: "healthy"
    }
]

const mockUptime = {
    current: "99.98%",
    last24h: "100%",
    last7d: "99.95%",
    last30d: "99.92%"
}

const mockAlerts = [
    {
        id: "1",
        type: "warning",
        message: "Memory usage approaching 80%",
        timestamp: "2024-01-15T10:25:00Z",
        resolved: false
    },
    {
        id: "2",
        type: "info",
        message: "Database backup completed successfully",
        timestamp: "2024-01-15T09:00:00Z",
        resolved: true
    },
    {
        id: "3",
        type: "critical",
        message: "High CPU usage detected on server-02",
        timestamp: "2024-01-15T08:45:00Z",
        resolved: false
    }
]

export default function SystemPage() {
    const [metrics] = useState<SystemMetric[]>(mockSystemMetrics)
    const [quotas] = useState<Quota[]>(mockQuotas)
    const [alerts] = useState(mockAlerts)

    const getStatusIcon = (status: string) => {
        switch (status) {
            case 'healthy': return <CheckCircle className="h-4 w-4 text-green-600" />
            case 'warning': return <AlertTriangle className="h-4 w-4 text-yellow-600" />
            case 'critical': return <AlertTriangle className="h-4 w-4 text-red-600" />
            default: return <Activity className="h-4 w-4 text-gray-600" />
        }
    }

    const getTrendIcon = (trend: string) => {
        switch (trend) {
            case 'up': return <TrendingUp className="h-4 w-4 text-red-600" />
            case 'down': return <TrendingDown className="h-4 w-4 text-green-600" />
            default: return <Activity className="h-4 w-4 text-gray-600" />
        }
    }

    const getStatusBadge = (status: string) => {
        const colors = {
            healthy: "bg-green-100 text-green-800",
            warning: "bg-yellow-100 text-yellow-800",
            critical: "bg-red-100 text-red-800"
        }
        return <Badge className={colors[status as keyof typeof colors]}>{status}</Badge>
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">System Monitoring</h1>
                    <p className="text-gray-600">Monitor server health, quotas, and system performance</p>
                </div>

                {/* Uptime Overview */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Current Uptime</CardTitle>
                            <CheckCircle className="h-4 w-4 text-green-600" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{mockUptime.current}</div>
                            <p className="text-xs text-muted-foreground">
                                Last 24h: {mockUptime.last24h}
                            </p>
                        </CardContent>
                    </Card>
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Last 7 Days</CardTitle>
                            <Activity className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{mockUptime.last7d}</div>
                            <p className="text-xs text-muted-foreground">
                                Stable performance
                            </p>
                        </CardContent>
                    </Card>
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Last 30 Days</CardTitle>
                            <Activity className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{mockUptime.last30d}</div>
                            <p className="text-xs text-muted-foreground">
                                Minor downtime
                            </p>
                        </CardContent>
                    </Card>
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Alerts</CardTitle>
                            <AlertTriangle className="h-4 w-4 text-yellow-600" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{alerts.filter(a => !a.resolved).length}</div>
                            <p className="text-xs text-muted-foreground">
                                Requires attention
                            </p>
                        </CardContent>
                    </Card>
                </div>

                <Tabs defaultValue="metrics" className="space-y-6">
                    <TabsList>
                        <TabsTrigger value="metrics">System Metrics</TabsTrigger>
                        <TabsTrigger value="quotas">Quotas</TabsTrigger>
                        <TabsTrigger value="alerts">Alerts</TabsTrigger>
                        <TabsTrigger value="logs">System Logs</TabsTrigger>
                    </TabsList>

                    <TabsContent value="metrics">
                        <Card>
                            <CardHeader>
                                <CardTitle>Real-time System Metrics</CardTitle>
                            </CardHeader>
                            <CardContent>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    {metrics.map((metric) => (
                                        <div key={metric.name} className="space-y-2">
                                            <div className="flex items-center justify-between">
                                                <span className="text-sm font-medium">{metric.name}</span>
                                                <div className="flex items-center space-x-2">
                                                    {getStatusIcon(metric.status)}
                                                    {getTrendIcon(metric.trend)}
                                                </div>
                                            </div>
                                            <div className="flex items-center space-x-2">
                                                <span className="text-2xl font-bold">{metric.value}</span>
                                                <span className="text-sm text-muted-foreground">{metric.unit}</span>
                                            </div>
                                            <Progress value={metric.value} className="w-full" />
                                            <p className="text-xs text-muted-foreground">
                                                Updated: {new Date(metric.lastUpdated).toLocaleTimeString()}
                                            </p>
                                        </div>
                                    ))}
                                </div>
                            </CardContent>
                        </Card>
                    </TabsContent>

                    <TabsContent value="quotas">
                        <Card>
                            <CardHeader>
                                <CardTitle>Service Quotas</CardTitle>
                            </CardHeader>
                            <CardContent>
                                <Table>
                                    <TableHeader>
                                        <TableRow>
                                            <TableHead>Service</TableHead>
                                            <TableHead>Usage</TableHead>
                                            <TableHead>Limit</TableHead>
                                            <TableHead>Percentage</TableHead>
                                            <TableHead>Status</TableHead>
                                        </TableRow>
                                    </TableHeader>
                                    <TableBody>
                                        {quotas.map((quota) => (
                                            <TableRow key={quota.service}>
                                                <TableCell className="font-medium">{quota.service}</TableCell>
                                                <TableCell>{quota.used.toLocaleString()} {quota.unit}</TableCell>
                                                <TableCell>{quota.limit.toLocaleString()} {quota.unit}</TableCell>
                                                <TableCell>
                                                    <div className="flex items-center space-x-2">
                                                        <Progress value={quota.percentage} className="w-20" />
                                                        <span className="text-sm">{quota.percentage}%</span>
                                                    </div>
                                                </TableCell>
                                                <TableCell>{getStatusBadge(quota.status)}</TableCell>
                                            </TableRow>
                                        ))}
                                    </TableBody>
                                </Table>
                            </CardContent>
                        </Card>
                    </TabsContent>

                    <TabsContent value="alerts">
                        <Card>
                            <CardHeader>
                                <CardTitle>System Alerts</CardTitle>
                            </CardHeader>
                            <CardContent>
                                <div className="space-y-4">
                                    {alerts.map((alert) => (
                                        <div key={alert.id} className={`p-4 rounded-lg border ${alert.type === 'critical' ? 'border-red-200 bg-red-50' :
                                                alert.type === 'warning' ? 'border-yellow-200 bg-yellow-50' :
                                                    'border-blue-200 bg-blue-50'
                                            }`}>
                                            <div className="flex items-start justify-between">
                                                <div className="flex items-start space-x-3">
                                                    {alert.type === 'critical' ? (
                                                        <AlertTriangle className="h-5 w-5 text-red-600 mt-0.5" />
                                                    ) : alert.type === 'warning' ? (
                                                        <AlertTriangle className="h-5 w-5 text-yellow-600 mt-0.5" />
                                                    ) : (
                                                        <CheckCircle className="h-5 w-5 text-blue-600 mt-0.5" />
                                                    )}
                                                    <div>
                                                        <p className="text-sm font-medium">{alert.message}</p>
                                                        <p className="text-xs text-muted-foreground mt-1">
                                                            {new Date(alert.timestamp).toLocaleString()}
                                                        </p>
                                                    </div>
                                                </div>
                                                <Badge variant={alert.resolved ? "default" : "secondary"}>
                                                    {alert.resolved ? "Resolved" : "Active"}
                                                </Badge>
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            </CardContent>
                        </Card>
                    </TabsContent>

                    <TabsContent value="logs">
                        <Card>
                            <CardHeader>
                                <CardTitle>Recent System Logs</CardTitle>
                            </CardHeader>
                            <CardContent>
                                <div className="space-y-2">
                                    <div className="flex items-center space-x-2 text-sm">
                                        <span className="text-green-600">●</span>
                                        <span className="text-muted-foreground">2024-01-15 10:30:15</span>
                                        <span className="font-mono">INFO</span>
                                        <span>System metrics collected successfully</span>
                                    </div>
                                    <div className="flex items-center space-x-2 text-sm">
                                        <span className="text-yellow-600">●</span>
                                        <span className="text-muted-foreground">2024-01-15 10:25:30</span>
                                        <span className="font-mono">WARN</span>
                                        <span>Memory usage approaching threshold (78%)</span>
                                    </div>
                                    <div className="flex items-center space-x-2 text-sm">
                                        <span className="text-blue-600">●</span>
                                        <span className="text-muted-foreground">2024-01-15 10:20:45</span>
                                        <span className="font-mono">INFO</span>
                                        <span>Database backup completed</span>
                                    </div>
                                    <div className="flex items-center space-x-2 text-sm">
                                        <span className="text-red-600">●</span>
                                        <span className="text-muted-foreground">2024-01-15 08:45:12</span>
                                        <span className="font-mono">ERROR</span>
                                        <span>High CPU usage detected on server-02</span>
                                    </div>
                                </div>
                            </CardContent>
                        </Card>
                    </TabsContent>
                </Tabs>
            </div>
        </AdminLayout>
    )
} 