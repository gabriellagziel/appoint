'use client';

import Button from '@/components/Button';
import Card from '@/components/Card';
import { Copy, Eye, EyeOff, Key, Plus, Trash2 } from 'lucide-react';
import { useState } from 'react';

export default function ApiKeysPage() {
    const [keys, setKeys] = useState([
        {
            id: 'sk_live_1234567890abcdef',
            name: 'Production API Key',
            created: '2024-01-15',
            lastUsed: '2024-01-20',
            status: 'active',
            permissions: ['meetings:create', 'meetings:read'],
        },
        {
            id: 'sk_test_0987654321fedcba',
            name: 'Development API Key',
            created: '2024-01-10',
            lastUsed: '2024-01-18',
            status: 'active',
            permissions: ['meetings:create', 'meetings:read'],
        },
    ]);

    const [showSecret, setShowSecret] = useState<Record<string, boolean>>({});
    const [copiedKey, setCopiedKey] = useState<string | null>(null);

    const toggleSecret = (keyId: string) => {
        setShowSecret(prev => ({ ...prev, [keyId]: !prev[keyId] }));
    };

    const copyToClipboard = async (text: string, keyId: string) => {
        try {
            await navigator.clipboard.writeText(text);
            setCopiedKey(keyId);
            setTimeout(() => setCopiedKey(null), 2000);
        } catch (err) {
            console.error('Failed to copy: ', err);
        }
    };

    const deleteKey = (keyId: string) => {
        setKeys(prev => prev.filter(key => key.id !== keyId));
    };

    const createNewKey = () => {
        const newKey = {
            id: `sk_live_${Math.random().toString(36).substr(2, 9)}`,
            name: 'New API Key',
            created: new Date().toISOString().split('T')[0],
            lastUsed: 'Never',
            status: 'active',
            permissions: ['meetings:create', 'meetings:read'],
        };
        setKeys(prev => [newKey, ...prev]);
    };

    return (
        <div className="space-y-6">
            {/* Header */}
            <div className="flex justify-between items-center">
                <div>
                    <h1 className="text-2xl font-bold text-neutral-900">API Keys</h1>
                    <p className="text-neutral-600 mt-1">
                        Manage your API keys for accessing the App-Oint platform
                    </p>
                </div>
                <Button onClick={createNewKey} className="flex items-center gap-2">
                    <Plus className="w-4 h-4" />
                    Create New Key
                </Button>
            </div>

            {/* API Keys List */}
            <div className="space-y-4">
                {keys.map((key) => (
                    <Card key={key.id} className="p-6">
                        <div className="flex justify-between items-start">
                            <div className="flex-1">
                                <div className="flex items-center gap-3 mb-3">
                                    <Key className="w-5 h-5 text-primary-600" />
                                    <h3 className="font-semibold text-neutral-900">{key.name}</h3>
                                    <span className={`px-2 py-1 text-xs rounded-full ${key.status === 'active'
                                            ? 'bg-success-100 text-success-700'
                                            : 'bg-neutral-100 text-neutral-700'
                                        }`}>
                                        {key.status}
                                    </span>
                                </div>

                                <div className="space-y-2">
                                    <div className="flex items-center gap-2">
                                        <span className="text-sm text-neutral-600">Key:</span>
                                        <code className="text-sm bg-neutral-100 px-2 py-1 rounded">
                                            {showSecret[key.id] ? key.id : '••••••••••••••••'}
                                        </code>
                                        <button
                                            onClick={() => toggleSecret(key.id)}
                                            className="text-neutral-500 hover:text-neutral-700"
                                            aria-label={showSecret[key.id] ? "Hide API key" : "Show API key"}
                                        >
                                            {showSecret[key.id] ? (
                                                <EyeOff className="w-4 h-4" />
                                            ) : (
                                                <Eye className="w-4 h-4" />
                                            )}
                                        </button>
                                        <button
                                            onClick={() => copyToClipboard(key.id, key.id)}
                                            className="text-neutral-500 hover:text-neutral-700"
                                            aria-label="Copy API key"
                                        >
                                            <Copy className="w-4 h-4" />
                                        </button>
                                        {copiedKey === key.id && (
                                            <span className="text-xs text-success-600">Copied!</span>
                                        )}
                                    </div>

                                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                                        <div>
                                            <span className="text-neutral-600">Created:</span>
                                            <span className="ml-2 text-neutral-900">{key.created}</span>
                                        </div>
                                        <div>
                                            <span className="text-neutral-600">Last Used:</span>
                                            <span className="ml-2 text-neutral-900">{key.lastUsed}</span>
                                        </div>
                                        <div>
                                            <span className="text-neutral-600">Permissions:</span>
                                            <span className="ml-2 text-neutral-900">
                                                {key.permissions.join(', ')}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div className="flex items-center gap-2">
                                <Button
                                    variant="outline"
                                    size="sm"
                                    onClick={() => copyToClipboard(key.id, key.id)}
                                >
                                    <Copy className="w-4 h-4 mr-1" />
                                    Copy
                                </Button>
                                <Button
                                    variant="outline"
                                    size="sm"
                                    onClick={() => deleteKey(key.id)}
                                    className="text-error-600 hover:text-error-700"
                                >
                                    <Trash2 className="w-4 h-4 mr-1" />
                                    Delete
                                </Button>
                            </div>
                        </div>
                    </Card>
                ))}
            </div>

            {/* Empty State */}
            {keys.length === 0 && (
                <Card className="p-8 text-center">
                    <Key className="w-12 h-12 text-neutral-400 mx-auto mb-4" />
                    <h3 className="text-lg font-semibold text-neutral-900 mb-2">
                        No API Keys
                    </h3>
                    <p className="text-neutral-600 mb-4">
                        Create your first API key to start integrating with the App-Oint platform.
                    </p>
                    <Button onClick={createNewKey}>
                        <Plus className="w-4 h-4 mr-2" />
                        Create Your First Key
                    </Button>
                </Card>
            )}

            {/* Documentation */}
            <Card className="p-6">
                <h3 className="font-semibold text-neutral-900 mb-4">API Key Documentation</h3>
                <div className="space-y-3 text-sm text-neutral-600">
                    <p>
                        <strong>Usage:</strong> Include your API key in the Authorization header:
                    </p>
                    <code className="block bg-neutral-100 p-3 rounded text-xs">
                        Authorization: Bearer sk_live_your_api_key_here
                    </code>
                    <p>
                        <strong>Security:</strong> Keep your API keys secure and never expose them in client-side code.
                    </p>
                    <p>
                        <strong>Permissions:</strong> Each key can have different permissions for meetings, analytics, and billing.
                    </p>
                </div>
            </Card>
        </div>
    );
} 