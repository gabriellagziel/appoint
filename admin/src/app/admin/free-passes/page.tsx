"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Gift, Search, UserPlus } from "lucide-react"
import { useState } from "react"

const mockUsers = [
    { id: 1, name: "John Doe", email: "john@example.com", phone: "+1234567890", type: "mobile", status: "active" },
    { id: 2, name: "Jane Smith", email: "jane@example.com", phone: "+1234567891", type: "business", status: "active" },
]

const mockFreePasses = [
    { id: 1, userId: 1, userName: "John Doe", type: "temporary", duration: "30 days", grantedBy: "Admin User", grantedAt: "2024-01-15", expiresAt: "2024-02-15", status: "active" },
    { id: 2, userId: 2, userName: "Jane Smith", type: "lifetime", duration: "Lifetime", grantedBy: "Admin User", grantedAt: "2024-01-10", expiresAt: "Never", status: "active" },
]

export default function FreePassesPage() {
    const [searchTerm, setSearchTerm] = useState("")
    const [selectedUser, setSelectedUser] = useState<any>(null)
    const [passType, setPassType] = useState("temporary")
    const [duration, setDuration] = useState("30")
    const [notes, setNotes] = useState("")
    const [showGrantForm, setShowGrantForm] = useState(false)

    const filteredUsers = mockUsers.filter(user =>
        user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
        user.phone.includes(searchTerm)
    )

    const handleGrantPass = async () => {
        if (!selectedUser) return

        try {
            const response = await fetch('/api/free-passes', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    userId: selectedUser.id,
                    type: passType,
                    duration: passType === "temporary" ? parseInt(duration) : null,
                    notes,
                    grantedBy: "Admin User" // In real app, get from auth context
                }),
            })

            if (response.ok) {
                console.log("Free pass granted successfully")
                // Reset form
                setSelectedUser(null)
                setPassType("temporary")
                setDuration("30")
                setNotes("")
                setShowGrantForm(false)
            } else {
                console.error("Failed to grant free pass")
            }
        } catch (error) {
            console.error("Error granting free pass:", error)
        }
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Free Pass Management</h1>
                    <p className="text-gray-600">Grant free access to mobile app and business users</p>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <Card>
                        <CardHeader>
                            <CardTitle className="flex items-center gap-2">
                                <Search className="h-5 w-5" />
                                Find Users
                            </CardTitle>
                        </CardHeader>
                        <CardContent className="space-y-4">
                            <div className="space-y-2">
                                <Label htmlFor="search">Search Users</Label>
                                <Input
                                    id="search"
                                    placeholder="Search by name, email, or phone..."
                                    value={searchTerm}
                                    onChange={(e) => setSearchTerm(e.target.value)}
                                />
                            </div>

                            <div className="space-y-2">
                                <Label>Users</Label>
                                <div className="max-h-60 overflow-y-auto space-y-2">
                                    {filteredUsers.map((user) => (
                                        <div
                                            key={user.id}
                                            className={`p-3 border rounded-lg cursor-pointer hover:bg-gray-50 ${selectedUser?.id === user.id ? "border-blue-500 bg-blue-50" : ""
                                                }`}
                                            onClick={() => setSelectedUser(user)}
                                        >
                                            <div className="flex justify-between items-start">
                                                <div>
                                                    <div className="font-medium">{user.name}</div>
                                                    <div className="text-sm text-gray-600">{user.email}</div>
                                                    <div className="text-sm text-gray-500">{user.phone}</div>
                                                </div>
                                                <Badge variant={user.type === "business" ? "secondary" : "default"}>
                                                    {user.type}
                                                </Badge>
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            </div>

                            {selectedUser && (
                                <Button onClick={() => setShowGrantForm(true)} className="w-full">
                                    <UserPlus className="h-4 w-4 mr-2" />
                                    Grant Free Pass to {selectedUser.name}
                                </Button>
                            )}
                        </CardContent>
                    </Card>

                    {showGrantForm && selectedUser && (
                        <Card>
                            <CardHeader>
                                <CardTitle className="flex items-center gap-2">
                                    <Gift className="h-5 w-5" />
                                    Grant Free Pass
                                </CardTitle>
                            </CardHeader>
                            <CardContent className="space-y-4">
                                <div className="p-3 bg-blue-50 border border-blue-200 rounded-lg">
                                    <div className="font-medium">{selectedUser.name}</div>
                                    <div className="text-sm text-gray-600">{selectedUser.email}</div>
                                    <div className="text-sm text-gray-500">{selectedUser.phone}</div>
                                </div>

                                <div className="space-y-2">
                                    <Label htmlFor="passType">Pass Type</Label>
                                    <Select value={passType} onValueChange={setPassType}>
                                        <SelectTrigger>
                                            <SelectValue />
                                        </SelectTrigger>
                                        <SelectContent>
                                            <SelectItem value="temporary">Temporary Access</SelectItem>
                                            <SelectItem value="lifetime">Lifetime Access</SelectItem>
                                        </SelectContent>
                                    </Select>
                                </div>

                                {passType === "temporary" && (
                                    <div className="space-y-2">
                                        <Label htmlFor="duration">Duration (days)</Label>
                                        <Select value={duration} onValueChange={setDuration}>
                                            <SelectTrigger>
                                                <SelectValue />
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="7">7 days</SelectItem>
                                                <SelectItem value="14">14 days</SelectItem>
                                                <SelectItem value="30">30 days</SelectItem>
                                                <SelectItem value="60">60 days</SelectItem>
                                                <SelectItem value="90">90 days</SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </div>
                                )}

                                <div className="space-y-2">
                                    <Label htmlFor="notes">Notes (optional)</Label>
                                    <Input
                                        id="notes"
                                        placeholder="Reason for granting free access..."
                                        value={notes}
                                        onChange={(e) => setNotes(e.target.value)}
                                    />
                                </div>

                                <div className="flex gap-2">
                                    <Button onClick={handleGrantPass} className="flex-1">
                                        Grant Free Pass
                                    </Button>
                                    <Button variant="outline" onClick={() => setShowGrantForm(false)}>
                                        Cancel
                                    </Button>
                                </div>
                            </CardContent>
                        </Card>
                    )}
                </div>

                <Card>
                    <CardHeader>
                        <CardTitle>Recent Free Passes</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>User</TableHead>
                                    <TableHead>Type</TableHead>
                                    <TableHead>Duration</TableHead>
                                    <TableHead>Granted By</TableHead>
                                    <TableHead>Granted At</TableHead>
                                    <TableHead>Expires At</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {mockFreePasses.map((pass) => (
                                    <TableRow key={pass.id}>
                                        <TableCell className="font-medium">{pass.userName}</TableCell>
                                        <TableCell>
                                            <Badge variant={pass.type === "lifetime" ? "secondary" : "default"}>
                                                {pass.type}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>{pass.duration}</TableCell>
                                        <TableCell>{pass.grantedBy}</TableCell>
                                        <TableCell>{pass.grantedAt}</TableCell>
                                        <TableCell>{pass.expiresAt}</TableCell>
                                        <TableCell>
                                            <Badge variant={pass.status === "active" ? "default" : "secondary"}>
                                                {pass.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <button className="text-sm text-blue-600 hover:text-blue-800">View</button>
                                                <button className="text-sm text-red-600 hover:text-red-800">Revoke</button>
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