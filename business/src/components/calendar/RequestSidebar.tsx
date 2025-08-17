"use client"

import React from "react"

type MeetingRequest = {
  id: string
  title: string
  requestedTime: string
  requestedDate: string
  fromUser: { name: string; email: string; avatar?: string }
  reason?: string
  status: "pending" | "accepted" | "declined"
  createdAt: string
}

interface RequestSidebarProps {
  requests: MeetingRequest[]
  onAccept: (id: string) => void
  onDecline: (id: string) => void
  onSuggestTime: (id: string) => void
}

export default function RequestSidebar({ requests, onAccept, onDecline, onSuggestTime }: RequestSidebarProps) {
  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 h-full p-4">
      <h3 className="text-base font-semibold text-gray-900">Requests</h3>
      <div className="mt-3 space-y-3">
        {requests.length === 0 ? (
          <p className="text-sm text-gray-500">No pending requests.</p>
        ) : (
          requests.map((r) => (
            <div key={r.id} className="rounded-lg border border-gray-200 p-3">
              <div className="flex items-start gap-3">
                <div className="h-8 w-8 rounded-full bg-gray-200 flex items-center justify-center text-xs font-medium">
                  {r.fromUser.name.charAt(0)}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="text-sm font-medium text-gray-900 truncate">{r.title}</div>
                  <div className="text-xs text-gray-500">{r.fromUser.name} • {r.fromUser.email}</div>
                  <div className="text-xs text-gray-500">{r.requestedDate} at {r.requestedTime}</div>
                  {r.reason && <div className="mt-1 text-xs text-gray-700 line-clamp-2">{r.reason}</div>}
                </div>
              </div>
              <div className="mt-3 flex flex-wrap gap-2">
                <button onClick={() => onAccept(r.id)} className="px-3 py-1.5 text-xs rounded-lg bg-green-600 text-white hover:bg-green-700">Accept</button>
                <button onClick={() => onSuggestTime(r.id)} className="px-3 py-1.5 text-xs rounded-lg bg-amber-600 text-white hover:bg-amber-700">Suggest time</button>
                <button onClick={() => onDecline(r.id)} className="px-3 py-1.5 text-xs rounded-lg bg-red-600 text-white hover:bg-red-700">Decline</button>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  )
}


