'use client';
import { ConvoEngine, MEETING_CREATION_FLOW } from '@/lib/convo/engine';
import { upsertMeeting } from '@/lib/localStore';
import { Meeting, MeetingType } from '@/types/meeting';
import { useEffect, useState } from 'react';
import ConfirmationCard from './ConfirmationCard';
import QuestionCard from './QuestionCard';
import SummaryCard from './SummaryCard';

interface ConversationalFlowProps {
    locale?: string;
    onComplete?: (meeting: Meeting) => void;
}

export default function ConversationalFlow({ locale = 'en', onComplete }: ConversationalFlowProps) {
    const [engine] = useState(() => new ConvoEngine(MEETING_CREATION_FLOW));
    const [data, setData] = useState(engine.getData());
    const [createdMeetingId, setCreatedMeetingId] = useState<string>('');

    const currentStep = engine.getCurrentStep();
    const progress = engine.getProgress();

    const handleOptionSelect = (optionId: string, value: any) => {
        engine.updateData(optionId, value);
        setData(engine.getData());

        if (engine.canGoNext()) {
            engine.goNext();
            setData(engine.getData());
        }
    };

    const handleFieldChange = (fieldId: string, value: any) => {
        engine.updateData(fieldId, value);
        setData(engine.getData());
    };

    const handleNext = () => {
        if (engine.canGoNext()) {
            engine.goNext();
            setData(engine.getData());
        }
    };

    const handleBack = () => {
        if (engine.canGoBack()) {
            engine.goBack();
            setData(engine.getData());
        }
    };

    const handleEdit = () => {
        // Go back to the first step to edit
        engine.reset();
        setData(engine.getData());
    };

    const handleConfirm = () => {
        const meeting: Meeting = {
            id: 'meeting-' + Math.random().toString(36).slice(2, 9),
            title: `${data.meetingType} meeting`,
            type: data.meetingType as MeetingType,
            details: {
                date: data.date,
                time: data.time,
                location: data.location,
                platform: data.location.includes('Zoom') || data.location.includes('Meet') ? data.location : ''
            },
            participants: data.participants?.map((name: string, i: number) => ({
                id: `p${i}`,
                name,
                status: 'pending' as const
            })) || [],
            externalLink: '',
            messages: []
        };

        upsertMeeting(meeting);
        setCreatedMeetingId(meeting.id);

        if (onComplete) {
            onComplete(meeting);
        }

        // Move to confirmation step
        engine.goNext();
        setData(engine.getData());
    };

    // Handle flow completion
    useEffect(() => {
        engine.onComplete = (finalData) => {
            console.log('Flow completed with data:', finalData);
        };
    }, [engine]);

    const renderStep = () => {
        switch (currentStep.type) {
            case 'choice':
            case 'input':
                return (
                    <QuestionCard
                        step={currentStep}
                        onOptionSelect={handleOptionSelect}
                        onFieldChange={handleFieldChange}
                        data={data}
                    />
                );

            case 'summary':
                return (
                    <SummaryCard
                        data={data}
                        onEdit={handleEdit}
                        onConfirm={handleConfirm}
                    />
                );

            case 'confirmation':
                return (
                    <ConfirmationCard
                        meetingId={createdMeetingId}
                        locale={locale}
                    />
                );

            default:
                return null;
        }
    };

    return (
        <div className="min-h-screen bg-gray-50 py-8">
            {/* Progress Bar */}
            <div className="max-w-md mx-auto mb-8 px-4">
                <div className="flex items-center justify-between mb-2">
                    <span className="text-sm text-gray-600">Step {progress.current} of {progress.total}</span>
                    <span className="text-sm text-gray-600">{progress.percentage}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                    <div
                        className="bg-blue-600 h-2 rounded-full transition-all duration-300"
                        style={{ width: `${progress.percentage}%` }}
                    />
                </div>
            </div>

            {/* Current Step */}
            <div className="mb-8">
                {renderStep()}
            </div>

            {/* Navigation */}
            {currentStep.type !== 'confirmation' && (
                <div className="max-w-md mx-auto px-4">
                    <div className="flex gap-3">
                        {engine.canGoBack() && (
                            <button
                                onClick={handleBack}
                                className="flex-1 rounded-xl border border-gray-300 px-4 py-3 text-gray-700 hover:bg-gray-50 transition-colors"
                            >
                                ← Back
                            </button>
                        )}

                        {engine.canGoNext() && currentStep.type !== 'choice' && (
                            <button
                                onClick={handleNext}
                                className="flex-1 rounded-xl bg-blue-600 text-white px-4 py-3 hover:bg-blue-700 transition-colors"
                            >
                                Next →
                            </button>
                        )}
                    </div>
                </div>
            )}
        </div>
    );
}


