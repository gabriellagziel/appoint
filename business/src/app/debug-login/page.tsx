'use client'

import { signInWithEmail } from '@/services/auth_service'
import { useState } from 'react'

export default function DebugLoginPage() {
    const [email, setEmail] = useState('supreamleader1972')
    const [password, setPassword] = useState('AbuAmir!2012')
    const [result, setResult] = useState('')
    const [loading, setLoading] = useState(false)

    const testLogin = async () => {
        setLoading(true)
        setResult('Testing login...')

        try {
            console.log('🔍 Starting login test...')
            console.log('🔍 Email:', email)
            console.log('🔍 Password:', password)

            const user = await signInWithEmail(email, password)

            console.log('✅ Login successful!', user)
            setResult(`✅ Login successful! User: ${user.displayName} (${user.email})`)

            // Try to redirect to dashboard
            setTimeout(() => {
                window.location.href = '/dashboard'
            }, 2000)

        } catch (error: any) {
            console.error('❌ Login failed:', error)
            setResult(`❌ Login failed: ${error.message}`)
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="min-h-screen gradient-bg flex items-center justify-center py-12 px-4">
            <div className="max-w-md w-full space-y-8">
                <div>
                    <h2 className="text-2xl font-bold text-center">Debug Login Test</h2>
                    <p className="text-center text-gray-600 mt-2">Testing login step by step</p>
                </div>

                <div className="space-y-4">
                    <div>
                        <label className="block text-sm font-medium text-gray-700">Username</label>
                        <input
                            type="text"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                        />
                    </div>

                    <div>
                        <label className="block text-sm font-medium text-gray-700">Password</label>
                        <input
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                        />
                    </div>
                </div>

                <button
                    onClick={testLogin}
                    disabled={loading}
                    className="w-full btn-primary"
                >
                    {loading ? 'Testing...' : 'Test Login'}
                </button>

                {result && (
                    <div className="mt-4 p-4 bg-gray-100 rounded-lg">
                        <p className="text-sm">{result}</p>
                    </div>
                )}

                <div className="text-center">
                    <p className="text-sm text-gray-600">
                        Default credentials:<br />
                        Username: <code>supreamleader1972</code><br />
                        Password: <code>AbuAmir!2012</code>
                    </p>
                </div>

                <div className="text-center">
                    <a href="/login" className="text-blue-600 hover:text-blue-500 text-sm">
                        ← Back to regular login
                    </a>
                </div>
            </div>
        </div>
    )
} 