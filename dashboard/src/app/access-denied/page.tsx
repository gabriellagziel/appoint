'use client'

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { AlertTriangle } from 'lucide-react'
import { useRouter } from 'next/navigation'

export default function AccessDeniedPage() {
    const router = useRouter()

    return (
        <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-red-50 to-orange-100 p-4">
            <Card className="w-full max-w-md">
                <CardHeader className="text-center">
                    <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-red-100">
                        <AlertTriangle className="h-6 w-6 text-red-600" />
                    </div>
                    <CardTitle className="text-2xl font-bold text-red-600">
                        Access Denied
                    </CardTitle>
                    <CardDescription className="text-gray-600">
                        You don't have permission to access this dashboard
                    </CardDescription>
                </CardHeader>

                <CardContent className="space-y-4">
                    <div className="text-center text-sm text-gray-500">
                        <p>
                            This dashboard is only available to business owners.
                            If you believe this is an error, please contact support.
                        </p>
                    </div>

                    <div className="flex flex-col space-y-2">
                        <Button
                            onClick={() => router.push('/login')}
                            className="w-full"
                        >
                            Back to Login
                        </Button>

                        <Button
                            variant="outline"
                            onClick={() => router.push('/')}
                            className="w-full"
                        >
                            Go to Home
                        </Button>
                    </div>
                </CardContent>
            </Card>
        </div>
    )
} 