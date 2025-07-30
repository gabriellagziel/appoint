'use client'
export const dynamic = 'force-dynamic'

import React from 'react'
import { useSession } from 'next-auth/react'

export default function DashboardPage() {
  const session = useSession()

  // Handle case when session is undefined (SSR)
  if (!session) return <p>Loading...</p>

  if (session.status === 'loading') return <p>Loading...</p>
  if (session.status === 'unauthenticated') return <p>Not authenticated</p>

  const user = session.data?.user

  return (
    <div>
      <h1>Dashboard</h1>
      <p>Welcome, {user?.name || 'User'}!</p>
    </div>
  )
} // Force DigitalOcean to pick up latest commit
// Force DigitalOcean to pick up latest commit with useSession fixes
