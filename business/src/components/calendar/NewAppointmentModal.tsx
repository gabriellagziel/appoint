"use client"

import React, { useState, useEffect } from "react"

interface NewAppointmentModalProps {
  isOpen: boolean
  prefillTime?: { date: string; time: string }
  onClose: () => void
  onAppointmentCreated: (appointment: any) => void
}

export default function NewAppointmentModal({ isOpen, prefillTime, onClose, onAppointmentCreated }: NewAppointmentModalProps) {
  const [title, setTitle] = useState("")
  const [date, setDate] = useState("")
  const [time, setTime] = useState("")
  const [duration, setDuration] = useState(60)
  const [creating, setCreating] = useState(false)

  useEffect(() => {
    if (prefillTime) {
      setDate(prefillTime.date)
      setTime(prefillTime.time)
    }
  }, [prefillTime])

  if (!isOpen) return null

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!title || !date || !time) return
    setCreating(true)
    try {
      const [h, m] = time.split(":").map(Number)
      const end = new Date(new Date(`${date}T${time}:00`).getTime() + duration * 60000)
      const pad = (n: number) => String(n).padStart(2, "0")
      const endTime = `${pad(end.getHours())}:${pad(end.getMinutes())}`
      const appt = {
        id: Date.now().toString(),
        title,
        startTime: time,
        endTime,
        participants: [],
        status: "confirmed" as const,
      }
      onAppointmentCreated(appt)
      onClose()
    } finally {
      setCreating(false)
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
      <div className="w-full max-w-md bg-white rounded-xl shadow-lg border border-gray-200">
        <div className="px-4 py-3 border-b flex items-center justify-between">
          <h3 className="text-base font-semibold text-gray-900">New Appointment</h3>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700">Close</button>
        </div>
        <form onSubmit={handleCreate} className="p-4 space-y-4">
          <div>
            <label htmlFor="appt-title" className="block text-xs font-medium text-gray-700 mb-1">Title</label>
            <input id="appt-title" aria-label="Appointment title" value={title} onChange={(e) => setTitle(e.target.value)} className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Client consultation" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label htmlFor="appt-date" className="block text-xs font-medium text-gray-700 mb-1">Date</label>
              <input id="appt-date" aria-label="Appointment date" type="date" value={date} onChange={(e) => setDate(e.target.value)} className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
            </div>
            <div>
              <label htmlFor="appt-time" className="block text-xs font-medium text-gray-700 mb-1">Time</label>
              <input id="appt-time" aria-label="Appointment time" type="time" value={time} onChange={(e) => setTime(e.target.value)} className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
            </div>
          </div>
          <div>
            <label htmlFor="appt-duration" className="block text-xs font-medium text-gray-700 mb-1">Duration</label>
            <select id="appt-duration" aria-label="Appointment duration" value={duration} onChange={(e) => setDuration(Number(e.target.value))} className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
              <option value={15}>15 minutes</option>
              <option value={30}>30 minutes</option>
              <option value={45}>45 minutes</option>
              <option value={60}>1 hour</option>
              <option value={90}>1.5 hours</option>
              <option value={120}>2 hours</option>
            </select>
          </div>
          <button disabled={creating} className="w-full rounded-lg bg-blue-600 text-white py-2 text-sm font-medium disabled:opacity-50">
            {creating ? "Creating..." : "Create appointment"}
          </button>
        </form>
      </div>
    </div>
  )
}


