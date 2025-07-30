import * as functions from 'firebase-functions-test';
import * as admin from 'firebase-admin';
import { 
  validateInput, 
  createCheckoutSessionSchema, 
  cancelSubscriptionSchema, 
  sendNotificationToStudioSchema 
} from '../src/validation';

// Mock Firebase Admin
jest.mock('firebase-admin', () => ({
  initializeApp: jest.fn(),
  firestore: jest.fn(() => ({
    collection: jest.fn(),
    runTransaction: jest.fn(),
  })),
  messaging: jest.fn(() => ({
    sendToDevice: jest.fn(),
  })),
}));

// Mock Stripe
jest.mock('stripe', () => jest.fn(() => ({
  checkout: {
    sessions: {
      create: jest.fn(),
    },
  },
  subscriptions: {
    update: jest.fn(),
  },
  webhooks: {
    constructEvent: jest.fn(),
  },
})));

// Import the functions to test
import * as myFunctions from '../src/index';

describe('Cloud Functions TypeScript Unit Tests', () => {
  let adminInitStub: any;
  let dbStub: any;
  let messagingStub: any;

  beforeEach(() => {
    // Setup Firestore mocks
    dbStub = {
      collection: jest.fn(),
      runTransaction: jest.fn(),
    };
    
    (admin.firestore as jest.Mock).mockReturnValue(dbStub);
    
    // Setup messaging mocks
    messagingStub = {
      sendToDevice: jest.fn(),
    };
    (admin.messaging as jest.Mock).mockReturnValue(messagingStub);
    
    // Initialize admin
    adminInitStub = admin.initializeApp();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('HTTP Functions', () => {
    describe('createCheckoutSession', () => {
      it('should create checkout session successfully', async () => {
        const mockSession = {
          url: 'https://checkout.stripe.com/session_123',
          id: 'cs_123',
        };

        const stripe = require('stripe');
        stripe.mockReturnValue({
          checkout: {
            sessions: {
              create: jest.fn().mockResolvedValue(mockSession),
            },
          },
        });

        const req = {
          body: {
            studioId: 'studio123',
            priceId: 'price_123',
            successUrl: 'https://app.com/success',
            cancelUrl: 'https://app.com/cancel',
            customerEmail: 'test@example.com',
          },
        };
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
        };

        await myFunctions.createCheckoutSession(req, res);

        expect(res.json).toHaveBeenCalledWith({
          url: mockSession.url,
          sessionId: mockSession.id,
        });
      });

      it('should handle validation errors', async () => {
        const req = {
          body: {
            studioId: '', // Invalid empty studioId
            priceId: 'price_123',
          },
        };
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
        };

        await myFunctions.createCheckoutSession(req, res);

        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith({
          error: 'Failed to create checkout session',
        });
      });

      it('should handle Stripe errors', async () => {
        const stripe = require('stripe');
        stripe.mockReturnValue({
          checkout: {
            sessions: {
              create: jest.fn().mockRejectedValue(new Error('Stripe error')),
            },
          },
        });

        const req = {
          body: {
            studioId: 'studio123',
            priceId: 'price_123',
          },
        };
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
        };

        await myFunctions.createCheckoutSession(req, res);

        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith({
          error: 'Failed to create checkout session',
        });
      });
    });

    describe('stripeWebhook', () => {
      it('should handle checkout.session.completed event', async () => {
        const mockSession = {
          metadata: { studioId: 'studio123' },
          subscription: 'sub_123',
        };

        const stripe = require('stripe');
        stripe.mockReturnValue({
          webhooks: {
            constructEvent: jest.fn().mockReturnValue({
              type: 'checkout.session.completed',
              data: { object: mockSession },
            }),
          },
        });

        const mockUpdate = jest.fn().mockResolvedValue({});
        dbStub.collection.mockReturnValue({
          doc: jest.fn().mockReturnValue({
            update: mockUpdate,
          }),
        });

        const req = {
          headers: { 'stripe-signature': 'test_signature' },
          rawBody: 'test_body',
        };
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
          send: jest.fn(),
        };

        await myFunctions.stripeWebhook(req, res);

        expect(mockUpdate).toHaveBeenCalledWith({
          subscriptionStatus: 'active',
          subscriptionId: 'sub_123',
          lastPaymentDate: expect.any(Object),
        });
        expect(res.json).toHaveBeenCalledWith({ received: true });
      });

      it('should handle webhook signature verification failure', async () => {
        const stripe = require('stripe');
        stripe.mockReturnValue({
          webhooks: {
            constructEvent: jest.fn().mockImplementation(() => {
              throw new Error('Invalid signature');
            }),
          },
        });

        const req = {
          headers: { 'stripe-signature': 'invalid_signature' },
          rawBody: 'test_body',
        };
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
          send: jest.fn(),
        };

        await myFunctions.stripeWebhook(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.send).toHaveBeenCalledWith('Webhook Error: Invalid signature');
      });

      it('should handle unhandled event types', async () => {
        const stripe = require('stripe');
        stripe.mockReturnValue({
          webhooks: {
            constructEvent: jest.fn().mockReturnValue({
              type: 'unhandled.event.type',
              data: { object: {} },
            }),
          },
        });

        const req = {
          headers: { 'stripe-signature': 'test_signature' },
          rawBody: 'test_body',
        };
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
          send: jest.fn(),
        };

        await myFunctions.stripeWebhook(req, res);

        expect(res.json).toHaveBeenCalledWith({ received: true });
      });
    });
  });

  describe('Callable Functions', () => {
    describe('cancelSubscription', () => {
      it('should cancel subscription successfully', async () => {
        const mockSubscription = { id: 'sub_123', status: 'canceled' };
        const stripe = require('stripe');
        stripe.mockReturnValue({
          subscriptions: {
            update: jest.fn().mockResolvedValue(mockSubscription),
          },
        });

        const data = { subscriptionId: 'sub_123' };
        const context = {
          auth: { uid: 'user123' },
        };

        const result = await myFunctions.cancelSubscription(data, context);

        expect(result).toEqual({
          success: true,
          subscription: mockSubscription,
        });
      });

      it('should throw HttpsError on validation failure', async () => {
        const data = { subscriptionId: '' }; // Invalid empty subscriptionId
        const context = {
          auth: { uid: 'user123' },
        };

        await expect(myFunctions.cancelSubscription(data, context))
          .rejects
          .toThrow('Failed to cancel subscription');
      });

      it('should throw HttpsError on Stripe failure', async () => {
        const stripe = require('stripe');
        stripe.mockReturnValue({
          subscriptions: {
            update: jest.fn().mockRejectedValue(new Error('Stripe error')),
          },
        });

        const data = { subscriptionId: 'sub_123' };
        const context = {
          auth: { uid: 'user123' },
        };

        await expect(myFunctions.cancelSubscription(data, context))
          .rejects
          .toThrow('Failed to cancel subscription');
      });
    });

    describe('sendNotificationToStudio', () => {
      it('should send notification successfully', async () => {
        const mockStudioData = { fcmToken: 'fcm_token_123' };
        const mockStudioSnap = {
          exists: true,
          data: jest.fn().mockReturnValue(mockStudioData),
        };

        dbStub.collection.mockReturnValue({
          doc: jest.fn().mockReturnValue({
            get: jest.fn().mockResolvedValue(mockStudioSnap),
          }),
        });

        messagingStub.sendToDevice.mockResolvedValue({ successCount: 1 });

        const data = {
          studioId: 'studio123',
          title: 'Test Notification',
          body: 'Test message',
          data: { type: 'test' },
        };
        const context = {
          auth: { uid: 'user123' },
        };

        const result = await myFunctions.sendNotificationToStudio(data, context);

        expect(result).toEqual({ success: true });
        expect(messagingStub.sendToDevice).toHaveBeenCalledWith(
          'fcm_token_123',
          expect.objectContaining({
            notification: {
              title: 'Test Notification',
              body: 'Test message',
            },
            data: { type: 'test' },
          })
        );
      });

      it('should throw error when studio not found', async () => {
        const mockStudioSnap = { exists: false };

        dbStub.collection.mockReturnValue({
          doc: jest.fn().mockReturnValue({
            get: jest.fn().mockResolvedValue(mockStudioSnap),
          }),
        });

        const data = {
          studioId: 'nonexistent',
          title: 'Test',
          body: 'Test',
        };
        const context = {
          auth: { uid: 'user123' },
        };

        await expect(myFunctions.sendNotificationToStudio(data, context))
          .rejects
          .toThrow('Studio not found');
      });

      it('should throw error when no FCM token found', async () => {
        const mockStudioData = { fcmToken: null };
        const mockStudioSnap = {
          exists: true,
          data: jest.fn().mockReturnValue(mockStudioData),
        };

        dbStub.collection.mockReturnValue({
          doc: jest.fn().mockReturnValue({
            get: jest.fn().mockResolvedValue(mockStudioSnap),
          }),
        });

        const data = {
          studioId: 'studio123',
          title: 'Test',
          body: 'Test',
        };
        const context = {
          auth: { uid: 'user123' },
        };

        await expect(myFunctions.sendNotificationToStudio(data, context))
          .rejects
          .toThrow('No FCM token found for studio');
      });

      it('should throw error on validation failure', async () => {
        const data = {
          studioId: '', // Invalid empty studioId
          title: 'Test',
          body: 'Test',
        };
        const context = {
          auth: { uid: 'user123' },
        };

        await expect(myFunctions.sendNotificationToStudio(data, context))
          .rejects
          .toThrow('Failed to send notification');
      });
    });
  });

  describe('Firestore Triggers', () => {
    describe('onNewBooking', () => {
      it('should send FCM notification for new booking', async () => {
        const mockBooking = {
          studioId: 'studio123',
          clientName: 'John Doe',
        };

        const mockStudioData = { fcmToken: 'fcm_token_123' };
        const mockStudioSnap = {
          exists: true,
          get: jest.fn().mockReturnValue('fcm_token_123'),
        };

        dbStub.collection.mockReturnValue({
          doc: jest.fn().mockReturnValue({
            get: jest.fn().mockResolvedValue(mockStudioSnap),
          }),
        });

        messagingStub.sendToDevice.mockResolvedValue({ successCount: 1 });

        const snap = {
          data: jest.fn().mockReturnValue(mockBooking),
        };
        const context = { params: { bookingId: 'booking123' } };

        const result = await myFunctions.onNewBooking(snap, context);

        expect(result).toBeNull();
        expect(messagingStub.sendToDevice).toHaveBeenCalledWith(
          'fcm_token_123',
          expect.objectContaining({
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
          })
        );
      });

      it('should handle missing studio', async () => {
        const mockBooking = {
          studioId: 'nonexistent',
          clientName: 'John Doe',
        };

        const mockStudioSnap = { exists: false };

        dbStub.collection.mockReturnValue({
          doc: jest.fn().mockReturnValue({
            get: jest.fn().mockResolvedValue(mockStudioSnap),
          }),
        });

        const snap = {
          data: jest.fn().mockReturnValue(mockBooking),
        };
        const context = { params: { bookingId: 'booking123' } };

        const result = await myFunctions.onNewBooking(snap, context);

        expect(result).toBeNull();
        expect(messagingStub.sendToDevice).not.toHaveBeenCalled();
      });

      it('should handle missing FCM token', async () => {
        const mockBooking = {
          studioId: 'studio123',
          clientName: 'John Doe',
        };

        const mockStudioSnap = {
          exists: true,
          get: jest.fn().mockReturnValue(null),
        };

        dbStub.collection.mockReturnValue({
          doc: jest.fn().mockReturnValue({
            get: jest.fn().mockResolvedValue(mockStudioSnap),
          }),
        });

        const snap = {
          data: jest.fn().mockReturnValue(mockBooking),
        };
        const context = { params: { bookingId: 'booking123' } };

        const result = await myFunctions.onNewBooking(snap, context);

        expect(result).toBeNull();
        expect(messagingStub.sendToDevice).not.toHaveBeenCalled();
      });

      it('should handle FCM sending errors', async () => {
        const mockBooking = {
          studioId: 'studio123',
          clientName: 'John Doe',
        };

        const mockStudioSnap = {
          exists: true,
          get: jest.fn().mockReturnValue('fcm_token_123'),
        };

        dbStub.collection.mockReturnValue({
          doc: jest.fn().mockReturnValue({
            get: jest.fn().mockResolvedValue(mockStudioSnap),
          }),
        });

        messagingStub.sendToDevice.mockRejectedValue(new Error('FCM error'));

        const snap = {
          data: jest.fn().mockReturnValue(mockBooking),
        };
        const context = { params: { bookingId: 'booking123' } };

        const result = await myFunctions.onNewBooking(snap, context);

        expect(result).toBeNull();
      });
    });
  });
}); 