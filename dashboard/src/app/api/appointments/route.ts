import { NextResponse } from "next/server"
import { getAdminDb, getAdminAuth } from "@/lib/firebaseAdmin"
import { z } from "zod"

// Replace mock data with Firestore-backed appointments list.
export async function GET(request: Request) {
  // Enforce authenticated access by verifying Firebase session cookie if present
  // Note: In production you may centralize this in middleware; we validate again here server-side.
  const auth = getAdminAuth()
  const db = getAdminDb()
  try {
    const authHeader = (request.headers.get('authorization') || '').replace(/^Bearer\s+/i, '')
    if (!authHeader) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    const decoded = await auth.verifyIdToken(authHeader)
    const uid = decoded.uid

    const snap = await db.collection('appointments').where('ownerId', '==', uid).get()
    const data = snap.docs.map(d => ({ id: d.id, ...d.data() }))
    return NextResponse.json(data)
  } catch (e: any) {
    return NextResponse.json({ error: 'Failed to load appointments' }, { status: 500 })
  }
}

export async function POST(request: Request) {
  // Create a new appointment stored in Firestore, validating payload.
  const auth = getAdminAuth()
  const db = getAdminDb()
  const schema = z.object({
    title: z.string().min(1),
    startTime: z.string().datetime(),
    endTime: z.string().datetime(),
    location: z.string().optional(),
    notes: z.string().optional(),
  })
  try {
    const authHeader = (request.headers.get('authorization') || '').replace(/^Bearer\s+/i, '')
    if (!authHeader) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    const decoded = await auth.verifyIdToken(authHeader)
    const uid = decoded.uid

    const body = await request.json()
    const parsed = schema.parse(body)
    const docRef = await db.collection('appointments').add({
      ownerId: uid,
      ...parsed,
      createdAt: new Date(),
      updatedAt: new Date(),
    })
    return NextResponse.json({ id: docRef.id })
  } catch (e: any) {
    const status = e?.name === 'ZodError' ? 400 : 500
    return NextResponse.json({ error: e?.message || 'Failed to create appointment' }, { status })
  }
}