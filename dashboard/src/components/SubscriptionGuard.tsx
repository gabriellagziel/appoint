'use client'

import { ReactNode } from 'react'
import { useSubscription } from '@/hooks/useSubscription'
import { checkUsageLimits } from '@/services/pricing_service'
import { Alert, AlertDescription } from '@/components/ui/alert'
import { Button } from '@/components/ui/button'
import { AlertTriangle, Crown } from 'lucide-react'
import { useRouter } from 'next/navigation'

interface SubscriptionGuardProps {
  children: ReactNode
  feature: string
  requiredPlan?: string
  usageType?: 'meetingsCount' | 'mapLoadCount' | 'customersCount' | 'teamMembersCount'
}

export const SubscriptionGuard = ({ 
  children, 
  feature, 
  requiredPlan,
  usageType 
}: SubscriptionGuardProps) => {
  const { subscription, currentPlan, loading } = useSubscription()
  const router = useRouter()

  if (loading) {
    return (
      <div className="flex justify-center items-center h-32">
        <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-gray-900"></div>
      </div>
    )
  }

  // Check if user has required plan
  if (requiredPlan && currentPlan?.id !== requiredPlan) {
    return (
      <Alert>
        <Crown className="h-4 w-4" />
        <AlertDescription>
          This feature requires the {requiredPlan} plan. 
          <Button 
            variant="link" 
            className="p-0 h-auto font-semibold ml-1"
            onClick={() => router.push('/dashboard/pricing')}
          >
            Upgrade now
          </Button>
        </AlertDescription>
      </Alert>
    )
  }

  // Check usage limits
  if (usageType && subscription && currentPlan) {
    const usageCheck = checkUsageLimits(subscription, currentPlan)
    
    if (usageCheck.exceeded) {
      return (
        <Alert variant="destructive">
          <AlertTriangle className="h-4 w-4" />
          <AlertDescription>
            {usageCheck.message}
            <Button 
              variant="link" 
              className="p-0 h-auto font-semibold ml-1 text-red-600"
              onClick={() => router.push('/dashboard/pricing')}
            >
              Upgrade now
            </Button>
          </AlertDescription>
        </Alert>
      )
    }
  }

  // Check if subscription is active
  if (subscription && subscription.status !== 'active') {
    return (
      <Alert variant="destructive">
        <AlertTriangle className="h-4 w-4" />
        <AlertDescription>
          Your subscription is not active. Please renew your subscription to access this feature.
          <Button 
            variant="link" 
            className="p-0 h-auto font-semibold ml-1 text-red-600"
            onClick={() => router.push('/dashboard/pricing')}
          >
            Renew subscription
          </Button>
        </AlertDescription>
      </Alert>
    )
  }

  return <>{children}</>
} 