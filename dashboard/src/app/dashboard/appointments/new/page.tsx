"use client"
import { useState } from "react"
import { Calendar } from "@/components/ui/calendar"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card } from "@/components/ui/card"

const timeSlots = ["09:00 AM", "10:00 AM", "11:00 AM", "01:00 PM", "02:00 PM", "03:00 PM"]

export default function NewBookingPage() {
  const [date, setDate] = useState<Date | undefined>(undefined)
  const [time, setTime] = useState("")
  const [customer, setCustomer] = useState("")
  const [submitted, setSubmitted] = useState(false)

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setSubmitted(true)
  }

  return (
    <Card className="p-8 max-w-lg mx-auto">
      <h1 className="text-2xl font-bold mb-4">New Booking</h1>
      {submitted ? (
        <div className="text-green-600 font-semibold">Booking submitted (mock)!</div>
      ) : (
        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          <Label htmlFor="booking-date">Date</Label>
          <Calendar mode="single" selected={date} onSelect={setDate} className="rounded border" id="booking-date" />
          <Label htmlFor="booking-time">Time Slot</Label>
          <select id="booking-time" aria-label="Time Slot" value={time} onChange={e => setTime(e.target.value)} className="border rounded px-3 py-2">
            <option value="">Select a time</option>
            {timeSlots.map(slot => (
              <option key={slot} value={slot}>{slot}</option>
            ))}
          </select>
          <Label htmlFor="customer-name">Customer Name</Label>
          <Input id="customer-name" value={customer} onChange={e => setCustomer(e.target.value)} placeholder="Customer Name" required />
          <button type="submit" className="bg-gray-900 text-white px-4 py-2 rounded">Book</button>
        </form>
      )}
    </Card>
  )
} 