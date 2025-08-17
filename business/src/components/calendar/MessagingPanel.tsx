"use client"

import React, { useState } from "react"

interface MessagingPanelProps {
  isOpen: boolean
  messages: { id: string; from: string; to: string; content: string; timestamp: string; type: "inbox" | "outbox" }[]
  onSendMessage: (to: string, content: string) => Promise<void> | void
  onClose: () => void
}

export default function MessagingPanel({ isOpen, messages, onSendMessage, onClose }: MessagingPanelProps) {
  const [to, setTo] = useState("")
  const [content, setContent] = useState("")
  const [sending, setSending] = useState(false)

  if (!isOpen) return null

  const handleSend = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!to || !content) return
    setSending(true)
    try {
      await onSendMessage(to, content)
      setContent("")
    } finally {
      setSending(false)
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-black/40 p-4">
      <div className="w-full max-w-3xl bg-white rounded-xl shadow-lg border border-gray-200 overflow-hidden">
        <div className="flex items-center justify-between px-4 py-3 border-b">
          <h3 className="text-base font-semibold text-gray-900">Messages</h3>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700">Close</button>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-0">
          <div className="md:col-span-2 p-4 h-80 overflow-y-auto space-y-3 bg-gray-50">
            {messages.length === 0 ? (
              <div className="text-sm text-gray-500">No messages yet.</div>
            ) : (
              messages.map((m) => (
                <div key={m.id} className={"flex " + (m.type === "outbox" ? "justify-end" : "justify-start") }>
                  <div className={
                    "max-w-[80%] rounded-lg px-3 py-2 text-sm " +
                    (m.type === "outbox" ? "bg-blue-600 text-white" : "bg-white border border-gray-200 text-gray-900")
                  }>
                    <div className="opacity-75 text-xs mb-1">{m.from}</div>
                    <div>{m.content}</div>
                    <div className="opacity-60 text-[10px] mt-1">{new Date(m.timestamp).toLocaleString()}</div>
                  </div>
                </div>
              ))
            )}
          </div>
          <form onSubmit={handleSend} className="md:col-span-1 p-4 space-y-3">
            <div>
              <label htmlFor="msg-to" className="block text-xs font-medium text-gray-700 mb-1">To</label>
              <input id="msg-to" aria-label="Recipient" value={to} onChange={(e) => setTo(e.target.value)} className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="email@example.com" />
            </div>
            <div>
              <label htmlFor="msg-content" className="block text-xs font-medium text-gray-700 mb-1">Message</label>
              <textarea id="msg-content" aria-label="Message content" value={content} onChange={(e) => setContent(e.target.value)} rows={4} className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Type your message..." />
            </div>
            <button disabled={sending} className="w-full rounded-lg bg-blue-600 text-white py-2 text-sm font-medium disabled:opacity-50">
              {sending ? "Sending..." : "Send"}
            </button>
          </form>
        </div>
      </div>
    </div>
  )
}


