// Server-side Stripe helper for dashboard APIs
import Stripe from 'stripe'

let stripe: Stripe | null = null

export function getStripe(): Stripe {
  if (stripe) return stripe
  const key = process.env.STRIPE_SECRET_KEY || ''
  if (!key) throw new Error('STRIPE_SECRET_KEY not configured')
  stripe = new Stripe(key, { apiVersion: '2024-06-20' } as any)
  return stripe
}


