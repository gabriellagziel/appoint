import { NextResponse } from 'next/server'
import { getAdminAuth, getAdminDb } from '@/lib/firebaseAdmin'
import { getStripe } from '@/lib/stripe'
import { z } from 'zod'

// Create or upgrade a subscription for the business associated with the current user.
// Server-side gating: requires valid Firebase ID token in Authorization header.
export async function POST(request: Request) {
  const auth = getAdminAuth()
  const db = getAdminDb()
  const schema = z.object({ planId: z.string().min(2) })
  try {
    const authHeader = (request.headers.get('authorization') || '').replace(/^Bearer\s+/i, '')
    if (!authHeader) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    const decoded = await auth.verifyIdToken(authHeader)
    const uid = decoded.uid
    const body = await request.json()
    const { planId } = schema.parse(body)

    // Lookup user's businessId (assumes mapping in Firestore users collection)
    const userDoc = await db.collection('users').doc(uid).get()
    const businessId = (userDoc.data() || {}).businessId
    if (!businessId) return NextResponse.json({ error: 'No business linked' }, { status: 400 })

    // Create/lookup Stripe customer for this business
    const businessRef = db.collection('businesses').doc(businessId)
    const businessSnap = await businessRef.get()
    const business = businessSnap.data() || {}
    const stripe = getStripe()

    let stripeCustomerId = business.stripeCustomerId as string | undefined
    if (!stripeCustomerId) {
      const customer = await stripe.customers.create({
        email: decoded.email || undefined,
        metadata: { businessId },
      })
      stripeCustomerId = customer.id
      await businessRef.set({ stripeCustomerId }, { merge: true })
    }

    // Create a subscription on Stripe
    const subscription = await stripe.subscriptions.create({
      customer: stripeCustomerId,
      items: [{ price: planId }], // planId must be a valid Stripe Price ID
      payment_behavior: 'default_incomplete',
      expand: ['latest_invoice.payment_intent'],
    })

    // Persist subscription link in Firestore
    const subsSnap = await db.collection('subscriptions').where('businessId', '==', businessId).get()
    const payload = {
      businessId,
      planId,
      status: subscription.status,
      stripeCustomerId,
      stripeSubscriptionId: subscription.id,
      currentPeriodStart: new Date((subscription.current_period_start || 0) * 1000),
      currentPeriodEnd: new Date((subscription.current_period_end || 0) * 1000),
      cancelAtPeriodEnd: subscription.cancel_at_period_end || false,
      updatedAt: new Date(),
      createdAt: new Date(),
    }
    if (subsSnap.empty) {
      await db.collection('subscriptions').add(payload)
    } else {
      await db.collection('subscriptions').doc(subsSnap.docs[0].id).set(payload, { merge: true })
    }

    // Return client secret if needed for payment confirmation on the client
    const latestInvoice: any = (subscription as any).latest_invoice
    const paymentIntent = latestInvoice?.payment_intent
    return NextResponse.json({
      subscriptionId: subscription.id,
      clientSecret: paymentIntent?.client_secret || null,
      status: subscription.status,
    })
  } catch (e: any) {
    const status = e?.name === 'ZodError' ? 400 : 500
    return NextResponse.json({ error: e?.message || 'Upgrade failed' }, { status })
  }
}


