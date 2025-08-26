'use client';
import { useState } from 'react';
import Details from './steps/Details';
import Participants from './steps/Participants';
import Review from './steps/Review';
import Type from './steps/Type';

export interface MeetingData {
    type: string;
    participants: string[];
    title: string;
    description: string;
    date: string;
    time: string;
    duration: number;
}

export default function CreateMeeting() {
    const [step, setStep] = useState(0);
    const [data, setData] = useState<MeetingData>({
        type: '',
        participants: [],
        title: '',
        description: '',
        date: '',
        time: '',
        duration: 60
    });

    const next = (patch: Partial<MeetingData>) => {
        setData({ ...data, ...patch });
        setStep(s => s + 1);
    };

    const back = () => setStep(s => Math.max(0, s - 1));

    const steps = [
        <Type key="type" onNext={next} data={data} />,
        <Participants key="participants" onNext={next} onBack={back} data={data} />,
        <Details key="details" onNext={next} onBack={back} data={data} />,
        <Review key="review" data={data} onBack={back} />
    ];

    return (
        <main className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 pb-20">
            {/* Header */}
            <div className="bg-white shadow-sm border-b">
                <div className="max-w-md mx-auto px-6 py-4">
                    <div className="flex items-center justify-between">
                        <button
                            onClick={() => window.history.back()}
                            className="text-gray-600 hover:text-gray-800"
                        >
                            ← חזור
                        </button>
                        <h1 className="text-xl font-bold text-gray-800">צור פגישה חדשה</h1>
                        <div className="w-6"></div>
                    </div>

                    {/* Progress Bar */}
                    <div className="mt-4">
                        <div className="flex justify-between text-sm text-gray-500 mb-2">
                            <span>סוג</span>
                            <span>משתתפים</span>
                            <span>פרטים</span>
                            <span>בדיקה</span>
                        </div>
                        <div className="w-full bg-gray-200 rounded-full h-2">
                            <div
                                className="bg-blue-600 h-2 rounded-full transition-all duration-300"
                                style={{ width: `${((step + 1) / 4) * 100}%` }}
                            ></div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Step Content */}
            <div className="max-w-md mx-auto px-6 py-6">
                {steps[step]}
            </div>
        </main>
    );
}
