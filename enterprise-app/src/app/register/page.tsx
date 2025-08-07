'use client';

import Button from '@/components/Button';
import Card from '@/components/Card';
import FormInput from '@/components/FormInput';
import { ArrowLeft, Building2, CheckCircle, Globe, Mail, Phone } from 'lucide-react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import React, { useState } from 'react';

export default function RegisterPage() {
    const router = useRouter();
    const [formData, setFormData] = useState({
        businessName: '',
        contactName: '',
        email: '',
        phone: '',
        website: '',
        industry: '',
        expectedMeetings: '',
    });
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

        if (!formData.businessName.trim()) {
            newErrors.businessName = 'Business name is required';
        }

        if (!formData.contactName.trim()) {
            newErrors.contactName = 'Contact name is required';
        }

        if (!formData.email.trim()) {
            newErrors.email = 'Email is required';
        } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
            newErrors.email = 'Please enter a valid email address';
        }

        if (!formData.phone.trim()) {
            newErrors.phone = 'Phone number is required';
        }

        if (!formData.industry.trim()) {
            newErrors.industry = 'Industry is required';
        }

        if (!formData.expectedMeetings.trim()) {
            newErrors.expectedMeetings = 'Expected meetings per month is required';
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
        await new Promise(resolve => setTimeout(resolve, 2000));

        // Redirect to success page
        router.push('/success');
    };

    const fillDemoData = () => {
        setFormData({
            businessName: 'TechCorp Solutions',
            contactName: 'John Smith',
            email: 'john@techcorp.com',
            phone: '+1 (555) 123-4567',
            website: 'https://techcorp.com',
            industry: 'Technology',
            expectedMeetings: '500',
        });
        setErrors({});
    };

    return (
        <div className="min-h-screen bg-gradient-to-br from-primary-50 to-secondary-50">
            <div className="max-w-4xl mx-auto px-4 py-8">
                {/* Header */}
                <div className="text-center mb-8">
                    <Link href="/" className="inline-flex items-center text-primary-600 hover:text-primary-700 mb-4">
                        <ArrowLeft className="w-4 h-4 mr-2" />
                        Back to Home
                    </Link>
                    <h1 className="text-3xl font-bold text-neutral-900 mb-2">Business Registration</h1>
                    <p className="text-neutral-600">Get started with App-Oint Enterprise in minutes</p>
                </div>

                <div className="grid lg:grid-cols-3 gap-8">
                    {/* Form */}
                    <div className="lg:col-span-2">
                        <Card>
                            <form onSubmit={handleSubmit} className="space-y-6">
                                <div className="grid md:grid-cols-2 gap-6">
                                    <FormInput
                                        label="Business Name"
                                        icon={Building2}
                                        value={formData.businessName}
                                        onChange={(value) => handleInputChange('businessName', value)}
                                        error={errors.businessName}
                                        placeholder="Your Company Name"
                                        required
                                    />

                                    <FormInput
                                        label="Contact Name"
                                        icon={Building2}
                                        value={formData.contactName}
                                        onChange={(value) => handleInputChange('contactName', value)}
                                        error={errors.contactName}
                                        placeholder="Your Full Name"
                                        required
                                    />

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

                                    <FormInput
                                        label="Phone Number"
                                        icon={Phone}
                                        value={formData.phone}
                                        onChange={(value) => handleInputChange('phone', value)}
                                        error={errors.phone}
                                        placeholder="+1 (555) 123-4567"
                                        required
                                    />

                                    <FormInput
                                        label="Website (Optional)"
                                        icon={Globe}
                                        value={formData.website}
                                        onChange={(value) => handleInputChange('website', value)}
                                        placeholder="https://yourwebsite.com"
                                    />

                                    <FormInput
                                        label="Industry"
                                        icon={Building2}
                                        value={formData.industry}
                                        onChange={(value) => handleInputChange('industry', value)}
                                        error={errors.industry}
                                        placeholder="Technology, Healthcare, etc."
                                        required
                                    />
                                </div>

                                <FormInput
                                    label="Expected Meetings per Month"
                                    icon={Building2}
                                    value={formData.expectedMeetings}
                                    onChange={(value) => handleInputChange('expectedMeetings', value)}
                                    error={errors.expectedMeetings}
                                    placeholder="e.g., 500"
                                    required
                                />

                                <div className="flex flex-col sm:flex-row gap-4 pt-4">
                                    <Button
                                        type="submit"
                                        variant="primary"
                                        size="lg"
                                        loading={isSubmitting}
                                        className="flex-1"
                                    >
                                        {isSubmitting ? 'Processing...' : 'Register Business'}
                                    </Button>

                                    <Button
                                        type="button"
                                        variant="secondary"
                                        size="lg"
                                        onClick={fillDemoData}
                                        className="flex-1"
                                    >
                                        Fill Demo Data
                                    </Button>
                                </div>
                            </form>
                        </Card>
                    </div>

                    {/* Sidebar */}
                    <div className="space-y-6">
                        <Card>
                            <h3 className="text-lg font-semibold text-neutral-900 mb-4">What You&apos;ll Get</h3>
                            <div className="space-y-3">
                                <div className="flex items-start space-x-3">
                                    <CheckCircle className="w-5 h-5 text-success-500 mt-0.5 flex-shrink-0" />
                                    <div>
                                        <p className="font-medium text-neutral-900">Instant Platform Access</p>
                                        <p className="text-sm text-neutral-600">Get your access keys immediately after approval</p>
                                    </div>
                                </div>
                                <div className="flex items-start space-x-3">
                                    <CheckCircle className="w-5 h-5 text-success-500 mt-0.5 flex-shrink-0" />
                                    <div>
                                        <p className="font-medium text-neutral-900">Usage Dashboard</p>
                                        <p className="text-sm text-neutral-600">Monitor meetings, analytics, and billing</p>
                                    </div>
                                </div>
                                <div className="flex items-start space-x-3">
                                    <CheckCircle className="w-5 h-5 text-success-500 mt-0.5 flex-shrink-0" />
                                    <div>
                                        <p className="font-medium text-neutral-900">Monthly Invoicing</p>
                                        <p className="text-sm text-neutral-600">No subscriptions, pay per meeting</p>
                                    </div>
                                </div>
                                <div className="flex items-start space-x-3">
                                    <CheckCircle className="w-5 h-5 text-success-500 mt-0.5 flex-shrink-0" />
                                    <div>
                                        <p className="font-medium text-neutral-900">24/7 Support</p>
                                        <p className="text-sm text-neutral-600">Enterprise-grade support included</p>
                                    </div>
                                </div>
                            </div>
                        </Card>

                        <Card>
                            <h3 className="text-lg font-semibold text-neutral-900 mb-4">Pricing</h3>
                            <div className="space-y-3">
                                <div className="p-3 bg-primary-50 rounded-lg">
                                    <p className="font-medium text-primary-900">Basic Meeting</p>
                                    <p className="text-2xl font-bold text-primary-600">€0.49</p>
                                    <p className="text-sm text-primary-700">per meeting</p>
                                </div>
                                <div className="p-3 bg-accent-50 rounded-lg">
                                    <p className="font-medium text-accent-900">Meeting with Map</p>
                                    <p className="text-2xl font-bold text-accent-600">€0.99</p>
                                    <p className="text-sm text-accent-700">per meeting</p>
                                </div>
                            </div>
                        </Card>
                    </div>
                </div>
            </div>
        </div>
    );
} 