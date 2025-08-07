const express = require('express');
const cors = require('cors');
const crypto = require('crypto');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3003;

// Middleware
app.use(cors());
app.use(express.json());

// In-memory sandbox storage (replace with database in production)
const sandboxes = new Map();
const sandboxData = new Map();

// Sandbox lifecycle management
class SandboxManager {
    constructor() {
        this.cleanupInterval = setInterval(() => {
            this.cleanupExpiredSandboxes();
        }, 24 * 60 * 60 * 1000); // Daily cleanup
    }

    createSandbox(tenantId) {
        const sandboxId = `sandbox_${tenantId}_${Date.now()}`;
        const createdAt = new Date();
        const expiresAt = new Date(createdAt.getTime() + 30 * 24 * 60 * 60 * 1000); // 30 days

        const sandbox = {
            id: sandboxId,
            tenantId,
            createdAt,
            expiresAt,
            status: 'active',
            apiEndpoint: `https://sandbox-${sandboxId}.appoint.com`,
            data: this.generateSeedData()
        };

        sandboxes.set(sandboxId, sandbox);
        sandboxData.set(sandboxId, sandbox.data);

        console.log(`Created sandbox: ${sandboxId} for tenant: ${tenantId}`);
        return sandbox;
    }

    generateSeedData() {
        return {
            businesses: [
                {
                    id: 'business_001',
                    name: 'Sample Medical Clinic',
                    description: 'A comprehensive medical facility',
                    address: '123 Healthcare Ave, Medical City, MC 12345',
                    phone: '+1-555-123-4567',
                    email: 'contact@sampleclinic.com',
                    services: ['consultation', 'treatment', 'follow-up'],
                    hours: {
                        monday: '9:00 AM - 5:00 PM',
                        tuesday: '9:00 AM - 5:00 PM',
                        wednesday: '9:00 AM - 5:00 PM',
                        thursday: '9:00 AM - 5:00 PM',
                        friday: '9:00 AM - 5:00 PM',
                        saturday: '10:00 AM - 2:00 PM',
                        sunday: 'Closed'
                    }
                },
                {
                    id: 'business_002',
                    name: 'Dental Care Center',
                    description: 'Professional dental services',
                    address: '456 Dental Blvd, Health Town, HT 67890',
                    phone: '+1-555-987-6543',
                    email: 'info@dentalcare.com',
                    services: ['cleaning', 'examination', 'whitening'],
                    hours: {
                        monday: '8:00 AM - 6:00 PM',
                        tuesday: '8:00 AM - 6:00 PM',
                        wednesday: '8:00 AM - 6:00 PM',
                        thursday: '8:00 AM - 6:00 PM',
                        friday: '8:00 AM - 4:00 PM',
                        saturday: '9:00 AM - 1:00 PM',
                        sunday: 'Closed'
                    }
                }
            ],
            users: [
                {
                    id: 'user_001',
                    email: 'john.doe@example.com',
                    firstName: 'John',
                    lastName: 'Doe',
                    phone: '+1-555-111-2222',
                    preferences: {
                        notifications: true,
                        emailUpdates: true,
                        smsReminders: false
                    }
                },
                {
                    id: 'user_002',
                    email: 'jane.smith@example.com',
                    firstName: 'Jane',
                    lastName: 'Smith',
                    phone: '+1-555-333-4444',
                    preferences: {
                        notifications: true,
                        emailUpdates: true,
                        smsReminders: true
                    }
                }
            ],
            bookings: [
                {
                    id: 'booking_001',
                    userId: 'user_001',
                    businessId: 'business_001',
                    scheduledAt: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
                    serviceType: 'consultation',
                    status: 'confirmed',
                    notes: 'First time visit',
                    location: '123 Healthcare Ave, Medical City, MC 12345',
                    createdAt: new Date().toISOString()
                },
                {
                    id: 'booking_002',
                    userId: 'user_002',
                    businessId: 'business_002',
                    scheduledAt: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000).toISOString(),
                    serviceType: 'cleaning',
                    status: 'pending',
                    notes: 'Regular cleaning appointment',
                    location: '456 Dental Blvd, Health Town, HT 67890',
                    createdAt: new Date().toISOString()
                }
            ],
            services: [
                {
                    id: 'service_001',
                    businessId: 'business_001',
                    name: 'General Consultation',
                    description: 'Comprehensive health consultation',
                    duration: 30,
                    price: 75.00,
                    category: 'consultation'
                },
                {
                    id: 'service_002',
                    businessId: 'business_001',
                    name: 'Follow-up Visit',
                    description: 'Follow-up medical consultation',
                    duration: 15,
                    price: 50.00,
                    category: 'consultation'
                },
                {
                    id: 'service_003',
                    businessId: 'business_002',
                    name: 'Dental Cleaning',
                    description: 'Professional dental cleaning',
                    duration: 60,
                    price: 120.00,
                    category: 'cleaning'
                }
            ]
        };
    }

    cleanupExpiredSandboxes() {
        const now = new Date();
        for (const [sandboxId, sandbox] of sandboxes.entries()) {
            if (now > sandbox.expiresAt) {
                this.deleteSandbox(sandboxId);
                console.log(`Cleaned up expired sandbox: ${sandboxId}`);
            }
        }
    }

    deleteSandbox(sandboxId) {
        sandboxes.delete(sandboxId);
        sandboxData.delete(sandboxId);
    }

    getSandbox(sandboxId) {
        return sandboxes.get(sandboxId);
    }

    getSandboxData(sandboxId) {
        return sandboxData.get(sandboxId);
    }

    updateSandboxData(sandboxId, data) {
        const currentData = sandboxData.get(sandboxId);
        if (currentData) {
            sandboxData.set(sandboxId, { ...currentData, ...data });
        }
    }
}

