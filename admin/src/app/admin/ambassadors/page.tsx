"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Activity, Award, Globe, TrendingUp, Users2 } from "lucide-react"
import { useState } from "react"

// Mock ambassador data
const mockAmbassadors = [
    { id: 1, name: "John Smith", country: "US", language: "en", status: "active", referrals: 15, score: 4.8, joinedAt: "2024-01-15" },
    { id: 2, name: "Maria Garcia", country: "ES", language: "es", status: "active", referrals: 12, score: 4.9, joinedAt: "2024-01-20" },
    { id: 3, name: "Hans Mueller", country: "DE", language: "de", status: "active", referrals: 18, score: 4.7, joinedAt: "2024-01-10" },
    { id: 4, name: "Pierre Dubois", country: "FR", language: "fr", status: "inactive", referrals: 8, score: 4.2, joinedAt: "2024-01-05" },
]

const mockQuotas = {
    "US_en": { quota: 345, current: 289, utilization: 83.8 },
    "ES_es": { quota: 220, current: 187, utilization: 85.0 },
    "DE_de": { quota: 133, current: 112, utilization: 84.2 },
    "FR_fr": { quota: 142, current: 98, utilization: 69.0 },
}

export default function AmbassadorsPage() {
    const [selectedCountry, setSelectedCountry] = useState("all")
    const [selectedStatus, setSelectedStatus] = useState("all")

    const filteredAmbassadors = mockAmbassadors.filter(ambassador => {
        if (selectedCountry !== "all" && ambassador.country !== selectedCountry) return false
        if (selectedStatus !== "all" && ambassador.status !== selectedStatus) return false
        return true
    })

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Ambassador Program</h1>
                    <p className="text-gray-600">Manage and monitor the global ambassador program</p>
                </div>

                {/* Stats Cards */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Ambassadors</CardTitle>
                            <Users2 className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">1,247</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +12.5% from last month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Ambassadors</CardTitle>
                            <Activity className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">1,089</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                87.3% active rate
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Global Quota</CardTitle>
                            <Globe className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">6,675</div>
                            <div className="flex items-center text-xs text-blue-600">
                                18.7% utilization
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Avg Score</CardTitle>
                            <Award className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">4.7</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +0.2 from last month
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
                                <Label htmlFor="country">Country</Label>
                                <Select value={selectedCountry} onValueChange={setSelectedCountry}>
                                    <SelectTrigger>
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Countries</SelectItem>
                                        <SelectItem value="US">United States</SelectItem>
                                        <SelectItem value="ES">Spain</SelectItem>
                                        <SelectItem value="DE">Germany</SelectItem>
                                        <SelectItem value="FR">France</SelectItem>
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
                                        <SelectItem value="inactive">Inactive</SelectItem>
                                        <SelectItem value="suspended">Suspended</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="search">Search</Label>
                                <Input placeholder="Search ambassadors..." />
                            </div>
                        </div>
                    </CardContent>
                </Card>

                {/* Quota Overview */}
                <Card>
                    <CardHeader>
                        <CardTitle>Quota Overview</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Country</TableHead>
                                    <TableHead>Language</TableHead>
                                    <TableHead>Quota</TableHead>
                                    <TableHead>Current</TableHead>
                                    <TableHead>Utilization</TableHead>
                                    <TableHead>Status</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {Object.entries(mockQuotas).map(([key, data]) => {
                                    const [country, language] = key.split('_')
                                    return (
                                        <TableRow key={key}>
                                            <TableCell className="font-medium">{country}</TableCell>
                                            <TableCell>{language.toUpperCase()}</TableCell>
                                            <TableCell>{data.quota}</TableCell>
                                            <TableCell>{data.current}</TableCell>
                                            <TableCell>{data.utilization}%</TableCell>
                                            <TableCell>
                                                <Badge variant={data.utilization > 80 ? "destructive" : "default"}>
                                                    {data.utilization > 80 ? "High" : "Normal"}
                                                </Badge>
                                            </TableCell>
                                        </TableRow>
                                    )
                                })}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Ambassadors Table */}
                <Card>
                    <CardHeader>
                        <CardTitle>Ambassadors</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Name</TableHead>
                                    <TableHead>Country</TableHead>
                                    <TableHead>Language</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Referrals</TableHead>
                                    <TableHead>Score</TableHead>
                                    <TableHead>Joined</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredAmbassadors.map((ambassador) => (
                                    <TableRow key={ambassador.id}>
                                        <TableCell className="font-medium">{ambassador.name}</TableCell>
                                        <TableCell>{ambassador.country}</TableCell>
                                        <TableCell>{ambassador.language.toUpperCase()}</TableCell>
                                        <TableCell>
                                            <Badge variant={ambassador.status === "active" ? "default" : "secondary"}>
                                                {ambassador.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{ambassador.referrals}</TableCell>
                                        <TableCell>{ambassador.score}</TableCell>
                                        <TableCell>{ambassador.joinedAt}</TableCell>
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
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Users2 className="h-6 w-6 mx-auto mb-2" />
                                    <div>Add Ambassador</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Award className="h-6 w-6 mx-auto mb-2" />
                                    <div>Review Applications</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Activity className="h-6 w-6 mx-auto mb-2" />
                                    <div>Performance Report</div>
                                </div>
                            </Button>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
} 