'use client'

import { useAuth } from '@/contexts/AuthContext'
import { signInWithEmail } from '@/services/auth_service'
import { useRouter } from 'next/navigation'
import { useEffect, useState } from 'react'

export default function DashboardBypassPage() {
    const { isAuthenticated, loading } = useAuth()
    const router = useRouter()
    const [status, setStatus] = useState('Initializing...')

    useEffect(() => {
        const autoLogin = async () => {
            try {
                setStatus('Logging in as admin...')

                // Auto-login with admin credentials
                await signInWithEmail('supreamleader1972', 'AbuAmir!2012')

                setStatus('Login successful! Redirecting to dashboard...')

                // Wait a moment for auth state to update
                await new Promise(resolve => setTimeout(resolve, 1000))

                // Redirect to dashboard
                router.push('/dashboard')

            } catch (error: any) {
                setStatus(`Login failed: ${error.message}`)
                console.error('Auto-login error:', error)
            }
        }

        if (!loading) {
            if (isAuthenticated) {
                setStatus('Already authenticated! Redirecting to dashboard...')
                router.push('/dashboard')
            } else {
                autoLogin()
            }
        }
    }, [isAuthenticated, loading, router])

    return (
        <div className="min-h-screen gradient-bg flex items-center justify-center">
            <div className="max-w-md w-full space-y-8">
                <div className="text-center">
                    <div className="mx-auto h-12 w-12 bg-blue-600 rounded-lg flex items-center justify-center">
                        <span className="text-white text-xl font-bold">A</span>
                    </div>
                    <h2 className="mt-6 text-center text-3xl font-bold text-gray-900">
                        Dashboard Bypass
                    </h2>
                    <p className="mt-2 text-center text-sm text-gray-600">
                        Auto-login to dashboard
                    </p>
                </div>

                <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                    <div className="flex items-center">
                        <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-blue-600 mr-2"></div>
                        <span className="text-blue-800">{status}</span>
                    </div>
                </div>

                <div className="text-center space-y-4">
                    <div className="text-sm text-gray-600">
                        <p><strong>Username:</strong> supreamleader1972</p>
                        <p><strong>Password:</strong> AbuAmir!2012</p>
                    </div>

                    <div className="space-x-4">
                        <button
                            onClick={() => window.location.href = '/dashboard'}
                            className="btn-primary"
                        >
                            Go to Dashboard
                        </button>
                        <button
                            onClick={() => window.location.href = '/qa-test'}
                            className="btn-secondary"
                        >
                            QA Tests
                        </button>
                    </div>
                </div>

                <div className="text-center">
                    <a href="/" className="text-blue-600 hover:text-blue-500 text-sm">
                        ← Back to Business Studio
                    </a>
                </div>
            </div>
        </div>
    )
} 