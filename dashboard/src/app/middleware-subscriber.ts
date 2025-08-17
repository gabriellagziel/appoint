// Optional per-route subscriber-only middleware helpers for reuse
import { NextResponse, type NextRequest } from 'next/server'
import { getAdminDb, getAdminAuth } from '@/lib/firebaseAdmin'
import { getStripe } from '@/lib/stripe'

export async function requireActiveSubscription(request: NextRequest): Promise<NextResponse | null> {
  try {
    const authHeader = (request.headers.get('authorization') || '').replace(/^Bearer\s+/i, '')
    if (!authHeader) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 }) as any
    const auth = getAdminAuth()
    const db = getAdminDb()
    const stripe = getStripe()
    const decoded = await auth.verifyIdToken(authHeader)
    const uid = decoded.uid
    const userDoc = await db.collection('users').doc(uid).get()
    const businessId = (userDoc.data() || {}).businessId
    if (!businessId) return NextResponse.json({ error: 'No business' }, { status: 400 }) as any
    const subsSnap = await db.collection('subscriptions').where('businessId', '==', businessId).get()
    if (subsSnap.empty) return NextResponse.json({ error: 'Subscription required' }, { status: 403 }) as any
    const sub = subsSnap.docs[0].data()
    const stripeSub = await stripe.subscriptions.retrieve(sub.stripeSubscriptionId)
    const active = ['active', 'trialing'].includes(stripeSub.status)
    if (!active) return NextResponse.json({ error: 'Subscription inactive' }, { status: 403 }) as any
    return null
  } catch (e) {
    return NextResponse.json({ error: 'Subscription check failed' }, { status: 500 }) as any
  }
}


