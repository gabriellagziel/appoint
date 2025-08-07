const admin = require('firebase-admin');
const functions = require('firebase-functions');

// Mock Stripe
jest.mock('stripe', () => {
  return jest.fn(() => ({
    checkout: {
      sessions: {
        create: jest.fn(),
        retrieve: jest.fn(),
      },
    },
    subscriptions: {
      update: jest.fn(),
    },
    webhooks: {
      constructEvent: jest.fn(),
    },
  }));
});

// Mock Firebase Admin
jest.mock('firebase-admin', () => ({
  initializeApp: jest.fn(),
  firestore: jest.fn(() => ({
    collection: jest.fn(),
  })),
  messaging: jest.fn(() => ({
    send: jest.fn(),
    sendToDevice: jest.fn(),
  })),
  firestore: {
    FieldValue: {
      serverTimestamp: jest.fn(() => 'server-timestamp'),
    },
  },
}));

// Mock Firebase Functions
jest.mock('firebase-functions', () => ({
  https: {
    onRequest: jest.fn(),
    onCall: jest.fn(),
    HttpsError: jest.fn((code, message) => ({ code, message })),
  },
  firestore: {
    document: jest.fn(() => ({
      onCreate: jest.fn(),
    })),
  },
  config: jest.fn(() => ({
    stripe: {
      secret_key: 'sk_test_123',
      webhook_secret: 'whsec_test_123',
    },
  })),
}));

// Import the TypeScript functions to test
const {
  createCheckoutSession,
  stripeWebhook,
  cancelSubscription,
  sendNotificationToStudio,
  onNewBooking,
} = require('../src/index.ts');

