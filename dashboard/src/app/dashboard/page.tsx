'use client'
export const dynamic = 'force-dynamic'

import { useSession } from 'next-auth/react'

export default function DashboardOverviewPage() {
  const sessionState = useSession()

  if (sessionState.status === 'loading') return <p>Loading...</p>
  if (sessionState.status === 'unauthenticated') return <p>Not authenticated</p>

  const user = sessionState.data?.user

  return (
    <div>
      <h1>Dashboard</h1>
      <p>Welcome, {user?.name}</p>
      {/* More dashboard content here */}
    </div>
  )
} 