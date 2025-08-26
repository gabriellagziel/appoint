'use client';
import { useState } from 'react';
import { MeetingData } from '../page';

interface ReviewProps {
    onBack: () => void;
    data: MeetingData;
}

const durationLabels: { [key: number]: string } = {
    15: '15 דקות',
    30: '30 דקות',
    45: '45 דקות',
    60: 'שעה',
    90: 'שעה וחצי',
    120: 'שעתיים'
};

export default function Review({ onBack, data }: ReviewProps) {
    const [isCreating, setIsCreating] = useState(false);
    const [meetingUrl, setMeetingUrl] = useState<string | null>(null);

    const createMeeting = async () => {
        setIsCreating(true);
        try {
            const response = await fetch('/api/meetings', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data),
            });

            if (response.ok) {
                const result = await response.json();
                setMeetingUrl(result.url);
            } else {
                throw new Error('Failed to create meeting');
            }
        } catch (error) {
            console.error('Error creating meeting:', error);
            alert('שגיאה ביצירת הפגישה. נסה שוב.');
        } finally {
            setIsCreating(false);
        }
    };

    const copyToClipboard = async () => {
        if (meetingUrl) {
            try {
                await navigator.clipboard.writeText(meetingUrl);
                alert('הקישור הועתק ללוח!');
            } catch (error) {
                console.error('Failed to copy:', error);
            }
        }
    };

    const formatDate = (date: string, time: string) => {
        try {
            return new Date(`${date}T${time}`).toLocaleDateString('he-IL', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
        } catch {
            return `${date} בשעה ${time}`;
        }
    };

    if (meetingUrl) {
        return (
            <div className="space-y-6 text-center">
                <div className="text-6xl mb-4">🎉</div>
                <h2 className="text-2xl font-bold text-gray-800 mb-2">הפגישה נוצרה בהצלחה!</h2>
                <p className="text-gray-600 mb-6">שלח את הקישור למשתתפים כדי שיוכלו לאשר את השתתפותם</p>

                <div className="bg-green-50 p-4 rounded-xl border border-green-200">
                    <p className="text-sm text-green-700 mb-2">קישור הזמנה:</p>
                    <div className="bg-white p-3 rounded-lg border border-green-200 mb-3">
                        <code className="text-green-800 break-all">{meetingUrl}</code>
                    </div>
                    <button
                        onClick={copyToClipboard}
                        className="bg-green-600 text-white px-6 py-2 rounded-lg hover:bg-green-700 transition-colors"
                    >
                        העתק קישור
                    </button>
                </div>

                <div className="flex gap-3">
                    <button
                        onClick={() => window.location.href = '/'}
                        className="flex-1 px-6 py-3 bg-gray-600 text-white rounded-xl hover:bg-gray-700 transition-colors"
                    >
                        חזור לבית
                    </button>
                    <button
                        onClick={() => window.location.href = '/agenda'}
                        className="flex-1 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors"
                    >
                        צפה ביומן
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="space-y-6">
            <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-800 mb-2">בדיקה ואישור</h2>
                <p className="text-gray-600">בדוק את פרטי הפגישה לפני היצירה</p>
            </div>

            {/* Meeting Summary */}
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
                <h3 className="font-bold text-xl text-gray-800 mb-4 text-center">{data.title}</h3>

                <div className="space-y-4">
                    {/* Type */}
                    <div className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                        <span className="text-2xl">
                            {data.type === 'work' ? '💼' :
                                data.type === 'personal' ? '👤' :
                                    data.type === 'family' ? '👨‍👩‍👧' :
                                        data.type === 'health' ? '🏥' :
                                            data.type === 'social' ? '🎉' : '📝'}
                        </span>
                        <div>
                            <p className="font-semibold text-gray-800">סוג פגישה</p>
                            <p className="text-gray-600">
                                {data.type === 'work' ? 'עבודה' :
                                    data.type === 'personal' ? 'אישי' :
                                        data.type === 'family' ? 'משפחה' :
                                            data.type === 'health' ? 'בריאות' :
                                                data.type === 'social' ? 'חברתי' : 'אחר'}
                            </p>
                        </div>
                    </div>

                    {/* Date & Time */}
                    <div className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                        <span className="text-2xl">📅</span>
                        <div>
                            <p className="font-semibold text-gray-800">תאריך ושעה</p>
                            <p className="text-gray-600">{formatDate(data.date, data.time)}</p>
                        </div>
                    </div>

                    {/* Duration */}
                    <div className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                        <span className="text-2xl">⏱️</span>
                        <div>
                            <p className="font-semibold text-gray-800">משך</p>
                            <p className="text-gray-600">{durationLabels[data.duration] || `${data.duration} דקות`}</p>
                        </div>
                    </div>

                    {/* Participants */}
                    <div className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                        <span className="text-2xl">👥</span>
                        <div>
                            <p className="font-semibold text-gray-800">משתתפים</p>
                            <p className="text-gray-600">{data.participants.length} משתתפים</p>
                            <div className="mt-1 text-sm text-gray-500">
                                {data.participants.slice(0, 2).join(', ')}
                                {data.participants.length > 2 && ` +${data.participants.length - 2} נוספים`}
                            </div>
                        </div>
                    </div>

                    {/* Description */}
                    {data.description && (
                        <div className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                            <span className="text-2xl">📝</span>
                            <div>
                                <p className="font-semibold text-gray-800">תיאור</p>
                                <p className="text-gray-600">{data.description}</p>
                            </div>
                        </div>
                    )}
                </div>
            </div>

            {/* Navigation */}
            <div className="flex gap-3">
                <button
                    onClick={onBack}
                    className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-xl hover:bg-gray-50 transition-colors"
                >
                    ← חזור
                </button>
                <button
                    onClick={createMeeting}
                    disabled={isCreating}
                    className="flex-1 bg-gradient-to-r from-green-500 to-emerald-600 text-white py-3 rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                    {isCreating ? 'יוצר פגישה...' : 'צור פגישה'}
                </button>
            </div>
        </div>
    );
}
