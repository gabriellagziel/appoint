"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { FileText, Image, Video } from "lucide-react"

export default function ContentPage() {
    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Content Management</h1>
                    <p className="text-gray-600">Manage platform content, media, and assets</p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <Card>
                        <CardHeader>
                            <CardTitle className="flex items-center gap-2">
                                <FileText className="h-5 w-5" />
                                Text Content
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <p className="text-sm text-gray-600 mb-4">Manage help articles, terms, and policies</p>
                            <Button>Manage Content</Button>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle className="flex items-center gap-2">
                                <Image className="h-5 w-5" />
                                Media Assets
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <p className="text-sm text-gray-600 mb-4">Upload and manage images and graphics</p>
                            <Button>Manage Media</Button>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle className="flex items-center gap-2">
                                <Video className="h-5 w-5" />
                                Video Content
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <p className="text-sm text-gray-600 mb-4">Manage tutorial videos and guides</p>
                            <Button>Manage Videos</Button>
                        </CardContent>
                    </Card>
                </div>
            </div>
        </AdminLayout>
    )
} 