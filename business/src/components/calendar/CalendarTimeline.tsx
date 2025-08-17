"use client"

import React from "react"

type Meeting = {
  id: string
  title: string
  startTime: string
  endTime: string
  participants: string[]
  status: "confirmed" | "pending" | "canceled"
  location?: string
  virtualLink?: string
  notes?: string
  requestReason?: string
}

interface CalendarTimelineProps {
  meetings: Meeting[]
  selectedMeetingId?: string
  onMeetingSelect: (meeting: Meeting) => void
  onTimeSlotClick: (time: string) => void
}

const TIME_SLOTS = [
  "08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30",
  "12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30",
  "16:00","16:30","17:00","17:30"
]

export default function CalendarTimeline({
  meetings,
  selectedMeetingId,
  onMeetingSelect,
  onTimeSlotClick,
}: CalendarTimelineProps) {
  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 h-full flex flex-col overflow-hidden">
      <div className="p-4 border-b border-gray-200 flex items-center justify-between">
        <div>
          <h2 className="text-base font-semibold text-gray-900">Today</h2>
          <p className="text-sm text-gray-500">Tap a time slot to create a meeting</p>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto">
        <div className="divide-y divide-gray-100">
          {TIME_SLOTS.map((slot) => {
            const slotMeetings = meetings.filter((m) => m.startTime === slot)
            return (
              <div key={slot} className="relative">
                <button
                  type="button"
                  onClick={() => onTimeSlotClick(slot)}
                  className="w-full text-left px-4 py-3 hover:bg-gray-50 focus:outline-none focus-visible:ring-2 focus-visible:ring-blue-500/40"
                >
                  <div className="flex items-center gap-4">
                    <span className="w-16 shrink-0 text-xs font-medium text-gray-500 tabular-nums">
                      {slot}
                    </span>
                    <div className="flex-1">
                      {slotMeetings.length === 0 ? (
                        <div className="text-xs text-gray-400">Available</div>
                      ) : (
                        <div className="space-y-2">
                          {slotMeetings.map((m) => (
                            <div
                              key={m.id}
                              onClick={(e) => {
                                e.stopPropagation()
                                onMeetingSelect(m)
                              }}
                              className={
                                "group cursor-pointer rounded-lg border px-3 py-2 transition-colors " +
                                (selectedMeetingId === m.id
                                  ? "border-blue-500 bg-blue-50"
                                  : "border-gray-200 bg-white hover:bg-gray-50")
                              }
                            >
                              <div className="flex items-center justify-between">
                                <div className="text-sm font-medium text-gray-900 line-clamp-1">
                                  {m.title}
                                </div>
                                <span
                                  className={
                                    "ml-2 inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium " +
                                    (m.status === "confirmed"
                                      ? "bg-green-100 text-green-700"
                                      : m.status === "pending"
                                      ? "bg-amber-100 text-amber-700"
                                      : "bg-red-100 text-red-700")
                                  }
                                >
                                  {m.status}
                                </span>
                              </div>
                              <div className="mt-1 text-xs text-gray-500">
                                {m.startTime} - {m.endTime}
                              </div>
                              {m.location && (
                                <div className="mt-1 text-xs text-gray-500">{m.location}</div>
                              )}
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                </button>
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}


