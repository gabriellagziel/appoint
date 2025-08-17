import { NextResponse } from 'next/server'
import { getAdminAuth, getAdminDb } from '@/lib/firebaseAdmin'
import crypto from 'crypto'

export async function POST(request: Request, { params }: { params: { id: string } }) {
  const auth = getAdminAuth(); const db = getAdminDb()
  const token = (request.headers.get('authorization') || '').replace(/^Bearer\s+/i, '')
  if (!token) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  const decoded = await auth.verifyIdToken(token)
  const orgId = (decoded as any).orgId || decoded.uid
  const ref = db.collection('org_api_keys').doc(params.id)
  const snap = await ref.get()
  if (!snap.exists || snap.data()!.orgId !== orgId) return NextResponse.json({ error: 'Not found' }, { status: 404 })

  // Invalidate old and create new secret (hash only stored)
  const raw = `sk_live_${crypto.randomBytes(24).toString('hex')}`
  const hash = crypto.createHash('sha256').update(raw).digest('hex')
  await ref.update({ hash, updatedAt: new Date().toISOString() })

  return NextResponse.json({ id: params.id, secret: raw })
}


