'use client';

import { useState } from 'react';
import { Plus, Clock, Calendar, Link, Trash2, Edit, Bell } from 'lucide-react';

interface Reminder {
  id: string;
  title: string;
  description?: string;
  date: string;
  time: string;
  recurring: 'none' | 'daily' | 'weekly' | 'monthly' | 'yearly';
  linkedMeetingId?: string;
  completed: boolean;
}

export default function RemindersPage() {
  const [reminders, setReminders] = useState<Reminder[]>([
    {
      id: '1',
      title: 'Call mom',
      description: 'Check in on her weekend plans',
      date: '2025-01-27',
      time: '18:00',
      recurring: 'weekly',
      completed: false
    },
    {
      id: '2',
      title: 'Review project proposal',
      description: 'Final review before client meeting',
      date: '2025-01-28',
      time: '09:00',
      recurring: 'none',
      completed: false
    }
  ]);

  const [showCreateForm, setShowCreateForm] = useState(false);
  const [editingReminder, setEditingReminder] = useState<Reminder | null>(null);
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    date: '',
    time: '',
    recurring: 'none' as Reminder['recurring']
  });

  const addReminder = () => {
    if (!formData.title || !formData.date || !formData.time) return;

    const newReminder: Reminder = {
      id: Date.now().toString(),
      ...formData,
      completed: false
    };

    setReminders([...reminders, newReminder]);
    setFormData({ title: '', description: '', date: '', time: '', recurring: 'none' });
    setShowCreateForm(false);
  };

  const updateReminder = () => {
    if (!editingReminder || !formData.title || !formData.date || !formData.time) return;

    setReminders(reminders.map(r =>
      r.id === editingReminder.id
        ? { ...r, ...formData }
        : r
    ));

    setEditingReminder(null);
    setFormData({ title: '', description: '', date: '', time: '', recurring: 'none' });
  };

  const deleteReminder = (id: string) => {
    setReminders(reminders.filter(r => r.id !== id));
  };

  const toggleComplete = (id: string) => {
    setReminders(reminders.map(r =>
      r.id === id ? { ...r, completed: !r.completed } : r
    ));
  };

  const startEdit = (reminder: Reminder) => {
    setEditingReminder(reminder);
    setFormData({
      title: reminder.title,
      description: reminder.description || '',
      date: reminder.date,
      time: reminder.time,
      recurring: reminder.recurring
    });
  };

  const getRecurringText = (recurring: Reminder['recurring']) => {
    switch (recurring) {
      case 'daily': return '🔄 Daily';
      case 'weekly': return '📅 Weekly';
      case 'monthly': return '📆 Monthly';
      case 'yearly': return '🎯 Yearly';
      default: return '⏰ Once';
    }
  };

  const getStatusColor = (reminder: Reminder) => {
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
        <h1 className="text-2xl font-semibold">Reminders</h1>
        <button
          onClick={() => setShowCreateForm(true)}
          className="flex items-center gap-2 px-4 py-2 bg-blue-500 text-white rounded-xl hover:bg-blue-600 transition-colors"
        >
          <Plus className="w-4 h-4" />
          New Reminder
        </button>
      </div>

      {/* Create/Edit Form */}
      {(showCreateForm || editingReminder) && (
        <div className="p-4 border-2 border-gray-200 rounded-xl bg-gray-50">
          <h3 className="font-semibold mb-3">
            {editingReminder ? 'Edit Reminder' : 'Create New Reminder'}
          </h3>

          <div className="space-y-3">
            <input
              type="text"
              placeholder="Reminder title"
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
            />

            <textarea
              placeholder="Description (optional)"
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              rows={2}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none resize-none"
            />

            <div className="grid grid-cols-2 gap-3">
              <input
                type="date"
                value={formData.date}
                onChange={(e) => setFormData({ ...formData, date: e.target.value })}
                className="p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
              />
              <input
                type="time"
                value={formData.time}
                onChange={(e) => setFormData({ ...formData, time: e.target.value })}
                className="p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
              />
            </div>

            <select
              value={formData.recurring}
              onChange={(e) => setFormData({ ...formData, recurring: e.target.value as Reminder['recurring'] })}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
            >
              <option value="none">⏰ Once</option>
              <option value="daily">🔄 Daily</option>
              <option value="weekly">📅 Weekly</option>
              <option value="monthly">📆 Monthly</option>
              <option value="yearly">🎯 Yearly</option>
            </select>
          </div>

          <div className="flex gap-2 mt-4">
            <button
              onClick={editingReminder ? updateReminder : addReminder}
              className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
            >
              {editingReminder ? 'Update' : 'Create'}
            </button>
            <button
              onClick={() => {
                setShowCreateForm(false);
                setEditingReminder(null);
                setFormData({ title: '', description: '', date: '', time: '', recurring: 'none' });
              }}
              className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* Reminders List */}
      <div className="space-y-3">
        {reminders.length === 0 ? (
          <div className="text-center py-8 text-gray-500">
            <Bell className="w-12 h-12 mx-auto mb-3 text-gray-300" />
            <p>No reminders yet. Create your first one!</p>
          </div>
        ) : (
          reminders.map((reminder) => (
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
                      onChange={() => toggleComplete(reminder.id)}
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

                  <div className="flex items-center gap-4 text-sm text-gray-500">
                    <span className="flex items-center gap-1">
                      <Calendar className="w-4 h-4" />
                      {new Date(reminder.date).toLocaleDateString()}
                    </span>
                    <span className="flex items-center gap-1">
                      <Clock className="w-4 h-4" />
                      {reminder.time}
                    </span>
                    <span className="flex items-center gap-1">
                      {getRecurringText(reminder.recurring)}
                    </span>
                  </div>
                </div>

                <div className="flex gap-2 ml-3">
                  <button
                    onClick={() => startEdit(reminder)}
                    className="p-2 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                    aria-label={`Edit ${reminder.title}`}
                  >
                    <Edit className="w-4 h-4" />
                  </button>
                  <button
                    onClick={() => deleteReminder(reminder.id)}
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

      {/* Quick Actions */}
      <div className="grid grid-cols-2 gap-3">
        <button className="p-3 border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-colors text-center">
          <Link className="w-6 h-6 mx-auto mb-2 text-blue-500" />
          <div className="text-sm font-medium">Link to Meeting</div>
        </button>
        <button className="p-3 border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-colors text-center">
          <Calendar className="w-6 h-6 mx-auto mb-2 text-blue-500" />
          <div className="text-sm font-medium">View Calendar</div>
        </button>
      </div>
    </main>
  );
}

