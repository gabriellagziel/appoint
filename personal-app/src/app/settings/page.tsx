'use client';
import Link from 'next/link';
import { useState } from 'react';

interface SettingSection {
    id: string;
    title: string;
    icon: string;
    items: SettingItem[];
}

interface SettingItem {
    id: string;
    label: string;
    description?: string;
    type: 'toggle' | 'link' | 'button' | 'select';
    value?: boolean | string;
    options?: { value: string; label: string }[];
    action?: () => void;
}

const settingSections: SettingSection[] = [
    {
        id: 'account',
        title: 'חשבון',
        icon: '👤',
        items: [
            {
                id: 'profile',
                label: 'ערוך פרופיל',
                description: 'שנה פרטי אישי, תמונה ופרטי קשר',
                type: 'link'
            },
            {
                id: 'notifications',
                label: 'התראות',
                description: 'הגדר התראות לפגישות וזיכרונות',
                type: 'toggle',
                value: true
            },
            {
                id: 'privacy',
                label: 'פרטיות',
                description: 'הגדר הרשאות ופרטיות',
                type: 'link'
            }
        ]
    },
    {
        id: 'appearance',
        title: 'מראה',
        icon: '🎨',
        items: [
            {
                id: 'theme',
                label: 'ערכת נושא',
                description: 'בחר בין בהיר, כהה או אוטומטי',
                type: 'select',
                value: 'auto',
                options: [
                    { value: 'light', label: 'בהיר' },
                    { value: 'dark', label: 'כהה' },
                    { value: 'auto', label: 'אוטומטי' }
                ]
            },
            {
                id: 'language',
                label: 'שפה',
                description: 'עברית או אנגלית',
                type: 'select',
                value: 'he',
                options: [
                    { value: 'he', label: 'עברית' },
                    { value: 'en', label: 'English' }
                ]
            },
            {
                id: 'fontSize',
                label: 'גודל טקסט',
                description: 'הגדל או הקטן את הטקסט',
                type: 'select',
                value: 'medium',
                options: [
                    { value: 'small', label: 'קטן' },
                    { value: 'medium', label: 'בינוני' },
                    { value: 'large', label: 'גדול' }
                ]
            }
        ]
    },
    {
        id: 'notifications',
        title: 'התראות',
        icon: '🔔',
        items: [
            {
                id: 'meetingReminders',
                label: 'תזכורות פגישות',
                description: 'קבל תזכורות לפני פגישות',
                type: 'toggle',
                value: true
            },
            {
                id: 'reminderNotifications',
                label: 'התראות זיכרונות',
                description: 'קבל התראות לזיכרונות',
                type: 'toggle',
                value: true
            },
            {
                id: 'sound',
                label: 'צלילים',
                description: 'הפעל צלילים להתראות',
                type: 'toggle',
                value: false
            },
            {
                id: 'vibration',
                label: 'רטט',
                description: 'הפעל רטט להתראות',
                type: 'toggle',
                value: true
            }
        ]
    },
    {
        id: 'data',
        title: 'נתונים',
        icon: '💾',
        items: [
            {
                id: 'backup',
                label: 'גיבוי אוטומטי',
                description: 'גבה נתונים אוטומטית לענן',
                type: 'toggle',
                value: true
            },
            {
                id: 'export',
                label: 'ייצא נתונים',
                description: 'ייצא את כל הנתונים שלך',
                type: 'button'
            },
            {
                id: 'clear',
                label: 'נקה נתונים',
                description: 'מחק את כל הנתונים (לא הפיך)',
                type: 'button'
            }
        ]
    },
    {
        id: 'support',
        title: 'תמיכה',
        icon: '🆘',
        items: [
            {
                id: 'help',
                label: 'עזרה ותמיכה',
                description: 'גש למרכז העזרה',
                type: 'link'
            },
            {
                id: 'feedback',
                label: 'שלח משוב',
                description: 'שלח לנו משוב על האפליקציה',
                type: 'link'
            },
            {
                id: 'about',
                label: 'אודות',
                description: 'מידע על האפליקציה וגרסה',
                type: 'link'
            }
        ]
    }
];

