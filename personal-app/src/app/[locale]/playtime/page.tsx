'use client';

import { useState } from 'react';
import { Plus, Gamepad2, MapPin, Globe, Users, Calendar, Clock, Trophy, Star } from 'lucide-react';

interface PlaytimeSession {
  id: string;
  title: string;
  description?: string;
  type: 'physical' | 'virtual';
  date: string;
  time: string;
  duration: number; // in minutes
  location: string;
  maxPlayers: number;
  currentPlayers: number;
  gameType: string;
  difficulty: 'beginner' | 'intermediate' | 'advanced';
  status: 'upcoming' | 'active' | 'completed';
  participants: Array<{ id: string; name: string; status: 'joined' | 'pending' }>;
}

export default function PlaytimePage() {
  const [playtimeSessions, setPlaytimeSessions] = useState<PlaytimeSession[]>([
    {
      id: '1',
      title: 'Basketball at Central Park',
      description: 'Weekly pickup basketball game',
      type: 'physical',
      date: '2025-01-27',
      time: '16:00',
      duration: 120,
      location: 'Central Park Basketball Court',
      maxPlayers: 10,
      currentPlayers: 6,
      gameType: 'Basketball',
      difficulty: 'intermediate',
      status: 'upcoming',
      participants: [
        { id: '1', name: 'Gabriel', status: 'joined' },
        { id: '2', name: 'Dana', status: 'joined' },
        { id: '3', name: 'Ron', status: 'joined' }
      ]
    },
    {
      id: '2',
      title: 'Online Chess Tournament',
      description: 'Monthly chess tournament for all levels',
      type: 'virtual',
      date: '2025-01-28',
      time: '19:00',
      duration: 180,
      location: 'Chess.com',
      maxPlayers: 16,
      currentPlayers: 12,
      gameType: 'Chess',
      difficulty: 'beginner',
      status: 'upcoming',
      participants: [
        { id: '1', name: 'Gabriel', status: 'joined' },
        { id: '4', name: 'Sarah', status: 'joined' }
      ]
    }
  ]);

  const [showCreateForm, setShowCreateForm] = useState(false);
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    type: 'physical' as 'physical' | 'virtual',
    date: '',
    time: '',
    duration: 60,
    location: '',
    maxPlayers: 4,
    gameType: '',
    difficulty: 'beginner' as 'beginner' | 'intermediate' | 'advanced'
  });

  const createPlaytimeSession = () => {
    if (!formData.title || !formData.date || !formData.time || !formData.location) return;

    const newSession: PlaytimeSession = {
      id: Date.now().toString(),
      ...formData,
      currentPlayers: 1,
      status: 'upcoming',
      participants: [{ id: '1', name: 'Gabriel', status: 'joined' }]
    };

    setPlaytimeSessions([...playtimeSessions, newSession]);
    setFormData({
      title: '',
      description: '',
      type: 'physical',
      date: '',
      time: '',
      duration: 60,
      location: '',
      maxPlayers: 4,
      gameType: '',
      difficulty: 'beginner'
    });
    setShowCreateForm(false);
  };

  const joinSession = (sessionId: string) => {
    setPlaytimeSessions(playtimeSessions.map(s => 
      s.id === sessionId 
        ? { ...s, currentPlayers: s.currentPlayers + 1 }
        : s
    ));
  };

  const leaveSession = (sessionId: string) => {
    setPlaytimeSessions(playtimeSessions.map(s => 
      s.id === sessionId 
        ? { ...s, currentPlayers: Math.max(0, s.currentPlayers - 1) }
        : s
    ));
  };

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty) {
      case 'beginner': return 'bg-green-100 text-green-800 border-green-200';
      case 'intermediate': return 'bg-yellow-100 text-yellow-800 border-yellow-200';
      case 'advanced': return 'bg-red-100 text-red-800 border-red-200';
      default: return 'bg-gray-100 text-gray-800 border-gray-200';
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'upcoming': return 'bg-blue-100 border-blue-200';
      case 'active': return 'bg-green-100 border-green-200';
      case 'completed': return 'bg-gray-100 border-gray-200';
      default: return 'bg-gray-100 border-gray-200';
    }
  };

  const getGameTypeIcon = (gameType: string) => {
    const gameIcons: Record<string, string> = {
      'Basketball': '🏀',
      'Chess': '♟️',
      'Soccer': '⚽',
      'Tennis': '🎾',
      'Video Games': '🎮',
      'Board Games': '🎲',
      'Card Games': '🃏',
      'Puzzle': '🧩'
    };
    return gameIcons[gameType] || '🎯';
  };

  return (
    <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Playtime</h1>
        <button
          onClick={() => setShowCreateForm(true)}
          className="flex items-center gap-2 px-4 py-2 bg-blue-500 text-white rounded-xl hover:bg-blue-600 transition-colors"
        >
          <Plus className="w-4 h-4" />
          Create Session
        </button>
      </div>

      {/* Create Session Form */}
      {showCreateForm && (
        <div className="p-4 border-2 border-gray-200 rounded-xl bg-gray-50">
          <h3 className="font-semibold mb-3">Create Playtime Session</h3>
          
          <div className="space-y-3">
            <input
              type="text"
              placeholder="Session title"
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
            />
            
            <textarea
              placeholder="Description (optional)"
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              rows={2}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none resize-none"
            />
            
            <div className="grid grid-cols-2 gap-3">
              <button
                onClick={() => setFormData({ ...formData, type: 'physical' })}
                className={`p-3 border-2 rounded-lg transition-colors ${
                  formData.type === 'physical'
                    ? 'border-blue-500 bg-blue-50 text-blue-700'
                    : 'border-gray-200 hover:border-gray-300'
                }`}
              >
                <MapPin className="w-6 h-6 mx-auto mb-2" />
                <div className="text-sm font-medium">Physical</div>
              </button>
              <button
                onClick={() => setFormData({ ...formData, type: 'virtual' })}
                className={`p-3 border-2 rounded-lg transition-colors ${
                  formData.type === 'virtual'
                    ? 'border-blue-500 bg-blue-50 text-blue-700'
                    : 'border-gray-200 hover:border-gray-300'
                }`}
              >
                <Globe className="w-6 h-6 mx-auto mb-2" />
                <div className="text-sm font-medium">Virtual</div>
              </button>
            </div>
            
            <div className="grid grid-cols-2 gap-3">
              <input
                type="date"
                value={formData.date}
                onChange={(e) => setFormData({ ...formData, date: e.target.value })}
                className="p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
              />
              <input
                type="time"
                value={formData.time}
                onChange={(e) => setFormData({ ...formData, time: e.target.value })}
                className="p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
              />
            </div>
            
            <div className="grid grid-cols-2 gap-3">
              <input
                type="number"
                placeholder="Duration (minutes)"
                value={formData.duration}
                onChange={(e) => setFormData({ ...formData, duration: parseInt(e.target.value) || 60 })}
                min="15"
                max="480"
                className="p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
              />
              <input
                type="number"
                placeholder="Max players"
                value={formData.maxPlayers}
                onChange={(e) => setFormData({ ...formData, maxPlayers: parseInt(e.target.value) || 4 })}
                min="2"
                max="20"
                className="p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
              />
            </div>
            
            <input
              type="text"
              placeholder="Location or platform"
              value={formData.location}
              onChange={(e) => setFormData({ ...formData, location: e.target.value })}
              className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
            />
            
            <div className="grid grid-cols-2 gap-3">
              <input
                type="text"
                placeholder="Game type"
                value={formData.gameType}
                onChange={(e) => setFormData({ ...formData, gameType: e.target.value })}
                className="p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
              />
              <select
                value={formData.difficulty}
                onChange={(e) => setFormData({ ...formData, difficulty: e.target.value as any })}
                className="p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
              >
                <option value="beginner">🟢 Beginner</option>
                <option value="intermediate">🟡 Intermediate</option>
                <option value="advanced">🔴 Advanced</option>
              </select>
            </div>
          </div>
          
          <div className="flex gap-2 mt-4">
            <button
              onClick={createPlaytimeSession}
              className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
            >
              Create Session
            </button>
            <button
              onClick={() => setShowCreateForm(false)}
              className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* Playtime Sessions */}
      <div className="space-y-4">
        <h2 className="text-xl font-semibold">Playtime Sessions</h2>
        
        {playtimeSessions.length === 0 ? (
          <div className="text-center py-8 text-gray-500">
            <Gamepad2 className="w-12 h-12 mx-auto mb-3 text-gray-300" />
            <p>No playtime sessions yet. Create your first one!</p>
          </div>
        ) : (
          <div className="space-y-3">
            {playtimeSessions.map((session) => (
              <div
                key={session.id}
                className={`p-4 border-2 rounded-xl ${getStatusColor(session.status)} transition-colors`}
              >
                <div className="flex items-start justify-between mb-3">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2">
                      <span className="text-2xl">{getGameTypeIcon(session.gameType)}</span>
                      <h3 className="font-semibold text-lg">{session.title}</h3>
                      <span className={`px-2 py-1 rounded-full text-xs font-medium border ${getDifficultyColor(session.difficulty)}`}>
                        {session.difficulty}
                      </span>
                    </div>
                    
                    {session.description && (
                      <p className="text-gray-600 text-sm mb-2">{session.description}</p>
                    )}
                    
                    <div className="grid grid-cols-2 gap-4 text-sm text-gray-500 mb-3">
                      <div className="flex items-center gap-1">
                        <Calendar className="w-4 h-4" />
                        {new Date(session.date).toLocaleDateString()}
                      </div>
                      <div className="flex items-center gap-1">
                        <Clock className="w-4 h-4" />
                        {session.time} ({session.duration} min)
                      </div>
                      <div className="flex items-center gap-1">
                        {session.type === 'physical' ? <MapPin className="w-4 h-4" /> : <Globe className="w-4 h-4" />}
                        {session.location}
                      </div>
                      <div className="flex items-center gap-1">
                        <Users className="w-4 h-4" />
                        {session.currentPlayers}/{session.maxPlayers} players
                      </div>
                    </div>
                  </div>
                  
                  <div className="ml-3">
                    <div className={`px-3 py-1 rounded-full text-xs font-medium ${
                      session.status === 'upcoming' ? 'bg-blue-100 text-blue-800' :
                      session.status === 'active' ? 'bg-green-100 text-green-800' :
                      'bg-gray-100 text-gray-800'
                    }`}>
                      {session.status}
                    </div>
                  </div>
                </div>

                {/* Participants */}
                <div className="mb-3">
                  <h4 className="text-sm font-medium text-gray-700 mb-2">Participants:</h4>
                  <div className="flex flex-wrap gap-2">
                    {session.participants.map((participant) => (
                      <div
                        key={participant.id}
                        className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm border border-blue-200"
                      >
                        {participant.name} {participant.status === 'joined' && '✅'}
                      </div>
                    ))}
                  </div>
                </div>

                {/* Actions */}
                <div className="flex gap-2">
                  {session.currentPlayers < session.maxPlayers ? (
                    <button
                      onClick={() => joinSession(session.id)}
                      className="flex-1 p-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors text-center text-sm"
                    >
                      Join Session
                    </button>
                  ) : (
                    <button
                      onClick={() => leaveSession(session.id)}
                      className="flex-1 p-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors text-center text-sm"
                    >
                      Leave Session
                    </button>
                  )}
                  
                  <button className="p-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                    <Trophy className="w-4 h-4 text-yellow-500" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 gap-3">
        <button className="p-3 border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-colors text-center">
          <Star className="w-6 h-6 mx-auto mb-2 text-blue-500" />
          <div className="text-sm font-medium">Find Players</div>
        </button>
        <button className="p-3 border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-colors text-center">
          <Trophy className="w-6 h-6 mx-auto mb-2 text-blue-500" />
          <div className="text-sm font-medium">Leaderboards</div>
        </button>
      </div>
    </main>
  );
}

