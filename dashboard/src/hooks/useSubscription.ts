import { useState, useEffect } from 'react'
import { useAuth } from '@/contexts/AuthContext'
import { getBusinessSubscription } from '@/services/subscription_service'
import { getPlan, Plan, Subscription } from '@/services/pricing_service'

export const useSubscription = () => {
  const { user } = useAuth()
  const [subscription, setSubscription] = useState<Subscription | null>(null)
  const [currentPlan, setCurrentPlan] = useState<Plan | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (user?.businessId) {
      loadSubscription()
    }
  }, [user?.businessId])

  const loadSubscription = async () => {
    try {
      setLoading(true)
      setError(null)
      
      const subscriptionData = await getBusinessSubscription(user!.businessId!)
      setSubscription(subscriptionData)
      
      if (subscriptionData?.planId) {
        const planData = await getPlan(subscriptionData.planId)
        setCurrentPlan(planData)
      }
    } catch (error) {
      console.error('Error loading subscription:', error)
      setError('Failed to load subscription')
    } finally {
      setLoading(false)
    }
  }

  const refreshSubscription = () => {
    loadSubscription()
  }

  return {
    subscription,
    currentPlan,
    loading,
    error,
    refreshSubscription
  }
} 