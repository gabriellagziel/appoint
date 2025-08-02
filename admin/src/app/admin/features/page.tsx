"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { AlertCircle, CheckCircle, Flag, ToggleLeft, TrendingUp, Users } from "lucide-react"
import { useState } from "react"

// Mock feature flags data
const mockFeatureFlags = [
    {
        id: 1,
        name: "new_booking_ui",
        description: "Enhanced booking interface with improved UX",
        status: "enabled",
        rolloutPercentage: 100,
        targetAudience: "all_users",
        createdAt: "2024-01-15",
        lastModified: "2024-01-20",
        environment: "production"
    },
    {
        id: 2,
        name: "ai_recommendations",
        description: "AI-powered appointment recommendations",
        status: "gradual_rollout",
        rolloutPercentage: 25,
        targetAudience: "premium_users",
        createdAt: "2024-01-10",
        lastModified: "2024-01-18",
        environment: "production"
    },
    {
        id: 3,
        name: "dark_mode",
        description: "Dark theme for mobile app",
        status: "disabled",
        rolloutPercentage: 0,
        targetAudience: "mobile_users",
        createdAt: "2024-01-05",
        lastModified: "2024-01-15",
        environment: "staging"
    }
]

const mockRolloutHistory = [
    {
        feature: "new_booking_ui",
        action: "enabled",
        percentage: 100,
        timestamp: "2024-01-20 10:30",
        user: "admin@app-oint.com"
    },
    {
        feature: "ai_recommendations",
        action: "gradual_rollout",
        percentage: 25,
        timestamp: "2024-01-18 14:15",
        user: "admin@app-oint.com"
    },
    {
        feature: "dark_mode",
        action: "disabled",
        percentage: 0,
        timestamp: "2024-01-15 09:45",
        user: "admin@app-oint.com"
    }
]

