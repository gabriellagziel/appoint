"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Progress } from "@/components/ui/progress"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Activity, AlertTriangle, CheckCircle, Clock, Database, Server, Users } from "lucide-react"
import { useState } from "react"

// Mock system data
const mockSystemStatus = {
  overall: "healthy",
  uptime: "99.9%",
  lastIncident: "2024-01-10 14:30",
  activeUsers: 1247,
  cpuUsage: 45,
  memoryUsage: 62,
  diskUsage: 78,
  networkLatency: 120,
}

const mockServices = [
  { name: "API Gateway", status: "healthy", responseTime: 45, uptime: "99.9%" },
  { name: "Database", status: "healthy", responseTime: 12, uptime: "99.8%" },
  { name: "Authentication", status: "healthy", responseTime: 23, uptime: "99.9%" },
  { name: "File Storage", status: "warning", responseTime: 156, uptime: "98.5%" },
  { name: "Email Service", status: "healthy", responseTime: 89, uptime: "99.7%" },
  { name: "Analytics", status: "healthy", responseTime: 34, uptime: "99.6%" },
]

const mockAlerts = [
  { id: 1, type: "warning", message: "High disk usage on server-03", timestamp: "2024-01-15 10:30", resolved: false },
  { id: 2, type: "info", message: "Scheduled maintenance completed", timestamp: "2024-01-15 09:00", resolved: true },
  { id: 3, type: "error", message: "Database connection timeout", timestamp: "2024-01-15 08:45", resolved: true },
]

export default function SystemPage() {
  const [maintenanceMode, setMaintenanceMode] = useState(false)

  const getStatusColor = (status: string) => {
    switch (status) {
      case "healthy": return "default"
      case "warning": return "secondary"
      case "error": return "destructive"
      default: return "default"
    }
  }

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "healthy": return <CheckCircle className="h-4 w-4 text-green-500" />
      case "warning": return <AlertTriangle className="h-4 w-4 text-yellow-500" />
      case "error": return <AlertTriangle className="h-4 w-4 text-red-500" />
      default: return <Clock className="h-4 w-4 text-gray-500" />
    }
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">System Monitoring</h1>
            <p className="text-gray-600">Monitor system health, performance, and alerts</p>
          </div>
          <div className="flex items-center gap-4">
            <Button
              variant={maintenanceMode ? "destructive" : "outline"}
              onClick={() => setMaintenanceMode(!maintenanceMode)}
            >
              {maintenanceMode ? "Disable" : "Enable"} Maintenance Mode
            </Button>
            <Button variant="outline">
              <Activity className="h-4 w-4 mr-2" />
              Refresh
            </Button>
          </div>
        </div>

        {/* System Overview */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">System Status</CardTitle>
              <div className="flex items-center gap-2">
                {getStatusIcon(mockSystemStatus.overall)}
                <Badge variant={getStatusColor(mockSystemStatus.overall)}>
                  {mockSystemStatus.overall}
                </Badge>
              </div>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{mockSystemStatus.uptime}</div>
              <p className="text-xs text-gray-500">Uptime</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Active Users</CardTitle>
              <Users className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{mockSystemStatus.activeUsers}</div>
              <p className="text-xs text-gray-500">Currently online</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">CPU Usage</CardTitle>
              <Server className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{mockSystemStatus.cpuUsage}%</div>
              <Progress value={mockSystemStatus.cpuUsage} className="mt-2" />
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Memory Usage</CardTitle>
              <Database className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{mockSystemStatus.memoryUsage}%</div>
              <Progress value={mockSystemStatus.memoryUsage} className="mt-2" />
            </CardContent>
          </Card>
        </div>

        {/* Services Status */}
        <Card>
          <CardHeader>
            <CardTitle>Service Status</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Service</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Response Time</TableHead>
                  <TableHead>Uptime</TableHead>
                  <TableHead>Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {mockServices.map((service) => (
                  <TableRow key={service.name}>
                    <TableCell className="font-medium">{service.name}</TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        {getStatusIcon(service.status)}
                        <Badge variant={getStatusColor(service.status)}>
                          {service.status}
                        </Badge>
                      </div>
                    </TableCell>
                    <TableCell>{service.responseTime}ms</TableCell>
                    <TableCell>{service.uptime}</TableCell>
                    <TableCell>
                      <Button variant="outline" size="sm">
                        Details
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        {/* Recent Alerts */}
        <Card>
          <CardHeader>
            <CardTitle>Recent Alerts</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {mockAlerts.map((alert) => (
                <div key={alert.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div className="flex items-center gap-3">
                    {getStatusIcon(alert.type)}
                    <div>
                      <p className="font-medium">{alert.message}</p>
                      <p className="text-sm text-gray-500">{alert.timestamp}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    <Badge variant={alert.resolved ? "default" : "secondary"}>
                      {alert.resolved ? "Resolved" : "Active"}
                    </Badge>
                    {!alert.resolved && (
                      <Button variant="outline" size="sm">
                        Resolve
                      </Button>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Performance Metrics */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <Card>
            <CardHeader>
              <CardTitle>Disk Usage</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div>
                  <div className="flex justify-between text-sm">
                    <span>Used</span>
                    <span>{mockSystemStatus.diskUsage}%</span>
                  </div>
                  <Progress value={mockSystemStatus.diskUsage} className="mt-2" />
                </div>
                <div className="text-sm text-gray-500">
                  782 GB used of 1 TB total
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Network Latency</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="text-2xl font-bold">{mockSystemStatus.networkLatency}ms</div>
                <div className="text-sm text-gray-500">
                  Average response time across all regions
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </AdminLayout>
  )
} 