describe('TypeScript Cloud Functions', () => {
  let mockDb;
  let mockCollection;
  let mockDoc;
  let mockStripe;
  let mockMessaging;

  beforeEach(() => {
    jest.clearAllMocks();
    
    // Setup mock Firestore
    mockDoc = {
      get: jest.fn(),
      set: jest.fn(),
      update: jest.fn(),
      exists: true,
      data: jest.fn(),
    };

    mockCollection = {
      doc: jest.fn(() => mockDoc),
      add: jest.fn(),
    };

    mockDb = {
      collection: jest.fn(() => mockCollection),
    };

    admin.firestore.mockReturnValue(mockDb);

    // Setup mock Stripe
    const Stripe = require('stripe');
    mockStripe = new Stripe();

    // Setup mock Messaging
    mockMessaging = {
      send: jest.fn(),
      sendToDevice: jest.fn(),
    };
    admin.messaging.mockReturnValue(mockMessaging);
  });

  describe('createCheckoutSession', () => {
    it('should create checkout session successfully', async () => {
      const req = {
        method: 'POST',
        body: {
          studioId: 'studio123',
          priceId: 'price_test123',
          successUrl: 'https://example.com/success',
          cancelUrl: 'https://example.com/cancel',
          customerEmail: 'test@example.com',
        },
      };
      const res = {
        json: jest.fn(),
        status: jest.fn().mockReturnThis(),
      };

      mockStripe.checkout.sessions.create.mockResolvedValue({
        url: 'https://checkout.stripe.com/test',
        id: 'cs_test123',
      });

      await createCheckoutSession(req, res);

      expect(mockStripe.checkout.sessions.create).toHaveBeenCalledWith({
        payment_method_types: ['card'],
        mode: 'subscription',
        line_items: [{ price: 'price_test123', quantity: 1 }],
        success_url: 'https://example.com/success',
        cancel_url: 'https://example.com/cancel',
        metadata: { 
          studioId: 'studio123',
          type: 'subscription'
        },
        customer_email: 'test@example.com',
      });

      expect(res.json).toHaveBeenCalledWith({
        url: 'https://checkout.stripe.com/test',
        sessionId: 'cs_test123',
      });
    });

    it('should handle validation errors', async () => {
      const req = {
        method: 'POST',
        body: {
          // Missing required fields
        },
      };
      const res = {
        json: jest.fn(),
        status: jest.fn().mockReturnThis(),
      };

      await createCheckoutSession(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        error: 'Failed to create checkout session',
      });
    });

    it('should handle Stripe errors', async () => {
      const req = {
        method: 'POST',
        body: {
          studioId: 'studio123',
          priceId: 'price_test123',
        },
      };
      const res = {
        json: jest.fn(),
        status: jest.fn().mockReturnThis(),
      };

      mockStripe.checkout.sessions.create.mockRejectedValue(
        new Error('Stripe error')
      );

      await createCheckoutSession(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        error: 'Failed to create checkout session',
      });
    });
  });

  describe('stripeWebhook', () => {
    it('should handle checkout.session.completed event', async () => {
      const req = {
        method: 'POST',
        headers: {
          'stripe-signature': 'test_signature',
        },
        rawBody: 'test_body',
      };
      const res = {
        json: jest.fn(),
        status: jest.fn().mockReturnThis(),
        send: jest.fn(),
      };

      const mockEvent = {
        type: 'checkout.session.completed',
        data: {
          object: {
            metadata: {
              studioId: 'studio123',
            },
            subscription: 'sub_test123',
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      expect(mockDoc.update).toHaveBeenCalledWith({
        subscriptionStatus: 'active',
        subscriptionId: 'sub_test123',
        lastPaymentDate: 'server-timestamp',
      });

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should handle customer.subscription.deleted event', async () => {
      const req = {
        method: 'POST',
        headers: {
          'stripe-signature': 'test_signature',
        },
        rawBody: 'test_body',
      };
      const res = {
        json: jest.fn(),
        status: jest.fn().mockReturnThis(),
        send: jest.fn(),
      };

      const mockEvent = {
        type: 'customer.subscription.deleted',
        data: {
          object: {
            id: 'sub_test123',
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should handle webhook signature verification failure', async () => {
      const req = {
        method: 'POST',
        headers: {
          'stripe-signature': 'invalid_signature',
        },
        rawBody: 'test_body',
      };
      const res = {
        json: jest.fn(),
        status: jest.fn().mockReturnThis(),
        send: jest.fn(),
      };

      mockStripe.webhooks.constructEvent.mockImplementation(() => {
        throw new Error('Invalid signature');
      });

      await stripeWebhook(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.send).toHaveBeenCalledWith('Webhook Error: Invalid signature');
    });

    it('should handle webhook processing errors', async () => {
      const req = {
        method: 'POST',
        headers: {
          'stripe-signature': 'test_signature',
        },
        rawBody: 'test_body',
      };
      const res = {
        json: jest.fn(),
        status: jest.fn().mockReturnThis(),
        send: jest.fn(),
      };

      const mockEvent = {
        type: 'checkout.session.completed',
        data: {
          object: {
            metadata: {
              studioId: 'studio123',
            },
            subscription: 'sub_test123',
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);
      mockDoc.update.mockRejectedValue(new Error('Database error'));

      await stripeWebhook(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        error: 'Webhook processing failed',
      });
    });
  });

  describe('cancelSubscription', () => {
    it('should cancel subscription successfully', async () => {
      const data = {
        subscriptionId: 'sub_test123',
      };
      const context = {
        auth: {
          uid: 'user123',
        },
      };

      mockStripe.subscriptions.update.mockResolvedValue({
        id: 'sub_test123',
        cancel_at_period_end: true,
      });

      const result = await cancelSubscription(data, context);

      expect(mockStripe.subscriptions.update).toHaveBeenCalledWith('sub_test123', {
        cancel_at_period_end: true,
      });

      expect(result).toEqual({
        success: true,
        subscription: {
          id: 'sub_test123',
          cancel_at_period_end: true,
        },
      });
    });

    it('should handle validation errors', async () => {
      const data = {
        // Missing subscriptionId
      };
      const context = {
        auth: {
          uid: 'user123',
        },
      };

      await expect(cancelSubscription(data, context)).rejects.toThrow();
    });

    it('should handle Stripe errors', async () => {
      const data = {
        subscriptionId: 'sub_test123',
      };
      const context = {
        auth: {
          uid: 'user123',
        },
      };

      mockStripe.subscriptions.update.mockRejectedValue(
        new Error('Stripe error')
      );

      await expect(cancelSubscription(data, context)).rejects.toThrow();
    });
  });

  describe('sendNotificationToStudio', () => {
    it('should send notification successfully', async () => {
      const data = {
        studioId: 'studio123',
        title: 'Test Notification',
        body: 'This is a test notification',
        data: { key: 'value' },
      };
      const context = {
        auth: {
          uid: 'user123',
        },
      };

      mockDoc.get.mockResolvedValue({
        exists: true,
        data: () => ({
          fcmToken: 'test_fcm_token',
        }),
      });

      mockMessaging.send.mockResolvedValue('message_id_123');

      const result = await sendNotificationToStudio(data, context);

      expect(mockDoc.get).toHaveBeenCalled();
      expect(mockMessaging.send).toHaveBeenCalledWith({
        token: 'test_fcm_token',
        notification: {
          title: 'Test Notification',
          body: 'This is a test notification',
        },
        data: { key: 'value' },
      });

      expect(result).toEqual({
        success: true,
        messageId: 'message_id_123',
      });
    });

    it('should throw error when studio not found', async () => {
      const data = {
        studioId: 'nonexistent_studio',
        title: 'Test Notification',
        body: 'This is a test notification',
      };
      const context = {
        auth: {
          uid: 'user123',
        },
      };

      mockDoc.get.mockResolvedValue({
        exists: false,
      });

      await expect(sendNotificationToStudio(data, context)).rejects.toThrow();
    });

    it('should throw error when no FCM token found', async () => {
      const data = {
        studioId: 'studio123',
        title: 'Test Notification',
        body: 'This is a test notification',
      };
      const context = {
        auth: {
          uid: 'user123',
        },
      };

      mockDoc.get.mockResolvedValue({
        exists: true,
        data: () => ({
          // No fcmToken
        }),
      });

      await expect(sendNotificationToStudio(data, context)).rejects.toThrow();
    });

    it('should handle messaging errors', async () => {
      const data = {
        studioId: 'studio123',
        title: 'Test Notification',
        body: 'This is a test notification',
      };
      const context = {
        auth: {
          uid: 'user123',
        },
      };

      mockDoc.get.mockResolvedValue({
        exists: true,
        data: () => ({
          fcmToken: 'test_fcm_token',
        }),
      });

      mockMessaging.send.mockRejectedValue(new Error('Messaging error'));

      await expect(sendNotificationToStudio(data, context)).rejects.toThrow();
    });
  });

  describe('onNewBooking', () => {
    it('should send FCM notification for new booking', async () => {
      const snap = {
        data: () => ({
          studioId: 'studio123',
          clientName: 'John Doe',
        }),
      };
      const context = {
        params: {
          bookingId: 'booking123',
        },
      };

      mockDoc.get.mockResolvedValue({
        exists: true,
        get: jest.fn(() => 'test_fcm_token'),
      });

      mockMessaging.sendToDevice.mockResolvedValue({
        successCount: 1,
        failureCount: 0,
      });

      const result = await onNewBooking(snap, context);

      expect(mockDoc.get).toHaveBeenCalledWith('fcmToken');
      expect(mockMessaging.sendToDevice).toHaveBeenCalledWith('test_fcm_token', {
        notification: {
          title: 'New Booking',
          body: 'New booking from John Doe',
        },
        data: {
          bookingId: 'booking123',
          studioId: 'studio123',
          type: 'new_booking',
          timestamp: expect.any(String),
        },
        android: {
          notification: {
            channelId: 'bookings',
            priority: 'high',
            defaultSound: true,
          },
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
            },
          },
        },
      });

      expect(result).toBeNull();
    });

    it('should handle studio not found', async () => {
      const snap = {
        data: () => ({
          studioId: 'nonexistent_studio',
          clientName: 'John Doe',
        }),
      };
      const context = {
        params: {
          bookingId: 'booking123',
        },
      };

      mockDoc.get.mockResolvedValue({
        exists: false,
      });

      const result = await onNewBooking(snap, context);

      expect(result).toBeNull();
    });

    it('should handle missing FCM token', async () => {
      const snap = {
        data: () => ({
          studioId: 'studio123',
          clientName: 'John Doe',
        }),
      };
      const context = {
        params: {
          bookingId: 'booking123',
        },
      };

      mockDoc.get.mockResolvedValue({
        exists: true,
        get: jest.fn(() => null),
      });

      const result = await onNewBooking(snap, context);

      expect(result).toBeNull();
    });

    it('should handle messaging errors gracefully', async () => {
      const snap = {
        data: () => ({
          studioId: 'studio123',
          clientName: 'John Doe',
        }),
      };
      const context = {
        params: {
          bookingId: 'booking123',
        },
      };

      mockDoc.get.mockResolvedValue({
        exists: true,
        get: jest.fn(() => 'test_fcm_token'),
      });

      mockMessaging.sendToDevice.mockRejectedValue(new Error('Messaging error'));

      const result = await onNewBooking(snap, context);

      expect(result).toBeNull();
    });
  });
});

// Helper functions for creating mock requests and responses
function createMockRequest(data = {}) {
  return {
    method: 'POST',
    body: data,
    headers: {},
  };
}

function createMockResponse() {
  return {
    status: jest.fn().mockReturnThis(),
    json: jest.fn(),
    send: jest.fn(),
  };
}

function createMockContext(auth = null) {
  return {
    auth: auth,
    params: {},
  };
} 