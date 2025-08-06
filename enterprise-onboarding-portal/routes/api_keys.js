const express = require('express');
const crypto = require('crypto');
const { collections } = require('../firebase');
const { authenticateFirebaseToken } = require('../middleware/auth');

const router = express.Router();

// Generate new API key
router.post('/generate', authenticateFirebaseToken, async (req, res) => {
    try {
        const { label, permissions, expiryDate } = req.body;
        const userId = req.user.uid;

        // Validate input
        if (!label || !permissions) {
            return res.status(400).json({ error: 'Label and permissions are required' });
        }

        // Generate secure API key
        const apiKey = `appoint_${crypto.randomBytes(32).toString('hex')}`;

        // Create API key document
        const apiKeyData = {
            apiKey,
            userId,
            label,
            permissions,
            isActive: true,
            createdAt: new Date(),
            expiryDate: expiryDate ? new Date(expiryDate) : null,
            usageCount: 0,
            lastUsed: null
        };

        // Store in Firestore
        await collections.apiKeys.doc(apiKey).set(apiKeyData);

        res.status(201).json({
            message: 'API key generated successfully',
            apiKey,
            data: apiKeyData
        });

    } catch (error) {
        console.error('API key generation error:', error);
        res.status(500).json({ error: 'Failed to generate API key' });
    }
});

// List user's API keys
router.get('/list', authenticateFirebaseToken, async (req, res) => {
    try {
        const userId = req.user.uid;

        const apiKeysSnapshot = await collections.apiKeys
            .where('userId', '==', userId)
            .orderBy('createdAt', 'desc')
            .get();

        const apiKeys = [];
        apiKeysSnapshot.forEach(doc => {
            const data = doc.data();
            apiKeys.push({
                id: doc.id,
                label: data.label,
                permissions: data.permissions,
                isActive: data.isActive,
                createdAt: data.createdAt.toDate(),
                expiryDate: data.expiryDate ? data.expiryDate.toDate() : null,
                usageCount: data.usageCount || 0,
                lastUsed: data.lastUsed ? data.lastUsed.toDate() : null
            });
        });

        res.json({ apiKeys });

    } catch (error) {
        console.error('API key listing error:', error);
        res.status(500).json({ error: 'Failed to list API keys' });
    }
});

// Get API key details
router.get('/:apiKey', authenticateFirebaseToken, async (req, res) => {
    try {
        const { apiKey } = req.params;
        const userId = req.user.uid;

        const apiKeyDoc = await collections.apiKeys.doc(apiKey).get();

        if (!apiKeyDoc.exists) {
            return res.status(404).json({ error: 'API key not found' });
        }

        const data = apiKeyDoc.data();

        // Check ownership
        if (data.userId !== userId) {
            return res.status(403).json({ error: 'Access denied' });
        }

        res.json({
            apiKey: data.apiKey,
            label: data.label,
            permissions: data.permissions,
            isActive: data.isActive,
            createdAt: data.createdAt.toDate(),
            expiryDate: data.expiryDate ? data.expiryDate.toDate() : null,
            usageCount: data.usageCount || 0,
            lastUsed: data.lastUsed ? data.lastUsed.toDate() : null
        });

    } catch (error) {
        console.error('API key details error:', error);
        res.status(500).json({ error: 'Failed to get API key details' });
    }
});

// Update API key
router.put('/:apiKey', authenticateFirebaseToken, async (req, res) => {
    try {
        const { apiKey } = req.params;
        const { label, permissions, isActive } = req.body;
        const userId = req.user.uid;

        const apiKeyDoc = await collections.apiKeys.doc(apiKey).get();

        if (!apiKeyDoc.exists) {
            return res.status(404).json({ error: 'API key not found' });
        }

        const data = apiKeyDoc.data();

        // Check ownership
        if (data.userId !== userId) {
            return res.status(403).json({ error: 'Access denied' });
        }

        // Update fields
        const updates = {};
        if (label !== undefined) updates.label = label;
        if (permissions !== undefined) updates.permissions = permissions;
        if (isActive !== undefined) updates.isActive = isActive;

        await collections.apiKeys.doc(apiKey).update(updates);

        res.json({ message: 'API key updated successfully' });

    } catch (error) {
        console.error('API key update error:', error);
        res.status(500).json({ error: 'Failed to update API key' });
    }
});

// Revoke API key
router.delete('/:apiKey', authenticateFirebaseToken, async (req, res) => {
    try {
        const { apiKey } = req.params;
        const userId = req.user.uid;

        const apiKeyDoc = await collections.apiKeys.doc(apiKey).get();

        if (!apiKeyDoc.exists) {
            return res.status(404).json({ error: 'API key not found' });
        }

        const data = apiKeyDoc.data();

        // Check ownership
        if (data.userId !== userId) {
            return res.status(403).json({ error: 'Access denied' });
        }

        // Delete API key
        await collections.apiKeys.doc(apiKey).delete();

        res.json({ message: 'API key revoked successfully' });

    } catch (error) {
        console.error('API key revocation error:', error);
        res.status(500).json({ error: 'Failed to revoke API key' });
    }
});

// Regenerate API key
router.post('/:apiKey/regenerate', authenticateFirebaseToken, async (req, res) => {
    try {
        const { apiKey } = req.params;
        const userId = req.user.uid;

        const apiKeyDoc = await collections.apiKeys.doc(apiKey).get();

        if (!apiKeyDoc.exists) {
            return res.status(404).json({ error: 'API key not found' });
        }

        const data = apiKeyDoc.data();

        // Check ownership
        if (data.userId !== userId) {
            return res.status(403).json({ error: 'Access denied' });
        }

        // Generate new API key
        const newApiKey = `appoint_${crypto.randomBytes(32).toString('hex')}`;

        // Create new document with new key
        const newApiKeyData = {
            ...data,
            apiKey: newApiKey,
            createdAt: new Date(),
            usageCount: 0,
            lastUsed: null
        };

        // Delete old key and create new one
        await collections.apiKeys.doc(apiKey).delete();
        await collections.apiKeys.doc(newApiKey).set(newApiKeyData);

        res.json({
            message: 'API key regenerated successfully',
            newApiKey,
            data: newApiKeyData
        });

    } catch (error) {
        console.error('API key regeneration error:', error);
        res.status(500).json({ error: 'Failed to regenerate API key' });
    }
});

module.exports = router; 