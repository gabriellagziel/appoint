'use client';

interface SummaryCardProps {
    data: any;
    onEdit?: () => void;
    onConfirm?: () => void;
}

export default function SummaryCard({ data, onEdit, onConfirm }: SummaryCardProps) {
    const formatDate = (date: string) => {
        if (!date) return '—';
        return new Date(date).toLocaleDateString('en-US', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    };

    const formatTime = (time: string) => {
        if (!time) return '—';
        return time;
    };

    const getMeetingTypeLabel = (type: string) => {
        const typeMap: Record<string, string> = {
            personal: '👤 Personal 1:1',
            group: '👥 Group / Event',
            virtual: '💻 Virtual',
            business: '🏢 With a Business',
            playtime: '🎮 Playtime',
            opencall: '📢 Open Call'
        };
        return typeMap[type] || type;
    };

    return (
        <div className="bg-white rounded-2xl border shadow-sm p-6 max-w-md mx-auto">
            <div className="text-center mb-6">
                <h2 className="text-xl font-semibold text-gray-900 mb-2">Review Your Meeting</h2>
                <p className="text-gray-600 text-sm">Please review the details before confirming</p>
            </div>

            <div className="space-y-4 mb-6">
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                    <span className="text-sm font-medium text-gray-600">Type:</span>
                    <span className="text-sm text-gray-900">{getMeetingTypeLabel(data.meetingType)}</span>
                </div>

                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                    <span className="text-sm font-medium text-gray-600">Participants:</span>
                    <span className="text-sm text-gray-900">
                        {data.participants?.length ? data.participants.join(', ') : '—'}
                    </span>
                </div>

                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                    <span className="text-sm font-medium text-gray-600">Date:</span>
                    <span className="text-sm text-gray-900">{formatDate(data.date)}</span>
                </div>

                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                    <span className="text-sm font-medium text-gray-600">Time:</span>
                    <span className="text-sm text-gray-900">{formatTime(data.time)}</span>
                </div>

                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                    <span className="text-sm font-medium text-gray-600">Location:</span>
                    <span className="text-sm text-gray-900">{data.location || '—'}</span>
                </div>

                {data.notes && (
                    <div className="p-3 bg-gray-50 rounded-lg">
                        <span className="text-sm font-medium text-gray-600 block mb-2">Notes:</span>
                        <span className="text-sm text-gray-900">{data.notes}</span>
                    </div>
                )}
            </div>

            <div className="flex gap-3">
                {onEdit && (
                    <button
                        onClick={onEdit}
                        className="flex-1 rounded-xl border border-gray-300 px-4 py-3 text-gray-700 hover:bg-gray-50 transition-colors"
                    >
                        ✏️ Edit
                    </button>
                )}
                {onConfirm && (
                    <button
                        onClick={onConfirm}
                        className="flex-1 rounded-xl bg-blue-600 text-white px-4 py-3 hover:bg-blue-700 transition-colors"
                    >
                        ✅ Confirm
                    </button>
                )}
            </div>
        </div>
    );
}


