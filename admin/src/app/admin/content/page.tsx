"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

export default function ContentPage() {
    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Content</h1>
                    <p className="text-gray-600">Content management interface</p>
                </div>

                <Card>
                    <CardHeader>
                        <CardTitle>Content Management</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <p className="text-muted-foreground">
                            Content management interface coming soon...
                        </p>
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
} 