export default function FeatureFlagsPage() {
    const [selectedStatus, setSelectedStatus] = useState("all")
    const [selectedEnvironment, setSelectedEnvironment] = useState("all")

    const filteredFlags = mockFeatureFlags.filter(flag => {
        if (selectedStatus !== "all" && flag.status !== selectedStatus) return false
        if (selectedEnvironment !== "all" && flag.environment !== selectedEnvironment) return false
        return true
    })

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Feature Flags & Rollouts</h1>
                    <p className="text-gray-600">Manage feature toggles and gradual rollouts</p>
                </div>

                {/* Feature Flags Stats */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Features</CardTitle>
                            <Flag className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">15</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +3 this month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Enabled Features</CardTitle>
                            <CheckCircle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">8</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                53% of total
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Gradual Rollouts</CardTitle>
                            <ToggleLeft className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">4</div>
                            <div className="flex items-center text-xs text-orange-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                In progress
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Disabled Features</CardTitle>
                            <AlertCircle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">3</div>
                            <div className="flex items-center text-xs text-red-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                20% of total
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Feature Flags Management */}
                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                            <CardTitle>Feature Flags</CardTitle>
                            <div className="flex space-x-2">
                                <Select value={selectedStatus} onValueChange={setSelectedStatus}>
                                    <SelectTrigger className="w-32">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Status</SelectItem>
                                        <SelectItem value="enabled">Enabled</SelectItem>
                                        <SelectItem value="gradual_rollout">Gradual Rollout</SelectItem>
                                        <SelectItem value="disabled">Disabled</SelectItem>
                                    </SelectContent>
                                </Select>
                                <Select value={selectedEnvironment} onValueChange={setSelectedEnvironment}>
                                    <SelectTrigger className="w-32">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Environments</SelectItem>
                                        <SelectItem value="production">Production</SelectItem>
                                        <SelectItem value="staging">Staging</SelectItem>
                                        <SelectItem value="development">Development</SelectItem>
                                    </SelectContent>
                                </Select>
                                <Button>
                                    <Flag className="h-4 w-4 mr-2" />
                                    Add Feature Flag
                                </Button>
                            </div>
                        </div>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Feature Name</TableHead>
                                    <TableHead>Description</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Rollout %</TableHead>
                                    <TableHead>Target Audience</TableHead>
                                    <TableHead>Environment</TableHead>
                                    <TableHead>Last Modified</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredFlags.map((flag) => (
                                    <TableRow key={flag.id}>
                                        <TableCell className="font-medium">{flag.name}</TableCell>
                                        <TableCell>{flag.description}</TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                flag.status === "enabled" ? "default" :
                                                    flag.status === "gradual_rollout" ? "secondary" : "outline"
                                            }>
                                                {flag.status.replace('_', ' ')}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>
                                            <div className="flex items-center space-x-2">
                                                <div className="w-full bg-gray-200 rounded-full h-2">
                                                    <div
                                                        className="bg-blue-600 h-2 rounded-full"
                                                        style={{ width: `${flag.rolloutPercentage}%` }}
                                                    ></div>
                                                </div>
                                                <span className="text-sm">{flag.rolloutPercentage}%</span>
                                            </div>
                                        </TableCell>
                                        <TableCell>{flag.targetAudience.replace('_', ' ')}</TableCell>
                                        <TableCell>
                                            <Badge variant="outline">{flag.environment}</Badge>
                                        </TableCell>
                                        <TableCell>{flag.lastModified}</TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <button className="text-sm text-blue-600 hover:text-blue-800">Edit</button>
                                                <button className="text-sm text-orange-600 hover:text-orange-800">Toggle</button>
                                                <button className="text-sm text-red-600 hover:text-red-800">Delete</button>
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Rollout History */}
                <Card>
                    <CardHeader>
                        <CardTitle>Rollout History</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Feature</TableHead>
                                    <TableHead>Action</TableHead>
                                    <TableHead>Percentage</TableHead>
                                    <TableHead>Timestamp</TableHead>
                                    <TableHead>User</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {mockRolloutHistory.map((rollout, index) => (
                                    <TableRow key={index}>
                                        <TableCell className="font-medium">{rollout.feature}</TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                rollout.action === "enabled" ? "default" :
                                                    rollout.action === "gradual_rollout" ? "secondary" : "outline"
                                            }>
                                                {rollout.action.replace('_', ' ')}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{rollout.percentage}%</TableCell>
                                        <TableCell>{rollout.timestamp}</TableCell>
                                        <TableCell>{rollout.user}</TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Feature Flag Tools */}
                <Card>
                    <CardHeader>
                        <CardTitle>Feature Flag Tools</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div className="space-y-4">
                                <h3 className="font-semibold">Rollout Management</h3>
                                <div className="space-y-2">
                                    <Button variant="outline" className="w-full">
                                        <ToggleLeft className="h-4 w-4 mr-2" />
                                        Gradual Rollout
                                    </Button>
                                    <Button variant="outline" className="w-full">
                                        <Users className="h-4 w-4 mr-2" />
                                        Target Specific Users
                                    </Button>
                                </div>
                            </div>

                            <div className="space-y-4">
                                <h3 className="font-semibold">Monitoring</h3>
                                <div className="space-y-2">
                                    <Button variant="outline" className="w-full">
                                        <TrendingUp className="h-4 w-4 mr-2" />
                                        Feature Analytics
                                    </Button>
                                    <Button variant="outline" className="w-full">
                                        <AlertCircle className="h-4 w-4 mr-2" />
                                        Error Monitoring
                                    </Button>
                                </div>
                            </div>

                            <div className="space-y-4">
                                <h3 className="font-semibold">Safety</h3>
                                <div className="space-y-2">
                                    <Button variant="outline" className="w-full">
                                        <CheckCircle className="h-4 w-4 mr-2" />
                                        Emergency Rollback
                                    </Button>
                                    <Button variant="outline" className="w-full">
                                        <Flag className="h-4 w-4 mr-2" />
                                        Feature Dependencies
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
                                    <Flag className="h-6 w-6 mx-auto mb-2" />
                                    <div>Add Feature</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <ToggleLeft className="h-6 w-6 mx-auto mb-2" />
                                    <div>Toggle Feature</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Users className="h-6 w-6 mx-auto mb-2" />
                                    <div>Target Users</div>
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