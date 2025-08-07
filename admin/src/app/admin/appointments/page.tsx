"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Calendar, Clock, MapPin, Search, User } from "lucide-react"
import { useState } from "react"

// Mock appointment data
const mockAppointments = [
    {
        id: 1,
        businessName: "Downtown Dental",
        customerName: "John Smith",
        service: "Dental Cleaning",
        date: "2024-01-20",
        time: "10:00 AM",
        duration: "60 min",
        status: "confirmed",
        location: "123 Main St, Downtown",
        price: "$150",
        notes: "First time patient"
    },
    {
        id: 2,
        businessName: "City Spa",
        customerName: "Sarah Johnson",
        service: "Massage Therapy",
        date: "2024-01-20",
        time: "2:30 PM",
        duration: "90 min",
        status: "pending",
        location: "456 Oak Ave, Midtown",
        price: "$120",
        notes: "Deep tissue massage requested"
    },
    {
        id: 3,
        businessName: "Tech Solutions",
        customerName: "Mike Davis",
        service: "IT Consultation",
        date: "2024-01-21",
        time: "9:00 AM",
        duration: "120 min",
        status: "cancelled",
        location: "789 Tech Blvd, Business District",
        price: "$200",
        notes: "Network troubleshooting"
    },
    {
        id: 4,
        businessName: "Green Gardens",
        customerName: "Lisa Wilson",
        service: "Landscape Design",
        date: "2024-01-21",
        time: "1:00 PM",
        duration: "180 min",
        status: "confirmed",
        location: "321 Garden St, Suburbs",
        price: "$300",
        notes: "Complete backyard redesign"
    },
    {
        id: 5,
        businessName: "Legal Associates",
        customerName: "Robert Brown",
        service: "Legal Consultation",
        date: "2024-01-22",
        time: "11:00 AM",
        duration: "60 min",
        status: "confirmed",
        location: "555 Law Ave, Downtown",
        price: "$250",
        notes: "Contract review"
    }
]

export default function AppointmentsPage() {
    const [filterStatus, setFilterStatus] = useState("all")
    const [filterDate, setFilterDate] = useState("all")
    const [searchTerm, setSearchTerm] = useState("")

    const getStatusColor = (status: string) => {
        switch (status) {
            case "confirmed": return "default"
            case "pending": return "secondary"
            case "cancelled": return "destructive"
            case "completed": return "default"
            default: return "default"
        }
    }

    const filteredAppointments = mockAppointments.filter(appointment => {
        if (filterStatus !== "all" && appointment.status !== filterStatus) return false
        if (searchTerm && !appointment.customerName.toLowerCase().includes(searchTerm.toLowerCase()) &&
            !appointment.businessName.toLowerCase().includes(searchTerm.toLowerCase())) return false
        return true
    })

    const handleViewDetails = (appointmentId: number) => {
        console.log(`Viewing appointment ${appointmentId}`)
    }

    const handleCancelAppointment = (appointmentId: number) => {
        console.log(`Cancelling appointment ${appointmentId}`)
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Appointment Management</h1>
                    <p className="text-gray-600">Monitor and manage all appointments across the platform</p>
                </div>

                {/* Stats */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Appointments</CardTitle>
                            <Calendar className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">{mockAppointments.length}</div>
                            <p className="text-xs text-gray-500">All time</p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Confirmed</CardTitle>
                            <Clock className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">
                                {mockAppointments.filter(a => a.status === "confirmed").length}
                            </div>
                            <p className="text-xs text-gray-500">Today</p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Pending</CardTitle>
                            <Clock className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">
                                {mockAppointments.filter(a => a.status === "pending").length}
                            </div>
                            <p className="text-xs text-gray-500">Awaiting confirmation</p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Cancelled</CardTitle>
                            <Clock className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">
                                {mockAppointments.filter(a => a.status === "cancelled").length}
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
                                        <SelectItem value="confirmed">Confirmed</SelectItem>
                                        <SelectItem value="pending">Pending</SelectItem>
                                        <SelectItem value="cancelled">Cancelled</SelectItem>
                                        <SelectItem value="completed">Completed</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                            <div className="flex-1">
                                <label className="text-sm font-medium">Date Range</label>
                                <Select value={filterDate} onValueChange={setFilterDate}>
                                    <SelectTrigger>
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Dates</SelectItem>
                                        <SelectItem value="today">Today</SelectItem>
                                        <SelectItem value="tomorrow">Tomorrow</SelectItem>
                                        <SelectItem value="week">This Week</SelectItem>
                                        <SelectItem value="month">This Month</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                            <div className="flex-1">
                                <label className="text-sm font-medium">Search</label>
                                <div className="relative">
                                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                                    <Input
                                        placeholder="Search appointments..."
                                        value={searchTerm}
                                        onChange={(e) => setSearchTerm(e.target.value)}
                                        className="pl-10"
                                    />
                                </div>
                            </div>
                        </div>
                    </CardContent>
                </Card>

                {/* Appointments Table */}
                <Card>
                    <CardHeader>
                        <CardTitle>Appointments</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>ID</TableHead>
                                    <TableHead>Business</TableHead>
                                    <TableHead>Customer</TableHead>
                                    <TableHead>Service</TableHead>
                                    <TableHead>Date & Time</TableHead>
                                    <TableHead>Duration</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Price</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredAppointments.map((appointment) => (
                                    <TableRow key={appointment.id}>
                                        <TableCell className="font-medium">#{appointment.id}</TableCell>
                                        <TableCell>
                                            <div className="font-medium">{appointment.businessName}</div>
                                            <div className="flex items-center text-sm text-gray-500">
                                                <MapPin className="h-3 w-3 mr-1" />
                                                {appointment.location}
                                            </div>
                                        </TableCell>
                                        <TableCell>
                                            <div className="flex items-center">
                                                <User className="h-4 w-4 mr-2" />
                                                {appointment.customerName}
                                            </div>
                                        </TableCell>
                                        <TableCell>{appointment.service}</TableCell>
                                        <TableCell>
                                            <div>
                                                <div className="font-medium">{appointment.date}</div>
                                                <div className="text-sm text-gray-500">{appointment.time}</div>
                                            </div>
                                        </TableCell>
                                        <TableCell>{appointment.duration}</TableCell>
                                        <TableCell>
                                            <Badge variant={getStatusColor(appointment.status)}>
                                                {appointment.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{appointment.price}</TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <Button
                                                    variant="outline"
                                                    size="sm"
                                                    onClick={() => handleViewDetails(appointment.id)}
                                                >
                                                    View
                                                </Button>
                                                {appointment.status === "pending" && (
                                                    <Button
                                                        variant="outline"
                                                        size="sm"
                                                        onClick={() => handleCancelAppointment(appointment.id)}
                                                    >
                                                        Cancel
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