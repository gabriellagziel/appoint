"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { AlertCircle, CheckCircle, MessageSquare, Send, TrendingUp, Users } from "lucide-react"

export default function CommunicationPage() {
    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Admin Communication</h1>
                    <p className="text-gray-600">Manage internal admin communications and announcements</p>
                </div>

                {/* Communication Stats */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Messages</CardTitle>
                            <MessageSquare className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">156</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +12 this month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Announcements</CardTitle>
                            <Send className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">8</div>
                            <div className="flex items-center text-xs text-green-600">
                                <CheckCircle className="h-3 w-3 mr-1" />
                                All up to date
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Unread Messages</CardTitle>
                            <AlertCircle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">3</div>
                            <div className="flex items-center text-xs text-orange-600">
                                <AlertCircle className="h-3 w-3 mr-1" />
                                Requires attention
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Admin Team</CardTitle>
                            <Users className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">12</div>
                            <div className="flex items-center text-xs text-blue-600">
                                <Users className="h-3 w-3 mr-1" />
                                Active members
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Announcements Table */}
                <Card>
                    <CardHeader>
                        <CardTitle>Recent Announcements</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Title</TableHead>
                                    <TableHead>Type</TableHead>
                                    <TableHead>Priority</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Author</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                <TableRow>
                                    <TableCell className="font-medium">System Maintenance Scheduled</TableCell>
                                    <TableCell>
                                        <Badge variant="outline">Maintenance</Badge>
                                    </TableCell>
                                    <TableCell>
                                        <Badge variant="default">High</Badge>
                                    </TableCell>
                                    <TableCell>
                                        <Badge variant="default">Published</Badge>
                                    </TableCell>
                                    <TableCell>admin@app-oint.com</TableCell>
                                    <TableCell>
                                        <div className="flex space-x-2">
                                            <button className="text-sm text-blue-600 hover:text-blue-800">View</button>
                                            <button className="text-sm text-orange-600 hover:text-orange-800">Edit</button>
                                        </div>
                                    </TableCell>
                                </TableRow>
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
                        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <MessageSquare className="h-6 w-6 mx-auto mb-2" />
                                    <div>Send Message</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Send className="h-6 w-6 mx-auto mb-2" />
                                    <div>Create Announcement</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Users className="h-6 w-6 mx-auto mb-2" />
                                    <div>Team Chat</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <AlertCircle className="h-6 w-6 mx-auto mb-2" />
                                    <div>Emergency Alert</div>
                                </div>
                            </Button>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
} 