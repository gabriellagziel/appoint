"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Textarea } from "@/components/ui/textarea"
import { useAuth } from "@/contexts/AuthContext"
import { uploadMedia, type ContentItem, type MediaAsset } from "@/services/content_service"
import { Image, Upload, X } from "lucide-react"
import { useState } from "react"
import { toast } from "sonner"

interface ContentFormProps {
    initialData?: Partial<ContentItem>
    onSubmit: (data: Omit<ContentItem, 'id' | 'createdAt' | 'updatedAt'>) => Promise<void>
    onCancel: () => void
    loading?: boolean
}

export default function ContentForm({ initialData, onSubmit, onCancel, loading }: ContentFormProps) {
    const { user: currentUser } = useAuth()
    const [formData, setFormData] = useState({
        title: initialData?.title || '',
        slug: initialData?.slug || '',
        body: initialData?.body || '',
        excerpt: initialData?.excerpt || '',
        type: initialData?.type || 'page' as const,
        status: initialData?.status || 'draft' as const,
        featuredImage: initialData?.featuredImage || '',
        tags: initialData?.tags || [],
        metaTitle: initialData?.metaTitle || '',
        metaDescription: initialData?.metaDescription || '',
        seoUrl: initialData?.seoUrl || ''
    })
    const [uploading, setUploading] = useState(false)
    const [newTag, setNewTag] = useState('')

    const handleInputChange = (field: string, value: string) => {
        setFormData(prev => ({ ...prev, [field]: value }))
    }

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault()
        
        if (!formData.title.trim()) {
            toast.error('Title is required')
            return
        }

        if (!formData.body.trim()) {
            toast.error('Content body is required')
            return
        }

        try {
            await onSubmit({
                ...formData,
                authorId: currentUser?.uid || 'unknown',
                authorEmail: currentUser?.email || undefined,
                authorName: currentUser?.displayName || undefined
            })
        } catch (error) {
            console.error('Error submitting content:', error)
            toast.error('Failed to save content')
        }
    }

    const handleFileUpload = async (file: File) => {
        if (!file) return

        // Validate file type
        const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp']
        if (!allowedTypes.includes(file.type)) {
            toast.error('Please select a valid image file (JPEG, PNG, GIF, WebP)')
            return
        }

        // Validate file size (5MB limit)
        if (file.size > 5 * 1024 * 1024) {
            toast.error('File size must be less than 5MB')
            return
        }

        try {
            setUploading(true)
            const mediaAsset = await uploadMedia(file, {
                uploadedBy: currentUser?.uid || 'unknown',
                uploadedByEmail: currentUser?.email || undefined,
                altText: `Featured image for ${formData.title}`,
                caption: formData.title
            })

            setFormData(prev => ({ ...prev, featuredImage: mediaAsset.url }))
            toast.success('Image uploaded successfully')
        } catch (error) {
            console.error('Error uploading image:', error)
            toast.error('Failed to upload image')
        } finally {
            setUploading(false)
        }
    }

    const handleAddTag = () => {
        if (newTag.trim() && !formData.tags.includes(newTag.trim())) {
            setFormData(prev => ({ ...prev, tags: [...prev.tags, newTag.trim()] }))
            setNewTag('')
        }
    }

    const handleRemoveTag = (tagToRemove: string) => {
        setFormData(prev => ({ ...prev, tags: prev.tags.filter(tag => tag !== tagToRemove) }))
    }

    const generateSlug = () => {
        const slug = formData.title
            .toLowerCase()
            .replace(/[^a-z0-9]+/g, '-')
            .replace(/(^-|-$)/g, '')
        setFormData(prev => ({ ...prev, slug }))
    }

    return (
        <form onSubmit={handleSubmit} className="space-y-6">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                {/* Main Content */}
                <div className="lg:col-span-2 space-y-6">
                    <Card>
                        <CardHeader>
                            <CardTitle>Content Details</CardTitle>
                        </CardHeader>
                        <CardContent className="space-y-4">
                            <div className="space-y-2">
                                <Label htmlFor="title">Title *</Label>
                                <Input
                                    id="title"
                                    value={formData.title}
                                    onChange={(e) => handleInputChange('title', e.target.value)}
                                    placeholder="Enter content title"
                                    required
                                />
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="slug">Slug</Label>
                                <div className="flex gap-2">
                                    <Input
                                        id="slug"
                                        value={formData.slug}
                                        onChange={(e) => handleInputChange('slug', e.target.value)}
                                        placeholder="content-slug"
                                    />
                                    <Button type="button" variant="outline" onClick={generateSlug}>
                                        Generate
                                    </Button>
                                </div>
                            </div>

                            <div className="grid grid-cols-2 gap-4">
                                <div className="space-y-2">
                                    <Label htmlFor="type">Type</Label>
                                    <Select value={formData.type} onValueChange={(value: any) => handleInputChange('type', value)}>
                                        <SelectTrigger>
                                            <SelectValue />
                                        </SelectTrigger>
                                        <SelectContent>
                                            <SelectItem value="page">Page</SelectItem>
                                            <SelectItem value="article">Article</SelectItem>
                                            <SelectItem value="help">Help Content</SelectItem>
                                            <SelectItem value="policy">Policy</SelectItem>
                                            <SelectItem value="announcement">Announcement</SelectItem>
                                        </SelectContent>
                                    </Select>
                                </div>

                                <div className="space-y-2">
                                    <Label htmlFor="status">Status</Label>
                                    <Select value={formData.status} onValueChange={(value: any) => handleInputChange('status', value)}>
                                        <SelectTrigger>
                                            <SelectValue />
                                        </SelectTrigger>
                                        <SelectContent>
                                            <SelectItem value="draft">Draft</SelectItem>
                                            <SelectItem value="published">Published</SelectItem>
                                            <SelectItem value="archived">Archived</SelectItem>
                                        </SelectContent>
                                    </Select>
                                </div>
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="excerpt">Excerpt</Label>
                                <Textarea
                                    id="excerpt"
                                    value={formData.excerpt}
                                    onChange={(e) => handleInputChange('excerpt', e.target.value)}
                                    placeholder="Brief description of the content"
                                    rows={3}
                                />
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="body">Content Body *</Label>
                                <Textarea
                                    id="body"
                                    value={formData.body}
                                    onChange={(e) => handleInputChange('body', e.target.value)}
                                    placeholder="Enter your content here..."
                                    rows={12}
                                    required
                                />
                                <p className="text-sm text-gray-500">
                                    You can use HTML tags for formatting. For a rich text editor, consider integrating TipTap or Quill.
                                </p>
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Sidebar */}
                <div className="space-y-6">
                    <Card>
                        <CardHeader>
                            <CardTitle>Featured Image</CardTitle>
                        </CardHeader>
                        <CardContent className="space-y-4">
                            {formData.featuredImage ? (
                                <div className="space-y-2">
                                    <img
                                        src={formData.featuredImage}
                                        alt="Featured"
                                        className="w-full h-32 object-cover rounded-md"
                                    />
                                    <Button
                                        type="button"
                                        variant="outline"
                                        size="sm"
                                        onClick={() => setFormData(prev => ({ ...prev, featuredImage: '' }))}
                                    >
                                        <X className="h-4 w-4 mr-2" />
                                        Remove
                                    </Button>
                                </div>
                            ) : (
                                <div className="border-2 border-dashed border-gray-300 rounded-md p-6 text-center">
                                    <Upload className="h-8 w-8 text-gray-400 mx-auto mb-2" />
                                    <p className="text-sm text-gray-500 mb-2">Upload featured image</p>
                                    <input
                                        type="file"
                                        accept="image/*"
                                        onChange={(e) => {
                                            const file = e.target.files?.[0]
                                            if (file) handleFileUpload(file)
                                        }}
                                        className="hidden"
                                        id="image-upload"
                                        aria-label="Upload featured image"
                                    />
                                    <Button
                                        type="button"
                                        variant="outline"
                                        size="sm"
                                        onClick={() => document.getElementById('image-upload')?.click()}
                                        disabled={uploading}
                                        aria-label="Choose image file"
                                    >
                                        {uploading ? 'Uploading...' : 'Choose Image'}
                                    </Button>
                                </div>
                            )}
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle>Tags</CardTitle>
                        </CardHeader>
                        <CardContent className="space-y-4">
                            <div className="flex gap-2">
                                <Input
                                    value={newTag}
                                    onChange={(e) => setNewTag(e.target.value)}
                                    placeholder="Add tag"
                                    onKeyPress={(e) => {
                                        if (e.key === 'Enter') {
                                            e.preventDefault()
                                            handleAddTag()
                                        }
                                    }}
                                />
                                <Button type="button" variant="outline" onClick={handleAddTag}>
                                    Add
                                </Button>
                            </div>
                            {formData.tags.length > 0 && (
                                <div className="flex flex-wrap gap-2">
                                    {formData.tags.map((tag) => (
                                        <div key={tag} className="flex items-center gap-1 bg-blue-100 text-blue-800 px-2 py-1 rounded-md">
                                            <span className="text-sm">{tag}</span>
                                            <button
                                                type="button"
                                                onClick={() => handleRemoveTag(tag)}
                                                className="text-blue-600 hover:text-blue-800"
                                                aria-label={`Remove tag ${tag}`}
                                                title={`Remove tag ${tag}`}
                                            >
                                                <X className="h-3 w-3" />
                                            </button>
                                        </div>
                                    ))}
                                </div>
                            )}
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle>SEO Settings</CardTitle>
                        </CardHeader>
                        <CardContent className="space-y-4">
                            <div className="space-y-2">
                                <Label htmlFor="metaTitle">Meta Title</Label>
                                <Input
                                    id="metaTitle"
                                    value={formData.metaTitle}
                                    onChange={(e) => handleInputChange('metaTitle', e.target.value)}
                                    placeholder="SEO title for search engines"
                                />
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="metaDescription">Meta Description</Label>
                                <Textarea
                                    id="metaDescription"
                                    value={formData.metaDescription}
                                    onChange={(e) => handleInputChange('metaDescription', e.target.value)}
                                    placeholder="Brief description for search engines"
                                    rows={3}
                                />
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="seoUrl">SEO URL</Label>
                                <Input
                                    id="seoUrl"
                                    value={formData.seoUrl}
                                    onChange={(e) => handleInputChange('seoUrl', e.target.value)}
                                    placeholder="Custom URL for SEO"
                                />
                            </div>
                        </CardContent>
                    </Card>
                </div>
            </div>

            {/* Form Actions */}
            <div className="flex justify-end gap-2">
                <Button type="button" variant="outline" onClick={onCancel}>
                    Cancel
                </Button>
                <Button type="submit" disabled={loading}>
                    {loading ? 'Saving...' : 'Save Content'}
                </Button>
            </div>
        </form>
    )
}