export default function Settings() {
    const [settings, setSettings] = useState<{ [key: string]: boolean | string }>({
        notifications: true,
        theme: 'auto',
        language: 'he',
        fontSize: 'medium',
        meetingReminders: true,
        reminderNotifications: true,
        sound: false,
        vibration: true,
        backup: true
    });

    const handleToggle = (itemId: string) => {
        setSettings(prev => ({
            ...prev,
            [itemId]: !prev[itemId]
        }));
    };

    const handleSelect = (itemId: string, value: string) => {
        setSettings(prev => ({
            ...prev,
            [itemId]: value
        }));
    };

    const handleAction = (itemId: string) => {
        switch (itemId) {
            case 'export':
                alert('מייצא נתונים... (בהמשך יהיה API אמיתי)');
                break;
            case 'clear':
                if (confirm('האם אתה בטוח שברצונך למחוק את כל הנתונים? פעולה זו לא הפיכה!')) {
                    alert('נתונים נמחקו (בהמשך יהיה API אמיתי)');
                }
                break;
            default:
                console.log(`Action for ${itemId}`);
        }
    };

    const renderSettingItem = (item: SettingItem) => {
        switch (item.type) {
            case 'toggle':
                return (
                    <div className="flex items-center justify-between">
                        <div className="flex-1">
                            <div className="font-medium text-gray-800">{item.label}</div>
                            {item.description && (
                                <div className="text-sm text-gray-500 mt-1">{item.description}</div>
                            )}
                        </div>
                        <button
                            onClick={() => handleToggle(item.id)}
                            aria-label={`${settings[item.id] ? 'כבה' : 'הפעל'} ${item.label}`}
                            className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${settings[item.id] ? 'bg-blue-600' : 'bg-gray-200'
                                }`}
                        >
                            <span
                                className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${settings[item.id] ? 'translate-x-6' : 'translate-x-1'
                                    }`}
                            />
                        </button>
                    </div>
                );

            case 'select':
                return (
                    <div className="flex items-center justify-between">
                        <div className="flex-1">
                            <div className="font-medium text-gray-800">{item.label}</div>
                            {item.description && (
                                <div className="text-sm text-gray-500 mt-1">{item.description}</div>
                            )}
                        </div>
                        <select
                            value={String(settings[item.id] || item.value)}
                            onChange={(e) => handleSelect(item.id, e.target.value)}
                            aria-label={`בחר ${item.label}`}
                            className="px-3 py-1 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                        >
                            {item.options?.map((option) => (
                                <option key={option.value} value={option.value}>
                                    {option.label}
                                </option>
                            ))}
                        </select>
                    </div>
                );

            case 'button':
                return (
                    <div className="flex items-center justify-between">
                        <div className="flex-1">
                            <div className="font-medium text-gray-800">{item.label}</div>
                            {item.description && (
                                <div className="text-sm text-gray-500 mt-1">{item.description}</div>
                            )}
                        </div>
                        <button
                            onClick={() => handleAction(item.id)}
                            className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors text-sm"
                        >
                            פעל
                        </button>
                    </div>
                );

            case 'link':
            default:
                return (
                    <Link href={`/settings/${item.id}`} className="flex items-center justify-between">
                        <div className="flex-1">
                            <div className="font-medium text-gray-800">{item.label}</div>
                            {item.description && (
                                <div className="text-sm text-gray-500 mt-1">{item.description}</div>
                            )}
                        </div>
                        <span className="text-gray-400">→</span>
                    </Link>
                );
        }
    };

    return (
        <main className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 pb-20">
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
                        <h1 className="text-xl font-bold text-gray-800">הגדרות</h1>
                        <div className="w-6"></div>
                    </div>
                </div>
            </div>

            {/* Settings Sections */}
            <div className="max-w-md mx-auto px-6 py-4">
                {settingSections.map((section) => (
                    <div key={section.id} className="mb-6">
                        <div className="flex items-center gap-3 mb-4">
                            <span className="text-2xl">{section.icon}</span>
                            <h2 className="text-lg font-semibold text-gray-800">{section.title}</h2>
                        </div>

                        <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                            {section.items.map((item, index) => (
                                <div
                                    key={item.id}
                                    className={`p-4 ${index !== section.items.length - 1 ? 'border-b border-gray-100' : ''
                                        }`}
                                >
                                    {renderSettingItem(item)}
                                </div>
                            ))}
                        </div>
                    </div>
                ))}

                {/* App Info */}
                <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm text-center">
                    <div className="text-4xl mb-2">📱</div>
                    <h3 className="font-semibold text-gray-800 mb-1">App-Oint Personal</h3>
                    <p className="text-sm text-gray-500">גרסה 1.0.0</p>
                    <p className="text-xs text-gray-400 mt-2">© 2025 App-Oint. כל הזכויות שמורות.</p>
                </div>
            </div>
        </main>
    );
}
