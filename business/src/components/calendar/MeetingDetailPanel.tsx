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

interface MeetingDetailPanelProps {
  meeting: Meeting | null
  onAccept: (id: string) => void
  onDecline: (id: string) => void
  onSuggestTime: (id: string) => void
  onMessage: (id: string) => void
}

export default function MeetingDetailPanel({
  meeting,
  onAccept,
  onDecline,
  onSuggestTime,
  onMessage,
}: MeetingDetailPanelProps) {
  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 h-full p-4">
      <h3 className="text-base font-semibold text-gray-900">Meeting Details</h3>
      {!meeting ? (
        <p className="mt-2 text-sm text-gray-500">Select a meeting to view details.</p>
      ) : (
        <div className="mt-3 space-y-3">
          <div>
            <div className="text-sm font-medium text-gray-900">{meeting.title}</div>
            <div className="text-xs text-gray-500">
              {meeting.startTime} - {meeting.endTime}
            </div>
          </div>

          {meeting.location && (
            <div className="text-sm text-gray-700">Location: {meeting.location}</div>
          )}
          {meeting.virtualLink && (
            <a
              className="text-sm text-blue-600 hover:underline"
              href={meeting.virtualLink}
              target="_blank"
              rel="noreferrer"
            >
              Join virtual meeting
            </a>
          )}
          {meeting.notes && (
            <div className="text-sm text-gray-700">Notes: {meeting.notes}</div>
          )}

          <div className="flex flex-wrap gap-2 pt-2">
            <button
              className="px-3 py-1.5 text-sm rounded-lg bg-green-600 text-white hover:bg-green-700"
              onClick={() => onAccept(meeting.id)}
            >
              Accept
            </button>
            <button
              className="px-3 py-1.5 text-sm rounded-lg bg-amber-600 text-white hover:bg-amber-700"
              onClick={() => onSuggestTime(meeting.id)}
            >
              Suggest time
            </button>
            <button
              className="px-3 py-1.5 text-sm rounded-lg bg-blue-600 text-white hover:bg-blue-700"
              onClick={() => onMessage(meeting.id)}
            >
              Message
            </button>
            <button
              className="px-3 py-1.5 text-sm rounded-lg bg-red-600 text-white hover:bg-red-700"
              onClick={() => onDecline(meeting.id)}
            >
              Decline
            </button>
          </div>
        </div>
      )}
    </div>
  )
}


