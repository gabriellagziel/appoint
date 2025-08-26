'use client';
import Link from 'next/link';
import { useState } from 'react';

// Mock data for upcoming events
const mockUpcoming = [
  { id: 1, title: 'פגישה עם דן', time: '14:00', date: 'היום' },
  { id: 2, title: 'זיכרון: תשלום חשבונות', time: '16:30', date: 'מחר' },
  { id: 3, title: 'פגישת משפחה', time: '19:00', date: 'שלישי' },
];

export default function Home() {
  const [userName] = useState('גבריאל');

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 pb-20">
      {/* Header */}
      <div className="bg-white shadow-sm border-b">
        <div className="max-w-md mx-auto px-6 py-4">
          <h1 className="text-2xl font-bold text-gray-800">
            שלום, {userName} 👋
          </h1>
          <p className="text-gray-600 mt-1">מה נעשה היום?</p>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="max-w-md mx-auto px-6 py-6">
        <div className="grid gap-4">
          <Link
            href="/create/meeting"
            className="bg-gradient-to-r from-blue-500 to-indigo-600 text-white p-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-200 flex items-center justify-center text-lg font-semibold"
          >
            ➕ צור פגישה חדשה
          </Link>

          <Link
            href="/create/reminder"
            className="bg-gradient-to-r from-green-500 to-emerald-600 text-white p-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-200 flex items-center justify-center text-lg font-semibold"
          >
            ➕ צור זיכרון חדש
          </Link>

          <Link
            href="/playtime"
            className="bg-gradient-to-r from-purple-500 to-pink-600 text-white p-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-200 flex items-center justify-center text-lg font-semibold"
          >
            🎮 זמן משחק
          </Link>
        </div>

        {/* Upcoming Events */}
        <section className="mt-8">
          <h2 className="text-xl font-bold text-gray-800 mb-4">קרוב</h2>
          <div className="space-y-3">
            {mockUpcoming.map((event) => (
              <div key={event.id} className="bg-white p-4 rounded-lg shadow-sm border border-gray-100">
                <div className="flex justify-between items-center">
                  <div>
                    <h3 className="font-semibold text-gray-800">{event.title}</h3>
                    <p className="text-sm text-gray-500">{event.date} • {event.time}</p>
                  </div>
                  <div className="w-3 h-3 bg-blue-500 rounded-full"></div>
                </div>
              </div>
            ))}
          </div>
        </section>
      </div>

      {/* Bottom Navigation */}
      <nav className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-lg">
        <div className="max-w-md mx-auto flex justify-around py-3">
          <Link
            href="/"
            className="flex flex-col items-center p-2 text-blue-600"
          >
            <span className="text-2xl">🏠</span>
            <span className="text-xs mt-1">בית</span>
          </Link>

          <Link
            href="/agenda"
            className="flex flex-col items-center p-2 text-gray-500 hover:text-blue-600"
          >
            <span className="text-2xl">📅</span>
            <span className="text-xs mt-1">יומן</span>
          </Link>

          <Link
            href="/groups"
            className="flex flex-col items-center p-2 text-gray-500 hover:text-blue-600"
          >
            <span className="text-2xl">👥</span>
            <span className="text-xs mt-1">קבוצות</span>
          </Link>

          <Link
            href="/family"
            className="flex flex-col items-center p-2 text-gray-500 hover:text-blue-600"
          >
            <span className="text-2xl">👨‍👩‍👧</span>
            <span className="text-xs mt-1">משפחה</span>
          </Link>

          <Link
            href="/settings"
            className="flex flex-col items-center p-2 text-gray-500 hover:text-blue-600"
          >
            <span className="text-2xl">⚙️</span>
            <span className="text-xs mt-1">הגדרות</span>
          </Link>
        </div>
      </nav>
    </main>
  );
}
