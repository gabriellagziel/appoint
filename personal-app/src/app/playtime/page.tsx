'use client';
import Link from 'next/link';
import { useState } from 'react';

// Mock data for games and activities
const mockGames = [
    {
        id: 1,
        name: 'טאקי',
        type: 'card',
        players: '2-8',
        duration: '15-30 דקות',
        difficulty: 'easy',
        description: 'משחק קלפים מהיר ומהנה לכל המשפחה',
        icon: '🃏',
        isAvailable: true
    },
    {
        id: 2,
        name: 'שחמט',
        type: 'board',
        players: '2',
        duration: '30-120 דקות',
        difficulty: 'hard',
        description: 'משחק אסטרטגיה קלאסי',
        icon: '♟️',
        isAvailable: true
    },
    {
        id: 3,
        name: 'טאקי',
        type: 'card',
        players: '2-8',
        duration: '15-30 דקות',
        difficulty: 'easy',
        description: 'משחק קלפים מהיר ומהנה לכל המשפחה',
        icon: '🎲',
        isAvailable: false
    },
    {
        id: 4,
        name: 'פאזל',
        type: 'puzzle',
        players: '1-4',
        duration: '30-180 דקות',
        difficulty: 'medium',
        description: 'פאזל 1000 חלקים של נוף יפה',
        icon: '🧩',
        isAvailable: true
    },
    {
        id: 5,
        name: 'מונופול',
        type: 'board',
        players: '2-8',
        duration: '60-180 דקות',
        difficulty: 'medium',
        description: 'משחק כלכלי קלאסי',
        icon: '🏠',
        isAvailable: true
    },
    {
        id: 6,
        name: 'טאקי',
        type: 'card',
        players: '2-8',
        duration: '15-30 דקות',
        difficulty: 'easy',
        description: 'משחק קלפים מהיר ומהנה לכל המשפחה',
        icon: '🎯',
        isAvailable: false
    }
];

const gameTypes = [
    { value: 'all', label: 'כל המשחקים', icon: '🎮' },
    { value: 'card', label: 'קלפים', icon: '🃏' },
    { value: 'board', label: 'לוח', icon: '♟️' },
    { value: 'puzzle', label: 'פאזל', icon: '🧩' },
    { value: 'outdoor', label: 'חוץ', icon: '🏃‍♂️' }
];

const difficultyColors: Record<string, string> = {
    easy: 'bg-green-100 text-green-800 border-green-200',
    medium: 'bg-yellow-100 text-yellow-800 border-yellow-200',
    hard: 'bg-red-100 text-red-800 border-red-200'
};

const difficultyLabels: Record<string, string> = {
    easy: 'קל',
    medium: 'בינוני',
    hard: 'קשה'
};

export default function Playtime() {
    const [selectedType, setSelectedType] = useState('all');
    const [searchTerm, setSearchTerm] = useState('');

    const filteredGames = mockGames.filter(game => {
        const matchesType = selectedType === 'all' || game.type === selectedType;
        const matchesSearch = game.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
            game.description.toLowerCase().includes(searchTerm.toLowerCase());
        return matchesType && matchesSearch;
    });

    const startGame = (gameId: number) => {
        // TODO: In production, start game session
        console.log(`Starting game ${gameId}`);
        alert(`מתחיל משחק ${mockGames.find(g => g.id === gameId)?.name}`);
    };

    return (
        <main className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-100 pb-20">
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
                        <h1 className="text-xl font-bold text-gray-800">זמן משחק</h1>
                        <Link
                            href="/playtime/add"
                            className="text-purple-600 hover:text-purple-800 font-medium"
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
                        placeholder="חפש משחקים..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="w-full px-4 py-3 pl-10 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500"
                    />
                    <span className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">
                        🔍
                    </span>
                </div>

                {/* Game Type Filter */}
                <div className="flex gap-2 overflow-x-auto pb-2">
                    {gameTypes.map((type) => (
                        <button
                            key={type.value}
                            onClick={() => setSelectedType(type.value)}
                            className={`px-4 py-2 rounded-lg text-sm whitespace-nowrap transition-colors flex items-center gap-2 ${selectedType === type.value
                                    ? 'bg-purple-100 text-purple-700 border border-purple-200'
                                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                                }`}
                        >
                            <span>{type.icon}</span>
                            {type.label}
                        </button>
                    ))}
                </div>
            </div>

            {/* Games List */}
            <div className="max-w-md mx-auto px-6 py-4">
                {filteredGames.length === 0 ? (
                    <div className="text-center py-12">
                        <div className="text-6xl mb-4">🎮</div>
                        <h3 className="text-lg font-semibold text-gray-800 mb-2">לא נמצאו משחקים</h3>
                        <p className="text-gray-600 mb-6">
                            {searchTerm || selectedType !== 'all'
                                ? 'נסה לשנות את החיפוש או הפילטרים'
                                : 'עדיין אין לך משחקים. הוסף את הראשונים!'}
                        </p>
                        {!searchTerm && selectedType === 'all' && (
                            <Link
                                href="/playtime/add"
                                className="inline-block bg-gradient-to-r from-purple-500 to-pink-600 text-white px-6 py-3 rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all duration-200"
                            >
                                הוסף משחק חדש
                            </Link>
                        )}
                    </div>
                ) : (
                    <div className="space-y-4">
                        {filteredGames.map((game) => (
                            <div key={game.id} className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                                <div className="flex items-start gap-3">
                                    <span className="text-4xl">{game.icon}</span>

                                    <div className="flex-1">
                                        <div className="flex items-center justify-between mb-2">
                                            <h3 className="font-semibold text-gray-800 text-lg">{game.name}</h3>
                                            <span className={`px-2 py-1 rounded-full text-xs border ${difficultyColors[game.difficulty]}`}>
                                                {difficultyLabels[game.difficulty]}
                                            </span>
                                        </div>

                                        <p className="text-gray-600 text-sm mb-3">{game.description}</p>

                                        <div className="text-sm text-gray-500 space-y-1 mb-3">
                                            <p>👥 {game.players} שחקנים</p>
                                            <p>⏱️ {game.duration}</p>
                                            <p>📊 רמת קושי: {difficultyLabels[game.difficulty]}</p>
                                        </div>

                                        <div className="flex gap-2">
                                            {game.isAvailable ? (
                                                <button
                                                    onClick={() => startGame(game.id)}
                                                    className="px-4 py-2 bg-gradient-to-r from-purple-500 to-pink-600 text-white rounded-lg hover:shadow-lg transition-all duration-200 text-sm font-medium"
                                                >
                                                    🎮 התחל משחק
                                                </button>
                                            ) : (
                                                <span className="px-4 py-2 bg-gray-100 text-gray-500 rounded-lg text-sm">
                                                    לא זמין כרגע
                                                </span>
                                            )}

                                            <button className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors text-sm">
                                                📋 פרטים
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
                            href="/playtime/add"
                            className="p-3 bg-purple-50 border border-purple-200 rounded-lg text-center hover:bg-purple-100 transition-colors"
                        >
                            <div className="text-2xl mb-1">➕</div>
                            <div className="text-sm font-medium text-purple-700">משחק חדש</div>
                        </Link>
                        <Link
                            href="/playtime/schedule"
                            className="p-3 bg-pink-50 border border-pink-200 rounded-lg text-center hover:bg-pink-100 transition-colors"
                        >
                            <div className="text-2xl mb-1">📅</div>
                            <div className="text-sm font-medium text-pink-700">תזמן משחק</div>
                        </Link>
                    </div>
                </div>
            </div>
        </main>
    );
}
