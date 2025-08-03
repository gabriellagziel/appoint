"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

export default function ExportsPage() {
    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Exports</h1>
                    <p className="text-gray-600">Data export management</p>
                </div>

                <Card>
                    <CardHeader>
                        <CardTitle>Export Management</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <p className="text-muted-foreground">
                            Export management interface coming soon...
                        </p>
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
} 