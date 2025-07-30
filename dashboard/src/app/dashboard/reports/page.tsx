'use client'
export const dynamic = 'force-dynamic'

import { Card } from "@/components/ui/card"
import { reports } from "@/lib/mock-data"
import { useSession } from 'next-auth/react'

export default function ReportsPage() {
  const sessionState = useSession()

  // Handle case when session is undefined (SSR)
  if (!sessionState) return <p>Loading...</p>

  if (sessionState.status === 'loading') return <p>Loading...</p>
  if (sessionState.status === 'unauthenticated') return <p>Not authenticated</p>

  const user = sessionState.data?.user
  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Reports</h1>
      <p className="mb-4">Welcome, {user?.name}</p>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card className="p-6">
          <h2 className="text-xl font-bold mb-4">Monthly Bookings</h2>
          <table className="w-full">
            <thead>
              <tr>
                <th className="text-left">Month</th>
                <th className="text-left">Bookings</th>
              </tr>
            </thead>
            <tbody>
              {reports.monthlyBookings.map(row => (
                <tr key={row.month}>
                  <td>{row.month}</td>
                  <td>{row.count}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </Card>
        <Card className="p-6">
          <h2 className="text-xl font-bold mb-4">Revenue</h2>
          <table className="w-full">
            <thead>
              <tr>
                <th className="text-left">Month</th>
                <th className="text-left">Revenue ($)</th>
              </tr>
            </thead>
            <tbody>
              {reports.revenue.map(row => (
                <tr key={row.month}>
                  <td>{row.month}</td>
                  <td>{row.amount}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </Card>
      </div>
    </div>
  )
} 