'use client';
import Link from 'next/link';
import { useState } from 'react';

// Mock data for groups
const mockGroups = [
    {
        id: 1,
        name: 'צוות עבודה',
        description: 'צוות הפרויקט הנוכחי',
        members: 5,
        type: 'work',
        lastActivity: '2025-01-26T14:30:00Z'
    },
    {
        id: 2,
        name: 'חברים קרובים',
        description: 'קבוצת החברים הקרובים',
        members: 8,
        type: 'social',
        lastActivity: '2025-01-25T20:00:00Z'
    },
    {
        id: 3,
        name: 'משפחה מורחבת',
        description: 'כל המשפחה המורחבת',
        members: 15,
        type: 'family',
        lastActivity: '2025-01-24T18:00:00Z'
    },
    {
        id: 4,
        name: 'קבוצת ספורט',
        description: 'קבוצת ריצה שבועית',
        members: 12,
        type: 'health',
        lastActivity: '2025-01-23T07:00:00Z'
    }
];

const typeIcons: { [key: string]: string } = {
    work: '💼',
    social: '🎉',
    family: '👨‍👩‍👧',
    health: '🏃‍♂️',
    other: '👥'
};

const typeLabels: { [key: string]: string } = {
    work: 'עבודה',
    social: 'חברתי',
    family: 'משפחה',
    health: 'בריאות',
    other: 'אחר'
};

export default function Groups() {
    const [searchTerm, setSearchTerm] = useState('');

    const filteredGroups = mockGroups.filter(group =>
        group.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        group.description.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const formatLastActivity = (dateString: string) => {
        const date = new Date(dateString);
        const now = new Date();
        const diffInHours = Math.floor((now.getTime() - date.getTime()) / (1000 * 60 * 60));

        if (diffInHours < 1) return 'עכשיו';
        if (diffInHours < 24) return `לפני ${diffInHours} שעות`;
        if (diffInHours < 48) return 'אתמול';
        return date.toLocaleDateString('he-IL');
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
                        <h1 className="text-xl font-bold text-gray-800">קבוצות</h1>
                        <Link
                            href="/groups/create"
                            className="text-blue-600 hover:text-blue-800 font-medium"
                        >
                            חדש
                        </Link>
                    </div>
                </div>
            </div>

            {/* Search */}
            <div className="max-w-md mx-auto px-6 py-4">
                <div className="relative">
                    <input
                        type="text"
                        placeholder="חפש קבוצות..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="w-full px-4 py-3 pl-10 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                    <span className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">
                        🔍
                    </span>
                </div>
            </div>

            {/* Groups List */}
            <div className="max-w-md mx-auto px-6 py-4">
                {filteredGroups.length === 0 ? (
                    <div className="text-center py-12">
                        <div className="text-6xl mb-4">👥</div>
                        <h3 className="text-lg font-semibold text-gray-800 mb-2">לא נמצאו קבוצות</h3>
                        <p className="text-gray-600 mb-6">
                            {searchTerm ? 'נסה לחפש משהו אחר' : 'עדיין אין לך קבוצות. צור קבוצה ראשונה!'}
                        </p>
                        {!searchTerm && (
                            <Link
                                href="/groups/create"
                                className="inline-block bg-gradient-to-r from-blue-500 to-indigo-600 text-white px-6 py-3 rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all duration-200"
                            >
                                צור קבוצה חדשה
                            </Link>
                        )}
                    </div>
                ) : (
                    <div className="space-y-4">
                        {filteredGroups.map((group) => (
                            <Link
                                key={group.id}
                                href={`/groups/${group.id}`}
                                className="block bg-white p-4 rounded-xl border border-gray-200 shadow-sm hover:shadow-md transition-all duration-200"
                            >
                                <div className="flex items-start gap-3">
                                    <span className="text-3xl">{typeIcons[group.type]}</span>

                                    <div className="flex-1">
                                        <div className="flex items-center justify-between mb-2">
                                            <h3 className="font-semibold text-gray-800">{group.name}</h3>
                                            <span className="text-xs text-gray-500 bg-gray-100 px-2 py-1 rounded-full">
                                                {typeLabels[group.type]}
                                            </span>
                                        </div>

                                        <p className="text-gray-600 text-sm mb-3">{group.description}</p>

                                        <div className="flex items-center justify-between text-sm text-gray-500">
                                            <span>👥 {group.members} חברים</span>
                                            <span>🕐 {formatLastActivity(group.lastActivity)}</span>
                                        </div>
                                    </div>
                                </div>
                            </Link>
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
                            href="/groups/create"
                            className="p-3 bg-blue-50 border border-blue-200 rounded-lg text-center hover:bg-blue-100 transition-colors"
                        >
                            <div className="text-2xl mb-1">➕</div>
                            <div className="text-sm font-medium text-blue-700">קבוצה חדשה</div>
                        </Link>
                        <Link
                            href="/groups/invite"
                            className="p-3 bg-green-50 border border-green-200 rounded-lg text-center hover:bg-green-100 transition-colors"
                        >
                            <div className="text-2xl mb-1">📨</div>
                            <div className="text-sm font-medium text-green-700">הזמן חברים</div>
                        </Link>
                    </div>
                </div>
            </div>
        </main>
    );
}
