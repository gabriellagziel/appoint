"use client"

import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { useState } from 'react'

export function Hero() {
    const [email, setEmail] = useState('')
    const [isSubmitted, setIsSubmitted] = useState(false)

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault()
        // Placeholder for email capture - no backend wiring
        console.log('Email submitted:', email)
        setIsSubmitted(true)
        setEmail('')
    }

    return (
        <div className="relative bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen flex items-center">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
                <div className="text-center">
                    {/* Logo */}
                    <div className="flex justify-center mb-8">
                        <div className="bg-white p-4 rounded-full shadow-lg">
                            <svg
                                className="h-16 w-16 text-blue-600"
                                fill="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
                            </svg>
                        </div>
                    </div>

                    {/* Headline */}
                    <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
                        App-Oint: Coming Soon
                    </h1>

                    {/* Subheading */}
                    <p className="text-xl md:text-2xl text-gray-600 mb-12 max-w-3xl mx-auto">
                        We&apos;re building something amazing. Be the first to know when we launch and get early access to our revolutionary platform.
                    </p>

                    {/* Email Capture Form */}
                    <div className="max-w-md mx-auto">
                        {!isSubmitted ? (
                            <form onSubmit={handleSubmit} className="flex flex-col sm:flex-row gap-4">
                                <Input
                                    type="email"
                                    placeholder="Enter your email address"
                                    value={email}
                                    onChange={(e) => setEmail(e.target.value)}
                                    required
                                    className="flex-1"
                                />
                                <Button type="submit" className="px-8">
                                    Notify Me
                                </Button>
                            </form>
                        ) : (
                            <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                                                <p className="text-green-800 font-medium">
                  Thanks! We&apos;ll notify you when we launch.
                </p>
                            </div>
                        )}
                    </div>

                    {/* Additional Info */}
                    <div className="mt-12 text-sm text-gray-500">
                        <p>Join thousands of users who are already waiting for App-Oint</p>
                    </div>
                </div>
            </div>

            {/* Background decoration */}
            <div className="absolute inset-0 overflow-hidden pointer-events-none">
                <div className="absolute -top-40 -right-40 w-80 h-80 bg-blue-200 rounded-full opacity-20"></div>
                <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-indigo-200 rounded-full opacity-20"></div>
            </div>
        </div>
    )
} 