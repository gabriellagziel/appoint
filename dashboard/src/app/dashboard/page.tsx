'use client'
export const dynamic = 'force-dynamic'

import React, { useMemo } from 'react'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import Link from 'next/link'
import { LineChart } from '@/components/Charts/LineChart'
import { useAuth } from '@/contexts/AuthContext'
import { overviewCards } from '@/lib/mock-data'

export default function DashboardPage() {
  const { user, loading } = useAuth()

  const chartData = useMemo(
    () => (
      [
        { label: 'Jan', value: 8 },
        { label: 'Feb', value: 12 },
        { label: 'Mar', value: 10 },
        { label: 'Apr', value: 15 },
        { label: 'May', value: 14 },
        { label: 'Jun', value: 18 },
      ]
    ),
    []
  )

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <span>Loading...</span>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex items-start justify-between">
        <div>
          <h1 className="text-2xl font-semibold">Welcome back{user?.displayName ? `, ${user.displayName}` : ''}</h1>
          <p className="text-neutral-600">Here’s a quick snapshot of your Business Studio.</p>
        </div>
        <div className="flex gap-3">
          <Link href="/dashboard/appointments/new">
            <Button className="bg-blue-600 hover:bg-blue-700">New Booking</Button>
          </Link>
          <Link href="/dashboard/reports">
            <Button variant="outline">View Reports</Button>
          </Link>
        </div>
      </div>

      <div className="grid md:grid-cols-3 gap-6">
        {overviewCards.map((c) => (
          <Card key={c.title}>
            <CardHeader>
              <CardTitle>{c.title}</CardTitle>
              <CardDescription>Last 7 days</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-semibold">{c.value}</div>
            </CardContent>
          </Card>
        ))}
      </div>

      <div className="grid md:grid-cols-5 gap-6">
        <div className="md:col-span-3">
          <Card>
            <CardHeader>
              <CardTitle>Bookings trend</CardTitle>
              <CardDescription>Monthly bookings</CardDescription>
            </CardHeader>
            <CardContent>
              <LineChart data={chartData} title="Bookings" height={260} />
            </CardContent>
          </Card>
        </div>

        <div className="md:col-span-2">
          <Card>
            <CardHeader>
              <CardTitle>Quick actions</CardTitle>
              <CardDescription>Frequently used links</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="flex flex-col gap-3">
                <Link href="/dashboard/appointments/new" className="underline">Create a booking</Link>
                <Link href="/dashboard/appointments" className="underline">Manage appointments</Link>
                <Link href="/dashboard/reports" className="underline">View reports</Link>
                <Link href="/dashboard/pricing" className="underline">Plans & billing</Link>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}
