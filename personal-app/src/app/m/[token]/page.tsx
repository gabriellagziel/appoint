'use client';
import { notFound, useParams } from 'next/navigation';
import { useEffect, useState } from 'react';

interface Meeting {
    id: string;
    title: string;
    description: string;
    date: string;
    time: string;
    duration: number;
    participants: string[];
    type: string;
}

interface Slot {
    id: string;
    time: string;
    available: boolean;
}

export default function Booking() {
    const params = useParams();
    const token = params.token as string;

    const [meeting, setMeeting] = useState<Meeting | null>(null);
    const [slots, setSlots] = useState<Slot[]>([]);
    const [selectedSlot, setSelectedSlot] = useState<string | null>(null);
    const [isLoading, setIsLoading] = useState(true);
    const [isBooking, setIsBooking] = useState(false);
    const [bookingSuccess, setBookingSuccess] = useState(false);

    useEffect(() => {
        const fetchMeetingData = async () => {
            try {
                const response = await fetch(`/api/booking?token=${token}`);
                if (!response.ok) {
                    throw new Error('Meeting not found');
                }
                const data = await response.json();
                setMeeting(data.meeting);
                setSlots(data.slots);
            } catch (error) {
                console.error('Error fetching meeting:', error);
                notFound();
            } finally {
                setIsLoading(false);
            }
        };

        fetchMeetingData();
    }, [token]);



    const handleSlotSelect = (slotId: string) => {
        setSelectedSlot(slotId);
    };

    const handleBooking = async () => {
        if (!selectedSlot) return;

        setIsBooking(true);
        try {
            const response = await fetch('/api/booking', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    token: token,
                    slotId: selectedSlot,
                }),
            });

            if (response.ok) {
                setBookingSuccess(true);
            } else {
                throw new Error('Booking failed');
            }
        } catch (error) {
            console.error('Error booking slot:', error);
            alert('שגיאה באישור השתתפות. נסה שוב.');
        } finally {
            setIsBooking(false);
        }
    };

    if (isLoading) {
        return (
            <main className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
                    <p className="text-gray-600">טוען פגישה...</p>
                </div>
            </main>
        );
    }

    if (!meeting) {
        return notFound();
    }

    if (bookingSuccess) {
        return (
            <main className="min-h-screen bg-gradient-to-br from-green-50 to-emerald-100 flex items-center justify-center">
                <div className="max-w-md mx-auto text-center p-6">
                    <div className="text-6xl mb-4">✅</div>
                    <h1 className="text-2xl font-bold text-gray-800 mb-2">השתתפות אושרה!</h1>
                    <p className="text-gray-600 mb-6">
                        אישרת את השתתפותך בפגישה &quot;{meeting.title}&quot;
                    </p>
                    <div className="bg-white p-4 rounded-xl border border-green-200">
                        <p className="text-sm text-green-700 mb-2">פרטי הפגישה:</p>
                        <p className="font-semibold text-gray-800">{meeting.title}</p>
                        <p className="text-gray-600 text-sm">
                            {new Date(`${meeting.date}T${meeting.time}`).toLocaleDateString('he-IL', {
                                weekday: 'long',
                                year: 'numeric',
                                month: 'long',
                                day: 'numeric'
                            })} בשעה {meeting.time}
                        </p>
                    </div>
                </div>
            </main>
        );
    }

    return (
        <main className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 pb-20">
            {/* Header */}
            <div className="bg-white shadow-sm border-b">
                <div className="max-w-md mx-auto px-6 py-4">
                    <h1 className="text-xl font-bold text-gray-800 text-center">הזמנה לפגישה</h1>
                </div>
            </div>

            {/* Meeting Details */}
            <div className="max-w-md mx-auto px-6 py-6">
                <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm mb-6">
                    <h2 className="text-xl font-bold text-gray-800 mb-4 text-center">{meeting.title}</h2>

                    {meeting.description && (
                        <p className="text-gray-600 text-center mb-4">{meeting.description}</p>
                    )}

                    <div className="space-y-3">
                        <div className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                            <span className="text-2xl">📅</span>
                            <div>
                                <p className="font-semibold text-gray-800">תאריך ושעה</p>
                                <p className="text-gray-600">
                                    {new Date(`${meeting.date}T${meeting.time}`).toLocaleDateString('he-IL', {
                                        weekday: 'long',
                                        year: 'numeric',
                                        month: 'long',
                                        day: 'numeric'
                                    })} בשעה {meeting.time}
                                </p>
                            </div>
                        </div>

                        <div className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                            <span className="text-2xl">⏱️</span>
                            <div>
                                <p className="font-semibold text-gray-800">משך</p>
                                <p className="text-gray-600">{meeting.duration} דקות</p>
                            </div>
                        </div>

                        <div className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                            <span className="text-2xl">👥</span>
                            <div>
                                <p className="font-semibold text-gray-800">משתתפים</p>
                                <p className="text-gray-600">{meeting.participants.length} משתתפים</p>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Available Slots */}
                <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
                    <h3 className="text-lg font-bold text-gray-800 mb-4">בחר זמן השתתפות</h3>

                    {slots.length === 0 ? (
                        <p className="text-gray-500 text-center py-8">אין זמנים זמינים לפגישה זו</p>
                    ) : (
                        <div className="grid gap-3">
                            {slots.map((slot) => (
                                <button
                                    key={slot.id}
                                    onClick={() => handleSlotSelect(slot.id)}
                                    disabled={!slot.available}
                                    className={`p-4 rounded-lg border-2 transition-all duration-200 text-center ${selectedSlot === slot.id
                                            ? 'border-blue-500 bg-blue-50 text-blue-700'
                                            : slot.available
                                                ? 'border-gray-200 hover:border-gray-300 hover:bg-gray-50'
                                                : 'border-gray-100 bg-gray-50 text-gray-400 cursor-not-allowed'
                                        }`}
                                >
                                    <div className="font-semibold">{slot.time}</div>
                                    <div className="text-sm">
                                        {slot.available ? 'זמין' : 'לא זמין'}
                                    </div>
                                </button>
                            ))}
                        </div>
                    )}
                </div>

                {/* Booking Button */}
                {selectedSlot && (
                    <div className="mt-6">
                        <button
                            onClick={handleBooking}
                            disabled={isBooking}
                            className="w-full bg-gradient-to-r from-green-500 to-emerald-600 text-white py-4 rounded-xl font-semibold text-lg shadow-lg hover:shadow-xl transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            {isBooking ? 'מאשר השתתפות...' : 'אשר השתתפות'}
                        </button>
                    </div>
                )}
            </div>
        </main>
    );
}
