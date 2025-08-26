'use client';
import Link from 'next/link';
import { useState } from 'react';

// Mock data for family members
const mockFamilyMembers = [
    {
        id: 1,
        name: 'אמא',
        relationship: 'mother',
        avatar: '👩‍🦰',
        phone: '+972-50-123-4567',
        email: 'mom@family.com',
        lastContact: '2025-01-26T18:00:00Z',
        upcomingEvents: 2
    },
    {
        id: 2,
        name: 'אבא',
        relationship: 'father',
        avatar: '👨‍🦱',
        phone: '+972-50-123-4568',
        email: 'dad@family.com',
        lastContact: '2025-01-25T20:00:00Z',
        upcomingEvents: 1
    },
    {
        id: 3,
        name: 'אח',
        relationship: 'brother',
        avatar: '👨‍🦲',
        phone: '+972-50-123-4569',
        email: 'brother@family.com',
        lastContact: '2025-01-24T16:00:00Z',
        upcomingEvents: 0
    },
    {
        id: 4,
        name: 'אחות',
        relationship: 'sister',
        avatar: '👩‍🦳',
        phone: '+972-50-123-4570',
        email: 'sister@family.com',
        lastContact: '2025-01-23T14:00:00Z',
        upcomingEvents: 3
    },
    {
        id: 5,
        name: 'סבא',
        relationship: 'grandfather',
        avatar: '👴',
        phone: '+972-50-123-4571',
        email: 'grandpa@family.com',
        lastContact: '2025-01-22T12:00:00Z',
        upcomingEvents: 1
    },
    {
        id: 6,
        name: 'סבתא',
        relationship: 'grandmother',
        avatar: '👵',
        phone: '+972-50-123-4572',
        email: 'grandma@family.com',
        lastContact: '2025-01-21T10:00:00Z',
        upcomingEvents: 2
    }
];

const relationshipLabels: { [key: string]: string } = {
    mother: 'אמא',
    father: 'אבא',
    brother: 'אח',
    sister: 'אחות',
    grandfather: 'סבא',
    grandmother: 'סבתא',
    uncle: 'דוד',
    aunt: 'דודה',
    cousin: 'בן/בת דוד',
    other: 'אחר'
};

export default function Family() {
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedRelationship, setSelectedRelationship] = useState<string>('all');

    const filteredMembers = mockFamilyMembers.filter(member => {
        const matchesSearch = member.name.toLowerCase().includes(searchTerm.toLowerCase());
        const matchesRelationship = selectedRelationship === 'all' || member.relationship === selectedRelationship;
        return matchesSearch && matchesRelationship;
    });

    const formatLastContact = (dateString: string) => {
        const date = new Date(dateString);
        const now = new Date();
        const diffInHours = Math.floor((now.getTime() - date.getTime()) / (1000 * 60 * 60));

        if (diffInHours < 1) return 'עכשיו';
        if (diffInHours < 24) return `לפני ${diffInHours} שעות`;
        if (diffInHours < 48) return 'אתמול';
        return date.toLocaleDateString('he-IL');
    };

    const relationshipOptions = [
        { value: 'all', label: 'כולם' },
        { value: 'mother', label: 'הורים' },
        { value: 'brother', label: 'אחים' },
        { value: 'grandfather', label: 'סבים' },
        { value: 'other', label: 'אחר' }
    ];

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
                        <h1 className="text-xl font-bold text-gray-800">משפחה</h1>
                        <Link
                            href="/family/add"
                            className="text-blue-600 hover:text-blue-800 font-medium"
                        >
                            הוסף
                        </Link>
                    </div>
                </div>
            </div>

            {/* Search and Filters */}
            <div className="max-w-md mx-auto px-6 py-4 space-y-4">
                {/* Search */}
                <div className="relative">
                    <input
                        type="text"
                        placeholder="חפש חברי משפחה..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="w-full px-4 py-3 pl-10 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                    <span className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">
                        🔍
                    </span>
                </div>

                {/* Relationship Filter */}
                <div className="flex gap-2 overflow-x-auto pb-2">
                    {relationshipOptions.map((option) => (
                        <button
                            key={option.value}
                            onClick={() => setSelectedRelationship(option.value)}
                            className={`px-4 py-2 rounded-lg text-sm whitespace-nowrap transition-colors ${selectedRelationship === option.value
                                    ? 'bg-blue-100 text-blue-700 border border-blue-200'
                                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                                }`}
                        >
                            {option.label}
                        </button>
                    ))}
                </div>
            </div>

            {/* Family Members List */}
            <div className="max-w-md mx-auto px-6 py-4">
                {filteredMembers.length === 0 ? (
                    <div className="text-center py-12">
                        <div className="text-6xl mb-4">👨‍👩‍👧</div>
                        <h3 className="text-lg font-semibold text-gray-800 mb-2">לא נמצאו חברי משפחה</h3>
                        <p className="text-gray-600 mb-6">
                            {searchTerm || selectedRelationship !== 'all'
                                ? 'נסה לשנות את החיפוש או הפילטרים'
                                : 'עדיין אין לך חברי משפחה. הוסף את הראשונים!'}
                        </p>
                        {!searchTerm && selectedRelationship === 'all' && (
                            <Link
                                href="/family/add"
                                className="inline-block bg-gradient-to-r from-blue-500 to-indigo-600 text-white px-6 py-3 rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all duration-200"
                            >
                                הוסף חבר משפחה
                            </Link>
                        )}
                    </div>
                ) : (
                    <div className="space-y-4">
                        {filteredMembers.map((member) => (
                            <div key={member.id} className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                                <div className="flex items-start gap-3">
                                    <span className="text-4xl">{member.avatar}</span>

                                    <div className="flex-1">
                                        <div className="flex items-center justify-between mb-2">
                                            <h3 className="font-semibold text-gray-800 text-lg">{member.name}</h3>
                                            <span className="text-xs text-gray-500 bg-gray-100 px-2 py-1 rounded-full">
                                                {relationshipLabels[member.relationship]}
                                            </span>
                                        </div>

                                        <div className="text-sm text-gray-600 space-y-1 mb-3">
                                            <p>📱 {member.phone}</p>
                                            <p>📧 {member.email}</p>
                                            <p>🕐 {formatLastContact(member.lastContact)}</p>
                                            {member.upcomingEvents > 0 && (
                                                <p className="text-blue-600">📅 {member.upcomingEvents} אירועים קרובים</p>
                                            )}
                                        </div>

                                        <div className="flex gap-2">
                                            <button className="text-sm text-blue-600 hover:text-blue-800 transition-colors">
                                                📞 התקשר
                                            </button>
                                            <button className="text-sm text-green-600 hover:text-green-800 transition-colors">
                                                💬 הודעה
                                            </button>
                                            <button className="text-sm text-purple-600 hover:text-purple-800 transition-colors">
                                                📅 צור פגישה
                                            </button>
                                        </div>
                                    </div>
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
                            href="/family/add"
                            className="p-3 bg-blue-50 border border-blue-200 rounded-lg text-center hover:bg-blue-100 transition-colors"
                        >
                            <div className="text-2xl mb-1">➕</div>
                            <div className="text-sm font-medium text-blue-700">הוסף חבר</div>
                        </Link>
                        <Link
                            href="/family/events"
                            className="p-3 bg-green-50 border border-green-200 rounded-lg text-center hover:bg-green-100 transition-colors"
                        >
                            <div className="text-2xl mb-1">📅</div>
                            <div className="text-sm font-medium text-green-700">אירועי משפחה</div>
                        </Link>
                    </div>
                </div>
            </div>
        </main>
    );
}
