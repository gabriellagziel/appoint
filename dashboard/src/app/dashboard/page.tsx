'use client'
export const dynamic = 'force-dynamic'

import { Card } from "@/components/ui/card"
import { overviewCards } from "@/lib/mock-data"
import { useSession } from 'next-auth/react'

export default function DashboardOverviewPage() {
  const sessionState = useSession()

  if (sessionState.status === 'loading') return <p>Loading...</p>
  if (sessionState.status === 'unauthenticated') return <p>Not authenticated</p>

  const user = sessionState.data?.user
  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Dashboard</h1>
      <p className="mb-4">Welcome, {user?.name}</p>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {overviewCards.map(card => (
          <Card key={card.title} className="p-6 flex flex-col items-center justify-center">
            <div className="text-3xl font-bold mb-2">{card.value}</div>
            <div className="text-lg text-gray-600">{card.title}</div>
          </Card>
        ))}
      </div>
    </div>
  )
} 