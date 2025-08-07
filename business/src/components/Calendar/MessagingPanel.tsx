'use client'

import { useState } from 'react'

interface Message {
    id: string
    from: string
    to: string
    content: string
    timestamp: string
    type: 'inbox' | 'outbox'
}

interface MessagingPanelProps {
    messages: Message[]
    onSendMessage: (to: string, content: string) => void
    onClose: () => void
    isOpen: boolean
}

export default function MessagingPanel({ messages, onSendMessage, onClose, isOpen }: MessagingPanelProps) {
    const [selectedTab, setSelectedTab] = useState<'inbox' | 'outbox'>('inbox')
    const [newMessage, setNewMessage] = useState('')
    const [recipient, setRecipient] = useState('')
    const [isSending, setIsSending] = useState(false)

    const handleSendMessage = async () => {
        if (!newMessage.trim() || !recipient.trim()) return

        setIsSending(true)
        try {
            await onSendMessage(recipient, newMessage)
            setNewMessage('')
            setRecipient('')
        } catch (error) {
            console.error('Failed to send message:', error)
        } finally {
            setIsSending(false)
        }
    }

    const filteredMessages = messages.filter(msg => msg.type === selectedTab)

    if (!isOpen) return null

    return (
        <div className="fixed bottom-4 right-4 w-96 h-96 bg-white rounded-lg shadow-xl border border-gray-200 flex flex-col z-50">
            {/* Header */}
            <div className="p-4 border-b border-gray-200 bg-gray-50 rounded-t-lg">
                <div className="flex items-center justify-between">
                    <h3 className="text-lg font-semibold text-gray-900">Messages</h3>
                    <button
                        onClick={onClose}
                        className="text-gray-400 hover:text-gray-600"
                        aria-label="Close messaging panel"
                    >
                        ✕
                    </button>
                </div>

                {/* Tabs */}
                <div className="flex space-x-1 mt-3">
                    <button
                        onClick={() => setSelectedTab('inbox')}
                        className={`flex-1 px-3 py-2 text-sm font-medium rounded-md transition-colors ${selectedTab === 'inbox'
                            ? 'bg-blue-100 text-blue-700'
                            : 'text-gray-500 hover:text-gray-700'
                            }`}
                    >
                        📥 Inbox ({messages.filter(m => m.type === 'inbox').length})
                    </button>
                    <button
                        onClick={() => setSelectedTab('outbox')}
                        className={`flex-1 px-3 py-2 text-sm font-medium rounded-md transition-colors ${selectedTab === 'outbox'
                            ? 'bg-blue-100 text-blue-700'
                            : 'text-gray-500 hover:text-gray-700'
                            }`}
                    >
                        📤 Outbox ({messages.filter(m => m.type === 'outbox').length})
                    </button>
                </div>
            </div>

            {/* Messages List */}
            <div className="flex-1 overflow-y-auto p-4">
                {filteredMessages.length === 0 ? (
                    <div className="text-center py-8">
                        <div className="text-2xl mb-2">
                            {selectedTab === 'inbox' ? '📥' : '📤'}
                        </div>
                        <p className="text-gray-500 text-sm">
                            No {selectedTab} messages
                        </p>
                    </div>
                ) : (
                    <div className="space-y-3">
                        {filteredMessages.map((message) => (
                            <div
                                key={message.id}
                                className={`p-3 rounded-lg ${message.type === 'inbox'
                                    ? 'bg-blue-50 border border-blue-200'
                                    : 'bg-green-50 border border-green-200'
                                    }`}
                            >
                                <div className="flex items-start justify-between mb-2">
                                    <div className="text-sm font-medium text-gray-900">
                                        {message.type === 'inbox' ? `From: ${message.from}` : `To: ${message.to}`}
                                    </div>
                                    <div className="text-xs text-gray-500">
                                        {new Date(message.timestamp).toLocaleTimeString()}
                                    </div>
                                </div>
                                <p className="text-sm text-gray-700">{message.content}</p>
                            </div>
                        ))}
                    </div>
                )}
            </div>

            {/* Compose Message */}
            <div className="p-4 border-t border-gray-200 bg-gray-50 rounded-b-lg">
                <div className="space-y-3">
                    <input
                        type="text"
                        placeholder="Recipient email"
                        value={recipient}
                        onChange={(e) => setRecipient(e.target.value)}
                        className="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                    <div className="flex space-x-2">
                        <input
                            type="text"
                            placeholder="Type your message..."
                            value={newMessage}
                            onChange={(e) => setNewMessage(e.target.value)}
                            onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
                            className="flex-1 px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                        <button
                            onClick={handleSendMessage}
                            disabled={isSending || !newMessage.trim() || !recipient.trim()}
                            className="px-4 py-2 bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white text-sm font-medium rounded-md transition-colors"
                        >
                            {isSending ? 'Sending...' : 'Send'}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    )
} 