import { NextResponse } from 'next/server'
import { getStripe } from '@/lib/stripe'
import { getAdminAuth, getAdminDb } from '@/lib/firebaseAdmin'

export async function GET(request: Request) {
  const auth = getAdminAuth()
  const db = getAdminDb()
  const stripe = getStripe()
  try {
    const authHeader = (request.headers.get('authorization') || '').replace(/^Bearer\s+/i, '')
    if (!authHeader) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    const decoded = await auth.verifyIdToken(authHeader)
    const orgId = (decoded as any).orgId || decoded.uid

    const subsSnap = await db.collection('org_subscriptions').where('orgId', '==', orgId).get()
    if (subsSnap.empty) return NextResponse.json({ active: false, status: 'none' })
    const sub = subsSnap.docs[0].data()
    const stripeSub = await stripe.subscriptions.retrieve(sub.stripeSubscriptionId)
    if (stripeSub.status !== sub.status) await db.collection('org_subscriptions').doc(subsSnap.docs[0].id).update({ status: stripeSub.status, updatedAt: new Date() })
    const active = ['active', 'trialing'].includes(stripeSub.status)
    return NextResponse.json({ active, status: stripeSub.status })
  } catch (e: any) {
    return NextResponse.json({ error: 'Failed to verify status' }, { status: 500 })
  }
}