const sandboxManager = new SandboxManager();

// Routes
app.post('/api/sandbox/create', (req, res) => {
    try {
        const { tenantId } = req.body;

        if (!tenantId) {
            return res.status(400).json({ error: 'Tenant ID is required' });
        }

        const sandbox = sandboxManager.createSandbox(tenantId);

        res.json({
            success: true,
            sandbox: {
                id: sandbox.id,
                apiEndpoint: sandbox.apiEndpoint,
                createdAt: sandbox.createdAt,
                expiresAt: sandbox.expiresAt,
                status: sandbox.status
            }
        });
    } catch (error) {
        console.error('Sandbox creation error:', error);
        res.status(500).json({ error: 'Failed to create sandbox' });
    }
});

app.get('/api/sandbox/:sandboxId', (req, res) => {
    try {
        const { sandboxId } = req.params;
        const sandbox = sandboxManager.getSandbox(sandboxId);

        if (!sandbox) {
            return res.status(404).json({ error: 'Sandbox not found' });
        }

        res.json({
            success: true,
            sandbox: {
                id: sandbox.id,
                tenantId: sandbox.tenantId,
                apiEndpoint: sandbox.apiEndpoint,
                createdAt: sandbox.createdAt,
                expiresAt: sandbox.expiresAt,
                status: sandbox.status
            }
        });
    } catch (error) {
        console.error('Sandbox retrieval error:', error);
        res.status(500).json({ error: 'Failed to retrieve sandbox' });
    }
});

app.delete('/api/sandbox/:sandboxId', (req, res) => {
    try {
        const { sandboxId } = req.params;
        const sandbox = sandboxManager.getSandbox(sandboxId);

        if (!sandbox) {
            return res.status(404).json({ error: 'Sandbox not found' });
        }

        sandboxManager.deleteSandbox(sandboxId);

        res.json({ success: true, message: 'Sandbox deleted successfully' });
    } catch (error) {
        console.error('Sandbox deletion error:', error);
        res.status(500).json({ error: 'Failed to delete sandbox' });
    }
});

// Sandbox API endpoints
app.get('/sandbox-api/:sandboxId/businesses', (req, res) => {
    try {
        const { sandboxId } = req.params;
        const data = sandboxManager.getSandboxData(sandboxId);

        if (!data) {
            return res.status(404).json({ error: 'Sandbox not found' });
        }

        res.json(data.businesses);
    } catch (error) {
        console.error('Sandbox API error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.get('/sandbox-api/:sandboxId/businesses/:businessId', (req, res) => {
    try {
        const { sandboxId, businessId } = req.params;
        const data = sandboxManager.getSandboxData(sandboxId);

        if (!data) {
            return res.status(404).json({ error: 'Sandbox not found' });
        }

        const business = data.businesses.find(b => b.id === businessId);
        if (!business) {
            return res.status(404).json({ error: 'Business not found' });
        }

        res.json(business);
    } catch (error) {
        console.error('Sandbox API error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.get('/sandbox-api/:sandboxId/bookings', (req, res) => {
    try {
        const { sandboxId } = req.params;
        const data = sandboxManager.getSandboxData(sandboxId);

        if (!data) {
            return res.status(404).json({ error: 'Sandbox not found' });
        }

        res.json(data.bookings);
    } catch (error) {
        console.error('Sandbox API error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/sandbox-api/:sandboxId/bookings', (req, res) => {
    try {
        const { sandboxId } = req.params;
        const bookingData = req.body;
        const data = sandboxManager.getSandboxData(sandboxId);

        if (!data) {
            return res.status(404).json({ error: 'Sandbox not found' });
        }

        const newBooking = {
            id: `booking_${Date.now()}`,
            ...bookingData,
            createdAt: new Date().toISOString()
        };

        data.bookings.push(newBooking);
        sandboxManager.updateSandboxData(sandboxId, { bookings: data.bookings });

        res.status(201).json(newBooking);
    } catch (error) {
        console.error('Sandbox API error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.get('/sandbox-api/:sandboxId/users', (req, res) => {
    try {
        const { sandboxId } = req.params;
        const data = sandboxManager.getSandboxData(sandboxId);

        if (!data) {
            return res.status(404).json({ error: 'Sandbox not found' });
        }

        res.json(data.users);
    } catch (error) {
        console.error('Sandbox API error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Health check
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        activeSandboxes: sandboxes.size
    });
});

app.listen(PORT, () => {
    console.log(`Sandbox environment server running on port ${PORT}`);
    console.log('Available endpoints:');
    console.log('- Sandbox Management: /api/sandbox/create, /api/sandbox/:id, /api/sandbox/:id (DELETE)');
    console.log('- Sandbox API: /sandbox-api/:sandboxId/*');
    console.log('- Health: /health');
}); 