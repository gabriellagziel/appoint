const admin = require('firebase-admin');
const functions = require('firebase-functions');

// Mock Stripe
jest.mock('stripe', () => {
  return jest.fn(() => ({
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
  config: jest.fn(() => ({
    stripe: {
      secret_key: 'sk_test_123',
      webhook_secret: 'whsec_test_123',
    },
  })),
}));

// Import the webhook handler to test
const { stripeWebhook } = require('../src/index.ts');

describe('Stripe Webhook Simulation Tests', () => {
  let mockDb;
  let mockCollection;
  let mockDoc;
  let mockStripe;

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

      await stripeWebhook(req, res);

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

      await stripeWebhook(req, res);

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

      await stripeWebhook(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should extend subscription when invoice payment succeeds', async () => {
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

      await stripeWebhook(req, res);

      // Verify studio subscription was updated
      expect(mockCollection.doc).toHaveBeenCalledWith('studio123');
      expect(mockDoc.update).toHaveBeenCalledWith({
        subscriptionStatus: 'active',
        lastPaymentDate: 'server-timestamp',
        nextBillingDate: expect.any(Date),
      });
    });
  });

  describe('customer.subscription.created', () => {
    it('should handle customer.subscription.created event', async () => {
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
        type: 'customer.subscription.created',
        data: {
          object: {
            id: 'sub_test123',
            customer: 'cus_test123',
            status: 'active',
            current_period_start: 1234567890,
            current_period_end: 1234567890 + 2592000, // 30 days
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should create subscription record in Firestore', async () => {
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
        type: 'customer.subscription.created',
        data: {
          object: {
            id: 'sub_test123',
            customer: 'cus_test123',
            status: 'active',
            current_period_start: 1234567890,
            current_period_end: 1234567890 + 2592000,
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      // Verify subscription record was created
      expect(mockCollection.add).toHaveBeenCalledWith({
        subscriptionId: 'sub_test123',
        customerId: 'cus_test123',
        studioId: 'studio123',
        status: 'active',
        createdAt: 'server-timestamp',
        currentPeriodStart: new Date(1234567890 * 1000),
        currentPeriodEnd: new Date((1234567890 + 2592000) * 1000),
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
            current_period_start: 1234567890,
            current_period_end: 1234567890 + 2592000,
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should update subscription status in Firestore', async () => {
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
            status: 'past_due',
            current_period_start: 1234567890,
            current_period_end: 1234567890 + 2592000,
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      // Verify subscription was updated
      expect(mockCollection.doc).toHaveBeenCalledWith('studio123');
      expect(mockDoc.update).toHaveBeenCalledWith({
        subscriptionStatus: 'past_due',
        updatedAt: 'server-timestamp',
      });
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
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should cancel subscription in Firestore', async () => {
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
            metadata: {
              studioId: 'studio123',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      // Verify subscription was canceled
      expect(mockCollection.doc).toHaveBeenCalledWith('studio123');
      expect(mockDoc.update).toHaveBeenCalledWith({
        subscriptionStatus: 'canceled',
        canceledAt: 'server-timestamp',
      });
    });
  });

  describe('checkout.session.completed', () => {
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
            id: 'cs_test123',
            customer: 'cus_test123',
            subscription: 'sub_test123',
            metadata: {
              studioId: 'studio123',
              type: 'subscription',
            },
            payment_status: 'paid',
            mode: 'subscription',
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should activate subscription when checkout completes', async () => {
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
            id: 'cs_test123',
            customer: 'cus_test123',
            subscription: 'sub_test123',
            metadata: {
              studioId: 'studio123',
              type: 'subscription',
            },
            payment_status: 'paid',
            mode: 'subscription',
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      // Verify studio subscription was activated
      expect(mockCollection.doc).toHaveBeenCalledWith('studio123');
      expect(mockDoc.update).toHaveBeenCalledWith({
        subscriptionStatus: 'active',
        subscriptionId: 'sub_test123',
        lastPaymentDate: 'server-timestamp',
      });
    });
  });

  describe('payment_intent.payment_failed', () => {
    it('should handle payment_intent.payment_failed event', async () => {
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
        type: 'payment_intent.payment_failed',
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
            status: 'requires_payment_method',
            last_payment_error: {
              message: 'Your card was declined.',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should update booking status when payment fails', async () => {
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
        type: 'payment_intent.payment_failed',
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
            status: 'requires_payment_method',
            last_payment_error: {
              message: 'Your card was declined.',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      // Verify booking status was updated
      expect(mockCollection.doc).toHaveBeenCalledWith('booking123');
      expect(mockDoc.update).toHaveBeenCalledWith({
        paymentStatus: 'failed',
        paymentError: 'Your card was declined.',
        updatedAt: 'server-timestamp',
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

      await stripeWebhook(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should update subscription status when invoice payment fails', async () => {
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

      await stripeWebhook(req, res);

      // Verify subscription status was updated
      expect(mockCollection.doc).toHaveBeenCalledWith('studio123');
      expect(mockDoc.update).toHaveBeenCalledWith({
        subscriptionStatus: 'past_due',
        lastPaymentFailure: 'server-timestamp',
      });
    });
  });

  describe('Error Handling', () => {
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

    it('should handle database errors gracefully', async () => {
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

    it('should handle unknown event types', async () => {
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
        type: 'unknown.event.type',
        data: {
          object: {},
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await stripeWebhook(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });
  });
});

// Helper functions for creating mock webhook events
function createMockWebhookEvent(type, data) {
  return {
    type: type,
    data: {
      object: data,
    },
  };
}

function createMockRequest(signature = 'test_signature', body = 'test_body') {
  return {
    method: 'POST',
    headers: {
      'stripe-signature': signature,
    },
    rawBody: body,
  };
}

function createMockResponse() {
  return {
    status: jest.fn().mockReturnThis(),
    json: jest.fn(),
    send: jest.fn(),
  };
} 