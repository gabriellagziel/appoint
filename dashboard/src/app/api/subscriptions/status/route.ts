import { NextResponse } from 'next/server'
import { getAdminAuth, getAdminDb } from '@/lib/firebaseAdmin'
import { getStripe } from '@/lib/stripe'

// Verify subscription status against Stripe to prevent stale data
export async function GET(request: Request) {
  const auth = getAdminAuth()
  const db = getAdminDb()
  const stripe = getStripe()
  try {
    const authHeader = (request.headers.get('authorization') || '').replace(/^Bearer\s+/i, '')
    if (!authHeader) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    const decoded = await auth.verifyIdToken(authHeader)
    const uid = decoded.uid

    const userDoc = await db.collection('users').doc(uid).get()
    const businessId = (userDoc.data() || {}).businessId
    if (!businessId) return NextResponse.json({ error: 'No business linked' }, { status: 400 })

    const subsSnap = await db.collection('subscriptions').where('businessId', '==', businessId).get()
    if (subsSnap.empty) return NextResponse.json({ active: false, status: 'none' })
    const sub = subsSnap.docs[0].data()
    const stripeSubId = sub.stripeSubscriptionId as string
    const stripeSub = await stripe.subscriptions.retrieve(stripeSubId)

    // Update Firestore if drift
    if (stripeSub.status !== sub.status) {
      await db.collection('subscriptions').doc(subsSnap.docs[0].id).update({ status: stripeSub.status, updatedAt: new Date() })
    }
    const active = ['active', 'trialing'].includes(stripeSub.status)
    return NextResponse.json({ active, status: stripeSub.status })
  } catch (e: any) {
    return NextResponse.json({ error: 'Failed to verify status' }, { status: 500 })
  }
}


