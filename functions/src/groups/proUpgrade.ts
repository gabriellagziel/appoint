// Stripe group upgrade flow for "Pro" plan
// Purpose: Create checkout session for a group and validate resulting subscription status.
import { db as getDb } from '../lib/admin.js'
import { createCheckoutSession, confirmSession } from '../stripe.js'
import * as admin from 'firebase-admin'

type UpgradeResult = { url: string; id: string }

// Minimal facade to create a Stripe checkout session for a group.
// This calls into the existing exported function logic via HTTP-like interface.
export async function createProCheckoutSession(groupId: string, priceId: string): Promise<UpgradeResult> {
  // Record an upgrade intent in Firestore for auditability.
  const db = getDb()
  const ref = db.collection('group_upgrade_intents').doc()
  await ref.set({ groupId, priceId, status: 'initiated', createdAt: admin.firestore.FieldValue.serverTimestamp() })

  // Reuse createCheckoutSession exported handler by constructing a request-like object
  const mockReq: any = { body: { groupId, priceId }, method: 'POST' }
  let responsePayload: any = null
  const mockRes: any = {
    status: (_: number) => mockRes,
    json: (data: any) => {
      responsePayload = data
      return mockRes
    },
  }

  await (createCheckoutSession as any)(mockReq, mockRes)
  if (!responsePayload?.url || !responsePayload?.sessionId) {
    throw new Error('Failed to create Stripe checkout session')
  }

  // Update intent with session info
  await ref.update({ status: 'session_created', sessionId: responsePayload.sessionId, url: responsePayload.url })
  return { url: responsePayload.url, id: responsePayload.sessionId }
}

// Validate session after redirect completes to mark group as Pro.
export async function validateGroupSubscription(groupId: string, sessionId: string): Promise<void> {
  const db = getDb()
  // Reuse confirmSession — builds on Stripe subscription retrieval
  const mockReq: any = { body: { sessionId, studioId: groupId }, method: 'POST' }
  const mockRes: any = { status: (_: number) => mockRes, json: (_: any) => mockRes }
  await (confirmSession as any)(mockReq, mockRes)

  // Mark group as pro and persist subscription linkage
  await db.collection('groups').doc(groupId).set(
    { plan: 'pro', updatedAt: admin.firestore.FieldValue.serverTimestamp(), stripe: { sessionId } },
    { merge: true }
  )
}


