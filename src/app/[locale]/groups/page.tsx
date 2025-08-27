'use client';
import BottomNav from '@/components/personal/BottomNav';
import { useParams } from 'next/navigation';
import { useEffect, useState } from 'react';

interface Group {
    id: string;
    name: string;
    description?: string;
    members: GroupMember[];
    inviteLink: string;
    createdAt: string;
    isOwner: boolean;
}

interface GroupMember {
    id: string;
    name: string;
    role: 'owner' | 'admin' | 'member';
    joinedAt: string;
}

export default function GroupsPage() {
    const { locale } = useParams<{ locale: string }>();
    const [groups, setGroups] = useState<Group[]>([]);
    const [showCreateForm, setShowCreateForm] = useState(false);
    const [newGroup, setNewGroup] = useState({
        name: '',
        description: ''
    });

    // Load groups from localStorage
    useEffect(() => {
        const saved = localStorage.getItem('appoint.personal.groups.v1');
        if (saved) {
            try {
                setGroups(JSON.parse(saved));
            } catch (e) {
                console.error('Failed to parse groups:', e);
            }
        }
    }, []);

    // Save groups to localStorage
    const saveGroups = (newGroups: Group[]) => {
        localStorage.setItem('appoint.personal.groups.v1', JSON.stringify(newGroups));
        setGroups(newGroups);
    };

    const createGroup = () => {
        if (!newGroup.name.trim()) {
            alert('Please enter a group name');
            return;
        }

        const group: Group = {
            id: 'group-' + Math.random().toString(36).slice(2, 9),
            name: newGroup.name.trim(),
            description: newGroup.description.trim(),
            members: [
                {
                    id: 'member-1',
                    name: 'Gabriel',
                    role: 'owner',
                    joinedAt: new Date().toISOString()
                }
            ],
            inviteLink: `https://personal.app-oint.com/${locale}/groups/join/${Math.random().toString(36).slice(2, 9)}`,
            createdAt: new Date().toISOString(),
            isOwner: true
        };

        const updatedGroups = [...groups, group];
        saveGroups(updatedGroups);

        // Reset form
        setNewGroup({ name: '', description: '' });
        setShowCreateForm(false);
    };

    const deleteGroup = (groupId: string) => {
        if (confirm('Are you sure you want to delete this group? This action cannot be undone.')) {
            const updatedGroups = groups.filter(g => g.id !== groupId);
            saveGroups(updatedGroups);
        }
    };

    const copyInviteLink = (inviteLink: string) => {
        navigator.clipboard.writeText(inviteLink);
        alert('Invite link copied to clipboard!');
    };

    const formatDate = (dateString: string) => {
        return new Date(dateString).toLocaleDateString('en-US', {
            month: 'short',
            day: 'numeric',
            year: 'numeric'
        });
    };

    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8">
            <header className="mb-6">
                <div className="flex items-center justify-between">
                    <h1 className="text-2xl font-semibold">Groups</h1>
                    <button
                        onClick={() => setShowCreateForm(!showCreateForm)}
                        className="rounded-xl bg-blue-600 text-white px-4 py-2 hover:bg-blue-700 transition-colors"
                    >
                        {showCreateForm ? '✕' : '➕ Create'}
                    </button>
                </div>
            </header>

            {/* Create Group Form */}
            {showCreateForm && (
                <div className="mb-6 bg-white rounded-2xl border p-6 shadow-sm">
                    <h2 className="text-lg font-semibold mb-4">Create New Group</h2>

                    <div className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Group Name *
                            </label>
                            <input
                                type="text"
                                value={newGroup.name}
                                onChange={(e) => setNewGroup({ ...newGroup, name: e.target.value })}
                                placeholder="Enter group name..."
                                className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Description
                            </label>
                            <textarea
                                value={newGroup.description}
                                onChange={(e) => setNewGroup({ ...newGroup, description: e.target.value })}
                                placeholder="What is this group about?"
                                rows={3}
                                className="w-full rounded-xl border border-gray-300 px-4 py-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors resize-none"
                            />
                        </div>

                        <div className="flex gap-3 pt-4">
                            <button
                                onClick={() => setShowCreateForm(false)}
                                className="flex-1 rounded-xl border border-gray-300 px-4 py-3 text-gray-700 hover:bg-gray-50 transition-colors"
                            >
                                Cancel
                            </button>
                            <button
                                onClick={createGroup}
                                className="flex-1 rounded-xl bg-blue-600 text-white px-4 py-3 hover:bg-blue-700 transition-colors"
                            >
                                Create Group
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* Groups List */}
            <section className="space-y-3">
                <h2 className="text-lg font-semibold">Your Groups</h2>

                {groups.length === 0 ? (
                    <div className="text-center py-8 text-gray-500">
                        <div className="text-4xl mb-2">👥</div>
                        <p>No groups yet</p>
                        <p className="text-sm">Create your first group to start collaborating</p>
                    </div>
                ) : (
                    groups.map((group) => (
                        <div
                            key={group.id}
                            className="bg-white rounded-2xl border p-4 shadow-sm"
                        >
                            <div className="flex items-start justify-between mb-3">
                                <div className="flex-1">
                                    <h3 className="font-medium text-lg">{group.name}</h3>
                                    {group.description && (
                                        <p className="text-sm text-gray-600 mt-1">{group.description}</p>
                                    )}
                                </div>

                                {group.isOwner && (
                                    <button
                                        onClick={() => deleteGroup(group.id)}
                                        className="p-2 rounded-lg bg-red-100 text-red-600 hover:bg-red-200 transition-colors"
                                        title="Delete group"
                                    >
                                        🗑️
                                    </button>
                                )}
                            </div>

                            <div className="flex items-center justify-between text-sm text-gray-500 mb-3">
                                <span>👥 {group.members.length} member{group.members.length !== 1 ? 's' : ''}</span>
                                <span>📅 Created {formatDate(group.createdAt)}</span>
                            </div>

                            <div className="flex gap-2">
                                <button
                                    onClick={() => copyInviteLink(group.inviteLink)}
                                    className="flex-1 rounded-xl border border-gray-300 px-3 py-2 text-sm text-gray-700 hover:bg-gray-50 transition-colors"
                                >
                                    📋 Copy Invite Link
                                </button>

                                <button
                                    onClick={() => {/* TODO: Navigate to group details */ }}
                                    className="flex-1 rounded-xl bg-blue-600 text-white px-3 py-2 text-sm hover:bg-blue-700 transition-colors"
                                >
                                    👀 View Details
                                </button>
                            </div>

                            {/* Members Preview */}
                            <div className="mt-3 pt-3 border-t">
                                <div className="text-xs text-gray-500 mb-2">Members:</div>
                                <div className="flex flex-wrap gap-1">
                                    {group.members.slice(0, 3).map((member) => (
                                        <span
                                            key={member.id}
                                            className={`text-xs px-2 py-1 rounded-full ${member.role === 'owner'
                                                    ? 'bg-blue-100 text-blue-800'
                                                    : member.role === 'admin'
                                                        ? 'bg-green-100 text-green-800'
                                                        : 'bg-gray-100 text-gray-600'
                                                }`}
                                        >
                                            {member.name}
                                            {member.role === 'owner' && ' 👑'}
                                            {member.role === 'admin' && ' ⭐'}
                                        </span>
                                    ))}
                                    {group.members.length > 3 && (
                                        <span className="text-xs text-gray-500 px-2 py-1">
                                            +{group.members.length - 3} more
                                        </span>
                                    )}
                                </div>
                            </div>
                        </div>
                    ))
                )}
            </section>

            <BottomNav locale={locale as string} />
        </main>
    );
}


