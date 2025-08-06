'use client'

import { signInWithEmail } from '@/services/auth_service'
import { useState } from 'react'

export default function TestLoginPage() {
    const [result, setResult] = useState('')
    const [loading, setLoading] = useState(false)

    const testLogin = async () => {
        setLoading(true)
        setResult('Testing login...')

        try {
            const user = await signInWithEmail('supreamleader1972', 'AbuAmir!2012')
            setResult(`✅ Login successful! User: ${user.displayName} (${user.email})`)
        } catch (error: any) {
            setResult(`❌ Login failed: ${error.message}`)
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="min-h-screen gradient-bg flex items-center justify-center py-12 px-4">
            <div className="max-w-md w-full space-y-8">
                <div>
                    <h2 className="text-2xl font-bold text-center">Admin Login Test</h2>
                    <p className="text-center text-gray-600 mt-2">Testing admin credentials</p>
                </div>

                <button
                    onClick={testLogin}
                    disabled={loading}
                    className="w-full btn-primary"
                >
                    {loading ? 'Testing...' : 'Test Admin Login'}
                </button>

                {result && (
                    <div className="mt-4 p-4 bg-gray-100 rounded-lg">
                        <p className="text-sm">{result}</p>
                    </div>
                )}

                <div className="text-center">
                    <p className="text-sm text-gray-600">
                        Username: <code>supreamleader1972</code><br />
                        Password: <code>AbuAmir!2012</code>
                    </p>
                </div>
            </div>
        </div>
    )
} 