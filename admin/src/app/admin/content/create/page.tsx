"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Button } from "@/components/ui/button"
import ContentForm from "@/components/ContentForm"
import { createContent, type ContentItem } from "@/services/content_service"
import { ArrowLeft } from "lucide-react"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { useState } from "react"
import { toast } from "sonner"

export default function CreateContentPage() {
    const router = useRouter()
    const [loading, setLoading] = useState(false)

    const handleSubmit = async (data: Omit<ContentItem, 'id' | 'createdAt' | 'updatedAt'>) => {
        try {
            setLoading(true)
            const contentId = await createContent(data)
            toast.success('Content created successfully')
            router.push(`/admin/content/${contentId}`)
        } catch (error) {
            console.error('Error creating content:', error)
            toast.error('Failed to create content')
        } finally {
            setLoading(false)
        }
    }

    const handleCancel = () => {
        router.push('/admin/content')
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div className="flex items-center gap-4">
                    <Link href="/admin/content">
                        <Button variant="outline" size="sm">
                            <ArrowLeft className="h-4 w-4 mr-2" />
                            Back to Content
                        </Button>
                    </Link>
                    <div>
                        <h1 className="text-3xl font-bold text-gray-900">Create New Content</h1>
                        <p className="text-gray-600">Add a new article, page, or help content</p>
                    </div>
                </div>

                <ContentForm
                    onSubmit={handleSubmit}
                    onCancel={handleCancel}
                    loading={loading}
                />
            </div>
        </AdminLayout>
    )
}
