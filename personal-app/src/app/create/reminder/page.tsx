'use client';
import Link from 'next/link';
import { useState } from 'react';

interface ReminderData {
    title: string;
    description: string;
    date: string;
    time: string;
    priority: 'low' | 'medium' | 'high';
    category: string;
}

const priorityOptions = [
    { value: 'low', label: 'נמוך', color: 'bg-green-100 text-green-800 border-green-200' },
    { value: 'medium', label: 'בינוני', color: 'bg-yellow-100 text-yellow-800 border-yellow-200' },
    { value: 'high', label: 'גבוה', color: 'bg-red-100 text-red-800 border-red-200' }
];

const categoryOptions = [
    { value: 'personal', label: 'אישי', icon: '👤' },
    { value: 'work', label: 'עבודה', icon: '💼' },
    { value: 'health', label: 'בריאות', icon: '🏥' },
    { value: 'finance', label: 'כספים', icon: '💰' },
    { value: 'shopping', label: 'קניות', icon: '🛒' },
    { value: 'other', label: 'אחר', icon: '📝' }
];

export default function CreateReminder() {
    const [formData, setFormData] = useState<ReminderData>({
        title: '',
        description: '',
        date: '',
        time: '',
        priority: 'medium',
        category: ''
    });

    const [isCreating, setIsCreating] = useState(false);
    const [isSuccess, setIsSuccess] = useState(false);

    const handleInputChange = (field: keyof ReminderData, value: string) => {
        setFormData(prev => ({ ...prev, [field]: value }));
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        if (!formData.title || !formData.date || !formData.time) {
            alert('אנא מלא את כל השדות הנדרשים');
            return;
        }

        setIsCreating(true);

        try {
            // TODO: In production, save to database
            console.log('Creating reminder:', formData);

            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 1000));

            setIsSuccess(true);
        } catch (error) {
            console.error('Error creating reminder:', error);
            alert('שגיאה ביצירת הזיכרון. נסה שוב.');
        } finally {
            setIsCreating(false);
        }
    };

    if (isSuccess) {
        return (
            <main className="min-h-screen bg-gradient-to-br from-green-50 to-emerald-100 flex items-center justify-center">
                <div className="max-w-md mx-auto text-center p-6">
                    <div className="text-6xl mb-4">✅</div>
                    <h1 className="text-2xl font-bold text-gray-800 mb-2">הזיכרון נוצר בהצלחה!</h1>
                    <p className="text-gray-600 mb-6">
                        הזיכרון &quot;{formData.title}&quot; נוסף ליומן שלך
                    </p>

                    <div className="bg-white p-4 rounded-xl border border-green-200 mb-6">
                        <p className="text-sm text-green-700 mb-2">פרטי הזיכרון:</p>
                        <p className="font-semibold text-gray-800">{formData.title}</p>
                        <p className="text-gray-600 text-sm">
                            {new Date(`${formData.date}T${formData.time}`).toLocaleDateString('he-IL', {
                                weekday: 'long',
                                year: 'numeric',
                                month: 'long',
                                day: 'numeric'
                            })} בשעה {formData.time}
                        </p>
                        {formData.description && (
                            <p className="text-gray-600 text-sm mt-1">{formData.description}</p>
                        )}
                    </div>

                    <div className="flex gap-3">
                        <Link
                            href="/"
                            className="flex-1 px-6 py-3 bg-gray-600 text-white rounded-xl hover:bg-gray-700 transition-colors text-center"
                        >
                            חזור לבית
                        </Link>
                        <Link
                            href="/agenda"
                            className="flex-1 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors text-center"
                        >
                            צפה ביומן
                        </Link>
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
                    <div className="flex items-center justify-between">
                        <Link
                            href="/"
                            className="text-gray-600 hover:text-gray-800"
                        >
                            ← חזור
                        </Link>
                        <h1 className="text-xl font-bold text-gray-800">צור זיכרון חדש</h1>
                        <div className="w-6"></div>
                    </div>
                </div>
            </div>

            {/* Form */}
            <div className="max-w-md mx-auto px-6 py-6">
                <form onSubmit={handleSubmit} className="space-y-6">
                    {/* Title */}
                    <div className="bg-white p-4 rounded-xl border border-gray-200">
                        <label className="block text-sm font-medium text-gray-700 mb-2">כותרת הזיכרון *</label>
                        <input
                            type="text"
                            value={formData.title}
                            onChange={(e) => handleInputChange('title', e.target.value)}
                            placeholder="לדוגמה: תשלום חשבונות"
                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            required
                        />
                    </div>

                    {/* Description */}
                    <div className="bg-white p-4 rounded-xl border border-gray-200">
                        <label className="block text-sm font-medium text-gray-700 mb-2">תיאור (אופציונלי)</label>
                        <textarea
                            value={formData.description}
                            onChange={(e) => handleInputChange('description', e.target.value)}
                            placeholder="תיאור נוסף..."
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
                                    required
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">שעה *</label>
                                <input
                                    type="time"
                                    value={formData.time}
                                    onChange={(e) => handleInputChange('time', e.target.value)}
                                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                                    required
                                />
                            </div>
                        </div>
                    </div>

                    {/* Category */}
                    <div className="bg-white p-4 rounded-xl border border-gray-200">
                        <label className="block text-sm font-medium text-gray-700 mb-3">קטגוריה</label>
                        <div className="grid grid-cols-3 gap-2">
                            {categoryOptions.map((category) => (
                                <button
                                    key={category.value}
                                    type="button"
                                    onClick={() => handleInputChange('category', category.value)}
                                    aria-label={`בחר קטגוריה: ${category.label}`}
                                    className={`p-3 rounded-lg border transition-all duration-200 text-center ${formData.category === category.value
                                            ? 'border-blue-500 bg-blue-50 text-blue-700'
                                            : 'border-gray-200 hover:border-gray-300'
                                        }`}
                                >
                                    <div className="text-2xl mb-1">{category.icon}</div>
                                    <div className="text-xs">{category.label}</div>
                                </button>
                            ))}
                        </div>
                    </div>

                    {/* Priority */}
                    <div className="bg-white p-4 rounded-xl border border-gray-200">
                        <label className="block text-sm font-medium text-gray-700 mb-3">עדיפות</label>
                        <div className="grid grid-cols-3 gap-2">
                            {priorityOptions.map((priority) => (
                                <button
                                    key={priority.value}
                                    type="button"
                                    onClick={() => handleInputChange('priority', priority.value)}
                                    aria-label={`בחר עדיפות: ${priority.label}`}
                                    className={`p-3 rounded-lg border transition-all duration-200 ${formData.priority === priority.value
                                            ? 'border-blue-500 bg-blue-50 text-blue-700'
                                            : 'border-gray-200 hover:border-gray-300'
                                        }`}
                                >
                                    {priority.label}
                                </button>
                            ))}
                        </div>
                    </div>

                    {/* Submit Button */}
                    <button
                        type="submit"
                        disabled={isCreating}
                        className="w-full bg-gradient-to-r from-green-500 to-emerald-600 text-white py-4 rounded-xl font-semibold text-lg shadow-lg hover:shadow-xl transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        {isCreating ? 'יוצר זיכרון...' : 'צור זיכרון'}
                    </button>
                </form>
            </div>
        </main>
    );
}
