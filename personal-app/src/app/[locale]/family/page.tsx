'use client';

import { Bell, Calendar, Crown, Edit, Link, Plus, Settings, Trash2 } from 'lucide-react';
import { useState } from 'react';

interface FamilyMember {
  id: string;
  name: string;
  age: number;
  role: 'parent' | 'child';
  isPremium: boolean;
  linkedAt: string;
}

interface FamilyReminder {
  id: string;
  title: string;
  description?: string;
  date: string;
  time: string;
  assignedTo: string[];
  completed: boolean;
}

export default function FamilyPage() {
  const [familyMembers, setFamilyMembers] = useState<FamilyMember[]>([
    {
      id: '1',
      name: 'Gabriel',
      age: 35,
      role: 'parent',
      isPremium: true,
      linkedAt: '2025-01-01'
    },
    {
      id: '2',
      name: 'Emma',
      age: 12,
      role: 'child',
      isPremium: false,
      linkedAt: '2025-01-15'
    },
    {
      id: '3',
      name: 'Lucas',
      age: 8,
      role: 'child',
      isPremium: false,
      linkedAt: '2025-01-15'
    }
  ]);

  const [familyReminders, setFamilyReminders] = useState<FamilyReminder[]>([
    {
      id: '1',
      title: 'Family dinner',
      description: 'Weekly family dinner at 7 PM',
      date: '2025-01-27',
      time: '19:00',
      assignedTo: ['1', '2', '3'],
      completed: false
    },
    {
      id: '2',
      title: 'Homework check',
      description: 'Check Emma and Lucas homework',
      date: '2025-01-27',
      time: '16:00',
      assignedTo: ['1'],
      completed: false
    }
  ]);

  const [showAddMember, setShowAddMember] = useState(false);
  const [showAddReminder, setShowAddReminder] = useState(false);
  const [editingReminder, setEditingReminder] = useState<FamilyReminder | null>(null);
  const [memberForm, setMemberForm] = useState({
    name: '',
    age: '',
    role: 'child' as 'parent' | 'child'
  });
  const [reminderForm, setReminderForm] = useState({
    title: '',
    description: '',
    date: '',
    time: '',
    assignedTo: [] as string[]
  });

  const addFamilyMember = () => {
    if (!memberForm.name || !memberForm.age) return;

    const newMember: FamilyMember = {
      id: Date.now().toString(),
      name: memberForm.name.trim(),
      age: parseInt(memberForm.age),
      role: memberForm.role,
      isPremium: memberForm.role === 'child' ? false : true, // Kids are always free
      linkedAt: new Date().toISOString().split('T')[0]
    };

    setFamilyMembers([...familyMembers, newMember]);
    setMemberForm({ name: '', age: '', role: 'child' });
    setShowAddMember(false);
  };

  const removeFamilyMember = (id: string) => {
    setFamilyMembers(familyMembers.filter(m => m.id !== id));
  };

  const addFamilyReminder = () => {
    if (!reminderForm.title || !reminderForm.date || !reminderForm.time) return;

    const newReminder: FamilyReminder = {
      id: Date.now().toString(),
      title: reminderForm.title.trim(),
      description: reminderForm.description.trim(),
      date: reminderForm.date,
      time: reminderForm.time,
      assignedTo: reminderForm.assignedTo,
      completed: false
    };

    setFamilyReminders([...familyReminders, newReminder]);
    setReminderForm({ title: '', description: '', date: '', time: '', assignedTo: [] });
    setShowAddReminder(false);
  };

  const updateFamilyReminder = () => {
    if (!editingReminder || !reminderForm.title || !reminderForm.date || !reminderForm.time) return;

    setFamilyReminders(familyReminders.map(r =>
      r.id === editingReminder.id
        ? { ...r, ...reminderForm }
        : r
    ));

    setEditingReminder(null);
    setReminderForm({ title: '', description: '', date: '', time: '', assignedTo: [] });
  };

  const deleteFamilyReminder = (id: string) => {
    setFamilyReminders(familyReminders.filter(r => r.id !== id));
  };

  const toggleReminderComplete = (id: string) => {
    setFamilyReminders(familyReminders.map(r =>
      r.id === id ? { ...r, completed: !r.completed } : r
    ));
  };

  const startEditReminder = (reminder: FamilyReminder) => {
    setEditingReminder(reminder);
    setReminderForm({
      title: reminder.title,
      description: reminder.description || '',
      date: reminder.date,
      time: reminder.time,
      assignedTo: reminder.assignedTo
    });
  };

  const getMemberName = (id: string) => {
    const member = familyMembers.find(m => m.id === id);
    return member ? member.name : 'Unknown';
  };

  const getStatusColor = (reminder: FamilyReminder) => {
    if (reminder.completed) return 'bg-green-100 border-green-200';

    const reminderDate = new Date(`${reminder.date}T${reminder.time}`);
    const now = new Date();

    if (reminderDate < now) return 'bg-red-100 border-red-200';
    if (reminderDate.getTime() - now.getTime() < 24 * 60 * 60 * 1000) return 'bg-orange-100 border-orange-200';
    return 'bg-blue-100 border-blue-200';
  };

  return (
    <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Family</h1>
        <div className="flex gap-2">
          <button
            onClick={() => setShowAddMember(true)}
            className="flex items-center gap-2 px-4 py-2 bg-blue-500 text-white rounded-xl hover:bg-blue-600 transition-colors"
          >
            <Plus className="w-4 h-4" />
            Add Member
          </button>
          <button
            onClick={() => setShowAddReminder(true)}
            className="flex items-center gap-2 px-4 py-2 bg-green-500 text-white rounded-xl hover:bg-green-600 transition-colors"
          >
            <Bell className="w-4 h-4" />
            Add Reminder
          </button>
        </div>
      </div>

      {/* Family Members */}
      <div className="space-y-4">
        <h2 className="text-xl font-semibold">Family Members</h2>
        <div className="grid gap-3">
          {familyMembers.map((member) => (
            <div
              key={member.id}
              className="p-4 border-2 border-gray-200 rounded-xl hover:border-blue-300 transition-colors"
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className={`w-12 h-12 rounded-full flex items-center justify-center text-white font-medium ${member.role === 'parent' ? 'bg-blue-500' : 'bg-green-500'
                    }`}>
                    {member.name.charAt(0)}
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <h3 className="font-semibold text-lg">{member.name}</h3>
                      {member.role === 'parent' && <Crown className="w-4 h-4 text-yellow-500" />}
                    </div>
                    <div className="text-sm text-gray-600">
                      Age {member.age} • {member.role} • {member.isPremium ? 'Premium' : 'Free'}
                    </div>
                    <div className="text-xs text-gray-500">
                      Linked {new Date(member.linkedAt).toLocaleDateString()}
                    </div>
                  </div>
                </div>

                <div className="flex gap-2">
                  {member.role === 'child' && (
                    <div className="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-medium">
                      No Ads
                    </div>
                  )}
                  {member.role === 'parent' && (
                    <button
                      onClick={() => removeFamilyMember(member.id)}
                      className="p-2 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                      aria-label={`Remove ${member.name}`}
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Add Member Form */}
      {showAddMember && (
        <div className="p-4 border-2 border-gray-200 rounded-xl bg-gray-50">
          <h3 className="font-semibold mb-3">Add Family Member</h3>

          <div className="space-y-3">
            <input
              type="text"
              placeholder="Member name"
              value={memberForm.name}
              onChange={(e) => setMemberForm({ ...memberForm, name: e.target.value })}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
            />

            <input
              type="number"
              placeholder="Age"
              value={memberForm.age}
              onChange={(e) => setMemberForm({ ...memberForm, age: e.target.value })}
              min="1"
              max="120"
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
            />

            <select
              value={memberForm.role}
              onChange={(e) => setMemberForm({ ...memberForm, role: e.target.value as 'parent' | 'child' })}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
            >
              <option value="child">👶 Child (Free, No Ads)</option>
              <option value="parent">👨‍👩‍👧 Parent (Premium)</option>
            </select>
          </div>

          <div className="flex gap-2 mt-4">
            <button
              onClick={addFamilyMember}
              className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
            >
              Add Member
            </button>
            <button
              onClick={() => setShowAddMember(false)}
              className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* Family Reminders */}
      <div className="space-y-4">
        <h2 className="text-xl font-semibold">Family Reminders</h2>
        <div className="space-y-3">
          {familyReminders.length === 0 ? (
            <div className="text-center py-8 text-gray-500">
              <Bell className="w-12 h-12 mx-auto mb-3 text-gray-300" />
              <p>No family reminders yet. Create your first one!</p>
            </div>
          ) : (
            familyReminders.map((reminder) => (
              <div
                key={reminder.id}
                className={`p-4 border-2 rounded-xl ${getStatusColor(reminder)} transition-colors`}
              >
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2">
                      <input
                        type="checkbox"
                        checked={reminder.completed}
                        onChange={() => toggleReminderComplete(reminder.id)}
                        className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
                      />
                      <h3 className={`font-medium ${reminder.completed ? 'line-through text-gray-500' : ''}`}>
                        {reminder.title}
                      </h3>
                    </div>

                    {reminder.description && (
                      <p className={`text-sm mb-2 ${reminder.completed ? 'text-gray-400' : 'text-gray-600'}`}>
                        {reminder.description}
                      </p>
                    )}

                    <div className="flex items-center gap-4 text-sm text-gray-500 mb-2">
                      <span className="flex items-center gap-1">
                        <Calendar className="w-4 h-4" />
                        {new Date(reminder.date).toLocaleDateString()}
                      </span>
                      <span className="flex items-center gap-1">
                        <Bell className="w-4 h-4" />
                        {reminder.time}
                      </span>
                    </div>

                    <div className="text-sm text-gray-600">
                      <span className="font-medium">Assigned to:</span> {reminder.assignedTo.map(id => getMemberName(id)).join(', ')}
                    </div>
                  </div>

                  <div className="flex gap-2 ml-3">
                    <button
                      onClick={() => startEditReminder(reminder)}
                      className="p-2 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                      aria-label={`Edit ${reminder.title}`}
                    >
                      <Edit className="w-4 h-4" />
                    </button>
                    <button
                      onClick={() => deleteFamilyReminder(reminder.id)}
                      className="p-2 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                      aria-label={`Delete ${reminder.title}`}
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>
      </div>

      {/* Add/Edit Reminder Form */}
      {(showAddReminder || editingReminder) && (
        <div className="p-4 border-2 border-gray-200 rounded-xl bg-gray-50">
          <h3 className="font-semibold mb-3">
            {editingReminder ? 'Edit Family Reminder' : 'Create Family Reminder'}
          </h3>

          <div className="space-y-3">
            <input
              type="text"
              placeholder="Reminder title"
              value={reminderForm.title}
              onChange={(e) => setReminderForm({ ...reminderForm, title: e.target.value })}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
            />

            <textarea
              placeholder="Description (optional)"
              value={reminderForm.description}
              onChange={(e) => setReminderForm({ ...reminderForm, description: e.target.value })}
              rows={2}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none resize-none"
            />

            <div className="grid grid-cols-2 gap-3">
              <input
                type="date"
                value={reminderForm.date}
                onChange={(e) => setReminderForm({ ...reminderForm, date: e.target.value })}
                className="p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
              />
              <input
                type="time"
                value={reminderForm.time}
                onChange={(e) => setReminderForm({ ...reminderForm, time: e.target.value })}
                className="p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Assign to:</label>
              <div className="space-y-2">
                {familyMembers.map((member) => (
                  <label key={member.id} className="flex items-center gap-2">
                    <input
                      type="checkbox"
                      checked={reminderForm.assignedTo.includes(member.id)}
                      onChange={(e) => {
                        if (e.target.checked) {
                          setReminderForm({ ...reminderForm, assignedTo: [...reminderForm.assignedTo, member.id] });
                        } else {
                          setReminderForm({ ...reminderForm, assignedTo: reminderForm.assignedTo.filter(id => id !== member.id) });
                        }
                      }}
                      className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
                    />
                    <span className="text-sm">{member.name} ({member.role})</span>
                  </label>
                ))}
              </div>
            </div>
          </div>

          <div className="flex gap-2 mt-4">
            <button
              onClick={editingReminder ? updateFamilyReminder : addFamilyReminder}
              className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors"
            >
              {editingReminder ? 'Update' : 'Create'}
            </button>
            <button
              onClick={() => {
                setShowAddReminder(false);
                setEditingReminder(null);
                setReminderForm({ title: '', description: '', date: '', time: '', assignedTo: [] });
              }}
              className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* Family Calendar Preview */}
      <div className="p-4 border-2 border-gray-200 rounded-xl bg-gray-50">
        <h3 className="font-semibold mb-3">Family Calendar</h3>
        <div className="text-center py-4">
          <Calendar className="w-12 h-12 mx-auto mb-2 text-gray-400" />
          <p className="text-gray-600">Family calendar view coming soon!</p>
          <p className="text-sm text-gray-500">View all family events, reminders, and meetings in one place.</p>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 gap-3">
        <button className="p-3 border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-colors text-center">
          <Link className="w-6 h-6 mx-auto mb-2 text-blue-500" />
          <div className="text-sm font-medium">Link Child Account</div>
        </button>
        <button className="p-3 border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-colors text-center">
          <Settings className="w-6 h-6 mx-auto mb-2 text-blue-500" />
          <div className="text-sm font-medium">Family Settings</div>
        </button>
      </div>
    </main>
  );
}

