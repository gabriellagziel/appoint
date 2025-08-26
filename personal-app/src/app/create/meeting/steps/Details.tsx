'use client';
import { useState } from 'react';
import { MeetingData } from '../page';

interface DetailsProps {
    onNext: (data: Partial<MeetingData>) => void;
    onBack: () => void;
    data: MeetingData;
}

const durationOptions = [
    { value: 15, label: '15 דקות' },
    { value: 30, label: '30 דקות' },
    { value: 45, label: '45 דקות' },
    { value: 60, label: 'שעה' },
    { value: 90, label: 'שעה וחצי' },
    { value: 120, label: 'שעתיים' },
];

export default function Details({ onNext, onBack, data }: DetailsProps) {
    const [formData, setFormData] = useState({
        title: data.title,
        description: data.description,
        date: data.date,
        time: data.time,
        duration: data.duration
    });

    const handleInputChange = (field: string, value: string | number) => {
        setFormData(prev => ({ ...prev, [field]: value }));
    };

    const handleNext = () => {
        onNext(formData);
    };

    const isFormValid = formData.title && formData.date && formData.time;

    return (
        <div className="space-y-6">
            <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-800 mb-2">פרטי הפגישה</h2>
                <p className="text-gray-600">מלא את הפרטים הבסיסיים של הפגישה</p>
            </div>

            {/* Title */}
            <div className="bg-white p-4 rounded-xl border border-gray-200">
                <label className="block text-sm font-medium text-gray-700 mb-2">כותרת הפגישה *</label>
                <input
                    type="text"
                    value={formData.title}
                    onChange={(e) => handleInputChange('title', e.target.value)}
                    placeholder="לדוגמה: פגישת עבודה שבועית"
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
            </div>

            {/* Description */}
            <div className="bg-white p-4 rounded-xl border border-gray-200">
                <label className="block text-sm font-medium text-gray-700 mb-2">תיאור (אופציונלי)</label>
                <textarea
                    value={formData.description}
                    onChange={(e) => handleInputChange('description', e.target.value)}
                    placeholder="תיאור קצר של הפגישה..."
                    rows={3}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
                />
            </div>

            {/* Date and Time */}
            <div className="bg-white p-4 rounded-xl border border-gray-200">
                <div className="grid grid-cols-2 gap-4">
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">תאריך *</label>
                        <input
                            type="date"
                            value={formData.date}
                            onChange={(e) => handleInputChange('date', e.target.value)}
                            min={new Date().toISOString().split('T')[0]}
                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">שעה *</label>
                        <input
                            type="time"
                            value={formData.time}
                            onChange={(e) => handleInputChange('time', e.target.value)}
                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                    </div>
                </div>
            </div>

            {/* Duration */}
            <div className="bg-white p-4 rounded-xl border border-gray-200">
                <label className="block text-sm font-medium text-gray-700 mb-2">משך הפגישה</label>
                <div className="grid grid-cols-3 gap-2">
                    {durationOptions.map((option) => (
                        <button
                            key={option.value}
                            onClick={() => handleInputChange('duration', option.value)}
                            aria-label={`בחר משך של ${option.label}`}
                            className={`p-3 rounded-lg border transition-all duration-200 ${formData.duration === option.value
                                    ? 'border-blue-500 bg-blue-50 text-blue-700'
                                    : 'border-gray-200 hover:border-gray-300'
                                }`}
                        >
                            {option.label}
                        </button>
                    ))}
                </div>
            </div>

            {/* Preview */}
            {isFormValid && (
                <div className="bg-blue-50 p-4 rounded-xl border border-blue-200">
                    <h3 className="font-semibold text-blue-800 mb-2">תצוגה מקדימה:</h3>
                    <div className="text-blue-700">
                        <p><strong>{formData.title}</strong></p>
                        <p className="text-sm">
                            {new Date(`${formData.date}T${formData.time}`).toLocaleDateString('he-IL', {
                                weekday: 'long',
                                year: 'numeric',
                                month: 'long',
                                day: 'numeric'
                            })} בשעה {formData.time}
                        </p>
                        <p className="text-sm">משך: {durationOptions.find(d => d.value === formData.duration)?.label}</p>
                        {formData.description && (
                            <p className="text-sm mt-1">{formData.description}</p>
                        )}
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
                    disabled={!isFormValid}
                    className="flex-1 bg-gradient-to-r from-blue-500 to-indigo-600 text-white py-3 rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                    המשך לבדיקה →
                </button>
            </div>
        </div>
    );
}
