'use client';
import { MeetingData } from '../page';

interface TypeProps {
    onNext: (data: Partial<MeetingData>) => void;
    data: MeetingData;
}

const meetingTypes = [
    { id: 'work', title: 'עבודה', icon: '💼', description: 'פגישת עבודה או פרויקט' },
    { id: 'personal', title: 'אישי', icon: '👤', description: 'פגישה אישית או חברית' },
    { id: 'family', title: 'משפחה', icon: '👨‍👩‍👧', description: 'פגישת משפחה או אירוע' },
    { id: 'health', title: 'בריאות', icon: '🏥', description: 'פגישה רפואית או טיפול' },
    { id: 'social', title: 'חברתי', icon: '🎉', description: 'אירוע חברתי או בילוי' },
    { id: 'other', title: 'אחר', icon: '📝', description: 'סוג אחר של פגישה' },
];

export default function Type({ onNext, data }: TypeProps) {
    const handleTypeSelect = (type: string) => {
        onNext({ type });
    };

    return (
        <div className="space-y-6">
            <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-800 mb-2">איזה סוג פגישה?</h2>
                <p className="text-gray-600">בחר את הסוג המתאים ביותר לפגישה שלך</p>
            </div>

            <div className="grid gap-4">
                {meetingTypes.map((type) => (
                    <button
                        key={type.id}
                        onClick={() => handleTypeSelect(type.id)}
                        className={`p-4 rounded-xl border-2 transition-all duration-200 text-right ${data.type === type.id
                                ? 'border-blue-500 bg-blue-50 shadow-md'
                                : 'border-gray-200 bg-white hover:border-gray-300 hover:shadow-sm'
                            }`}
                    >
                        <div className="flex items-center gap-4">
                            <span className="text-3xl">{type.icon}</span>
                            <div className="flex-1">
                                <h3 className="font-semibold text-gray-800 text-lg">{type.title}</h3>
                                <p className="text-gray-600 text-sm">{type.description}</p>
                            </div>
                            {data.type === type.id && (
                                <div className="w-6 h-6 bg-blue-500 rounded-full flex items-center justify-center">
                                    <span className="text-white text-sm">✓</span>
                                </div>
                            )}
                        </div>
                    </button>
                ))}
            </div>

            {data.type && (
                <button
                    onClick={() => onNext({})}
                    className="w-full bg-gradient-to-r from-blue-500 to-indigo-600 text-white py-4 rounded-xl font-semibold text-lg shadow-lg hover:shadow-xl transition-all duration-200"
                >
                    המשך למשתתפים →
                </button>
            )}
        </div>
    );
}
