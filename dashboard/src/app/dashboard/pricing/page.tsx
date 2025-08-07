'use client'
export const dynamic = 'force-dynamic'

import { useState, useEffect } from 'react'
import { useAuth } from '@/contexts/AuthContext'
import { getPlans, Plan, Subscription } from '@/services/pricing_service'
import { getBusinessSubscription, createSubscription } from '@/services/subscription_service'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Alert, AlertDescription } from '@/components/ui/alert'
import { Check, Crown, Loader2, AlertCircle, Star } from 'lucide-react'

export default function PricingPage() {
  const { user } = useAuth()
  const [plans, setPlans] = useState<Plan[]>([])
  const [currentSubscription, setCurrentSubscription] = useState<Subscription | null>(null)
  const [loading, setLoading] = useState(true)
  const [upgrading, setUpgrading] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState<string | null>(null)

  useEffect(() => {
    if (user?.businessId) {
      loadData()
    }
  }, [user?.businessId])

  const loadData = async () => {
    try {
      setLoading(true)
      setError(null)
      
      // Load plans and current subscription in parallel
      const [plansData, subscriptionData] = await Promise.all([
        getPlans(),
        getBusinessSubscription(user!.businessId!)
      ])
      
      setPlans(plansData)
      setCurrentSubscription(subscriptionData)
    } catch (error) {
      console.error('Error loading pricing data:', error)
      setError('Failed to load pricing information')
    } finally {
      setLoading(false)
    }
  }

  const handleUpgrade = async (planId: string) => {
    if (!user?.businessId) return
    
    try {
      setUpgrading(planId)
      setError(null)
      setSuccess(null)
      
      // Create new subscription
      await createSubscription(user.businessId, planId)
      
      // Reload subscription data
      const newSubscription = await getBusinessSubscription(user.businessId)
      setCurrentSubscription(newSubscription)
      
      setSuccess('Successfully upgraded your plan!')
    } catch (error) {
      console.error('Error upgrading plan:', error)
      setError('Failed to upgrade plan. Please try again.')
    } finally {
      setUpgrading(null)
    }
  }

  const getCurrentPlanId = (): string => {
    return currentSubscription?.planId || 'free'
  }

  const isCurrentPlan = (planId: string): boolean => {
    return getCurrentPlanId() === planId
  }

  const formatPrice = (price: number): string => {
    return price === 0 ? 'Free' : `$${price}/month`
  }

  if (loading) {
    return (
      <div className="p-6">
        <div className="flex justify-center items-center h-64">
          <div className="flex items-center space-x-2">
            <Loader2 className="h-6 w-6 animate-spin" />
            <span>Loading pricing plans...</span>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="p-6">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Choose Your Plan
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Select the perfect plan for your business needs. All plans include our core features with different usage limits.
          </p>
        </div>

        {/* Alerts */}
        {error && (
          <Alert variant="destructive" className="mb-6">
            <AlertCircle className="h-4 w-4" />
            <AlertDescription>{error}</AlertDescription>
          </Alert>
        )}

        {success && (
          <Alert className="mb-6">
            <Check className="h-4 w-4" />
            <AlertDescription>{success}</AlertDescription>
          </Alert>
        )}

        {/* Current Plan Status */}
        {currentSubscription && (
          <div className="mb-8">
            <Card className="bg-blue-50 border-blue-200">
              <CardContent className="pt-6">
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="text-lg font-semibold text-blue-900">
                      Current Plan: {plans.find(p => p.id === currentSubscription.planId)?.name || 'Free'}
                    </h3>
                    <p className="text-blue-700">
                      Status: {currentSubscription.status === 'active' ? 'Active' : 'Inactive'}
                    </p>
                  </div>
                  <Badge variant="outline" className="text-blue-700 border-blue-300">
                    {currentSubscription.planId === 'free' ? 'Free Plan' : 'Paid Plan'}
                  </Badge>
                </div>
              </CardContent>
            </Card>
          </div>
        )}

        {/* Pricing Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {plans.map((plan) => (
            <Card 
              key={plan.id} 
              className={`relative ${
                plan.isPopular 
                  ? 'border-2 border-blue-500 shadow-lg scale-105' 
                  : 'border border-gray-200'
              }`}
            >
              {plan.isPopular && (
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <Badge className="bg-blue-500 text-white px-3 py-1">
                    <Star className="w-3 h-3 mr-1" />
                    Most Popular
                  </Badge>
                </div>
              )}

              <CardHeader className="text-center">
                <CardTitle className="text-2xl font-bold">
                  {plan.name}
                </CardTitle>
                <CardDescription>
                  {plan.description}
                </CardDescription>
                <div className="mt-4">
                  <span className="text-4xl font-bold text-gray-900">
                    {formatPrice(plan.price)}
                  </span>
                  {plan.price > 0 && (
                    <span className="text-gray-500 ml-2">/month</span>
                  )}
                </div>
              </CardHeader>

              <CardContent>
                {/* Features */}
                <div className="space-y-3 mb-6">
                  {plan.features.map((feature, index) => (
                    <div key={index} className="flex items-center">
                      <Check className="w-4 h-4 text-green-500 mr-3 flex-shrink-0" />
                      <span className="text-sm text-gray-700">{feature}</span>
                    </div>
                  ))}
                </div>

                {/* Limits */}
                <div className="space-y-2 mb-6 text-sm text-gray-600">
                  <div className="flex justify-between">
                    <span>Meetings:</span>
                    <span>{plan.meetingLimit === 'unlimited' ? 'Unlimited' : `${plan.meetingLimit}/month`}</span>
                  </div>
                  <div className="flex justify-between">
                    <span>Map Loads:</span>
                    <span>{plan.mapLimit}/month</span>
                  </div>
                  <div className="flex justify-between">
                    <span>Team Members:</span>
                    <span>{plan.maxTeamMembers}</span>
                  </div>
                  <div className="flex justify-between">
                    <span>Customers:</span>
                    <span>{plan.maxCustomers}</span>
                  </div>
                </div>

                {/* Action Button */}
                <Button
                  className={`w-full ${
                    isCurrentPlan(plan.id)
                      ? 'bg-gray-100 text-gray-500 cursor-not-allowed'
                      : plan.isPopular
                      ? 'bg-blue-600 hover:bg-blue-700'
                      : 'bg-gray-900 hover:bg-gray-800'
                  }`}
                  disabled={isCurrentPlan(plan.id) || upgrading === plan.id}
                  onClick={() => handleUpgrade(plan.id)}
                >
                  {upgrading === plan.id ? (
                    <>
                      <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                      Upgrading...
                    </>
                  ) : isCurrentPlan(plan.id) ? (
                    'Current Plan'
                  ) : (
                    `Upgrade to ${plan.name}`
                  )}
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* FAQ Section */}
        <div className="mt-16">
          <h2 className="text-2xl font-bold text-gray-900 mb-8 text-center">
            Frequently Asked Questions
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">Can I change my plan anytime?</h3>
              <p className="text-gray-600">Yes, you can upgrade or downgrade your plan at any time. Changes take effect immediately.</p>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">What happens if I exceed my limits?</h3>
              <p className="text-gray-600">You'll receive a notification and can upgrade your plan to continue using the service.</p>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">Is there a free trial?</h3>
              <p className="text-gray-600">Yes, all paid plans come with a 14-day free trial. No credit card required.</p>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">Can I cancel anytime?</h3>
              <p className="text-gray-600">Absolutely. You can cancel your subscription at any time with no cancellation fees.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
} 