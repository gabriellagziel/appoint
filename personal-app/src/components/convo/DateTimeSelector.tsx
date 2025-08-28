'use client';

import { useState } from 'react';
import { Calendar, Clock, Zap, Check } from 'lucide-react';

interface DateTime {
  date: string;
  time: string;
  suggested?: boolean;
}

interface DateTimeSelectorProps {
  dateTime: DateTime | null;
  onDateTimeChange: (dateTime: DateTime) => void;
  className?: string;
}

export default function DateTimeSelector({
  dateTime,
  onDateTimeChange,
  className = ''
}: DateTimeSelectorProps) {
  const [showSuggestions, setShowSuggestions] = useState(false);

  // Mock smart suggestions - in real app this would come from availability API
  const smartSuggestions: DateTime[] = [
    { date: '2025-01-27', time: '09:00', suggested: true },
    { date: '2025-01-27', time: '14:00', suggested: true },
    { date: '2025-01-28', time: '10:00', suggested: true },
    { date: '2025-01-28', time: '15:00', suggested: true },
    { date: '2025-01-29', time: '11:00', suggested: true },
  ];

  const quickTimes = [
    { label: 'Morning', time: '09:00', icon: '🌅' },
    { label: 'Lunch', time: '12:00', icon: '🍽️' },
    { label: 'Afternoon', time: '15:00', icon: '☀️' },
    { label: 'Evening', time: '18:00', icon: '🌆' },
  ];

  const handleDateChange = (date: string) => {
    onDateTimeChange({
      date,
      time: dateTime?.time || '09:00'
    });
  };

  const handleTimeChange = (time: string) => {
    onDateTimeChange({
      date: dateTime?.date || new Date().toISOString().split('T')[0],
      time
    });
  };

  const selectSuggestion = (suggestion: DateTime) => {
    onDateTimeChange(suggestion);
    setShowSuggestions(false);
  };

  const selectQuickTime = (time: string) => {
    const today = new Date().toISOString().split('T')[0];
    onDateTimeChange({
      date: today,
      time
    });
  };

  const getNextWeekDates = () => {
    const dates = [];
    const today = new Date();
    for (let i = 1; i <= 7; i++) {
      const date = new Date(today);
      date.setDate(today.getDate() + i);
      dates.push(date.toISOString().split('T')[0]);
    }
    return dates;
  };

  return (
    <div className={`space-y-4 ${className}`}>
      {/* Smart Suggestions */}
      <div className="space-y-3">
        <button
          onClick={() => setShowSuggestions(!showSuggestions)}
          className="w-full p-3 border-2 border-blue-200 bg-blue-50 rounded-xl hover:bg-blue-100 transition-colors"
        >
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Zap className="w-5 h-5 text-blue-600" />
              <span className="font-medium text-blue-800">Smart Suggestions</span>
            </div>
            <span className="text-blue-600 text-sm">
              {showSuggestions ? 'Hide' : 'Show'} available times
            </span>
          </div>
        </button>

        {showSuggestions && (
          <div className="space-y-2">
            <h4 className="font-medium text-gray-700">Available times this week:</h4>
            {smartSuggestions.map((suggestion, index) => (
              <button
                key={index}
                onClick={() => selectSuggestion(suggestion)}
                className="w-full p-3 border border-gray-200 rounded-lg hover:bg-green-50 hover:border-green-300 transition-colors text-left"
              >
                <div className="flex items-center justify-between">
                  <div>
                    <div className="font-medium">
                      {new Date(suggestion.date).toLocaleDateString('en-US', {
                        weekday: 'long',
                        month: 'short',
                        day: 'numeric'
                      })}
                    </div>
                    <div className="text-sm text-gray-600">{suggestion.time}</div>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="text-green-600 text-sm">Available</span>
                    <Check className="w-4 h-4 text-green-600" />
                  </div>
                </div>
              </button>
            ))}
          </div>
        )}
      </div>

      {/* Quick Time Selection */}
      <div className="space-y-3">
        <h4 className="font-medium text-gray-700">Quick times today:</h4>
        <div className="grid grid-cols-2 gap-2">
          {quickTimes.map((quickTime) => (
            <button
              key={quickTime.time}
              onClick={() => selectQuickTime(quickTime.time)}
              className="p-3 border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-colors text-center"
            >
              <div className="text-2xl mb-1">{quickTime.icon}</div>
              <div className="font-medium text-sm">{quickTime.label}</div>
              <div className="text-xs text-gray-600">{quickTime.time}</div>
            </button>
          ))}
        </div>
      </div>

      {/* Manual Date/Time Selection */}
      <div className="space-y-3">
        <h4 className="font-medium text-gray-700">Or pick custom date & time:</h4>

        {/* Date Selection */}
        <div className="space-y-2">
          <label className="block text-sm font-medium text-gray-700">
            <Calendar className="w-4 h-4 inline mr-2" />
            Date
          </label>
          <div className="grid grid-cols-7 gap-1">
            {getNextWeekDates().map((date) => (
              <button
                key={date}
                onClick={() => handleDateChange(date)}
                className={`p-2 text-xs rounded-lg transition-colors ${dateTime?.date === date
                    ? 'bg-blue-500 text-white'
                    : 'border border-gray-200 hover:bg-gray-50'
                  }`}
                title={`Select ${new Date(date).toLocaleDateString('en-US', {
                  weekday: 'long',
                  month: 'long',
                  day: 'numeric'
                })}`}
              >
                {new Date(date).getDate()}
              </button>
            ))}
          </div>
          <input
            type="date"
            value={dateTime?.date || ''}
            onChange={(e) => handleDateChange(e.target.value)}
            min={new Date().toISOString().split('T')[0]}
            className="w-full p-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none"
          />
        </div>

        {/* Time Selection */}
        <div className="space-y-2">
          <label className="block text-sm font-medium text-gray-700">
            <Clock className="w-4 h-4 inline mr-2" />
            Time
          </label>
          <input
            type="time"
            value={dateTime?.time || ''}
            onChange={(e) => handleTimeChange(e.target.value)}
            className="w-full p-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none"
          />
        </div>
      </div>

      {/* Selected DateTime Display */}
      {dateTime && (
        <div className="p-4 bg-green-50 border border-green-200 rounded-xl">
          <div className="flex items-center justify-between">
            <div>
              <div className="font-medium text-green-800">
                <Calendar className="w-4 h-4 inline mr-2" />
                {new Date(dateTime.date).toLocaleDateString('en-US', {
                  weekday: 'long',
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
                })}
              </div>
              <div className="text-sm text-green-600 mt-1">
                <Clock className="w-4 h-4 inline mr-2" />
                {dateTime.time}
              </div>
            </div>
            {dateTime.suggested && (
              <div className="flex items-center gap-2 text-green-600">
                <Zap className="w-4 h-4" />
                <span className="text-sm">Smart pick</span>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
