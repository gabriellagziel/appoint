'use client';
import BottomNav from '@/components/personal/BottomNav';
import { useParams } from 'next/navigation';
import { useEffect, useState } from 'react';

interface FamilyMember {
    id: string;
    name: string;
    role: 'parent' | 'child';
    age?: number;
    email?: string;
    avatar?: string;
    isActive: boolean;
    joinedAt: string;
}

interface FamilyActivity {
    id: string;
    type: 'meeting' | 'reminder' | 'playtime' | 'event';
    title: string;
    date: string;
    participants: string[];
    status: 'upcoming' | 'ongoing' | 'completed';
}

export default function FamilyPage() {
    const { locale } = useParams<{ locale: string }>();
    const [familyMembers, setFamilyMembers] = useState<FamilyMember[]>([]);
    const [familyActivities, setFamilyActivities] = useState<FamilyActivity[]>([]);
    const [showAddMember, setShowAddMember] = useState(false);
    const [newMember, setNewMember] = useState({
        name: '',
        role: 'child' as 'parent' | 'child',
        age: '',
        email: ''
    });

    // Load family data from localStorage
    useEffect(() => {
        const savedMembers = localStorage.getItem('appoint.personal.family.members.v1');
        const savedActivities = localStorage.getItem('appoint.personal.family.activities.v1');

        if (savedMembers) {
            try {
                setFamilyMembers(JSON.parse(savedMembers));
            } catch (e) {
                console.error('Failed to parse family members:', e);
            }
        }

        if (savedActivities) {
            try {
                setFamilyActivities(JSON.parse(savedActivities));
            } catch (e) {
                console.error('Failed to parse family activities:', e);
            }
        }

        // Initialize with default family if empty
        if (!savedMembers) {
            const defaultFamily: FamilyMember[] = [
                {
                    id: 'parent-1',
                    name: 'Gabriel',
                    role: 'parent',
                    email: 'gabriel@example.com',
                    isActive: true,
                    joinedAt: new Date().toISOString()
                }
            ];
            setFamilyMembers(defaultFamily);
            localStorage.setItem('appoint.personal.family.members.v1', JSON.stringify(defaultFamily));
        }
    }, []);

    // Save family members to localStorage
    const saveFamilyMembers = (newMembers: FamilyMember[]) => {
        localStorage.setItem('appoint.personal.family.members.v1', JSON.stringify(newMembers));
        setFamilyMembers(newMembers);
    };

    // Save family activities to localStorage
    const saveFamilyActivities = (newActivities: FamilyActivity[]) => {
        localStorage.setItem('appoint.personal.family.activities.v1', JSON.stringify(newActivities));
        setFamilyActivities(newActivities);
    };

    const addFamilyMember = () => {
        if (!newMember.name.trim()) {
            alert('Please enter a name');
            return;
        }

        if (newMember.role === 'child' && !newMember.age) {
            alert('Please enter age for child');
            return;
        }

        const member: FamilyMember = {
            id: 'member-' + Math.random().toString(36).slice(2, 9),
            name: newMember.name.trim(),
            role: newMember.role,
            age: newMember.role === 'child' ? parseInt(newMember.age) : undefined,
            email: newMember.email || undefined,
            avatar: `https://api.dicebear.com/7.x/avataaars/svg?seed=${newMember.name}`,
            isActive: true,
            joinedAt: new Date().toISOString()
        };

        const updatedMembers = [...familyMembers, member];
        saveFamilyMembers(updatedMembers);

        // Reset form
        setNewMember({ name: '', role: 'child', age: '', email: '' });
        setShowAddMember(false);
    };

    const removeFamilyMember = (memberId: string) => {
        if (confirm('Are you sure you want to remove this family member?')) {
            const updatedMembers = familyMembers.filter(m => m.id !== memberId);
            saveFamilyMembers(updatedMembers);
        }
    };

    const toggleMemberStatus = (memberId: string) => {
        const updatedMembers = familyMembers.map(m =>
            m.id === memberId ? { ...m, isActive: !m.isActive } : m
        );
        saveFamilyMembers(updatedMembers);
    };

    const formatDate = (dateString: string) => {
        return new Date(dateString).toLocaleDateString('en-US', {
            month: 'short',
            day: 'numeric',
            year: 'numeric'
        });
    };

    const getRoleLabel = (role: string) => {
        return role === 'parent' ? '👨‍👩‍👧 Parent' : '👶 Child';
    };

    const getStatusColor = (status: string) => {
        const colors = {
            upcoming: 'bg-blue-100 text-blue-800',
            ongoing: 'bg-green-100 text-green-800',
            completed: 'bg-gray-100 text-gray-800'
        };
        return colors[status as keyof typeof colors] || 'bg-gray-100 text-gray-800';
    };

    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8">
            <header className="mb-6">
                <div className="flex items-center justify-between">
                    <h1 className="text-2xl font-semibold">Family Management</h1>
                    <button
                        onClick={() => setShowAddMember(!showAddMember)}
                        className="rounded-xl bg-blue-600 text-white px-4 py-2 hover:bg-blue-700 transition-colors"
                    >
                        {showAddMember ? '✕' : '👨‍👩‍👧 Add'}
                    </button>
                </div>
            </header>

            {/* Add Family Member Form */}
            {showAddMember && (
                <div className="mb-6 bg-white rounded-2xl border p-6 shadow-sm">
                    <h2 className="text-lg font-semibold mb-4">Add Family Member</h2>

                    <div className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Name *
                            </label>
                            <input
                                type="text"
                                value={newMember.name}
                                onChange={(e) => setNewMember({ ...newMember, name: e.target.value })}
                                placeholder="Enter family member name..."
                                className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Role *
                            </label>
                            <select
                                value={newMember.role}
                                onChange={(e) => setNewMember({ ...newMember, role: e.target.value as 'parent' | 'child' })}
                                className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                aria-label="Family member role"
                            >
                                <option value="parent">👨‍👩‍👧 Parent</option>
                                <option value="child">👶 Child</option>
                            </select>
                        </div>

                        {newMember.role === 'child' && (
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">
                                    Age *
                                </label>
                                <input
                                    type="number"
                                    min="0"
                                    max="18"
                                    value={newMember.age}
                                    onChange={(e) => setNewMember({ ...newMember, age: e.target.value })}
                                    placeholder="Enter age..."
                                    className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                                />
                            </div>
                        )}

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Email (optional)
                            </label>
                            <input
                                type="email"
                                value={newMember.email}
                                onChange={(e) => setNewMember({ ...newMember, email: e.target.value })}
                                placeholder="Enter email address..."
                                className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                            />
                        </div>

                        <div className="flex gap-3 pt-4">
                            <button
                                onClick={() => setShowAddMember(false)}
                                className="flex-1 rounded-xl border border-gray-300 px-4 py-3 text-gray-700 hover:bg-gray-50 transition-colors"
                            >
                                Cancel
                            </button>
                            <button
                                onClick={addFamilyMember}
                                className="flex-1 rounded-xl bg-blue-600 text-white px-4 py-3 hover:bg-blue-700 transition-colors"
                            >
                                Add Member
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* Family Members */}
            <section className="mb-8">
                <h2 className="text-lg font-semibold mb-4">Family Members</h2>

                <div className="space-y-3">
                    {familyMembers.map((member) => (
                        <div
                            key={member.id}
                            className={`bg-white rounded-2xl border p-4 shadow-sm transition-all ${!member.isActive ? 'opacity-60' : ''
                                }`}
                        >
                            <div className="flex items-center gap-3">
                                <div className="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center text-lg">
                                    {member.avatar ? (
                                        <img src={member.avatar} alt={member.name} className="w-12 h-12 rounded-full" />
                                    ) : (
                                        member.name.charAt(0).toUpperCase()
                                    )}
                                </div>

                                <div className="flex-1">
                                    <div className="flex items-center gap-2 mb-1">
                                        <h3 className="font-medium">{member.name}</h3>
                                        <span className="text-xs bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
                                            {getRoleLabel(member.role)}
                                        </span>
                                        {member.age && (
                                            <span className="text-xs bg-green-100 text-green-800 px-2 py-1 rounded-full">
                                                Age {member.age}
                                            </span>
                                        )}
                                    </div>

                                    {member.email && (
                                        <p className="text-sm text-gray-600">{member.email}</p>
                                    )}

                                    <p className="text-xs text-gray-500">Joined {formatDate(member.joinedAt)}</p>
                                </div>

                                <div className="flex items-center gap-2">
                                    <button
                                        onClick={() => toggleMemberStatus(member.id)}
                                        className={`p-2 rounded-lg transition-colors ${member.isActive
                                                ? 'bg-green-100 text-green-600 hover:bg-green-200'
                                                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                                            }`}
                                        title={member.isActive ? 'Deactivate' : 'Activate'}
                                    >
                                        {member.isActive ? '✅' : '⭕'}
                                    </button>

                                    <button
                                        onClick={() => removeFamilyMember(member.id)}
                                        className="p-2 rounded-lg bg-red-100 text-red-600 hover:bg-red-200 transition-colors"
                                        title="Remove member"
                                    >
                                        🗑️
                                    </button>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </section>

            {/* Family Activities */}
            <section className="mb-8">
                <h2 className="text-lg font-semibold mb-4">Family Activities</h2>

                {familyActivities.length === 0 ? (
                    <div className="text-center py-8 text-gray-500">
                        <div className="text-4xl mb-2">🎯</div>
                        <p>No family activities yet</p>
                        <p className="text-sm">Create meetings and reminders to see them here</p>
                    </div>
                ) : (
                    <div className="space-y-3">
                        {familyActivities.map((activity) => (
                            <div
                                key={activity.id}
                                className="bg-white rounded-2xl border p-4 shadow-sm"
                            >
                                <div className="flex items-start justify-between mb-2">
                                    <div className="flex-1">
                                        <h3 className="font-medium">{activity.title}</h3>
                                        <p className="text-sm text-gray-600">
                                            {activity.participants.join(', ')}
                                        </p>
                                    </div>

                                    <span className={`text-xs px-2 py-1 rounded-full ${getStatusColor(activity.status)}`}>
                                        {activity.status.charAt(0).toUpperCase() + activity.status.slice(1)}
                                    </span>
                                </div>

                                <div className="text-xs text-gray-500">
                                    📅 {formatDate(activity.date)}
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </section>

            {/* Family Features */}
            <section className="mb-8">
                <h2 className="text-lg font-semibold mb-4">Family Features</h2>

                <div className="grid grid-cols-2 gap-3">
                    <button
                        onClick={() => {/* TODO: Navigate to shared calendar */ }}
                        className="bg-white rounded-2xl border p-4 text-center hover:shadow-md transition-shadow"
                    >
                        <div className="text-2xl mb-2">📅</div>
                        <div className="text-sm font-medium">Shared Calendar</div>
                    </button>

                    <button
                        onClick={() => {/* TODO: Navigate to family playtime */ }}
                        className="bg-white rounded-2xl border p-4 text-center hover:shadow-md transition-shadow"
                    >
                        <div className="text-2xl mb-2">🎮</div>
                        <div className="text-sm font-medium">Family Playtime</div>
                    </button>

                    <button
                        onClick={() => {/* TODO: Navigate to family reminders */ }}
                        className="bg-white rounded-2xl border p-4 text-center hover:shadow-md transition-shadow"
                    >
                        <div className="text-2xl mb-2">⏰</div>
                        <div className="text-sm font-medium">Family Reminders</div>
                    </button>

                    <button
                        onClick={() => {/* TODO: Navigate to family settings */ }}
                        className="bg-white rounded-2xl border p-4 text-center hover:shadow-md transition-shadow"
                    >
                        <div className="text-2xl mb-2">⚙️</div>
                        <div className="text-sm font-medium">Family Settings</div>
                    </button>
                </div>
            </section>

            <BottomNav locale={locale as string} />
        </main>
    );
}
