'use client';
import BottomNav from '@/components/personal/BottomNav';
import { useParams, useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';

interface Reminder {
    id: string;
    title: string;
    description?: string;
    date: string;
    time: string;
    recurring: 'none' | 'daily' | 'weekly' | 'monthly' | 'yearly';
    linkedMeeting?: string;
    family?: boolean;
    completed: boolean;
}

export default function RemindersPage() {
    const { locale } = useParams<{ locale: string }>();
    const router = useRouter();
    const [reminders, setReminders] = useState<Reminder[]>([]);
    const [showCreateForm, setShowCreateForm] = useState(false);
    const [newReminder, setNewReminder] = useState<Partial<Reminder>>({
        title: '',
        description: '',
        date: '',
        time: '',
        recurring: 'none',
        family: false
    });

    // Load reminders from localStorage
    useEffect(() => {
        const saved = localStorage.getItem('appoint.personal.reminders.v1');
        if (saved) {
            try {
                setReminders(JSON.parse(saved));
            } catch (e) {
                console.error('Failed to parse reminders:', e);
            }
        }
    }, []);

    // Save reminders to localStorage
    const saveReminders = (newReminders: Reminder[]) => {
        localStorage.setItem('appoint.personal.reminders.v1', JSON.stringify(newReminders));
        setReminders(newReminders);
    };

    const createReminder = () => {
        if (!newReminder.title || !newReminder.date || !newReminder.time) {
            alert('Please fill in all required fields');
            return;
        }

        const reminder: Reminder = {
            id: 'reminder-' + Math.random().toString(36).slice(2, 9),
            title: newReminder.title!,
            description: newReminder.description || '',
            date: newReminder.date!,
            time: newReminder.time!,
            recurring: newReminder.recurring || 'none',
            linkedMeeting: newReminder.linkedMeeting,
            family: newReminder.family || false,
            completed: false
        };

        const updatedReminders = [...reminders, reminder];
        saveReminders(updatedReminders);

        // Reset form
        setNewReminder({
            title: '',
            description: '',
            date: '',
            time: '',
            recurring: 'none',
            family: false
        });
        setShowCreateForm(false);
    };

    const toggleReminder = (id: string) => {
        const updatedReminders = reminders.map(r =>
            r.id === id ? { ...r, completed: !r.completed } : r
        );
        saveReminders(updatedReminders);
    };

    const deleteReminder = (id: string) => {
        if (confirm('Are you sure you want to delete this reminder?')) {
            const updatedReminders = reminders.filter(r => r.id !== id);
            saveReminders(updatedReminders);
        }
    };

    const formatDate = (date: string) => {
        return new Date(date).toLocaleDateString('en-US', {
            month: 'short',
            day: 'numeric',
            year: 'numeric'
        });
    };

    const formatTime = (time: string) => {
        return time;
    };

    const getRecurringLabel = (recurring: string) => {
        const labels = {
            none: 'Once',
            daily: 'Daily',
            weekly: 'Weekly',
            monthly: 'Monthly',
            yearly: 'Yearly'
        };
        return labels[recurring as keyof typeof labels] || 'Once';
    };

    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8">
            <header className="mb-6">
                <div className="flex items-center justify-between">
                    <h1 className="text-2xl font-semibold">Reminders</h1>
                    <button
                        onClick={() => setShowCreateForm(!showCreateForm)}
                        className="rounded-xl bg-blue-600 text-white px-4 py-2 hover:bg-blue-700 transition-colors"
                    >
                        {showCreateForm ? '✕' : '➕ Add'}
                    </button>
                </div>
            </header>

            {/* Create Reminder Form */}
            {showCreateForm && (
                <div className="mb-6 bg-white rounded-2xl border p-6 shadow-sm">
                    <h2 className="text-lg font-semibold mb-4">Create New Reminder</h2>

                    <div className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Title *
                            </label>
                            <input
                                type="text"
                                value={newReminder.title}
                                onChange={(e) => setNewReminder({ ...newReminder, title: e.target.value })}
                                placeholder="What do you need to remember?"
                                className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Description
                            </label>
                            <textarea
                                value={newReminder.description}
                                onChange={(e) => setNewReminder({ ...newReminder, description: e.target.value })}
                                placeholder="Additional details..."
                                rows={3}
                                className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors resize-none"
                            />
                        </div>

                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">
                                    Date *
                                </label>
                                <input
                                    type="date"
                                    value={newReminder.date}
                                    onChange={(e) => setNewReminder({ ...newReminder, date: e.target.value })}
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                    aria-label="Reminder date"
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">
                                    Time *
                                </label>
                                <input
                                    type="time"
                                    value={newReminder.time}
                                    onChange={(e) => setNewReminder({ ...newReminder, time: e.target.value })}
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                    aria-label="Reminder time"
                                />
                            </div>
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Recurring
                            </label>
                            <select
                                value={newReminder.recurring}
                                onChange={(e) => setNewReminder({ ...newReminder, recurring: e.target.value as any })}
                                className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                aria-label="Reminder recurring frequency"
                            >
                                <option value="none">Once</option>
                                <option value="daily">Daily</option>
                                <option value="weekly">Weekly</option>
                                <option value="monthly">Monthly</option>
                                <option value="yearly">Yearly</option>
                            </select>
                        </div>

                        <div className="flex items-center">
                            <input
                                type="checkbox"
                                id="family-reminder"
                                checked={newReminder.family}
                                onChange={(e) => setNewReminder({ ...newReminder, family: e.target.checked })}
                                className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                            />
                            <label htmlFor="family-reminder" className="ml-2 text-sm text-gray-700">
                                Family reminder (shared with family members)
                            </label>
                        </div>

                        <div className="flex gap-3 pt-4">
                            <button
                                onClick={() => setShowCreateForm(false)}
                                className="flex-1 rounded-xl border border-gray-300 px-4 py-3 text-gray-700 hover:bg-gray-50 transition-colors"
                            >
                                Cancel
                            </button>
                            <button
                                onClick={createReminder}
                                className="flex-1 rounded-xl bg-blue-600 text-white px-4 py-3 hover:bg-blue-700 transition-colors"
                            >
                                Create Reminder
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* Reminders List */}
            <section className="space-y-3">
                <h2 className="text-lg font-semibold">Your Reminders</h2>

                {reminders.length === 0 ? (
                    <div className="text-center py-8 text-gray-500">
                        <div className="text-4xl mb-2">⏰</div>
                        <p>No reminders yet</p>
                        <p className="text-sm">Create your first reminder to get started</p>
                    </div>
                ) : (
                    reminders.map((reminder) => (
                        <div
                            key={reminder.id}
                            className={`bg-white rounded-2xl border p-4 shadow-sm transition-all ${reminder.completed ? 'opacity-60' : ''
                                }`}
                        >
                            <div className="flex items-start justify-between">
                                <div className="flex-1">
                                    <div className="flex items-center gap-2 mb-2">
                                        <h3 className={`font-medium ${reminder.completed ? 'line-through' : ''}`}>
                                            {reminder.title}
                                        </h3>
                                        {reminder.family && (
                                            <span className="text-xs bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
                                                👨‍👩‍👧 Family
                                            </span>
                                        )}
                                        <span className="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded-full">
                                            {getRecurringLabel(reminder.recurring)}
                                        </span>
                                    </div>

                                    {reminder.description && (
                                        <p className="text-sm text-gray-600 mb-2">{reminder.description}</p>
                                    )}

                                    <div className="flex items-center gap-4 text-sm text-gray-500">
                                        <span>📅 {formatDate(reminder.date)}</span>
                                        <span>🕐 {formatTime(reminder.time)}</span>
                                    </div>
                                </div>

                                <div className="flex items-center gap-2">
                                    <button
                                        onClick={() => toggleReminder(reminder.id)}
                                        className={`p-2 rounded-lg transition-colors ${reminder.completed
                                                ? 'bg-green-100 text-green-600 hover:bg-green-200'
                                                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                                            }`}
                                    >
                                        {reminder.completed ? '✅' : '⭕'}
                                    </button>

                                    <button
                                        onClick={() => deleteReminder(reminder.id)}
                                        className="p-2 rounded-lg bg-red-100 text-red-600 hover:bg-red-200 transition-colors"
                                    >
                                        🗑️
                                    </button>
                                </div>
                            </div>
                        </div>
                    ))
                )}
            </section>

            <BottomNav locale={locale as string} />
        </main>
    );
}
