"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Download, FileText, TrendingUp } from "lucide-react"

export default function ExportsPage() {
    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Data Exports</h1>
                    <p className="text-gray-600">Generate and manage data exports and reports</p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <Card>
                        <CardHeader>
                            <CardTitle className="flex items-center gap-2">
                                <FileText className="h-5 w-5" />
                                User Data
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <p className="text-sm text-gray-600 mb-4">Export user accounts and activity data</p>
                            <Button>Generate Export</Button>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle className="flex items-center gap-2">
                                <TrendingUp className="h-5 w-5" />
                                Analytics Reports
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <p className="text-sm text-gray-600 mb-4">Export analytics and performance data</p>
                            <Button>Generate Report</Button>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle className="flex items-center gap-2">
                                <Download className="h-5 w-5" />
                                Business Data
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <p className="text-sm text-gray-600 mb-4">Export business accounts and transactions</p>
                            <Button>Generate Export</Button>
                        </CardContent>
                    </Card>
                </div>
            </div>
        </AdminLayout>
    )
} 