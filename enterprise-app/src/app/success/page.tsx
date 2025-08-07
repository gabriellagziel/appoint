'use client';

import Button from '@/components/Button';
import Card from '@/components/Card';
import { ArrowRight, CheckCircle, Clock, Key, Mail } from 'lucide-react';
import Link from 'next/link';

export default function SuccessPage() {
    return (
        <div className="min-h-screen bg-gradient-to-br from-success-50 to-primary-50 flex items-center justify-center px-4">
            <div className="w-full max-w-2xl">
                <Card className="text-center">
                    <div className="flex justify-center mb-6">
                        <div className="w-20 h-20 bg-success-100 rounded-full flex items-center justify-center">
                            <CheckCircle className="w-10 h-10 text-success-600" />
                        </div>
                    </div>

                    <h1 className="text-3xl font-bold text-neutral-900 mb-4">
                        Registration Successful!
                    </h1>

                    <p className="text-lg text-neutral-600 mb-8">
                        Thank you for registering your business with App-Oint Enterprise.
                        We&apos;ve received your application and will review it within 24 hours.
                    </p>

                    <div className="grid md:grid-cols-3 gap-6 mb-8">
                        <div className="text-center">
                            <div className="w-12 h-12 bg-primary-100 rounded-lg flex items-center justify-center mx-auto mb-3">
                                <Mail className="w-6 h-6 text-primary-600" />
                            </div>
                            <h3 className="font-semibold text-neutral-900 mb-1">Email Confirmation</h3>
                            <p className="text-sm text-neutral-600">Check your inbox for confirmation details</p>
                        </div>

                        <div className="text-center">
                            <div className="w-12 h-12 bg-accent-100 rounded-lg flex items-center justify-center mx-auto mb-3">
                                <Clock className="w-6 h-6 text-accent-600" />
                            </div>
                            <h3 className="font-semibold text-neutral-900 mb-1">24-Hour Review</h3>
                            <p className="text-sm text-neutral-600">We&apos;ll review and approve your account</p>
                        </div>

                        <div className="text-center">
                            <div className="w-12 h-12 bg-success-100 rounded-lg flex items-center justify-center mx-auto mb-3">
                                <Key className="w-6 h-6 text-success-600" />
                            </div>
                            <h3 className="font-semibold text-neutral-900 mb-1">Platform Access</h3>
                            <p className="text-sm text-neutral-600">Get your access keys upon approval</p>
                        </div>
                    </div>

                    <div className="bg-neutral-50 rounded-lg p-6 mb-8">
                        <h3 className="font-semibold text-neutral-900 mb-3">What happens next?</h3>
                        <div className="space-y-3 text-left">
                            <div className="flex items-start space-x-3">
                                <div className="w-6 h-6 bg-primary-600 text-white rounded-full flex items-center justify-center text-sm font-bold mt-0.5 flex-shrink-0">
                                    1
                                </div>
                                <div>
                                    <p className="font-medium text-neutral-900">Email Confirmation</p>
                                    <p className="text-sm text-neutral-600">You&apos;ll receive a confirmation email with your application details</p>
                                </div>
                            </div>
                            <div className="flex items-start space-x-3">
                                <div className="w-6 h-6 bg-primary-600 text-white rounded-full flex items-center justify-center text-sm font-bold mt-0.5 flex-shrink-0">
                                    2
                                </div>
                                <div>
                                    <p className="font-medium text-neutral-900">Account Review</p>
                                    <p className="text-sm text-neutral-600">Our team will review your business information within 24 hours</p>
                                </div>
                            </div>
                            <div className="flex items-start space-x-3">
                                <div className="w-6 h-6 bg-primary-600 text-white rounded-full flex items-center justify-center text-sm font-bold mt-0.5 flex-shrink-0">
                                    3
                                </div>
                                <div>
                                    <p className="font-medium text-neutral-900">Platform Access</p>
                                    <p className="text-sm text-neutral-600">Upon approval, you&apos;ll receive your access keys and dashboard access</p>
                                </div>
                            </div>
                            <div className="flex items-start space-x-3">
                                <div className="w-6 h-6 bg-primary-600 text-white rounded-full flex items-center justify-center text-sm font-bold mt-0.5 flex-shrink-0">
                                    4
                                </div>
                                <div>
                                    <p className="font-medium text-neutral-900">Start Integrating</p>
                                    <p className="text-sm text-neutral-600">Begin creating meetings and monitoring usage in your dashboard</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="flex flex-col sm:flex-row gap-4">
                        <Link href="/" className="flex-1">
                            <Button variant="secondary" size="lg" className="w-full">
                                Back to Home
                            </Button>
                        </Link>

                        <Link href="/login" className="flex-1">
                            <Button variant="primary" size="lg" className="w-full">
                                Go to Login
                                <ArrowRight className="w-4 h-4 ml-2" />
                            </Button>
                        </Link>
                    </div>

                    <div className="mt-8 pt-6 border-t border-neutral-200">
                        <p className="text-sm text-neutral-600">
                            Questions? Contact us at{' '}
                            <a href="mailto:enterprise@app-oint.com" className="text-primary-600 hover:text-primary-700 font-medium">
                                enterprise@app-oint.com
                            </a>
                        </p>
                    </div>
                </Card>
            </div>
        </div>
    );
} 