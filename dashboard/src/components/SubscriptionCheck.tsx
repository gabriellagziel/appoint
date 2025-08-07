'use client'

import { ReactNode, useEffect } from 'react'
import { useAuth } from '@/contexts/AuthContext'
import { useSubscription } from '@/hooks/useSubscription'
import { useRouter } from 'next/navigation'
import { getBusinessSubscription } from '@/services/subscription_service'

interface SubscriptionCheckProps {
  children: ReactNode
}

export const SubscriptionCheck = ({ children }: SubscriptionCheckProps) => {
  const { user } = useAuth()
  const { subscription, loading } = useSubscription()
  const router = useRouter()

  useEffect(() => {
    const checkSubscription = async () => {
      if (user?.businessId && !loading) {
        // If user has no subscription, redirect to pricing
        if (!subscription) {
          router.push('/dashboard/pricing')
          return
        }

        // If subscription is expired, redirect to pricing
        if (subscription.status !== 'active') {
          router.push('/dashboard/pricing')
          return
        }
      }
    }

    checkSubscription()
  }, [user?.businessId, subscription, loading, router])

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="flex items-center space-x-2">
          <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-gray-900"></div>
          <span>Checking subscription...</span>
        </div>
      </div>
    )
  }

  return <>{children}</>
} 