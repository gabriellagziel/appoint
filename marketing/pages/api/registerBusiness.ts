import type { NextApiRequest, NextApiResponse } from 'next'

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    res.setHeader('Allow', 'POST')
    res.status(405).json({ error: 'Method not allowed' })
    return
  }

  const cloudFunctionUrl = process.env.REDACTED_TOKEN
  if (!cloudFunctionUrl) {
    res.status(500).json({ error: 'Cloud function URL not configured' })
    return
  }

  try {
    const response = await fetch(cloudFunctionUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(req.body)
    })

    const data = await response.json()
    res.status(response.status).json(data)
  } catch (err: any) {
    console.error(err)
    res.status(500).json({ error: 'Internal proxy error' })
  }
}