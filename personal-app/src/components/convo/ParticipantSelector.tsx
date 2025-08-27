'use client';

import { useState } from 'react';
import { Search, UserPlus, Link, Users, X } from 'lucide-react';

interface Participant {
  id: string;
  name: string;
  email?: string;
  avatar?: string;
}

interface ParticipantSelectorProps {
  participants: Participant[];
  onParticipantsChange: (participants: Participant[]) => void;
  className?: string;
}

export default function ParticipantSelector({ 
  participants, 
  onParticipantsChange, 
  className = '' 
}: ParticipantSelectorProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [showImportOptions, setShowImportOptions] = useState(false);

  // Mock contacts - in real app this would come from API
  const mockContacts: Participant[] = [
    { id: '1', name: 'Dana Smith', email: 'dana@example.com' },
    { id: '2', name: 'Ron Johnson', email: 'ron@example.com' },
    { id: '3', name: 'Sarah Wilson', email: 'sarah@example.com' },
    { id: '4', name: 'Mike Brown', email: 'mike@example.com' },
  ];

  const filteredContacts = mockContacts.filter(contact =>
    contact.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    contact.email?.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const addParticipant = (participant: Participant) => {
    if (!participants.find(p => p.id === participant.id)) {
      onParticipantsChange([...participants, participant]);
    }
    setSearchQuery('');
  };

  const removeParticipant = (id: string) => {
    onParticipantsChange(participants.filter(p => p.id !== id));
  };

  const generateInviteLink = () => {
    const link = `${window.location.origin}/invite/${Math.random().toString(36).substr(2, 9)}`;
    navigator.clipboard.writeText(link);
    alert('Invite link copied to clipboard!');
  };

  const shareViaWhatsApp = () => {
    const text = encodeURIComponent('Join my meeting! Click the link to join.');
    const link = `${window.location.origin}/invite/${Math.random().toString(36).substr(2, 9)}`;
    window.open(`https://wa.me/?text=${text}%20${encodeURIComponent(link)}`);
  };

  return (
    <div className={`space-y-4 ${className}`}>
      {/* Search and Add */}
      <div className="space-y-3">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
          <input
            type="text"
            placeholder="Search contacts or type a name..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-10 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none"
          />
        </div>

        {/* Import Options */}
        <div className="flex gap-2">
          <button
            onClick={() => setShowImportOptions(!showImportOptions)}
            className="flex items-center gap-2 px-4 py-2 border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-colors"
          >
            <UserPlus className="w-4 h-4" />
            Import Contacts
          </button>
          <button
            onClick={generateInviteLink}
            className="flex items-center gap-2 px-4 py-2 border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-colors"
          >
            <Link className="w-4 h-4" />
            Generate Link
          </button>
        </div>

        {/* Share Options */}
        {showImportOptions && (
          <div className="grid grid-cols-2 gap-2 p-4 border-2 border-gray-200 rounded-xl bg-gray-50">
            <button
              onClick={shareViaWhatsApp}
              className="flex items-center justify-center gap-2 px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors"
            >
              WhatsApp
            </button>
            <button
              onClick={generateInviteLink}
              className="flex items-center justify-center gap-2 px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
            >
              Copy Link
            </button>
          </div>
        )}
      </div>

      {/* Search Results */}
      {searchQuery && filteredContacts.length > 0 && (
        <div className="space-y-2">
          <h4 className="font-medium text-gray-700">Found contacts:</h4>
          {filteredContacts.map(contact => (
            <button
              key={contact.id}
              onClick={() => addParticipant(contact)}
              className="w-full text-left p-3 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
            >
              <div className="font-medium">{contact.name}</div>
              {contact.email && (
                <div className="text-sm text-gray-500">{contact.email}</div>
              )}
            </button>
          ))}
        </div>
      )}

      {/* Selected Participants */}
      {participants.length > 0 && (
        <div className="space-y-2">
          <h4 className="font-medium text-gray-700">Selected participants ({participants.length}):</h4>
          <div className="space-y-2">
            {participants.map(participant => (
              <div
                key={participant.id}
                className="flex items-center justify-between p-3 bg-blue-50 border border-blue-200 rounded-lg"
              >
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center text-white font-medium">
                    {participant.name.charAt(0)}
                  </div>
                  <div>
                    <div className="font-medium">{participant.name}</div>
                    {participant.email && (
                      <div className="text-sm text-gray-500">{participant.email}</div>
                    )}
                  </div>
                </div>
                <button
                  onClick={() => removeParticipant(participant.id)}
                  className="p-1 hover:bg-blue-200 rounded-full transition-colors"
                  aria-label={`Remove ${participant.name}`}
                  title={`Remove ${participant.name}`}
                >
                  <X className="w-4 h-4 text-blue-600" />
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Group Features for 4+ participants */}
      {participants.length >= 4 && (
        <div className="p-4 bg-orange-50 border border-orange-200 rounded-xl">
          <h4 className="font-medium text-orange-800 mb-2">Group features unlocked! 🎉</h4>
          <div className="grid grid-cols-2 gap-2 text-sm">
            <div className="flex items-center gap-2">
              <span>📄</span>
              <span>Forms</span>
            </div>
            <div className="flex items-center gap-2">
              <span>🛒</span>
              <span>Checklists</span>
            </div>
            <div className="flex items-center gap-2">
              <span>🖼️</span>
              <span>Attachments</span>
            </div>
            <div className="flex items-center gap-2">
              <span>🗣️</span>
              <span>Group Chat</span>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
