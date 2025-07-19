import type { NextApiRequest, NextApiResponse } from 'next'
import { initializeApp, cert, getApps } from 'firebase-admin/app'
import { getFirestore } from 'firebase-admin/firestore'

// Initialise Firebase Admin using service account JSON in env variable
if (!getApps().length) {
  const serviceJson = process.env.FIREBASE_ADMIN_JSON ? JSON.parse(process.env.FIREBASE_ADMIN_JSON) : undefined
  if (serviceJson) {
    initializeApp({ credential: cert(serviceJson) })
  }
}

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'GET') {
    res.setHeader('Allow', 'GET')
    res.status(405).json({ error: 'Method not allowed' })
    return
  }
  try {
    const db = getFirestore()
    const snapshot = await db.collection('business_accounts').limit(1000).get()
    const data = snapshot.docs.map(d => ({ id: d.id, ...d.data() }))
    res.status(200).json(data)
  } catch (err: any) {
    console.error(err)
    res.status(500).json({ error: 'Failed to fetch' })
  }
}