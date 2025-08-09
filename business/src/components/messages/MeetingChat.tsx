'use client';

import { useEffect, useState, useRef } from 'react';
import { messagesService } from '@/services/messages.service';
import { MeetingMessage } from '@/lib/types/message';

interface MeetingChatProps {
  meetingId: string;
  currentUser: {
    uid: string;
    role: 'business' | 'user' | 'staff';
  };
}

export default function MeetingChat({ meetingId, currentUser }: MeetingChatProps) {
  const [messages, setMessages] = useState<MeetingMessage[]>([]);
  const [newMessage, setNewMessage] = useState('');
  const [loading, setLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const unsubscribe = messagesService.listMessages(meetingId, (messages) => {
      setMessages(messages);
    });

    // Mark messages as seen when component mounts
    messagesService.markAllSeen(meetingId, currentUser.uid);

    return () => unsubscribe();
  }, [meetingId, currentUser.uid]);

  useEffect(() => {
    // Auto-scroll to bottom when new messages arrive
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const handleSendMessage = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newMessage.trim()) return;

    setLoading(true);
    try {
      await messagesService.sendMessage({
        meetingId,
        authorUid: currentUser.uid,
        authorRole: currentUser.role,
        text: newMessage.trim(),
      });
      setNewMessage('');
    } catch (error) {
      console.error('Error sending message:', error);
    } finally {
      setLoading(false);
    }
  };

  const isOwnMessage = (message: MeetingMessage) => {
    return message.authorUid === currentUser.uid;
  };

  const getRoleColor = (role: string) => {
    switch (role) {
      case 'business': return 'bg-blue-500';
      case 'staff': return 'bg-green-500';
      case 'user': return 'bg-gray-500';
      default: return 'bg-gray-500';
    }
  };

  return (
    <div className="flex flex-col h-96 bg-white rounded-lg shadow">
      <div className="p-4 border-b border-gray-200">
        <h3 className="text-lg font-semibold text-gray-900">
          Meeting Chat
        </h3>
        <p className="text-sm text-gray-500">
          Meeting ID: {meetingId}
        </p>
      </div>

      <div className="flex-1 overflow-y-auto p-4 space-y-3">
        {messages.length === 0 ? (
          <div className="text-center text-gray-500 py-8">
            <svg className="w-12 h-12 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
            </svg>
            <p>No messages yet</p>
            <p className="text-sm">Start the conversation!</p>
          </div>
        ) : (
          messages.map((message) => (
            <div
              key={message.id}
              className={`flex ${isOwnMessage(message) ? 'justify-end' : 'justify-start'}`}
            >
              <div
                className={`max-w-xs lg:max-w-md px-4 py-2 rounded-lg ${
                  isOwnMessage(message)
                    ? 'bg-blue-600 text-white'
                    : 'bg-gray-100 text-gray-900'
                }`}
              >
                <div className="flex items-center mb-1">
                  <div
                    className={`w-2 h-2 rounded-full mr-2 ${getRoleColor(message.authorRole)}`}
                  />
                  <span className="text-xs opacity-75">
                    {message.authorRole} • {new Date(message.createdAt).toLocaleTimeString()}
                  </span>
                </div>
                <p className="text-sm">{message.text}</p>
              </div>
            </div>
          ))
        )}
        <div ref={messagesEndRef} />
      </div>

      <form onSubmit={handleSendMessage} className="p-4 border-t border-gray-200">
        <div className="flex gap-2">
          <input
            type="text"
            value={newMessage}
            onChange={(e) => setNewMessage(e.target.value)}
            placeholder="Type your message..."
            className="flex-1 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            disabled={loading}
          />
          <button
            type="submit"
            disabled={loading || !newMessage.trim()}
            className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {loading ? (
              <svg className="w-4 h-4 animate-spin" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
              </svg>
            ) : (
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
              </svg>
            )}
          </button>
        </div>
      </form>
    </div>
  );
}




