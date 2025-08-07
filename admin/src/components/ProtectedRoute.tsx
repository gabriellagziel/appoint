"use client"

import { useAuth } from '@/contexts/AuthContext';
import { useRouter } from 'next/navigation';
import { useEffect } from 'react';

interface ProtectedRouteProps {
    children: React.ReactNode;
    requiredRole?: 'admin' | 'super_admin';
    fallback?: React.ReactNode;
}

export function ProtectedRoute({
    children,
    requiredRole = 'admin',
    fallback
}: ProtectedRouteProps) {
    const { user, loading, isAuthenticated } = useAuth();
    const router = useRouter();

    useEffect(() => {
        if (!loading) {
            if (!isAuthenticated) {
                router.push('/admin/login');
                return;
            }

            // Check role requirements
            if (requiredRole === 'super_admin' && user?.role !== 'super_admin') {
                router.push('/admin/login?error=insufficient_permissions');
                return;
            }
        }
    }, [user, loading, isAuthenticated, requiredRole, router]);

    // Show loading state
    if (loading) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                    <p className="mt-4 text-gray-600">Loading...</p>
                </div>
            </div>
        );
    }

    // Show fallback or redirect if not authenticated
    if (!isAuthenticated) {
        return fallback || (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                    <p className="mt-4 text-gray-600">Redirecting to login...</p>
                </div>
            </div>
        );
    }

    // Check role requirements
    if (requiredRole === 'super_admin' && user?.role !== 'super_admin') {
        return fallback || (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="text-center">
                    <h2 className="text-2xl font-bold text-red-600 mb-4">Access Denied</h2>
                    <p className="text-gray-600">You don't have sufficient permissions to access this page.</p>
                </div>
            </div>
        );
    }

    return <>{children}</>;
} 