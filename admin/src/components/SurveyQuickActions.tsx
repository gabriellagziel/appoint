"use client"

import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { 
    BarChart3, 
    ClipboardList, 
    Download, 
    FileText, 
    Plus, 
    Settings, 
    Users 
} from "lucide-react"
import Link from "next/link"

export default function SurveyQuickActions() {
    const actions = [
        {
            title: "Create Survey",
            description: "Design a new survey with our builder",
            icon: Plus,
            href: "/admin/surveys/create",
            color: "bg-blue-500",
            badge: "New"
        },
        {
            title: "View All Surveys",
            description: "Manage existing surveys and responses",
            icon: ClipboardList,
            href: "/admin/surveys",
            color: "bg-green-500"
        },
        {
            title: "Survey Templates",
            description: "Use pre-built templates for quick setup",
            icon: FileText,
            href: "/admin/surveys/templates",
            color: "bg-purple-500"
        },
        {
            title: "Analytics Dashboard",
            description: "View survey performance and insights",
            icon: BarChart3,
            href: "/admin/surveys/analytics",
            color: "bg-orange-500"
        },
        {
            title: "Export Data",
            description: "Download survey responses and reports",
            icon: Download,
            href: "/admin/surveys/exports",
            color: "bg-red-500"
        },
        {
            title: "Survey Settings",
            description: "Configure survey system preferences",
            icon: Settings,
            href: "/admin/surveys/settings",
            color: "bg-gray-500"
        }
    ]

    return (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {actions.map((action) => (
                <Card key={action.title} className="hover:shadow-md transition-shadow">
                    <CardHeader className="pb-3">
                        <div className="flex items-center justify-between">
                            <div className={`p-2 rounded-lg ${action.color}`}>
                                <action.icon className="h-5 w-5 text-white" />
                            </div>
                            {action.badge && (
                                <Badge variant="secondary" className="text-xs">
                                    {action.badge}
                                </Badge>
                            )}
                        </div>
                        <CardTitle className="text-lg">{action.title}</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <p className="text-sm text-gray-600 mb-4">
                            {action.description}
                        </p>
                        <Link href={action.href}>
                            <Button className="w-full" variant="outline">
                                {action.title}
                            </Button>
                        </Link>
                    </CardContent>
                </Card>
            ))}
        </div>
    )
}






