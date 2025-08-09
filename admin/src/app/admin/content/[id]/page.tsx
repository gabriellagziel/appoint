"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import ContentForm from "@/components/ContentForm"
import { getContentById, updateContent, deleteContent, type ContentItem } from "@/services/content_service"
import { ArrowLeft, Calendar, Edit, Eye, Trash2, Users } from "lucide-react"
import Link from "next/link"
import { useRouter, useSearchParams } from "next/navigation"
import { useEffect, useState } from "react"
import { toast } from "sonner"
import { Label } from "@/components/ui/label"

interface ContentPageProps {
    params: {
        id: string
    }
}

export default function ContentPage({ params }: ContentPageProps) {
    const router = useRouter()
    const searchParams = useSearchParams()
    const isEditMode = searchParams.get('edit') === 'true'
    
    const [content, setContent] = useState<ContentItem | null>(null)
    const [loading, setLoading] = useState(true)
    const [saving, setSaving] = useState(false)
    const [deleteDialog, setDeleteDialog] = useState(false)

    useEffect(() => {
        loadContent()
    }, [params.id])

    const loadContent = async () => {
        try {
            setLoading(true)
            const contentData = await getContentById(params.id)
            if (!contentData) {
                toast.error('Content not found')
                router.push('/admin/content')
                return
            }
            setContent(contentData)
        } catch (error) {
            console.error('Error loading content:', error)
            toast.error('Failed to load content')
        } finally {
            setLoading(false)
        }
    }

    const handleUpdate = async (data: Omit<ContentItem, 'id' | 'createdAt' | 'updatedAt'>) => {
        try {
            setSaving(true)
            await updateContent(params.id, data)
            await loadContent()
            toast.success('Content updated successfully')
            router.push(`/admin/content/${params.id}`)
        } catch (error) {
            console.error('Error updating content:', error)
            toast.error('Failed to update content')
        } finally {
            setSaving(false)
        }
    }

    const handleDelete = async () => {
        try {
            await deleteContent(params.id)
            toast.success('Content deleted successfully')
            router.push('/admin/content')
        } catch (error) {
            console.error('Error deleting content:', error)
            toast.error('Failed to delete content')
        }
    }

    const getStatusColor = (status: string) => {
        switch (status) {
            case "published": return "default"
            case "draft": return "secondary"
            case "archived": return "destructive"
            default: return "default"
        }
    }

    const getTypeColor = (type: string) => {
        switch (type) {
            case "page": return "default"
            case "article": return "secondary"
            case "help": return "default"
            case "policy": return "destructive"
            case "announcement": return "secondary"
            default: return "default"
        }
    }

    const formatDate = (date: Date) => {
        return new Date(date).toLocaleString()
    }

    if (loading) {
        return (
            <AdminLayout>
                <div className="flex items-center justify-center h-64">
                    <div className="text-center">
                        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
                        <p className="text-gray-600">Loading content...</p>
                    </div>
                </div>
            </AdminLayout>
        )
    }

    if (!content) {
        return (
            <AdminLayout>
                <div className="text-center py-8">
                    <h2 className="text-2xl font-bold text-red-600 mb-4">Content Not Found</h2>
                    <p className="text-gray-600 mb-4">The content you're looking for doesn't exist.</p>
                    <Link href="/admin/content">
                        <Button>
                            <ArrowLeft className="h-4 w-4 mr-2" />
                            Back to Content
                        </Button>
                    </Link>
                </div>
            </AdminLayout>
        )
    }

    if (isEditMode) {
        return (
            <AdminLayout>
                <div className="space-y-6">
                    <div className="flex items-center gap-4">
                        <Link href={`/admin/content/${params.id}`}>
                            <Button variant="outline" size="sm">
                                <ArrowLeft className="h-4 w-4 mr-2" />
                                Back to View
                            </Button>
                        </Link>
                        <div>
                            <h1 className="text-3xl font-bold text-gray-900">Edit Content</h1>
                            <p className="text-gray-600">Update content details and settings</p>
                        </div>
                    </div>

                    <ContentForm
                        initialData={content}
                        onSubmit={handleUpdate}
                        onCancel={() => router.push(`/admin/content/${params.id}`)}
                        loading={saving}
                    />
                </div>
            </AdminLayout>
        )
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div className="flex items-center justify-between">
                    <div className="flex items-center gap-4">
                        <Link href="/admin/content">
                            <Button variant="outline" size="sm">
                                <ArrowLeft className="h-4 w-4 mr-2" />
                                Back to Content
                            </Button>
                        </Link>
                        <div>
                            <h1 className="text-3xl font-bold text-gray-900">{content.title}</h1>
                            <p className="text-gray-600">Content details and preview</p>
                        </div>
                    </div>
                    <div className="flex items-center gap-2">
                        <Button
                            variant="outline"
                            onClick={() => router.push(`/admin/content/${params.id}?edit=true`)}
                        >
                            <Edit className="h-4 w-4 mr-2" />
                            Edit
                        </Button>
                        <Button
                            variant="outline"
                            onClick={() => setDeleteDialog(true)}
                        >
                            <Trash2 className="h-4 w-4 mr-2" />
                            Delete
                        </Button>
                    </div>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    {/* Main Content */}
                    <div className="lg:col-span-2 space-y-6">
                        <Card>
                            <CardHeader>
                                <CardTitle>Content Preview</CardTitle>
                            </CardHeader>
                            <CardContent>
                                {content.featuredImage && (
                                    <img
                                        src={content.featuredImage}
                                        alt="Featured"
                                        className="w-full h-48 object-cover rounded-md mb-4"
                                    />
                                )}
                                <div 
                                    className="prose max-w-none"
                                    dangerouslySetInnerHTML={{ __html: content.body }}
                                />
                            </CardContent>
                        </Card>
                    </div>

                    {/* Sidebar */}
                    <div className="space-y-6">
                        <Card>
                            <CardHeader>
                                <CardTitle>Content Information</CardTitle>
                            </CardHeader>
                            <CardContent className="space-y-4">
                                <div className="flex items-center gap-2">
                                    <Badge variant={getTypeColor(content.type)}>
                                        {content.type}
                                    </Badge>
                                    <Badge variant={getStatusColor(content.status)}>
                                        {content.status}
                                    </Badge>
                                </div>

                                <div className="space-y-2">
                                    <Label className="text-sm font-medium">Slug</Label>
                                    <p className="text-sm text-gray-600">{content.slug}</p>
                                </div>

                                {content.excerpt && (
                                    <div className="space-y-2">
                                        <Label className="text-sm font-medium">Excerpt</Label>
                                        <p className="text-sm text-gray-600">{content.excerpt}</p>
                                    </div>
                                )}

                                <div className="space-y-2">
                                    <Label className="text-sm font-medium">Author</Label>
                                    <div className="flex items-center gap-2">
                                        <Users className="h-4 w-4 text-gray-400" />
                                        <span className="text-sm">{content.authorName || content.authorEmail || 'Unknown'}</span>
                                    </div>
                                </div>

                                <div className="space-y-2">
                                    <Label className="text-sm font-medium">Created</Label>
                                    <div className="flex items-center gap-2">
                                        <Calendar className="h-4 w-4 text-gray-400" />
                                        <span className="text-sm">{formatDate(content.createdAt)}</span>
                                    </div>
                                </div>

                                <div className="space-y-2">
                                    <Label className="text-sm font-medium">Updated</Label>
                                    <div className="flex items-center gap-2">
                                        <Calendar className="h-4 w-4 text-gray-400" />
                                        <span className="text-sm">{formatDate(content.updatedAt)}</span>
                                    </div>
                                </div>

                                {content.publishedAt && (
                                    <div className="space-y-2">
                                        <Label className="text-sm font-medium">Published</Label>
                                        <div className="flex items-center gap-2">
                                            <Eye className="h-4 w-4 text-gray-400" />
                                            <span className="text-sm">{formatDate(content.publishedAt)}</span>
                                        </div>
                                    </div>
                                )}

                                {content.viewCount !== undefined && (
                                    <div className="space-y-2">
                                        <Label className="text-sm font-medium">Views</Label>
                                        <p className="text-sm text-gray-600">{content.viewCount}</p>
                                    </div>
                                )}
                            </CardContent>
                        </Card>

                        {content.tags && content.tags.length > 0 && (
                            <Card>
                                <CardHeader>
                                    <CardTitle>Tags</CardTitle>
                                </CardHeader>
                                <CardContent>
                                    <div className="flex flex-wrap gap-2">
                                        {content.tags.map((tag) => (
                                            <Badge key={tag} variant="secondary">
                                                {tag}
                                            </Badge>
                                        ))}
                                    </div>
                                </CardContent>
                            </Card>
                        )}

                        {(content.metaTitle || content.metaDescription) && (
                            <Card>
                                <CardHeader>
                                    <CardTitle>SEO Information</CardTitle>
                                </CardHeader>
                                <CardContent className="space-y-4">
                                    {content.metaTitle && (
                                        <div className="space-y-2">
                                            <Label className="text-sm font-medium">Meta Title</Label>
                                            <p className="text-sm text-gray-600">{content.metaTitle}</p>
                                        </div>
                                    )}
                                    {content.metaDescription && (
                                        <div className="space-y-2">
                                            <Label className="text-sm font-medium">Meta Description</Label>
                                            <p className="text-sm text-gray-600">{content.metaDescription}</p>
                                        </div>
                                    )}
                                    {content.seoUrl && (
                                        <div className="space-y-2">
                                            <Label className="text-sm font-medium">SEO URL</Label>
                                            <p className="text-sm text-gray-600">{content.seoUrl}</p>
                                        </div>
                                    )}
                                </CardContent>
                            </Card>
                        )}
                    </div>
                </div>
            </div>

            {/* Delete Confirmation Dialog */}
            <Dialog open={deleteDialog} onOpenChange={setDeleteDialog}>
                <DialogContent>
                    <DialogHeader>
                        <DialogTitle>Delete Content</DialogTitle>
                    </DialogHeader>
                    <div className="space-y-4">
                        <p>
                            Are you sure you want to delete "{content.title}"? This action cannot be undone.
                        </p>
                        <div className="flex justify-end gap-2">
                            <Button variant="outline" onClick={() => setDeleteDialog(false)}>
                                Cancel
                            </Button>
                            <Button variant="destructive" onClick={handleDelete}>
                                Delete
                            </Button>
                        </div>
                    </div>
                </DialogContent>
            </Dialog>
        </AdminLayout>
    )
}






