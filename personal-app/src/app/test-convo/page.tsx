'use client';
import { useState } from 'react';

export default function TestConvoPage() {
    const [messages, setMessages] = useState([
        { from: 'system', text: 'Hi Gabriel 👋 What would you like to do today?' }
    ]);
    const [currentStep, setCurrentStep] = useState('intent');

    const quickActions = [
        { id: 'meeting', label: '➕ New Meeting' },
        { id: 'reminder', label: '⏰ Reminder' },
        { id: 'playtime', label: '🎮 Playtime' },
        { id: 'groups', label: '👥 Groups' },
        { id: 'family', label: '👨‍👩‍👧 Family' },
    ];

    const handleAction = (action: string) => {
        setMessages(prev => [...prev, { from: 'user', text: action }]);

        if (action === 'New Meeting') {
            setMessages(prev => [...prev, { from: 'system', text: 'What kind of meeting is it?' }]);
            setCurrentStep('meeting-type');
        } else {
            setMessages(prev => [...prev, { from: 'system', text: `${action} flow is coming soon! Want to create a meeting instead?` }]);
            setCurrentStep('fallback');
        }
    };

    const handleMeetingType = (type: string) => {
        setMessages(prev => [...prev, { from: 'user', text: type }, { from: 'system', text: 'When would you like to meet?' }]);
        setCurrentStep('meeting-time');
    };

    const handleDateTime = (datetime: string) => {
        setMessages(prev => [...prev,
        { from: 'user', text: datetime },
        { from: 'system', text: '✅ Meeting created successfully! (Demo mode)' }
        ]);
        setCurrentStep('complete');
    };

    return (
        <main className="mx-auto max-w-xl p-4 space-y-6">
            <div className="text-center py-4">
                <h1 className="text-2xl font-bold">PR-1 Conversational Demo</h1>
                <p className="text-gray-600">Test the conversational interface</p>
            </div>

            {/* Conversation History */}
            <div className="space-y-3">
                {messages.map((msg, i) => (
                    <div key={i} className={msg.from === 'user' ? 'text-right' : 'text-left'}>
                        <div className={`inline-block px-4 py-2 rounded-2xl max-w-xs ${msg.from === 'user' ? 'bg-blue-500 text-white' : 'bg-gray-100'
                            }`}>
                            {msg.text}
                        </div>
                    </div>
                ))}
            </div>

            {/* Interactive Elements */}
            <div className="space-y-4">
                {currentStep === 'intent' && (
                    <div>
                        <p className="font-medium mb-3">Quick Actions:</p>
                        <div className="grid grid-cols-2 gap-2">
                            {quickActions.map(action => (
                                <button
                                    key={action.id}
                                    onClick={() => handleAction(action.label)}
                                    className="px-4 py-2 bg-white border rounded-xl hover:shadow-md transition-shadow text-left"
                                >
                                    {action.label}
                                </button>
                            ))}
                        </div>
                    </div>
                )}

                {currentStep === 'meeting-type' && (
                    <div>
                        <p className="font-medium mb-3">Meeting type:</p>
                        <div className="space-y-2">
                            {['In-person', 'Video call', 'Phone call'].map(type => (
                                <button
                                    key={type}
                                    onClick={() => handleMeetingType(type)}
                                    className="block w-full px-4 py-2 bg-white border rounded-xl hover:shadow-md transition-shadow text-left"
                                >
                                    {type}
                                </button>
                            ))}
                        </div>
                    </div>
                )}

                {currentStep === 'meeting-time' && (
                    <div>
                        <p className="font-medium mb-3">Pick a time:</p>
                        <div className="space-y-2">
                            {['Today 2:00 PM', 'Tomorrow 10:00 AM', 'Friday 3:00 PM'].map(time => (
                                <button
                                    key={time}
                                    onClick={() => handleDateTime(time)}
                                    className="block w-full px-4 py-2 bg-white border rounded-xl hover:shadow-md transition-shadow text-left"
                                >
                                    {time}
                                </button>
                            ))}
                        </div>
                    </div>
                )}

                {currentStep === 'fallback' && (
                    <div>
                        <button
                            onClick={() => handleAction('New Meeting')}
                            className="px-4 py-2 bg-blue-500 text-white rounded-xl hover:bg-blue-600"
                        >
                            Create a meeting instead
                        </button>
                    </div>
                )}

                {currentStep === 'complete' && (
                    <div className="text-center">
                        <button
                            onClick={() => {
                                setMessages([{ from: 'system', text: 'Hi Gabriel 👋 What would you like to do today?' }]);
                                setCurrentStep('intent');
                            }}
                            className="px-4 py-2 bg-green-500 text-white rounded-xl hover:bg-green-600"
                        >
                            Start Over
                        </button>
                    </div>
                )}
            </div>
        </main>
    );
}
