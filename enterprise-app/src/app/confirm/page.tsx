'use client';

import { useEffect, useState } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
import { Card } from '@/components/Card';
import { Button } from '@/components/Button';

export default function ConfirmPage() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const [status, setStatus] = useState<'loading' | 'success' | 'error'>('loading');
  const [message, setMessage] = useState('');

  useEffect(() => {
    const token = searchParams.get('token');
    
    if (!token) {
      setStatus('error');
      setMessage('Invalid confirmation link. Please check your email and try again.');
      return;
    }

    const confirmEmail = async () => {
      try {
        const response = await fetch('/api/confirm', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ token }),
        });

        const data = await response.json();

        if (response.ok) {
          setStatus('success');
          setMessage('Email confirmed successfully! You can now log in to your account.');
        } else {
          setStatus('error');
          setMessage(data.error || 'Confirmation failed. Please try again or contact support.');
        }
      } catch (error) {
        setStatus('error');
        setMessage('An error occurred. Please try again.');
      }
    };

    confirmEmail();
  }, [searchParams]);

  const handleLogin = () => {
    router.push('/login?confirmed=1');
  };

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center px-4">
      <Card className="w-full max-w-md">
        <div className="text-center">
          {status === 'loading' && (
            <div className="space-y-4">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
              <h2 className="text-xl font-semibold text-gray-900">Confirming your email...</h2>
              <p className="text-gray-600">Please wait while we verify your confirmation token.</p>
            </div>
          )}

          {status === 'success' && (
            <div className="space-y-4">
              <div className="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100">
                <svg className="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                </svg>
              </div>
              <h2 className="text-xl font-semibold text-gray-900">Email Confirmed!</h2>
              <p className="text-gray-600">{message}</p>
              <Button onClick={handleLogin} className="w-full">
                Continue to Login
              </Button>
            </div>
          )}

          {status === 'error' && (
            <div className="space-y-4">
              <div className="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100">
                <svg className="h-6 w-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </div>
              <h2 className="text-xl font-semibold text-gray-900">Confirmation Failed</h2>
              <p className="text-gray-600">{message}</p>
              <div className="space-y-2">
                <Button onClick={() => router.push('/register')} variant="outline" className="w-full">
                  Try Registering Again
                </Button>
                <Button onClick={() => router.push('/login')} className="w-full">
                  Go to Login
                </Button>
              </div>
            </div>
          )}
        </div>
      </Card>
    </div>
  );
}


