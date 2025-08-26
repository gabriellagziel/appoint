'use client';
import Link from 'next/link';
import { useState } from 'react';

// Mock data for agenda
const mockEvents = [
    {
        id: 1,
        title: 'פגישה עם דן',
        type: 'work',
        date: '2025-01-27',
        time: '14:00',
        duration: 60,
        participants: ['דן כהן'],
        status: 'confirmed'
    },
    {
        id: 2,
        title: 'זיכרון: תשלום חשבונות',
        type: 'reminder',
        date: '2025-01-27',
        time: '16:30',
        duration: 15,
        participants: [],
        status: 'pending'
    },
    {
        id: 3,
        title: 'פגישת משפחה',
        type: 'family',
        date: '2025-01-28',
        time: '19:00',
        duration: 120,
        participants: ['אמא', 'אבא', 'אח'],
        status: 'confirmed'
    },
    {
        id: 4,
        title: 'פגישה רפואית',
        type: 'health',
        date: '2025-01-29',
        time: '09:00',
        duration: 45,
        participants: ['ד"ר כהן'],
        status: 'pending'
    }
];

const typeIcons: { [key: string]: string } = {
    work: '💼',
    personal: '👤',
    family: '👨‍👩‍👧',
    health: '🏥',
    social: '🎉',
    reminder: '⏰',
    other: '📝'
};

const typeLabels: { [key: string]: string } = {
    work: 'עבודה',
    personal: 'אישי',
    family: 'משפחה',
    health: 'בריאות',
    social: 'חברתי',
    reminder: 'זיכרון',
    other: 'אחר'
};

const statusColors: { [key: string]: string } = {
    confirmed: 'bg-green-100 text-green-800 border-green-200',
    pending: 'bg-yellow-100 text-yellow-800 border-yellow-200',
    cancelled: 'bg-red-100 text-red-800 border-red-200'
};

const statusLabels: { [key: string]: string } = {
    confirmed: 'מאושר',
    pending: 'ממתין',
    cancelled: 'בוטל'
};

export default function Agenda() {
    const [selectedDate, setSelectedDate] = useState(new Date().toISOString().split('T')[0]);
    const [viewMode, setViewMode] = useState<'list' | 'month'>('list');

    const filteredEvents = mockEvents.filter(event => event.date === selectedDate);

    const formatDate = (dateString: string) => {
        return new Date(dateString).toLocaleDateString('he-IL', {
            weekday: 'long',
            month: 'long',
            day: 'numeric'
        });
    };

    return (
        <main className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 pb-20">
            {/* Header */}
            <div className="bg-white shadow-sm border-b">
                <div className="max-w-md mx-auto px-6 py-4">
                    <div className="flex items-center justify-between">
                        <Link
                            href="/"
                            className="text-gray-600 hover:text-gray-800"
                        >
                            ← חזור
                        </Link>
                        <h1 className="text-xl font-bold text-gray-800">יומן</h1>
                        <div className="w-6"></div>
                    </div>
                </div>
            </div>

            {/* Date Selector */}
            <div className="max-w-md mx-auto px-6 py-4">
                <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                    <div className="flex items-center justify-between mb-4">
                        <h2 className="font-semibold text-gray-800">תאריך</h2>
                        <div className="flex gap-2">
                            <button
                                onClick={() => setViewMode('list')}
                                className={`px-3 py-1 rounded-lg text-sm transition-colors ${viewMode === 'list'
                                        ? 'bg-blue-100 text-blue-700'
                                        : 'bg-gray-100 text-gray-600'
                                    }`}
                            >
                                רשימה
                            </button>
                            <button
                                onClick={() => setViewMode('month')}
                                className={`px-3 py-1 rounded-lg text-sm transition-colors ${viewMode === 'month'
                                        ? 'bg-blue-100 text-blue-700'
                                        : 'bg-gray-100 text-gray-600'
                                    }`}
                            >
                                חודש
                            </button>
                        </div>
                    </div>

                    <input
                        type="date"
                        value={selectedDate}
                        onChange={(e) => setSelectedDate(e.target.value)}
                        aria-label="בחר תאריך"
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />

                    <div className="mt-2 text-sm text-gray-600">
                        {formatDate(selectedDate)}
                    </div>
                </div>
            </div>

            {/* Events List */}
            <div className="max-w-md mx-auto px-6 py-4">
                {filteredEvents.length === 0 ? (
                    <div className="text-center py-12">
                        <div className="text-6xl mb-4">📅</div>
                        <h3 className="text-lg font-semibold text-gray-800 mb-2">אין אירועים היום</h3>
                        <p className="text-gray-600 mb-6">היום יום חופשי! תוכל ליצור פגישה חדשה</p>
                        <Link
                            href="/create/meeting"
                            className="inline-block bg-gradient-to-r from-blue-500 to-indigo-600 text-white px-6 py-3 rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all duration-200"
                        >
                            צור פגישה חדשה
                        </Link>
                    </div>
                ) : (
                    <div className="space-y-4">
                        <h3 className="font-semibold text-gray-800">אירועים ליום {formatDate(selectedDate)}</h3>

                        {filteredEvents.map((event) => (
                            <div key={event.id} className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                                <div className="flex items-start gap-3">
                                    <span className="text-2xl">{typeIcons[event.type]}</span>

                                    <div className="flex-1">
                                        <div className="flex items-center justify-between mb-2">
                                            <h4 className="font-semibold text-gray-800">{event.title}</h4>
                                            <span className={`px-2 py-1 rounded-full text-xs border ${statusColors[event.status]}`}>
                                                {statusLabels[event.status]}
                                            </span>
                                        </div>

                                        <div className="text-sm text-gray-600 space-y-1">
                                            <p>🕐 {event.time} • {event.duration} דקות</p>
                                            <p>📅 {typeLabels[event.type]}</p>
                                            {event.participants.length > 0 && (
                                                <p>👥 {event.participants.join(', ')}</p>
                                            )}
                                        </div>
                                    </div>
                                </div>

                                <div className="mt-3 pt-3 border-t border-gray-100 flex gap-2">
                                    <button className="text-sm text-blue-600 hover:text-blue-800 transition-colors">
                                        ערוך
                                    </button>
                                    <button className="text-sm text-red-600 hover:text-red-800 transition-colors">
                                        בטל
                                    </button>
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </div>

            {/* Quick Actions */}
            <div className="max-w-md mx-auto px-6 py-4">
                <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                    <h3 className="font-semibold text-gray-800 mb-3">פעולות מהירות</h3>
                    <div className="grid grid-cols-2 gap-3">
                        <Link
                            href="/create/meeting"
                            className="p-3 bg-blue-50 border border-blue-200 rounded-lg text-center hover:bg-blue-100 transition-colors"
                        >
                            <div className="text-2xl mb-1">➕</div>
                            <div className="text-sm font-medium text-blue-700">פגישה חדשה</div>
                        </Link>
                        <Link
                            href="/create/reminder"
                            className="p-3 bg-green-50 border border-green-200 rounded-lg text-center hover:bg-green-100 transition-colors"
                        >
                            <div className="text-2xl mb-1">⏰</div>
                            <div className="text-sm font-medium text-green-700">זיכרון חדש</div>
                        </Link>
                    </div>
                </div>
            </div>
        </main>
    );
}
