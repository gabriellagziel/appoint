import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

// Mock Firebase Admin
jest.mock('firebase-admin', () => ({
  initializeApp: jest.fn(),
  apps: [],
  firestore: jest.fn(() => ({
    collection: jest.fn(),
  })),
  FieldValue: {
    serverTimestamp: jest.fn(() => 'server-timestamp'),
  },
}));

// Mock Stripe
const mockStripe = {
  webhooks: {
    constructEvent: jest.fn(),
  },
  subscriptions: {
    retrieve: jest.fn(),
  },
  paymentIntents: {
    retrieve: jest.fn(),
  },
};
jest.mock('stripe', () => jest.fn(() => mockStripe));

// Mock Firebase Functions
jest.mock('firebase-functions', () => ({
  config: jest.fn(() => ({
    stripe: {
      secret_key: 'sk_test_mock_key',
      webhook_secret: 'whsec_mock_secret',
    },
  })),
  https: {
    onRequest: jest.fn((handler) => handler),
    onCall: jest.fn((handler) => handler),
    HttpsError: jest.fn((code, message, details) => ({ code, message, details })),
  },
  pubsub: {
    schedule: jest.fn(() => ({
      onRun: jest.fn((handler) => handler),
    })),
  },
}));

describe('Stripe Webhook Simulation Tests', () => {
  let mockDb: any;
  let mockCollection: any;
  let mockDoc: any;
  let webhookHandler: any;

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

    (admin.firestore as any).mockReturnValue(mockDb);

    // Import the webhook handler after mocking
    const { handleCheckoutSessionCompleted } = require('../src/stripe');
    webhookHandler = handleCheckoutSessionCompleted;
  });

  describe('payment_intent.succeeded', () => {
    it('should handle payment_intent.succeeded event', async () => {
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
        type: 'payment_intent.succeeded',
        data: {
          object: {
            id: 'pi_test123',
            amount: 2000, // $20.00
            currency: 'usd',
            customer: 'cus_test123',
            metadata: {
              studioId: 'studio123',
              bookingId: 'booking123',
            },
            payment_method: 'pm_test123',
            status: 'succeeded',
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await webhookHandler(req, res);

      // Verify the event was processed
      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should update booking status when payment succeeds', async () => {
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
        type: 'payment_intent.succeeded',
        data: {
          object: {
            id: 'pi_test123',
            amount: 2000,
            currency: 'usd',
            customer: 'cus_test123',
            metadata: {
              studioId: 'studio123',
              bookingId: 'booking123',
            },
            status: 'succeeded',
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await webhookHandler(req, res);

      // Verify Firestore was called to update booking
      expect(mockCollection.doc).toHaveBeenCalledWith('booking123');
      expect(mockDoc.update).toHaveBeenCalledWith({
        paymentStatus: 'paid',
        paymentIntentId: 'pi_test123',
        paidAt: 'server-timestamp',
      });
    });
  });

  describe('invoice.payment_succeeded', () => {
    it('should handle invoice.payment_succeeded event', async () => {
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
        type: 'invoice.payment_succeeded',
        data: {
          object: {
            id: 'in_test123',
            subscription: 'sub_test123',
            customer: 'cus_test123',
            amount_paid: 2999, // $29.99
            currency: 'usd',
            status: 'paid',
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await webhookHandler(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should update subscription status when invoice payment succeeds', async () => {
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
        type: 'invoice.payment_succeeded',
        data: {
          object: {
            id: 'in_test123',
            subscription: 'sub_test123',
            customer: 'cus_test123',
            amount_paid: 2999,
            currency: 'usd',
            status: 'paid',
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await webhookHandler(req, res);

      // Verify subscription was updated
      expect(mockCollection.doc).toHaveBeenCalledWith('studio123');
      expect(mockDoc.update).toHaveBeenCalledWith({
        subscriptionStatus: 'active',
        lastPaymentDate: 'server-timestamp',
      });
    });
  });

  describe('customer.subscription.updated', () => {
    it('should handle customer.subscription.updated event', async () => {
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
        type: 'customer.subscription.updated',
        data: {
          object: {
            id: 'sub_test123',
            customer: 'cus_test123',
            status: 'active',
            current_period_end: 1640995200, // 2022-01-01
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await webhookHandler(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });
  });

  describe('customer.subscription.deleted', () => {
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
            customer: 'cus_test123',
            status: 'canceled',
            canceled_at: 1640995200,
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await webhookHandler(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should update studio subscription status when subscription is deleted', async () => {
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
            customer: 'cus_test123',
            status: 'canceled',
            canceled_at: 1640995200,
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await webhookHandler(req, res);

      // Verify studio subscription was updated
      expect(mockCollection.doc).toHaveBeenCalledWith('studio123');
      expect(mockDoc.update).toHaveBeenCalledWith({
        subscriptionStatus: 'canceled',
        subscriptionCanceledAt: 'server-timestamp',
      });
    });
  });

  describe('invoice.payment_failed', () => {
    it('should handle invoice.payment_failed event', async () => {
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
        type: 'invoice.payment_failed',
        data: {
          object: {
            id: 'in_test123',
            subscription: 'sub_test123',
            customer: 'cus_test123',
            amount_due: 2999,
            currency: 'usd',
            status: 'open',
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await webhookHandler(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should update subscription status when payment fails', async () => {
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
        type: 'invoice.payment_failed',
        data: {
          object: {
            id: 'in_test123',
            subscription: 'sub_test123',
            customer: 'cus_test123',
            amount_due: 2999,
            currency: 'usd',
            status: 'open',
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await webhookHandler(req, res);

      // Verify subscription status was updated
      expect(mockCollection.doc).toHaveBeenCalledWith('studio123');
      expect(mockDoc.update).toHaveBeenCalledWith({
        subscriptionStatus: 'payment_failed',
        lastPaymentFailure: 'server-timestamp',
      });
    });
  });

  describe('webhook signature verification', () => {
    it('should reject webhook with invalid signature', async () => {
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

      await webhookHandler(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.send).toHaveBeenCalledWith('Webhook Error: Invalid signature');
    });
  });

  describe('unhandled event types', () => {
    it('should handle unhandled event types gracefully', async () => {
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
        type: 'account.updated',
        data: {
          object: {
            id: 'acct_test123',
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await webhookHandler(req, res);

      // Should still return success for unhandled events
      expect(res.json).toHaveBeenCalledWith({ received: true });
    });
  });
}); 