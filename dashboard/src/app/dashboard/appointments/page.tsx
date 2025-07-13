'use client'
export const dynamic = 'force-dynamic'

import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { appointments } from "@/lib/mock-data"
import { useSession } from 'next-auth/react'

export default function AppointmentsListPage() {
  const sessionState = useSession()

  // Handle case when session is undefined (SSR)
  if (!sessionState) return <p>Loading...</p>

  if (sessionState.status === 'loading') return <p>Loading...</p>
  if (sessionState.status === 'unauthenticated') return <p>Not authenticated</p>

  const user = sessionState.data?.user
  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Appointments</h1>
      <p>Welcome, {user?.name}</p>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Date</TableHead>
            <TableHead>Time</TableHead>
            <TableHead>Status</TableHead>
            <TableHead>Customer</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {appointments.map(appt => (
            <TableRow key={appt.id}>
              <TableCell>{appt.date}</TableCell>
              <TableCell>{appt.time}</TableCell>
              <TableCell>{appt.status}</TableCell>
              <TableCell>{appt.customer}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  )
} 