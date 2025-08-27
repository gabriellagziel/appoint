'use client';
import { ConvoStep } from '@/lib/convo/engine';

interface QuestionCardProps {
    step: ConvoStep;
    onOptionSelect?: (optionId: string, value: any) => void;
    onFieldChange?: (fieldId: string, value: any) => void;
    data?: any;
}

export default function QuestionCard({ step, onOptionSelect, onFieldChange, data = {} }: QuestionCardProps) {
    return (
        <div className="bg-white rounded-2xl border shadow-sm p-6 max-w-md mx-auto">
            <div className="text-center mb-6">
                <h2 className="text-xl font-semibold text-gray-900 mb-2">{step.title}</h2>
                {step.description && (
                    <p className="text-gray-600 text-sm">{step.description}</p>
                )}
            </div>

            {step.type === 'choice' && step.options && (
                <div className="space-y-3">
                    {step.options.map((option) => (
                        <button
                            key={option.id}
                            onClick={() => onOptionSelect?.(option.id, option.value)}
                            className="w-full text-left p-4 rounded-xl border hover:border-blue-300 hover:shadow-md transition-all duration-200 bg-gray-50 hover:bg-blue-50"
                        >
                            <div className="flex items-center space-x-3">
                                <span className="text-2xl">{option.icon}</span>
                                <div className="flex-1">
                                    <div className="font-medium text-gray-900">{option.label}</div>
                                    {option.description && (
                                        <div className="text-sm text-gray-600 mt-1">{option.description}</div>
                                    )}
                                </div>
                            </div>
                        </button>
                    ))}
                </div>
            )}

            {step.type === 'input' && step.fields && (
                <div className="space-y-4">
                    {step.fields.map((field) => (
                        <div key={field.id}>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                {field.label}
                                {field.required && <span className="text-red-500 ml-1">*</span>}
                            </label>

                            {field.type === 'text' && (
                                <input
                                    type="text"
                                    placeholder={field.placeholder}
                                    value={data[field.id] || ''}
                                    onChange={(e) => onFieldChange?.(field.id, e.target.value)}
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                />
                            )}

                            {field.type === 'textarea' && (
                                <textarea
                                    placeholder={field.placeholder}
                                    value={data[field.id] || ''}
                                    onChange={(e) => onFieldChange?.(field.id, e.target.value)}
                                    rows={3}
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors resize-none"
                                />
                            )}

                            {field.type === 'date' && (
                                <input
                                    type="date"
                                    value={data[field.id] || ''}
                                    onChange={(e) => onFieldChange?.(field.id, e.target.value)}
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                    aria-label={field.label}
                                />
                            )}

                            {field.type === 'time' && (
                                <input
                                    type="time"
                                    value={data[field.id] || ''}
                                    onChange={(e) => onFieldChange?.(field.id, e.target.value)}
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                    aria-label={field.label}
                                />
                            )}

                            {field.type === 'select' && field.options && (
                                <select
                                    value={data[field.id] || ''}
                                    onChange={(e) => onFieldChange?.(field.id, e.target.value)}
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                    aria-label={field.label}
                                >
                                    <option value="">Select an option...</option>
                                    {field.options.map((option) => (
                                        <option key={option.id} value={option.value}>
                                            {option.label}
                                        </option>
                                    ))}
                                </select>
                            )}
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
}
