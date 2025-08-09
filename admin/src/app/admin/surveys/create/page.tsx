"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Switch } from "@/components/ui/switch"
import { Textarea } from "@/components/ui/textarea"
import SurveyBuilder from "@/components/SurveyBuilder"
import { useAuth } from "@/contexts/AuthContext"
import { createSurvey, type Survey, type SurveyQuestion } from "@/services/surveys_service"
import { ArrowLeft, Eye, Save } from "lucide-react"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { useState } from "react"
import { toast } from "sonner"

export default function CreateSurveyPage() {
    const { user: currentUser } = useAuth()
    const router = useRouter()
    const [loading, setLoading] = useState(false)
    const [previewMode, setPreviewMode] = useState(false)
    
    const [formData, setFormData] = useState({
        title: '',
        description: '',
        slug: '',
        tags: [] as string[],
        settings: {
            allowAnonymous: true,
            requireLogin: false
        }
    })
    
    const [questions, setQuestions] = useState<SurveyQuestion[]>([])
    const [newTag, setNewTag] = useState('')

    const handleInputChange = (field: string, value: string) => {
        setFormData(prev => ({ ...prev, [field]: value }))
    }

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault()
        
        if (!formData.title.trim()) {
            toast.error('Survey title is required')
            return
        }

        if (questions.length === 0) {
            toast.error('At least one question is required')
            return
        }

        // Validate questions
        const invalidQuestions = questions.filter(q => !q.title.trim())
        if (invalidQuestions.length > 0) {
            toast.error('All questions must have titles')
            return
        }

        try {
            setLoading(true)
            const surveyData = {
                ...formData,
                status: 'draft' as const,
                createdBy: currentUser?.uid || 'unknown',
                questions,
                version: 1
            }
            
            const surveyId = await createSurvey(surveyData)
            toast.success('Survey created successfully')
            router.push(`/admin/surveys/${surveyId}`)
        } catch (error) {
            console.error('Error creating survey:', error)
            toast.error('Failed to create survey')
        } finally {
            setLoading(false)
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

    const renderPreview = () => {
        return (
            <div className="space-y-6">
                <Card>
                    <CardHeader>
                        <CardTitle>{formData.title || 'Survey Title'}</CardTitle>
                        {formData.description && (
                            <p className="text-gray-600">{formData.description}</p>
                        )}
                    </CardHeader>
                    <CardContent className="space-y-4">
                        {questions.map((question, index) => (
                            <div key={question.id} className="border rounded-lg p-4">
                                <div className="mb-2">
                                    <h3 className="font-medium">
                                        {question.title || `Question ${index + 1}`}
                                        {question.required && <span className="text-red-500 ml-1">*</span>}
                                    </h3>
                                    {question.description && (
                                        <p className="text-sm text-gray-500 mt-1">{question.description}</p>
                                    )}
                                </div>
                                
                                <div className="mt-3">
                                    {question.type === 'short_text' && (
                                        <Input placeholder="Enter your answer" disabled />
                                    )}
                                    {question.type === 'long_text' && (
                                        <Textarea placeholder="Enter your answer" rows={3} disabled />
                                    )}
                                    {question.type === 'single_choice' && question.options && (
                                        <div className="space-y-2">
                                            {question.options.map((option, optIndex) => (
                                                <div key={optIndex} className="flex items-center space-x-2">
                                                    <input 
                                                        type="radio" 
                                                        disabled 
                                                        aria-label={`Select option ${optIndex + 1}`}
                                                    />
                                                    <Label>{option || `Option ${optIndex + 1}`}</Label>
                                                </div>
                                            ))}
                                        </div>
                                    )}
                                    {question.type === 'multi_choice' && question.options && (
                                        <div className="space-y-2">
                                            {question.options.map((option, optIndex) => (
                                                <div key={optIndex} className="flex items-center space-x-2">
                                                    <input 
                                                        type="checkbox" 
                                                        disabled 
                                                        aria-label={`Select option ${optIndex + 1}`}
                                                    />
                                                    <Label>{option || `Option ${optIndex + 1}`}</Label>
                                                </div>
                                            ))}
                                        </div>
                                    )}
                                    {question.type === 'scale' && question.scale && (
                                        <div className="space-y-2">
                                            <div className="flex justify-between text-sm text-gray-500">
                                                <span>{question.scale.min}</span>
                                                <span>{question.scale.max}</span>
                                            </div>
                                            <div className="flex gap-2">
                                                {Array.from({ length: question.scale.max - question.scale.min + 1 }, (_, i) => (
                                                    <input
                                                        key={i}
                                                        type="radio"
                                                        name={`scale-${question.id}`}
                                                        disabled
                                                        aria-label={`Select scale value ${question.scale!.min + i}`}
                                                    />
                                                ))}
                                            </div>
                                        </div>
                                    )}
                                    {question.type === 'date' && (
                                        <Input type="date" disabled aria-label="Select date" />
                                    )}
                                    {question.type === 'yes_no' && (
                                        <div className="space-y-2">
                                            <div className="flex items-center space-x-2">
                                                <input 
                                                    type="radio" 
                                                    name={`yesno-${question.id}`} 
                                                    disabled 
                                                    aria-label="Select Yes"
                                                />
                                                <Label>Yes</Label>
                                            </div>
                                            <div className="flex items-center space-x-2">
                                                <input 
                                                    type="radio" 
                                                    name={`yesno-${question.id}`} 
                                                    disabled 
                                                    aria-label="Select No"
                                                />
                                                <Label>No</Label>
                                            </div>
                                        </div>
                                    )}
                                </div>
                            </div>
                        ))}
                    </CardContent>
                </Card>
            </div>
        )
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div className="flex items-center justify-between">
                    <div className="flex items-center gap-4">
                        <Link href="/admin/surveys">
                            <Button variant="outline" size="sm">
                                <ArrowLeft className="h-4 w-4 mr-2" />
                                Back to Surveys
                            </Button>
                        </Link>
                        <div>
                            <h1 className="text-3xl font-bold text-gray-900">Create Survey</h1>
                            <p className="text-gray-600">Design and configure your survey</p>
                        </div>
                    </div>
                    <div className="flex items-center gap-2">
                        <Button
                            variant="outline"
                            onClick={() => setPreviewMode(!previewMode)}
                        >
                            <Eye className="h-4 w-4 mr-2" />
                            {previewMode ? 'Edit' : 'Preview'}
                        </Button>
                        <Button onClick={handleSubmit} disabled={loading}>
                            <Save className="h-4 w-4 mr-2" />
                            {loading ? 'Creating...' : 'Create Survey'}
                        </Button>
                    </div>
                </div>

                {previewMode ? (
                    renderPreview()
                ) : (
                    <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        {/* Survey Details */}
                        <div className="lg:col-span-1 space-y-6">
                            <Card>
                                <CardHeader>
                                    <CardTitle>Survey Details</CardTitle>
                                </CardHeader>
                                <CardContent className="space-y-4">
                                    <div className="space-y-2">
                                        <Label htmlFor="title">Title *</Label>
                                        <Input
                                            id="title"
                                            value={formData.title}
                                            onChange={(e) => handleInputChange('title', e.target.value)}
                                            placeholder="Enter survey title"
                                        />
                                    </div>

                                    <div className="space-y-2">
                                        <Label htmlFor="description">Description</Label>
                                        <Textarea
                                            id="description"
                                            value={formData.description}
                                            onChange={(e) => handleInputChange('description', e.target.value)}
                                            placeholder="Describe your survey"
                                            rows={3}
                                        />
                                    </div>

                                    <div className="space-y-2">
                                        <Label htmlFor="slug">Slug</Label>
                                        <div className="flex gap-2">
                                            <Input
                                                id="slug"
                                                value={formData.slug}
                                                onChange={(e) => handleInputChange('slug', e.target.value)}
                                                placeholder="survey-slug"
                                            />
                                            <Button type="button" variant="outline" onClick={generateSlug}>
                                                Generate
                                            </Button>
                                        </div>
                                    </div>

                                    <div className="space-y-2">
                                        <Label>Tags</Label>
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
                                                    <Badge key={tag} variant="secondary">
                                                        {tag}
                                                        <button
                                                            type="button"
                                                            onClick={() => handleRemoveTag(tag)}
                                                            className="ml-1 text-gray-500 hover:text-gray-700"
                                                        >
                                                            ×
                                                        </button>
                                                    </Badge>
                                                ))}
                                            </div>
                                        )}
                                    </div>
                                </CardContent>
                            </Card>

                            <Card>
                                <CardHeader>
                                    <CardTitle>Settings</CardTitle>
                                </CardHeader>
                                <CardContent className="space-y-4">
                                    <div className="flex items-center space-x-2">
                                        <Switch
                                            checked={formData.settings.allowAnonymous}
                                            onCheckedChange={(checked) => 
                                                setFormData(prev => ({
                                                    ...prev,
                                                    settings: { ...prev.settings, allowAnonymous: checked }
                                                }))
                                            }
                                        />
                                        <Label>Allow anonymous responses</Label>
                                    </div>

                                    <div className="flex items-center space-x-2">
                                        <Switch
                                            checked={formData.settings.requireLogin}
                                            onCheckedChange={(checked) => 
                                                setFormData(prev => ({
                                                    ...prev,
                                                    settings: { ...prev.settings, requireLogin: checked }
                                                }))
                                            }
                                        />
                                        <Label>Require user login</Label>
                                    </div>
                                </CardContent>
                            </Card>
                        </div>

                        {/* Survey Builder */}
                        <div className="lg:col-span-2">
                            <SurveyBuilder
                                questions={questions}
                                onQuestionsChange={setQuestions}
                            />
                        </div>
                    </div>
                )}
            </div>
        </AdminLayout>
    )
}
