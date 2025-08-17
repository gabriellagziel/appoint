import { NextResponse } from 'next/server'
import { getStripe } from '@/lib/stripe'
import { getAdminAuth, getAdminDb } from '@/lib/firebaseAdmin'
import { z } from 'zod'

export async function POST(request: Request) {
  const auth = getAdminAuth()
  const db = getAdminDb()
  const stripe = getStripe()
  const schema = z.object({ priceId: z.string().min(2) })
  try {
    const authHeader = (request.headers.get('authorization') || '').replace(/^Bearer\s+/i, '')
    if (!authHeader) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    const decoded = await auth.verifyIdToken(authHeader)
    const orgId = (decoded as any).orgId || decoded.uid
    const body = await request.json()
    const { priceId } = schema.parse(body)

    const orgRef = db.collection('organizations').doc(orgId)
    const orgSnap = await orgRef.get()
    const org = orgSnap.data() || {}

    let stripeCustomerId = org.stripeCustomerId as string | undefined
    if (!stripeCustomerId) {
      const customer = await stripe.customers.create({ email: decoded.email || undefined, metadata: { orgId } })
      stripeCustomerId = customer.id
      await orgRef.set({ stripeCustomerId }, { merge: true })
    }

    const subscription = await stripe.subscriptions.create({
      customer: stripeCustomerId,
      items: [{ price: priceId }],
      payment_behavior: 'default_incomplete',
      expand: ['latest_invoice.payment_intent'],
    })

    const payload = {
      orgId,
      planId: priceId,
      status: subscription.status,
      stripeCustomerId,
      stripeSubscriptionId: subscription.id,
      currentPeriodStart: new Date((subscription.current_period_start || 0) * 1000),
      currentPeriodEnd: new Date((subscription.current_period_end || 0) * 1000),
      cancelAtPeriodEnd: subscription.cancel_at_period_end || false,
      updatedAt: new Date(),
      createdAt: new Date(),
    }
    const subsSnap = await db.collection('org_subscriptions').where('orgId', '==', orgId).get()
    if (subsSnap.empty) await db.collection('org_subscriptions').add(payload)
    else await db.collection('org_subscriptions').doc(subsSnap.docs[0].id).set(payload, { merge: true })

    const latestInvoice: any = (subscription as any).latest_invoice
    const paymentIntent = latestInvoice?.payment_intent
    return NextResponse.json({ subscriptionId: subscription.id, clientSecret: paymentIntent?.client_secret || null, status: subscription.status })
  } catch (e: any) {
    const status = e?.name === 'ZodError' ? 400 : 500
    return NextResponse.json({ error: e?.message || 'Upgrade failed' }, { status })
  }
}


