'use client';

import Button from '@/components/Button';
import Card from '@/components/Card';
import FormInput from '@/components/FormInput';
import { ArrowLeft, Eye, EyeOff, Lock, Mail } from 'lucide-react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import React, { useState } from 'react';

export default function LoginPage() {
    const router = useRouter();
    const [formData, setFormData] = useState({
        email: '',
        password: '',
    });
    const [showPassword, setShowPassword] = useState(false);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [errors, setErrors] = useState<Record<string, string>>({});

    const handleInputChange = (field: string, value: string) => {
        setFormData(prev => ({ ...prev, [field]: value }));
        if (errors[field]) {
            setErrors(prev => ({ ...prev, [field]: '' }));
        }
    };

    const validateForm = () => {
        const newErrors: Record<string, string> = {};

        if (!formData.email.trim()) {
            newErrors.email = 'Email is required';
        } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
            newErrors.email = 'Please enter a valid email address';
        }

        if (!formData.password.trim()) {
            newErrors.password = 'Password is required';
        } else if (formData.password.length < 6) {
            newErrors.password = 'Password must be at least 6 characters';
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        if (!validateForm()) {
            return;
        }

        setIsSubmitting(true);

        // Simulate API call
        await new Promise(resolve => setTimeout(resolve, 1500));

        // Redirect to dashboard
        router.push('/dashboard');
    };

    const useDemoCredentials = () => {
        setFormData({
            email: 'demo@techcorp.com',
            password: 'demo123456',
        });
        setErrors({});
    };

    return (
        <div className="min-h-screen bg-gradient-to-br from-primary-50 to-secondary-50 flex items-center justify-center px-4">
            <div className="w-full max-w-md">
                {/* Header */}
                <div className="text-center mb-8">
                    <Link href="/" className="inline-flex items-center text-primary-600 hover:text-primary-700 mb-4">
                        <ArrowLeft className="w-4 h-4 mr-2" />
                        Back to Home
                    </Link>
                    <div className="flex items-center justify-center mb-4">
                        <div className="w-12 h-12 bg-primary-600 rounded-lg flex items-center justify-center">
                            <span className="text-white font-bold text-xl">A</span>
                        </div>
                    </div>
                    <h1 className="text-2xl font-bold text-neutral-900 mb-2">Welcome Back</h1>
                    <p className="text-neutral-600">Sign in to your App-Oint Enterprise account</p>
                </div>

                <Card>
                    <form onSubmit={handleSubmit} className="space-y-6">
                        <FormInput
                            label="Email Address"
                            icon={Mail}
                            type="email"
                            value={formData.email}
                            onChange={(value) => handleInputChange('email', value)}
                            error={errors.email}
                            placeholder="your@email.com"
                            required
                        />

                        <div className="space-y-2">
                            <label className="block text-sm font-medium text-neutral-700">
                                Password
                            </label>
                            <div className="relative">
                                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <Lock className="h-5 w-5 text-neutral-400" />
                                </div>
                                <input
                                    type={showPassword ? 'text' : 'password'}
                                    value={formData.password}
                                    onChange={(e) => handleInputChange('password', e.target.value)}
                                    className={`block w-full pl-10 pr-10 py-3 border rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors ${errors.password
                                            ? 'border-error-300 focus:ring-error-500 focus:border-error-500'
                                            : 'border-neutral-300'
                                        }`}
                                    placeholder="Enter your password"
                                    required
                                />
                                <button
                                    type="button"
                                    onClick={() => setShowPassword(!showPassword)}
                                    className="absolute inset-y-0 right-0 pr-3 flex items-center"
                                >
                                    {showPassword ? (
                                        <EyeOff className="h-5 w-5 text-neutral-400 hover:text-neutral-600" />
                                    ) : (
                                        <Eye className="h-5 w-5 text-neutral-400 hover:text-neutral-600" />
                                    )}
                                </button>
                            </div>
                            {errors.password && (
                                <p className="text-sm text-error-600">{errors.password}</p>
                            )}
                        </div>

                        <div className="flex items-center justify-between">
                            <label className="flex items-center">
                                <input
                                    type="checkbox"
                                    className="h-4 w-4 text-primary-600 focus:ring-primary-500 border-neutral-300 rounded"
                                />
                                <span className="ml-2 text-sm text-neutral-600">Remember me</span>
                            </label>
                            <Link href="#" className="text-sm text-primary-600 hover:text-primary-700">
                                Forgot password?
                            </Link>
                        </div>

                        <Button
                            type="submit"
                            variant="primary"
                            size="lg"
                            loading={isSubmitting}
                            className="w-full"
                        >
                            {isSubmitting ? 'Signing in...' : 'Sign In'}
                        </Button>

                        <Button
                            type="button"
                            variant="secondary"
                            size="lg"
                            onClick={useDemoCredentials}
                            className="w-full"
                        >
                            Use Demo Credentials
                        </Button>
                    </form>

                    <div className="mt-6 text-center">
                        <p className="text-sm text-neutral-600">
                            Don&apos;t have an account?{' '}
                            <Link href="/register" className="text-primary-600 hover:text-primary-700 font-medium">
                                Register your business
                            </Link>
                        </p>
                    </div>
                </Card>
            </div>
        </div>
    );
} 