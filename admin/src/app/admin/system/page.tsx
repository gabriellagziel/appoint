"use client"

import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
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
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
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
              <Users className="h-4 w-4 text-gray-400" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{mockSystemStatus.activeUsers.toLocaleString()}</div>
              <p className="text-xs text-gray-500">Current online users</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">CPU Usage</CardTitle>
              <Server className="h-4 w-4 text-gray-400" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{mockSystemStatus.cpuUsage}%</div>
              <p className="text-xs text-gray-500">Average CPU usage</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Memory Usage</CardTitle>
              <Database className="h-4 w-4 text-gray-400" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{mockSystemStatus.memoryUsage}%</div>
              <p className="text-xs text-gray-500">RAM utilization</p>
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
                  <Badge variant={alert.resolved ? "default" : "secondary"}>
                    {alert.resolved ? "Resolved" : "Active"}
                  </Badge>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
} 