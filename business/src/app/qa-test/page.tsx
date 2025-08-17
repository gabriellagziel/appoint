'use client'

import { useAuth } from '@/contexts/AuthContext'
import { getCurrentUser, onAuthStateChange, signInWithEmail, signOutUser } from '@/services/auth_service'
import { useState } from 'react'

interface TestResult {
    test: string
    status: 'pending' | 'pass' | 'fail'
    message: string
    details?: any
}

export default function QATestPage() {
    const { user, loading, isAuthenticated } = useAuth()
    const [results, setResults] = useState<TestResult[]>([])
    const [isRunning, setIsRunning] = useState(false)
    const [currentTest, setCurrentTest] = useState('')

    const addResult = (test: string, status: 'pass' | 'fail', message: string, details?: any) => {
        setResults(prev => [...prev, { test, status, message, details }])
    }

    const runAllTests = async () => {
        setIsRunning(true)
        setResults([])

        // Test 1: Check if auth service is accessible
        setCurrentTest('Testing auth service accessibility...')
        try {
            const testUser = getCurrentUser()
            addResult('Auth Service Access', 'pass', 'Auth service is accessible', { currentUser: testUser })
        } catch (error) {
            addResult('Auth Service Access', 'fail', 'Auth service not accessible', { error })
        }

        // Test 2: Test admin login
        setCurrentTest('Testing admin login...')
        try {
            const adminUser = await signInWithEmail('supreamleader1972', 'AbuAmir!2012')
            addResult('Admin Login', 'pass', 'Admin login successful', { user: adminUser })
        } catch (error: any) {
            addResult('Admin Login', 'fail', 'Admin login failed', { error: error.message })
        }

        // Test 3: Check AuthContext state
        setCurrentTest('Checking AuthContext state...')
        await new Promise(resolve => setTimeout(resolve, 1000)) // Wait for state to update

        addResult('AuthContext State',
            isAuthenticated ? 'pass' : 'fail',
            isAuthenticated ? 'User is authenticated' : 'User is not authenticated',
            { isAuthenticated, user, loading }
        )

        // Test 4: Test logout
        setCurrentTest('Testing logout...')
        try {
            await signOutUser()
            addResult('Logout', 'pass', 'Logout successful')
        } catch (error: any) {
            addResult('Logout', 'fail', 'Logout failed', { error: error.message })
        }

        // Test 5: Check AuthContext after logout
        setCurrentTest('Checking AuthContext after logout...')
        await new Promise(resolve => setTimeout(resolve, 1000))

        addResult('AuthContext After Logout',
            !isAuthenticated ? 'pass' : 'fail',
            !isAuthenticated ? 'User is properly logged out' : 'User is still authenticated',
            { isAuthenticated, user, loading }
        )

        // Test 6: Test auth state change listener
        setCurrentTest('Testing auth state change listener...')
        let listenerCalled = false
        let listenerUser: any = null

        const unsubscribe = onAuthStateChange((user) => {
            listenerCalled = true
            listenerUser = user
        })

        // Trigger a login to test the listener
        try {
            await signInWithEmail('supreamleader1972', 'AbuAmir!2012')
            await new Promise(resolve => setTimeout(resolve, 500))

            addResult('Auth State Change Listener',
                listenerCalled ? 'pass' : 'fail',
                listenerCalled ? 'Listener was called' : 'Listener was not called',
                { listenerCalled, listenerUser }
            )
        } catch (error: any) {
            addResult('Auth State Change Listener', 'fail', 'Failed to test listener', { error: error.message })
        }

        unsubscribe()

        setIsRunning(false)
        setCurrentTest('')
    }

    const testDashboardAccess = async () => {
        setCurrentTest('Testing dashboard access...')

        try {
            // First login
            await signInWithEmail('supreamleader1972', 'AbuAmir!2012')
            await new Promise(resolve => setTimeout(resolve, 1000))

            // Check if we can access dashboard
            const response = await fetch('/dashboard', { method: 'GET' })
            const canAccess = response.ok

            addResult('Dashboard Access',
                canAccess ? 'pass' : 'fail',
                canAccess ? 'Dashboard is accessible' : 'Dashboard is not accessible',
                { status: response.status, ok: response.ok }
            )

            // Try to redirect to dashboard
            window.location.href = '/dashboard'

        } catch (error: any) {
            addResult('Dashboard Access', 'fail', 'Dashboard access test failed', { error: error.message })
        }
    }

    const clearResults = () => {
        setResults([])
    }

    return (
        <div className="min-h-screen gradient-bg p-8">
            <div className="max-w-4xl mx-auto">
                <div className="bg-white rounded-lg shadow-lg p-6">
                    <h1 className="text-3xl font-bold text-center mb-8">🔍 Authentication QA Test Suite</h1>

                    <div className="mb-8">
                        <div className="flex space-x-4 mb-4">
                            <button
                                onClick={runAllTests}
                                disabled={isRunning}
                                className="btn-primary px-6 py-2"
                            >
                                {isRunning ? 'Running Tests...' : 'Run All Tests'}
                            </button>

                            <button
                                onClick={testDashboardAccess}
                                disabled={isRunning}
                                className="btn-secondary px-6 py-2"
                            >
                                Test Dashboard Access
                            </button>

                            <button
                                onClick={clearResults}
                                className="bg-gray-500 text-white px-6 py-2 rounded hover:bg-gray-600"
                            >
                                Clear Results
                            </button>
                        </div>

                        {isRunning && (
                            <div className="bg-blue-50 border border-blue-200 rounded p-4">
                                <div className="flex items-center">
                                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-blue-600 mr-2"></div>
                                    <span className="text-blue-800">{currentTest}</span>
                                </div>
                            </div>
                        )}
                    </div>

                    {/* Current Auth State */}
                    <div className="mb-8 p-4 bg-gray-50 rounded-lg">
                        <h3 className="text-lg font-semibold mb-2">Current Authentication State</h3>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                            <div>
                                <strong>Loading:</strong> {loading ? 'Yes' : 'No'}
                            </div>
                            <div>
                                <strong>Authenticated:</strong> {isAuthenticated ? 'Yes' : 'No'}
                            </div>
                            <div>
                                <strong>User:</strong> {user ? `${user.displayName} (${user.email})` : 'None'}
                            </div>
                        </div>
                    </div>

                    {/* Test Results */}
                    <div>
                        <h3 className="text-lg font-semibold mb-4">Test Results</h3>
                        {results.length === 0 ? (
                            <p className="text-gray-500 text-center py-8">No tests run yet. Click &quot;Run All Tests&quot; to start.</p>
                        ) : (
                            <div className="space-y-3">
                                {results.map((result, index) => (
                                    <div
                                        key={index}
                                        className={`p-4 rounded-lg border ${result.status === 'pass'
                                                ? 'bg-green-50 border-green-200'
                                                : result.status === 'fail'
                                                    ? 'bg-red-50 border-red-200'
                                                    : 'bg-yellow-50 border-yellow-200'
                                            }`}
                                    >
                                        <div className="flex items-center justify-between">
                                            <div className="flex items-center">
                                                {result.status === 'pass' && (
                                                    <span className="text-green-600 mr-2">✅</span>
                                                )}
                                                {result.status === 'fail' && (
                                                    <span className="text-red-600 mr-2">❌</span>
                                                )}
                                                <span className="font-medium">{result.test}</span>
                                            </div>
                                            <span className={`px-2 py-1 rounded text-xs font-medium ${result.status === 'pass'
                                                    ? 'bg-green-100 text-green-800'
                                                    : result.status === 'fail'
                                                        ? 'bg-red-100 text-red-800'
                                                        : 'bg-yellow-100 text-yellow-800'
                                                }`}>
                                                {result.status.toUpperCase()}
                                            </span>
                                        </div>
                                        <p className="text-sm mt-2">{result.message}</p>
                                        {result.details && (
                                            <details className="mt-2">
                                                <summary className="text-sm font-medium cursor-pointer">View Details</summary>
                                                <pre className="text-xs bg-gray-100 p-2 rounded mt-2 overflow-auto">
                                                    {JSON.stringify(result.details, null, 2)}
                                                </pre>
                                            </details>
                                        )}
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>

                    {/* Quick Actions */}
                    <div className="mt-8 p-4 bg-blue-50 rounded-lg">
                        <h3 className="text-lg font-semibold mb-4">Quick Actions</h3>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <h4 className="font-medium mb-2">Admin Credentials</h4>
                                <div className="text-sm space-y-1">
                                    <div><strong>Username:</strong> supreamleader1972</div>
                                    <div><strong>Password:</strong> AbuAmir!2012</div>
                                </div>
                            </div>
                            <div>
                                <h4 className="font-medium mb-2">Test Pages</h4>
                                <div className="text-sm space-y-1">
                                    <a href="/login" className="text-blue-600 hover:underline block">→ Login Page</a>
                                    <a href="/dashboard" className="text-blue-600 hover:underline block">→ Dashboard</a>
                                    <a href="/debug-login" className="text-blue-600 hover:underline block">→ Debug Login</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
} 