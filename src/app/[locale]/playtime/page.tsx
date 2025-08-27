'use client';
import BottomNav from '@/components/personal/BottomNav';
import { useParams } from 'next/navigation';
import { useEffect, useState } from 'react';

interface PlaytimeSession {
    id: string;
    title: string;
    type: 'physical' | 'virtual' | 'family' | 'solo';
    description?: string;
    date: string;
    time: string;
    duration: number; // in minutes
    participants: string[];
    location?: string;
    platform?: string;
    status: 'planned' | 'ongoing' | 'completed';
    score?: number;
    notes?: string;
}

export default function PlaytimePage() {
    const { locale } = useParams<{ locale: string }>();
    const [sessions, setSessions] = useState<PlaytimeSession[]>([]);
    const [showCreateForm, setShowCreateForm] = useState(false);
    const [newSession, setNewSession] = useState<Partial<PlaytimeSession>>({
        title: '',
        type: 'physical',
        description: '',
        date: '',
        time: '',
        duration: 60,
        participants: [],
        location: '',
        platform: ''
    });

    // Load playtime sessions from localStorage
    useEffect(() => {
        const saved = localStorage.getItem('appoint.personal.playtime.v1');
        if (saved) {
            try {
                setSessions(JSON.parse(saved));
            } catch (e) {
                console.error('Failed to parse playtime sessions:', e);
            }
        }
    }, []);

    // Save sessions to localStorage
    const saveSessions = (newSessions: PlaytimeSession[]) => {
        localStorage.setItem('appoint.personal.playtime.v1', JSON.stringify(newSessions));
        setSessions(newSessions);
    };

    const createSession = () => {
        if (!newSession.title || !newSession.date || !newSession.time) {
            alert('Please fill in all required fields');
            return;
        }

        const session: PlaytimeSession = {
            id: 'playtime-' + Math.random().toString(36).slice(2, 9),
            title: newSession.title!,
            type: newSession.type!,
            description: newSession.description || '',
            date: newSession.date!,
            time: newSession.time!,
            duration: newSession.duration || 60,
            participants: newSession.participants || [],
            location: newSession.location || '',
            platform: newSession.platform || '',
            status: 'planned'
        };

        const updatedSessions = [...sessions, session];
        saveSessions(updatedSessions);

        // Reset form
        setNewSession({
            title: '',
            type: 'physical',
            description: '',
            date: '',
            time: '',
            duration: 60,
            participants: [],
            location: '',
            platform: ''
        });
        setShowCreateForm(false);
    };

    const updateSessionStatus = (id: string, status: PlaytimeSession['status']) => {
        const updatedSessions = sessions.map(s =>
            s.id === id ? { ...s, status } : s
        );
        saveSessions(updatedSessions);
    };

    const deleteSession = (id: string) => {
        if (confirm('Are you sure you want to delete this playtime session?')) {
            const updatedSessions = sessions.filter(s => s.id !== id);
            saveSessions(updatedSessions);
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

    const getTypeIcon = (type: string) => {
        const icons = {
            physical: '🏃‍♂️',
            virtual: '💻',
            family: '👨‍👩‍👧',
            solo: '🎯'
        };
        return icons[type as keyof typeof icons] || '🎮';
    };

    const getTypeLabel = (type: string) => {
        const labels = {
            physical: 'Physical Activity',
            virtual: 'Virtual Game',
            family: 'Family Activity',
            solo: 'Solo Game'
        };
        return labels[type as keyof typeof icons] || type;
    };

    const getStatusColor = (status: string) => {
        const colors = {
            planned: 'bg-blue-100 text-blue-800',
            ongoing: 'bg-green-100 text-green-800',
            completed: 'bg-gray-100 text-gray-800'
        };
        return colors[status as keyof typeof colors] || 'bg-gray-100 text-gray-800';
    };

    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8">
            <header className="mb-6">
                <div className="flex items-center justify-between">
                    <h1 className="text-2xl font-semibold">Playtime</h1>
                    <button
                        onClick={() => setShowCreateForm(!showCreateForm)}
                        className="rounded-xl bg-blue-600 text-white px-4 py-2 hover:bg-blue-700 transition-colors"
                    >
                        {showCreateForm ? '✕' : '🎮 Add'}
                    </button>
                </div>
            </header>

            {/* Create Session Form */}
            {showCreateForm && (
                <div className="mb-6 bg-white rounded-2xl border p-6 shadow-sm">
                    <h2 className="text-lg font-semibold mb-4">Create Playtime Session</h2>

                    <div className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Title *
                            </label>
                            <input
                                type="text"
                                value={newSession.title}
                                onChange={(e) => setNewSession({ ...newSession, title: e.target.value })}
                                placeholder="What are you playing?"
                                className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Type *
                            </label>
                            <select
                                value={newSession.type}
                                onChange={(e) => setNewSession({ ...newSession, type: e.target.value as any })}
                                className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                aria-label="Playtime session type"
                            >
                                <option value="physical">🏃‍♂️ Physical Activity</option>
                                <option value="virtual">💻 Virtual Game</option>
                                <option value="family">👨‍👩‍👧 Family Activity</option>
                                <option value="solo">🎯 Solo Game</option>
                            </select>
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Description
                            </label>
                            <textarea
                                value={newSession.description}
                                onChange={(e) => setNewSession({ ...newSession, description: e.target.value })}
                                placeholder="Tell us about this activity..."
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
                                    value={newSession.date}
                                    onChange={(e) => setNewSession({ ...newSession, date: e.target.value })}
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                    aria-label="Session date"
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">
                                    Time *
                                </label>
                                <input
                                    type="time"
                                    value={newSession.time}
                                    onChange={(e) => setNewSession({ ...newSession, time: e.target.value })}
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                    aria-label="Session time"
                                />
                            </div>
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Duration (minutes)
                            </label>
                            <input
                                type="number"
                                min="15"
                                max="480"
                                step="15"
                                value={newSession.duration}
                                onChange={(e) => setNewSession({ ...newSession, duration: parseInt(e.target.value) || 60 })}
                                className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                aria-label="Session duration in minutes"
                            />
                        </div>

                        {newSession.type === 'physical' && (
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">
                                    Location
                                </label>
                                <input
                                    type="text"
                                    value={newSession.location}
                                    onChange={(e) => setNewSession({ ...newSession, location: e.target.value })}
                                    placeholder="Where will this take place?"
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                />
                            </div>
                        )}

                        {newSession.type === 'virtual' && (
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">
                                    Platform
                                </label>
                                <input
                                    type="text"
                                    value={newSession.platform}
                                    onChange={(e) => setNewSession({ ...newSession, platform: e.target.value })}
                                    placeholder="Zoom, Discord, Steam, etc."
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                />
                            </div>
                        )}

                        <div className="flex gap-3 pt-4">
                            <button
                                onClick={() => setShowCreateForm(false)}
                                className="flex-1 rounded-xl border border-gray-300 px-4 py-3 text-gray-700 hover:bg-gray-50 transition-colors"
                            >
                                Cancel
                            </button>
                            <button
                                onClick={createSession}
                                className="flex-1 rounded-xl bg-blue-600 text-white px-4 py-3 hover:bg-blue-700 transition-colors"
                            >
                                Create Session
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* Quick Actions */}
            <section className="mb-6">
                <h2 className="text-lg font-semibold mb-4">Quick Start</h2>
                <div className="grid grid-cols-2 gap-3">
                    <button
                        onClick={() => {/* TODO: Quick family game */ }}
                        className="bg-white rounded-2xl border p-4 text-center hover:shadow-md transition-shadow"
                    >
                        <div className="text-2xl mb-2">👨‍👩‍👧</div>
                        <div className="text-sm font-medium">Family Game</div>
                    </button>

                    <button
                        onClick={() => {/* TODO: Quick solo activity */ }}
                        className="bg-white rounded-2xl border p-4 text-center hover:shadow-md transition-shadow"
                    >
                        <div className="text-2xl mb-2">🎯</div>
                        <div className="text-sm font-medium">Solo Activity</div>
                    </button>
                </div>
            </section>

            {/* Sessions List */}
            <section className="space-y-3">
                <h2 className="text-lg font-semibold">Your Sessions</h2>

                {sessions.length === 0 ? (
                    <div className="text-center py-8 text-gray-500">
                        <div className="text-4xl mb-2">🎮</div>
                        <p>No playtime sessions yet</p>
                        <p className="text-sm">Create your first session to get started</p>
                    </div>
                ) : (
                    sessions.map((session) => (
                        <div
                            key={session.id}
                            className="bg-white rounded-2xl border p-4 shadow-sm"
                        >
                            <div className="flex items-start justify-between mb-3">
                                <div className="flex-1">
                                    <div className="flex items-center gap-2 mb-1">
                                        <span className="text-2xl">{getTypeIcon(session.type)}</span>
                                        <h3 className="font-medium">{session.title}</h3>
                                        <span className="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded-full">
                                            {getTypeLabel(session.type)}
                                        </span>
                                    </div>

                                    {session.description && (
                                        <p className="text-sm text-gray-600 mb-2">{session.description}</p>
                                    )}

                                    <div className="flex items-center gap-4 text-sm text-gray-500">
                                        <span>📅 {formatDate(session.date)}</span>
                                        <span>🕐 {formatTime(session.time)}</span>
                                        <span>⏱️ {session.duration} min</span>
                                    </div>

                                    {session.location && (
                                        <div className="text-sm text-gray-500 mt-1">📍 {session.location}</div>
                                    )}

                                    {session.platform && (
                                        <div className="text-sm text-gray-500 mt-1">💻 {session.platform}</div>
                                    )}
                                </div>

                                <span className={`text-xs px-2 py-1 rounded-full ${getStatusColor(session.status)}`}>
                                    {session.status.charAt(0).toUpperCase() + session.status.slice(1)}
                                </span>
                            </div>

                            <div className="flex gap-2 pt-3 border-t">
                                {session.status === 'planned' && (
                                    <>
                                        <button
                                            onClick={() => updateSessionStatus(session.id, 'ongoing')}
                                            className="flex-1 rounded-xl bg-green-600 text-white px-3 py-2 text-sm hover:bg-green-700 transition-colors"
                                        >
                                            🚀 Start
                                        </button>
                                        <button
                                            onClick={() => updateSessionStatus(session.id, 'completed')}
                                            className="flex-1 rounded-xl bg-blue-600 text-white px-3 py-2 text-sm hover:bg-blue-700 transition-colors"
                                        >
                                            ✅ Complete
                                        </button>
                                    </>
                                )}

                                {session.status === 'ongoing' && (
                                    <button
                                        onClick={() => updateSessionStatus(session.id, 'completed')}
                                        className="flex-1 rounded-xl bg-green-600 text-white px-3 py-2 text-sm hover:bg-green-700 transition-colors"
                                    >
                                        ✅ Complete
                                    </button>
                                )}

                                <button
                                    onClick={() => deleteSession(session.id)}
                                    className="px-3 py-2 rounded-lg bg-red-100 text-red-600 hover:bg-red-200 transition-colors"
                                    title="Delete session"
                                >
                                    🗑️
                                </button>
                            </div>
                        </div>
                    ))
                )}
            </section>

            <BottomNav locale={locale as string} />
        </main>
    );
}


