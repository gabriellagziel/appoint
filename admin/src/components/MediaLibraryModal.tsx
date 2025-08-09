"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { getMediaAssets, deleteMediaAsset, type MediaAsset } from "@/services/content_service"
import { Search, Upload, X, Image, Video, File } from "lucide-react"
import { useEffect, useState } from "react"
import { toast } from "sonner"

interface MediaLibraryModalProps {
    open: boolean
    onOpenChange: (open: boolean) => void
    onSelect: (media: MediaAsset) => void
    title?: string
}

export default function MediaLibraryModal({ open, onOpenChange, onSelect, title = "Media Library" }: MediaLibraryModalProps) {
    const [media, setMedia] = useState<MediaAsset[]>([])
    const [loading, setLoading] = useState(false)
    const [searchTerm, setSearchTerm] = useState("")
    const [selectedMedia, setSelectedMedia] = useState<MediaAsset | null>(null)
    const [uploading, setUploading] = useState(false)

    useEffect(() => {
        if (open) {
            loadMedia()
        }
    }, [open])

    const loadMedia = async () => {
        try {
            setLoading(true)
            const mediaAssets = await getMediaAssets(100)
            setMedia(mediaAssets)
        } catch (error) {
            console.error('Error loading media:', error)
            toast.error('Failed to load media library')
        } finally {
            setLoading(false)
        }
    }

    const handleSearch = () => {
        // Filter media based on search term
        const filtered = media.filter(item =>
            item.originalName.toLowerCase().includes(searchTerm.toLowerCase()) ||
            item.altText?.toLowerCase().includes(searchTerm.toLowerCase()) ||
            item.caption?.toLowerCase().includes(searchTerm.toLowerCase())
        )
        setMedia(filtered)
    }

    const handleFileUpload = async (file: File) => {
        if (!file) return

        // Validate file type
        const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'video/mp4', 'video/webm']
        if (!allowedTypes.includes(file.type)) {
            toast.error('Please select a valid file (JPEG, PNG, GIF, WebP, MP4, WebM)')
            return
        }

        // Validate file size (10MB limit)
        if (file.size > 10 * 1024 * 1024) {
            toast.error('File size must be less than 10MB')
            return
        }

        try {
            setUploading(true)
            // This would integrate with the uploadMedia function from content_service
            // For now, we'll simulate the upload
            await new Promise(resolve => setTimeout(resolve, 1000))
            
            const newMedia: MediaAsset = {
                id: Date.now().toString(),
                fileName: file.name,
                originalName: file.name,
                url: URL.createObjectURL(file),
                size: file.size,
                mimeType: file.type,
                uploadedBy: 'current-user',
                createdAt: new Date(),
                altText: file.name,
                caption: file.name
            }
            
            setMedia(prev => [newMedia, ...prev])
            toast.success('File uploaded successfully')
        } catch (error) {
            console.error('Error uploading file:', error)
            toast.error('Failed to upload file')
        } finally {
            setUploading(false)
        }
    }

    const handleDeleteMedia = async (mediaId: string) => {
        try {
            await deleteMediaAsset(mediaId)
            setMedia(prev => prev.filter(m => m.id !== mediaId))
            toast.success('Media deleted successfully')
        } catch (error) {
            console.error('Error deleting media:', error)
            toast.error('Failed to delete media')
        }
    }

    const handleSelect = (mediaItem: MediaAsset) => {
        onSelect(mediaItem)
        onOpenChange(false)
    }

    const getFileIcon = (mimeType: string) => {
        if (mimeType.startsWith('image/')) {
            return <Image className="h-6 w-6" />
        } else if (mimeType.startsWith('video/')) {
            return <Video className="h-6 w-6" />
        } else {
            return <File className="h-6 w-6" />
        }
    }

    const formatFileSize = (bytes: number) => {
        if (bytes === 0) return '0 Bytes'
        const k = 1024
        const sizes = ['Bytes', 'KB', 'MB', 'GB']
        const i = Math.floor(Math.log(bytes) / Math.log(k))
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
    }

    const formatDate = (date: Date) => {
        return new Date(date).toLocaleDateString()
    }

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="max-w-4xl max-h-[80vh] overflow-hidden">
                <DialogHeader>
                    <DialogTitle>{title}</DialogTitle>
                </DialogHeader>
                
                <div className="flex flex-col h-full">
                    {/* Search and Upload */}
                    <div className="flex items-center gap-4 mb-4">
                        <div className="flex-1 flex gap-2">
                            <Input
                                placeholder="Search media..."
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                onKeyPress={(e) => {
                                    if (e.key === 'Enter') {
                                        e.preventDefault()
                                        handleSearch()
                                    }
                                }}
                            />
                            <Button onClick={handleSearch}>
                                <Search className="h-4 w-4" />
                            </Button>
                        </div>
                        <div className="relative">
                            <input
                                type="file"
                                accept="image/*,video/*"
                                onChange={(e) => {
                                    const file = e.target.files?.[0]
                                    if (file) handleFileUpload(file)
                                }}
                                className="hidden"
                                id="media-upload"
                                aria-label="Upload media file"
                            />
                            <Button
                                onClick={() => document.getElementById('media-upload')?.click()}
                                disabled={uploading}
                                aria-label="Upload new media"
                            >
                                <Upload className="h-4 w-4 mr-2" />
                                {uploading ? 'Uploading...' : 'Upload'}
                            </Button>
                        </div>
                    </div>

                    {/* Media Grid */}
                    <div className="flex-1 overflow-y-auto">
                        {loading ? (
                            <div className="flex items-center justify-center h-32">
                                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                            </div>
                        ) : media.length === 0 ? (
                            <div className="text-center py-8">
                                <Image className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                                <h3 className="text-lg font-medium text-gray-900 mb-2">No media found</h3>
                                <p className="text-gray-500">Upload your first media file to get started.</p>
                            </div>
                        ) : (
                            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                                {media.map((item) => (
                                    <Card key={item.id} className="cursor-pointer hover:shadow-md transition-shadow">
                                        <CardContent className="p-3">
                                            <div className="relative group">
                                                {item.mimeType.startsWith('image/') ? (
                                                    <img
                                                        src={item.url}
                                                        alt={item.altText || item.originalName}
                                                        className="w-full h-24 object-cover rounded-md"
                                                    />
                                                ) : (
                                                    <div className="w-full h-24 bg-gray-100 rounded-md flex items-center justify-center">
                                                        {getFileIcon(item.mimeType)}
                                                    </div>
                                                )}
                                                
                                                {/* Overlay with actions */}
                                                <div className="absolute inset-0 bg-black bg-opacity-50 opacity-0 group-hover:opacity-100 transition-opacity rounded-md flex items-center justify-center gap-2">
                                                    <Button
                                                        size="sm"
                                                        onClick={() => handleSelect(item)}
                                                        aria-label={`Select ${item.originalName}`}
                                                    >
                                                        Select
                                                    </Button>
                                                    <Button
                                                        size="sm"
                                                        variant="destructive"
                                                        onClick={() => handleDeleteMedia(item.id)}
                                                        aria-label={`Delete ${item.originalName}`}
                                                    >
                                                        <X className="h-4 w-4" />
                                                    </Button>
                                                </div>
                                            </div>
                                            
                                            <div className="mt-2 space-y-1">
                                                <p className="text-sm font-medium truncate" title={item.originalName}>
                                                    {item.originalName}
                                                </p>
                                                <div className="flex items-center gap-2 text-xs text-gray-500">
                                                    <span>{formatFileSize(item.size)}</span>
                                                    <span>•</span>
                                                    <span>{formatDate(item.createdAt)}</span>
                                                </div>
                                                {item.altText && (
                                                    <p className="text-xs text-gray-500 truncate" title={item.altText}>
                                                        {item.altText}
                                                    </p>
                                                )}
                                            </div>
                                        </CardContent>
                                    </Card>
                                ))}
                            </div>
                        )}
                    </div>
                </div>
            </DialogContent>
        </Dialog>
    )
}






