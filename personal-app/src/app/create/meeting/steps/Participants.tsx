'use client';
import { useState } from 'react';
import { MeetingData } from '../page';

interface ParticipantsProps {
    onNext: (data: Partial<MeetingData>) => void;
    onBack: () => void;
    data: MeetingData;
}

const suggestedParticipants = [
    { name: 'דן כהן', email: 'dan@example.com', avatar: '👨‍💼' },
    { name: 'שרה לוי', email: 'sarah@example.com', avatar: '👩‍💼' },
    { name: 'משה ישראלי', email: 'moshe@example.com', avatar: '👨‍💻' },
    { name: 'רחל גולדברג', email: 'rachel@example.com', avatar: '👩‍🎨' },
];

export default function Participants({ onNext, onBack, data }: ParticipantsProps) {
    const [newParticipant, setNewParticipant] = useState({ name: '', email: '' });
    const [participants, setParticipants] = useState<string[]>(data.participants);

    const addParticipant = (participant: string) => {
        if (participant && !participants.includes(participant)) {
            const updated = [...participants, participant];
            setParticipants(updated);
        }
    };

    const removeParticipant = (participant: string) => {
        setParticipants(participants.filter(p => p !== participant));
    };

    const handleNext = () => {
        onNext({ participants });
    };

    return (
        <div className="space-y-6">
            <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-800 mb-2">מי משתתף?</h2>
                <p className="text-gray-600">הוסף משתתפים לפגישה שלך</p>
            </div>

            {/* Add New Participant */}
            <div className="bg-white p-4 rounded-xl border border-gray-200">
                <h3 className="font-semibold text-gray-800 mb-3">הוסף משתתף חדש</h3>
                <div className="flex gap-2">
                    <input
                        type="text"
                        placeholder="שם מלא"
                        value={newParticipant.name}
                        onChange={(e) => setNewParticipant({ ...newParticipant, name: e.target.value })}
                        className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                    <input
                        type="email"
                        placeholder="אימייל"
                        value={newParticipant.email}
                        onChange={(e) => setNewParticipant({ ...newParticipant, email: e.target.value })}
                        className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                    <button
                        onClick={() => {
                            if (newParticipant.name && newParticipant.email) {
                                addParticipant(`${newParticipant.name} (${newParticipant.email})`);
                                setNewParticipant({ name: '', email: '' });
                            }
                        }}
                        className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
                    >
                        הוסף
                    </button>
                </div>
            </div>

            {/* Suggested Participants */}
            <div className="bg-white p-4 rounded-xl border border-gray-200">
                <h3 className="font-semibold text-gray-800 mb-3">משתתפים מוצעים</h3>
                <div className="grid gap-2">
                    {suggestedParticipants.map((participant) => (
                        <button
                            key={participant.email}
                            onClick={() => addParticipant(`${participant.name} (${participant.email})`)}
                            className={`p-3 rounded-lg border transition-all duration-200 text-right ${participants.includes(`${participant.name} (${participant.email})`)
                                    ? 'border-blue-500 bg-blue-50'
                                    : 'border-gray-200 hover:border-gray-300'
                                }`}
                        >
                            <div className="flex items-center gap-3">
                                <span className="text-2xl">{participant.avatar}</span>
                                <div className="flex-1">
                                    <div className="font-semibold text-gray-800">{participant.name}</div>
                                    <div className="text-sm text-gray-500">{participant.email}</div>
                                </div>
                                {participants.includes(`${participant.name} (${participant.email})`) && (
                                    <span className="text-blue-500 text-xl">✓</span>
                                )}
                            </div>
                        </button>
                    ))}
                </div>
            </div>

            {/* Current Participants */}
            {participants.length > 0 && (
                <div className="bg-white p-4 rounded-xl border border-gray-200">
                    <h3 className="font-semibold text-gray-800 mb-3">משתתפים נבחרים ({participants.length})</h3>
                    <div className="space-y-2">
                        {participants.map((participant, index) => (
                            <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                <span className="text-gray-800">{participant}</span>
                                <button
                                    onClick={() => removeParticipant(participant)}
                                    className="text-red-500 hover:text-red-700 text-lg"
                                >
                                    ✕
                                </button>
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {/* Navigation */}
            <div className="flex gap-3">
                <button
                    onClick={onBack}
                    className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-xl hover:bg-gray-50 transition-colors"
                >
                    ← חזור
                </button>
                <button
                    onClick={handleNext}
                    disabled={participants.length === 0}
                    className="flex-1 bg-gradient-to-r from-blue-500 to-indigo-600 text-white py-3 rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                    המשך לפרטים →
                </button>
            </div>
        </div>
    );
}
