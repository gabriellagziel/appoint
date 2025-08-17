import { NextResponse } from 'next/server'
import crypto from 'crypto'
import { getAdminAuth, getAdminDb } from '@/lib/firebaseAdmin'

// Firestore-backed API key management with hashed storage
export async function GET(request: Request) {
  const auth = getAdminAuth(); const db = getAdminDb()
  const token = (request.headers.get('authorization') || '').replace(/^Bearer\s+/i, '')
  if (!token) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  const decoded = await auth.verifyIdToken(token)
  const orgId = (decoded as any).orgId || decoded.uid
  const snap = await db.collection('org_api_keys').where('orgId', '==', orgId).get()
  const keys = snap.docs.map(d => ({ id: d.id, ...d.data(), secret: undefined }))
  return NextResponse.json({ keys })
}

export async function POST(request: Request) {
  const auth = getAdminAuth(); const db = getAdminDb()
  const token = (request.headers.get('authorization') || '').replace(/^Bearer\s+/i, '')
  if (!token) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  const decoded = await auth.verifyIdToken(token)
  const orgId = (decoded as any).orgId || decoded.uid

  // Generate key and store only hash
  const raw = `sk_live_${crypto.randomBytes(24).toString('hex')}`
  const hash = crypto.createHash('sha256').update(raw).digest('hex')
  const docRef = await db.collection('org_api_keys').add({
    orgId,
    name: 'New API Key',
    hash,
    created: new Date().toISOString(),
    lastUsed: null,
    status: 'active',
    permissions: ['meetings:create', 'meetings:read'],
  })
  // Return plaintext once on creation
  return NextResponse.json({ id: docRef.id, secret: raw })
}


