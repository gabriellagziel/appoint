"use client"

import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { listSurveys, type Survey } from "@/services/surveys_service"
import { BarChart3, Edit, Eye, Users } from "lucide-react"
import Link from "next/link"
import { useEffect, useState } from "react"

export default function RecentSurveysList() {
    const [surveys, setSurveys] = useState<Survey[]>([])
    const [loading, setLoading] = useState(true)

    useEffect(() => {
        loadRecentSurveys()
    }, [])

    const loadRecentSurveys = async () => {
        try {
            setLoading(true)
            const surveysData = await listSurveys()
            // Get the 5 most recent surveys
            const recentSurveys = surveysData.slice(0, 5)
            setSurveys(recentSurveys)
        } catch (error) {
            console.error('Error loading recent surveys:', error)
        } finally {
            setLoading(false)
        }
    }

    const getStatusColor = (status: string) => {
        switch (status) {
            case "active": return "default"
            case "draft": return "secondary"
            case "closed": return "destructive"
            default: return "default"
        }
    }

    const formatDate = (date: Date) => {
        return new Date(date).toLocaleDateString()
    }

    const getQuestionCount = (survey: Survey) => {
        return survey.questions.length
    }

    if (loading) {
        return (
            <Card>
                <CardHeader>
                    <CardTitle>Recent Surveys</CardTitle>
                </CardHeader>
                <CardContent>
                    <div className="flex items-center justify-center h-32">
                        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                    </div>
                </CardContent>
            </Card>
        )
    }

    return (
        <Card>
            <CardHeader>
                <div className="flex items-center justify-between">
                    <CardTitle>Recent Surveys</CardTitle>
                    <Link href="/admin/surveys">
                        <Button variant="outline" size="sm">
                            View All
                        </Button>
                    </Link>
                </div>
            </CardHeader>
            <CardContent>
                {surveys.length === 0 ? (
                    <div className="text-center py-8">
                        <Users className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                        <h3 className="text-lg font-medium text-gray-900 mb-2">No surveys yet</h3>
                        <p className="text-gray-500 mb-4">Create your first survey to get started.</p>
                        <Link href="/admin/surveys/create">
                            <Button>
                                Create Survey
                            </Button>
                        </Link>
                    </div>
                ) : (
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableHead>Title</TableHead>
                                <TableHead>Status</TableHead>
                                <TableHead>Questions</TableHead>
                                <TableHead>Updated</TableHead>
                                <TableHead>Actions</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {surveys.map((survey) => (
                                <TableRow key={survey.id}>
                                    <TableCell>
                                        <div className="max-w-xs">
                                            <div className="font-medium">{survey.title}</div>
                                            {survey.description && (
                                                <div className="text-sm text-gray-500 mt-1">
                                                    {survey.description}
                                                </div>
                                            )}
                                        </div>
                                    </TableCell>
                                    <TableCell>
                                        <Badge variant={getStatusColor(survey.status)}>
                                            {survey.status}
                                        </Badge>
                                    </TableCell>
                                    <TableCell>
                                        <div className="flex items-center gap-2">
                                            <Users className="h-4 w-4 text-gray-400" />
                                            <span className="text-sm">{getQuestionCount(survey)} questions</span>
                                        </div>
                                    </TableCell>
                                    <TableCell>
                                        <div className="text-sm">
                                            {formatDate(survey.updatedAt)}
                                        </div>
                                    </TableCell>
                                    <TableCell>
                                        <div className="flex items-center gap-2">
                                            <Link href={`/admin/surveys/${survey.id}`}>
                                                <Button variant="ghost" size="sm">
                                                    <Eye className="h-4 w-4" />
                                                </Button>
                                            </Link>
                                            <Link href={`/admin/surveys/${survey.id}?edit=true`}>
                                                <Button variant="ghost" size="sm">
                                                    <Edit className="h-4 w-4" />
                                                </Button>
                                            </Link>
                                            <Link href={`/admin/surveys/${survey.id}/analytics`}>
                                                <Button variant="ghost" size="sm">
                                                    <BarChart3 className="h-4 w-4" />
                                                </Button>
                                            </Link>
                                        </div>
                                    </TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                )}
            </CardContent>
        </Card>
    )
}






