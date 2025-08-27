'use client';

import { useState } from 'react';
import { FileText, CheckSquare, Square, Plus, Trash2 } from 'lucide-react';

interface ChecklistItem {
  id: string;
  text: string;
  completed: boolean;
}

interface NotesChecklistProps {
  notes: string;
  checklist: ChecklistItem[];
  onNotesChange: (notes: string) => void;
  onChecklistChange: (checklist: ChecklistItem[]) => void;
  className?: string;
}

export default function NotesChecklist({ 
  notes, 
  checklist, 
  onNotesChange, 
  onChecklistChange, 
  className = '' 
}: NotesChecklistProps) {
  const [newItemText, setNewItemText] = useState('');

  const addChecklistItem = () => {
    if (newItemText.trim()) {
      const newItem: ChecklistItem = {
        id: Date.now().toString(),
        text: newItemText.trim(),
        completed: false
      };
      onChecklistChange([...checklist, newItem]);
      setNewItemText('');
    }
  };

  const toggleItem = (id: string) => {
    onChecklistChange(
      checklist.map(item =>
        item.id === id ? { ...item, completed: !item.completed } : item
      )
    );
  };

  const removeItem = (id: string) => {
    onChecklistChange(checklist.filter(item => item.id !== id));
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      addChecklistItem();
    }
  };

  return (
    <div className={`space-y-4 ${className}`}>
      {/* Notes Section */}
      <div className="space-y-2">
        <label className="block text-sm font-medium text-gray-700">
          <FileText className="w-4 h-4 inline mr-2" />
          Meeting Notes
        </label>
        <textarea
          value={notes}
          onChange={(e) => onNotesChange(e.target.value)}
          placeholder="Add any notes, agenda items, or important details..."
          rows={4}
          className="w-full p-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none resize-none"
        />
      </div>

      {/* Checklist Section */}
      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <label className="block text-sm font-medium text-gray-700">
            <CheckSquare className="w-4 h-4 inline mr-2" />
            Checklist
          </label>
          <span className="text-sm text-gray-500">
            {checklist.filter(item => item.completed).length} of {checklist.length} completed
          </span>
        </div>

        {/* Add New Item */}
        <div className="flex gap-2">
          <input
            type="text"
            value={newItemText}
            onChange={(e) => setNewItemText(e.target.value)}
            onKeyPress={handleKeyPress}
            placeholder="Add a checklist item..."
            className="flex-1 p-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none"
          />
          <button
            onClick={addChecklistItem}
            disabled={!newItemText.trim()}
            className="p-3 bg-blue-500 text-white rounded-xl hover:bg-blue-600 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
            aria-label="Add checklist item"
          >
            <Plus className="w-4 h-4" />
          </button>
        </div>

        {/* Checklist Items */}
        {checklist.length > 0 && (
          <div className="space-y-2">
            {checklist.map((item) => (
              <div
                key={item.id}
                className="flex items-center gap-3 p-3 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <button
                  onClick={() => toggleItem(item.id)}
                  className="flex-shrink-0"
                  aria-label={item.completed ? 'Mark as incomplete' : 'Mark as complete'}
                >
                  {item.completed ? (
                    <CheckSquare className="w-5 h-5 text-green-600" />
                  ) : (
                    <Square className="w-5 h-5 text-gray-400 hover:text-gray-600" />
                  )}
                </button>
                
                <span
                  className={`flex-1 ${
                    item.completed ? 'line-through text-gray-500' : 'text-gray-900'
                  }`}
                >
                  {item.text}
                </span>
                
                <button
                  onClick={() => removeItem(item.id)}
                  className="flex-shrink-0 p-1 text-gray-400 hover:text-red-500 transition-colors"
                  aria-label={`Remove ${item.text}`}
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            ))}
          </div>
        )}

        {/* Progress Bar */}
        {checklist.length > 0 && (
          <div className="space-y-2">
            <div className="flex justify-between text-sm text-gray-600">
              <span>Progress</span>
              <span>{Math.round((checklist.filter(item => item.completed).length / checklist.length) * 100)}%</span>
            </div>
            <div className="w-full bg-gray-200 rounded-full h-2">
              <div
                className="bg-green-500 h-2 rounded-full transition-all duration-300"
                style={{
                  width: `${(checklist.filter(item => item.completed).length / checklist.length) * 100}%`
                }}
              />
            </div>
          </div>
        )}
      </div>

      {/* Quick Templates */}
      <div className="space-y-2">
        <h4 className="text-sm font-medium text-gray-700">Quick templates:</h4>
        <div className="grid grid-cols-2 gap-2">
          {[
            { name: 'Coffee Chat', items: ['Agenda', 'Follow-up items', 'Next steps'] },
            { name: 'Project Review', items: ['Status update', 'Blockers', 'Timeline', 'Resources needed'] },
            { name: 'Team Meeting', items: ['Updates', 'Action items', 'Questions', 'Next meeting'] },
            { name: 'Client Call', items: ['Requirements', 'Questions', 'Next steps', 'Timeline'] }
          ].map((template) => (
            <button
              key={template.name}
              onClick={() => {
                const newItems = template.items.map((text, index) => ({
                  id: Date.now().toString() + index,
                  text,
                  completed: false
                }));
                onChecklistChange([...checklist, ...newItems]);
              }}
              className="p-3 border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-colors text-left"
            >
              <div className="font-medium text-sm">{template.name}</div>
              <div className="text-xs text-gray-500 mt-1">
                {template.items.length} items
              </div>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

