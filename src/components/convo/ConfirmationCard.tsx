'use client';
import { useRouter } from 'next/navigation';

interface ConfirmationCardProps {
    meetingId?: string;
    locale?: string;
}

export default function ConfirmationCard({ meetingId, locale = 'en' }: ConfirmationCardProps) {
    const router = useRouter();

    return (
        <div className="bg-white rounded-2xl border shadow-sm p-6 max-w-md mx-auto text-center">
            <div className="mb-6">
                <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <span className="text-2xl">✅</span>
                </div>
                <h2 className="text-xl font-semibold text-gray-900 mb-2">Meeting Created Successfully!</h2>
                <p className="text-gray-600 text-sm">Your meeting has been saved and is ready to go</p>
            </div>

            <div className="space-y-3">
                <button
                    onClick={() => router.push(`/${locale}/meetings`)}
                    className="w-full rounded-xl border border-gray-300 px-4 py-3 text-gray-700 hover:bg-gray-50 transition-colors"
                >
                    📋 Go to Meetings
                </button>

                {meetingId && (
                    <button
                        onClick={() => router.push(`/${locale}/meetings/${meetingId}`)}
                        className="w-full rounded-xl bg-blue-600 text-white px-4 py-3 hover:bg-blue-700 transition-colors"
                    >
                        🚀 Open Meeting Hub
                    </button>
                )}

                <button
                    onClick={() => router.push(`/${locale}/create/meeting`)}
                    className="w-full rounded-xl border border-blue-300 text-blue-600 px-4 py-3 hover:bg-blue-50 transition-colors"
                >
                    ➕ Create Another Meeting
                </button>
            </div>
        </div>
    );
}


