import { NextResponse } from 'next/server'
import { getAdminAuth, getAdminDb } from '@/lib/firebaseAdmin'

export async function DELETE(request: Request, { params }: { params: { id: string } }) {
  const auth = getAdminAuth(); const db = getAdminDb()
  const token = (request.headers.get('authorization') || '').replace(/^Bearer\s+/i, '')
  if (!token) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  const decoded = await auth.verifyIdToken(token)
  const orgId = (decoded as any).orgId || decoded.uid
  const doc = await db.collection('org_api_keys').doc(params.id).get()
  if (!doc.exists || doc.data()!.orgId !== orgId) return NextResponse.json({ error: 'Not found' }, { status: 404 })
  await db.collection('org_api_keys').doc(params.id).delete()
  return NextResponse.json({ ok: true })
}


