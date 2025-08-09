"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { useAuth } from "@/contexts/AuthContext"
import { assertPrivateLandingAccess } from "@/lib/private-landing-guard"
import { Activity, BarChart3, ClipboardList, Users } from "lucide-react"
import { useSearchParams } from "next/navigation"
import { useEffect, useState } from "react"
import RecentSurveysList from "@/components/RecentSurveysList"
import SurveyQuickActions from "@/components/SurveyQuickActions"

export default function PrivateSurveyLandingPage() {
    const { user } = useAuth()
    const searchParams = useSearchParams()
    const [accessGranted, setAccessGranted] = useState(false)
    const [loading, setLoading] = useState(true)

    useEffect(() => {
        checkAccess()
    }, [user, searchParams])

      const checkAccess = async () => {
    try {
      await assertPrivateLandingAccess({
        user,
        searchParams: Object.fromEntries(searchParams.entries()),
        ipAddress: typeof window !== 'undefined' ? undefined : 'client-side', // In real app, get from headers
        userAgent: typeof window !== 'undefined' ? navigator.userAgent : undefined
      })
      setAccessGranted(true)
    } catch (error) {
      // notFound() will be called by the guard
      setAccessGranted(false)
    } finally {
      setLoading(false)
    }
  }

    if (loading) {
        return (
            <AdminLayout>
                <div className="flex items-center justify-center h-64">
                    <div className="text-center">
                        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
                        <p className="text-gray-600">Checking access...</p>
                    </div>
                </div>
            </AdminLayout>
        )
    }

    if (!accessGranted) {
        return null // notFound() will handle the 404
    }

    return (
        <AdminLayout>
            <div className="space-y-6">
                {/* Header */}
                <div className="text-center">
                    <h1 className="text-4xl font-bold text-gray-900 mb-2">Private Survey Hub</h1>
                    <p className="text-xl text-gray-600">Central command center for survey management</p>
                    <div className="flex items-center justify-center gap-4 mt-4 text-sm text-gray-500">
                        <div className="flex items-center gap-1">
                            <Activity className="h-4 w-4" />
                            <span>Restricted Access</span>
                        </div>
                        <div className="flex items-center gap-1">
                            <Users className="h-4 w-4" />
                            <span>Super Admin Only</span>
                        </div>
                    </div>
                </div>

                {/* Quick Stats */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Surveys</CardTitle>
                            <ClipboardList className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">12</div>
                            <p className="text-xs text-muted-foreground">
                                +2 from last month
                            </p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Active Surveys</CardTitle>
                            <Activity className="h-4 w-4 text-green-500" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold text-green-600">8</div>
                            <p className="text-xs text-muted-foreground">
                                Currently collecting responses
                            </p>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Responses</CardTitle>
                            <BarChart3 className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">1,247</div>
                            <p className="text-xs text-muted-foreground">
                                +180 from last week
                            </p>
                        </CardContent>
                    </Card>
                </div>

                {/* Quick Actions */}
                <Card>
                    <CardHeader>
                        <CardTitle>Quick Actions</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <SurveyQuickActions />
                    </CardContent>
                </Card>

                {/* Recent Surveys */}
                <RecentSurveysList />

                {/* System Status */}
                <Card>
                    <CardHeader>
                        <CardTitle>System Status</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div className="space-y-2">
                                <div className="flex items-center justify-between">
                                    <span className="text-sm font-medium">Survey Builder</span>
                                    <div className="flex items-center gap-2">
                                        <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                                        <span className="text-sm text-green-600">Online</span>
                                    </div>
                                </div>
                                <div className="flex items-center justify-between">
                                    <span className="text-sm font-medium">Response Collection</span>
                                    <div className="flex items-center gap-2">
                                        <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                                        <span className="text-sm text-green-600">Online</span>
                                    </div>
                                </div>
                                <div className="flex items-center justify-between">
                                    <span className="text-sm font-medium">Analytics Engine</span>
                                    <div className="flex items-center gap-2">
                                        <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                                        <span className="text-sm text-green-600">Online</span>
                                    </div>
                                </div>
                            </div>
                            <div className="space-y-2">
                                <div className="flex items-center justify-between">
                                    <span className="text-sm font-medium">Export System</span>
                                    <div className="flex items-center gap-2">
                                        <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                                        <span className="text-sm text-green-600">Online</span>
                                    </div>
                                </div>
                                <div className="flex items-center justify-between">
                                    <span className="text-sm font-medium">Template Library</span>
                                    <div className="flex items-center gap-2">
                                        <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                                        <span className="text-sm text-green-600">Online</span>
                                    </div>
                                </div>
                                <div className="flex items-center justify-between">
                                    <span className="text-sm font-medium">Security</span>
                                    <div className="flex items-center gap-2">
                                        <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                                        <span className="text-sm text-green-600">Secure</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
}
