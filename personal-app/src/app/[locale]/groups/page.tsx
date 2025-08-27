'use client';

import { useState } from 'react';
import { Plus, Users, Link, Calendar, Settings, Copy, Share2, Trash2, Edit } from 'lucide-react';

interface Group {
  id: string;
  name: string;
  description?: string;
  members: Array<{ id: string; name: string; role: 'admin' | 'member' }>;
  inviteCode: string;
  createdAt: string;
  upcomingEvents: number;
}

export default function GroupsPage() {
  const [groups, setGroups] = useState<Group[]>([
    {
      id: '1',
      name: 'Book Club',
      description: 'Monthly book discussions and recommendations',
      members: [
        { id: '1', name: 'Gabriel', role: 'admin' },
        { id: '2', name: 'Dana', role: 'member' },
        { id: '3', name: 'Ron', role: 'member' }
      ],
      inviteCode: 'book-club-123',
      createdAt: '2025-01-15',
      upcomingEvents: 2
    },
    {
      id: '2',
      name: 'Tech Team',
      description: 'Weekly tech discussions and project updates',
      members: [
        { id: '1', name: 'Gabriel', role: 'admin' },
        { id: '4', name: 'Sarah', role: 'member' },
        { id: '5', name: 'Mike', role: 'member' }
      ],
      inviteCode: 'tech-team-456',
      createdAt: '2025-01-10',
      upcomingEvents: 1
    }
  ]);

  const [showCreateForm, setShowCreateForm] = useState(false);
  const [editingGroup, setEditingGroup] = useState<Group | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    description: ''
  });

  const createGroup = () => {
    if (!formData.name.trim()) return;

    const newGroup: Group = {
      id: Date.now().toString(),
      name: formData.name.trim(),
      description: formData.description.trim(),
      members: [{ id: '1', name: 'Gabriel', role: 'admin' }],
      inviteCode: `${formData.name.toLowerCase().replace(/\s+/g, '-')}-${Math.random().toString(36).substr(2, 6)}`,
      createdAt: new Date().toISOString().split('T')[0],
      upcomingEvents: 0
    };

    setGroups([...groups, newGroup]);
    setFormData({ name: '', description: '' });
    setShowCreateForm(false);
  };

  const updateGroup = () => {
    if (!editingGroup || !formData.name.trim()) return;

    setGroups(groups.map(g => 
      g.id === editingGroup.id 
        ? { ...g, name: formData.name.trim(), description: formData.description.trim() }
        : g
    ));
    
    setEditingGroup(null);
    setFormData({ name: '', description: '' });
  };

  const deleteGroup = (id: string) => {
    setGroups(groups.filter(g => g.id !== id));
  };

  const startEdit = (group: Group) => {
    setEditingGroup(group);
    setFormData({
      name: group.name,
      description: group.description || ''
    });
  };

  const copyInviteLink = (inviteCode: string) => {
    const link = `${window.location.origin}/join/${inviteCode}`;
    navigator.clipboard.writeText(link);
    alert('Invite link copied to clipboard!');
  };

  const shareGroup = (group: Group) => {
    const link = `${window.location.origin}/join/${group.inviteCode}`;
    const text = `Join my group "${group.name}" on App-Oint! ${link}`;
    
    if (navigator.share) {
      navigator.share({
        title: `Join ${group.name}`,
        text,
        url: link
      });
    } else {
      // Fallback for browsers that don't support Web Share API
      copyInviteLink(group.inviteCode);
    }
  };

  const generateNewInviteCode = (groupId: string) => {
    setGroups(groups.map(g => 
      g.id === groupId 
        ? { ...g, inviteCode: `${g.name.toLowerCase().replace(/\s+/g, '-')}-${Math.random().toString(36).substr(2, 6)}` }
        : g
    ));
  };

  return (
    <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Groups</h1>
        <button
          onClick={() => setShowCreateForm(true)}
          className="flex items-center gap-2 px-4 py-2 bg-blue-500 text-white rounded-xl hover:bg-blue-600 transition-colors"
        >
          <Plus className="w-4 h-4" />
          Create Group
        </button>
      </div>

      {/* Create/Edit Form */}
      {(showCreateForm || editingGroup) && (
        <div className="p-4 border-2 border-gray-200 rounded-xl bg-gray-50">
          <h3 className="font-semibold mb-3">
            {editingGroup ? 'Edit Group' : 'Create New Group'}
          </h3>
          
          <div className="space-y-3">
            <input
              type="text"
              placeholder="Group name"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
            />
            
            <textarea
              placeholder="Description (optional)"
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              rows={3}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none resize-none"
            />
          </div>
          
          <div className="flex gap-2 mt-4">
            <button
              onClick={editingGroup ? updateGroup : createGroup}
              className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
            >
              {editingGroup ? 'Update' : 'Create'}
            </button>
            <button
              onClick={() => {
                setShowCreateForm(false);
                setEditingGroup(null);
                setFormData({ name: '', description: '' });
              }}
              className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* Groups List */}
      <div className="space-y-4">
        {groups.length === 0 ? (
          <div className="text-center py-8 text-gray-500">
            <Users className="w-12 h-12 mx-auto mb-3 text-gray-300" />
            <p>No groups yet. Create your first one!</p>
          </div>
        ) : (
          groups.map((group) => (
            <div
              key={group.id}
              className="p-4 border-2 border-gray-200 rounded-xl hover:border-blue-300 transition-colors"
            >
              <div className="flex items-start justify-between mb-3">
                <div className="flex-1">
                  <h3 className="font-semibold text-lg mb-1">{group.name}</h3>
                  {group.description && (
                    <p className="text-gray-600 text-sm mb-2">{group.description}</p>
                  )}
                  
                  <div className="flex items-center gap-4 text-sm text-gray-500">
                    <span className="flex items-center gap-1">
                      <Users className="w-4 h-4" />
                      {group.members.length} members
                    </span>
                    <span className="flex items-center gap-1">
                      <Calendar className="w-4 h-4" />
                      {group.upcomingEvents} upcoming events
                    </span>
                    <span className="flex items-center gap-1">
                      Created {new Date(group.createdAt).toLocaleDateString()}
                    </span>
                  </div>
                </div>
                
                <div className="flex gap-2 ml-3">
                  <button
                    onClick={() => startEdit(group)}
                    className="p-2 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                    aria-label={`Edit ${group.name}`}
                  >
                    <Edit className="w-4 h-4" />
                  </button>
                  <button
                    onClick={() => deleteGroup(group.id)}
                    className="p-2 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                    aria-label={`Delete ${group.name}`}
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>

              {/* Members List */}
              <div className="mb-3">
                <h4 className="text-sm font-medium text-gray-700 mb-2">Members:</h4>
                <div className="flex flex-wrap gap-2">
                  {group.members.map((member) => (
                    <div
                      key={member.id}
                      className={`px-3 py-1 rounded-full text-sm ${
                        member.role === 'admin' 
                          ? 'bg-blue-100 text-blue-800 border border-blue-200' 
                          : 'bg-gray-100 text-gray-700 border border-gray-200'
                      }`}
                    >
                      {member.name} {member.role === 'admin' && '(Admin)'}
                    </div>
                  ))}
                </div>
              </div>

              {/* Invite Section */}
              <div className="p-3 bg-blue-50 border border-blue-200 rounded-lg">
                <div className="flex items-center justify-between mb-2">
                  <span className="text-sm font-medium text-blue-800">Invite Code:</span>
                  <button
                    onClick={() => generateNewInviteCode(group.id)}
                    className="text-xs text-blue-600 hover:text-blue-700 underline"
                  >
                    Generate New
                  </button>
                </div>
                
                <div className="flex items-center gap-2">
                  <code className="flex-1 p-2 bg-white border border-blue-200 rounded text-sm font-mono">
                    {group.inviteCode}
                  </code>
                  <button
                    onClick={() => copyInviteLink(group.inviteCode)}
                    className="p-2 text-blue-600 hover:bg-blue-100 rounded-lg transition-colors"
                    aria-label="Copy invite link"
                    title="Copy invite link"
                  >
                    <Copy className="w-4 h-4" />
                  </button>
                  <button
                    onClick={() => shareGroup(group)}
                    className="p-2 text-blue-600 hover:bg-blue-100 rounded-lg transition-colors"
                    aria-label="Share group"
                    title="Share group"
                  >
                    <Share2 className="w-4 h-4" />
                  </button>
                </div>
              </div>

              {/* Quick Actions */}
              <div className="flex gap-2 mt-3">
                <button className="flex-1 p-2 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors text-center text-sm">
                  <Calendar className="w-4 h-4 mx-auto mb-1 text-gray-500" />
                  Schedule Event
                </button>
                <button className="flex-1 p-2 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors text-center text-sm">
                  <Settings className="w-4 h-4 mx-auto mb-1 text-gray-500" />
                  Group Settings
                </button>
              </div>
            </div>
          ))
        )}
      </div>

      {/* Join Group Section */}
      <div className="p-4 border-2 border-gray-200 rounded-xl bg-gray-50">
        <h3 className="font-semibold mb-3">Join a Group</h3>
        <div className="flex gap-2">
          <input
            type="text"
            placeholder="Enter invite code"
            className="flex-1 p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
          />
          <button className="px-4 py-3 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors">
            Join
          </button>
        </div>
        <p className="text-sm text-gray-600 mt-2">
          Anyone with the invite code can join your groups. Share the code via WhatsApp, iMessage, or any messaging app.
        </p>
      </div>
    </main>
  );
}

