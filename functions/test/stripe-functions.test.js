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
      retrieve: jest.fn(),
      update: jest.fn(),
    },
    paymentIntents: {
      create: jest.fn(),
    },
    webhooks: {
      constructEvent: jest.fn(),
    },
  }));
});

// Import the functions to test
const { 
  createCheckoutSession,
  confirmSession,
  handleCheckoutSessionCompleted,
  cancelSubscription,
  createPaymentIntent 
} = require('../src/stripe');

describe('Stripe Functions', () => {
  let mockDb;
  let mockCollection;
  let mockDoc;
  let mockStripe;

  beforeEach(() => {
    jest.clearAllMocks();
    
    // Setup mock Firestore
    mockDoc = {
      get: jest.fn(() => Promise.resolve({ exists: true, data: () => ({ fcmToken: 'test-token' }) })),
      set: jest.fn(() => Promise.resolve()),
      update: jest.fn(() => Promise.resolve()),
    };

    mockCollection = {
      doc: jest.fn(() => mockDoc),
      add: jest.fn(() => Promise.resolve({ id: 'test-id' })),
    };

    mockDb = {
      collection: jest.fn(() => mockCollection),
    };

    admin.firestore.mockReturnValue(mockDb);

    // Setup mock Stripe
    const Stripe = require('stripe');
    mockStripe = new Stripe();
  });

  describe('createCheckoutSession', () => {
    it('should create checkout session successfully', async () => {
      const req = createMockRequest({
        studioId: 'test-studio',
        priceId: 'price_test123',
        successUrl: 'https://example.com/success',
        cancelUrl: 'https://example.com/cancel',
      });
      const res = createMockResponse();

      mockStripe.checkout.sessions.create.mockResolvedValue({
        url: 'https://checkout.stripe.com/test',
      });

      await createCheckoutSession(req, res);

      expect(mockStripe.checkout.sessions.create).toHaveBeenCalledWith({
        payment_method_types: ['card'],
        mode: 'subscription',
        line_items: [
          {
            price: 'price_test123',
            quantity: 1,
          },
        ],
        success_url: 'https://example.com/success',
        cancel_url: 'https://example.com/cancel',
        client_reference_id: 'test-studio',
        metadata: {
          studioId: 'test-studio',
        },
      });

      expect(res.json).toHaveBeenCalledWith({
        url: 'https://checkout.stripe.com/test',
      });
    });

    it('should handle missing required parameters', async () => {
      const req = createMockRequest({
        studioId: 'test-studio',
        // Missing priceId
      });
      const res = createMockResponse();

      await createCheckoutSession(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        error: 'Missing required parameters',
      });
    });

    it('should handle Stripe errors', async () => {
      const req = createMockRequest({
        studioId: 'test-studio',
        priceId: 'price_test123',
      });
      const res = createMockResponse();

      mockStripe.checkout.sessions.create.mockRejectedValue(
        new Error('Stripe error')
      );

      await createCheckoutSession(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        error: 'Failed to create checkout session',
      });
    });

    it('should handle OPTIONS request for CORS', async () => {
      const req = {
        ...createMockRequest(),
        method: 'OPTIONS',
      };
      const res = createMockResponse();

      await createCheckoutSession(req, res);

      expect(res.status).toHaveBeenCalledWith(204);
      expect(res.send).toHaveBeenCalledWith('');
    });
  });

  describe('confirmSession', () => {
    it('should confirm paid session successfully', async () => {
      const req = createMockRequest({
        sessionId: 'cs_test123',
        studioId: 'test-studio',
      });
      const res = createMockResponse();

      mockStripe.checkout.sessions.retrieve.mockResolvedValue({
        payment_status: 'paid',
        subscription: 'sub_test123',
      });

      mockStripe.subscriptions.retrieve.mockResolvedValue({
        id: 'sub_test123',
        status: 'active',
        customer: 'cus_test123',
        current_period_end: 1234567890,
        created: 1234567890,
      });

      await confirmSession(req, res);

      expect(mockDoc.update).toHaveBeenCalledWith(
        expect.objectContaining({
          subscriptionStatus: 'active',
          subscriptionData: expect.objectContaining({
            sessionId: 'cs_test123',
            subscriptionId: 'sub_test123',
            customerId: 'cus_test123',
            status: 'active',
          }),
        })
      );

      expect(res.json).toHaveBeenCalledWith({
        success: true,
        subscription: expect.objectContaining({
          id: 'sub_test123',
          status: 'active',
          currentPeriodEnd: 1234567890,
        }),
      });
    });

    it('should reject unpaid session', async () => {
      const req = createMockRequest({
        sessionId: 'cs_test123',
        studioId: 'test-studio',
      });
      const res = createMockResponse();

      mockStripe.checkout.sessions.retrieve.mockResolvedValue({
        payment_status: 'unpaid',
      });

      await confirmSession(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        error: 'Payment not completed',
      });
    });

    it('should handle missing parameters', async () => {
      const req = createMockRequest({
        sessionId: 'cs_test123',
        // Missing studioId
      });
      const res = createMockResponse();

      await confirmSession(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        error: 'Missing required parameters',
      });
    });
  });

  describe('handleCheckoutSessionCompleted', () => {
    it('should handle checkout.session.completed event', async () => {
      const req = createMockRequest({}, {
        'stripe-signature': 'test_signature',
      });
      const res = createMockResponse();

      const mockEvent = {
        type: 'checkout.session.completed',
        data: {
          object: {
            metadata: {
              studioId: 'test-studio',
            },
            subscription: 'sub_test123',
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await handleCheckoutSessionCompleted(req, res);

      expect(mockDoc.update).toHaveBeenCalledWith({
        subscriptionStatus: 'active',
        subscriptionId: 'sub_test123',
        lastPaymentDate: 'serverTimestamp',
      });

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should handle customer.subscription.updated event', async () => {
      const req = createMockRequest({}, {
        'stripe-signature': 'test_signature',
      });
      const res = createMockResponse();

      const mockEvent = {
        type: 'customer.subscription.updated',
        data: {
          object: {
            id: 'sub_test123',
            status: 'active',
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);

      await handleCheckoutSessionCompleted(req, res);

      expect(res.json).toHaveBeenCalledWith({ received: true });
    });

    it('should handle webhook signature verification failure', async () => {
      const req = createMockRequest({}, {
        'stripe-signature': 'invalid_signature',
      });
      const res = createMockResponse();

      mockStripe.webhooks.constructEvent.mockImplementation(() => {
        throw new Error('Invalid signature');
      });

      await handleCheckoutSessionCompleted(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.send).toHaveBeenCalledWith(
        'Webhook Error: Invalid signature'
      );
    });

    it('should handle webhook processing errors', async () => {
      const req = createMockRequest({}, {
        'stripe-signature': 'test_signature',
      });
      const res = createMockResponse();

      const mockEvent = {
        type: 'checkout.session.completed',
        data: {
          object: {
            metadata: {
              studioId: 'test-studio',
            },
          },
        },
      };

      mockStripe.webhooks.constructEvent.mockReturnValue(mockEvent);
      mockDoc.update.mockRejectedValue(new Error('Database error'));

      await handleCheckoutSessionCompleted(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        error: 'Webhook handler failed',
      });
    });
  });

  describe('cancelSubscription', () => {
    it('should cancel subscription successfully', async () => {
      const req = createMockRequest({
        studioId: 'test-studio',
        subscriptionId: 'sub_test123',
      });
      const res = createMockResponse();

      mockStripe.subscriptions.update.mockResolvedValue({
        id: 'sub_test123',
        status: 'active',
        cancel_at_period_end: true,
        current_period_end: 1234567890,
      });

      await cancelSubscription(req, res);

      expect(mockStripe.subscriptions.update).toHaveBeenCalledWith(
        'sub_test123',
        { cancel_at_period_end: true }
      );

      expect(mockDoc.update).toHaveBeenCalledWith({
        subscriptionStatus: 'cancelling',
        subscriptionData: expect.objectContaining({
          subscriptionId: 'sub_test123',
          cancelAtPeriodEnd: true,
        }),
        lastUpdated: 'serverTimestamp',
      });

      expect(res.json).toHaveBeenCalledWith({
        success: true,
        subscription: expect.objectContaining({
          id: 'sub_test123',
          status: 'active',
          cancelAtPeriodEnd: true,
        }),
      });
    });

    it('should handle missing parameters', async () => {
      const req = createMockRequest({
        studioId: 'test-studio',
        // Missing subscriptionId
      });
      const res = createMockResponse();

      await cancelSubscription(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        error: 'Missing required parameters',
      });
    });
  });

  describe('createPaymentIntent', () => {
    it('should create payment intent with 3D Secure', async () => {
      const data = { amount: 1000 };
      const context = createMockContext();

      mockStripe.paymentIntents.create.mockResolvedValue({
        client_secret: 'pi_test_secret',
        id: 'pi_test123',
        status: 'requires_payment_method',
      });

      const result = await createPaymentIntent(data, context);

      expect(mockStripe.paymentIntents.create).toHaveBeenCalledWith({
        amount: 100000, // Converted to cents
        currency: 'eur',
        payment_method_options: {
          card: { request_three_d_secure: 'any' },
        },
        metadata: {
          userId: 'test-user-id',
          type: 'payment',
        },
      });

      expect(result).toEqual({
        clientSecret: 'pi_test_secret',
        paymentIntentId: 'pi_test123',
        status: 'requires_payment_method',
      });
    });

    it('should reject invalid amount', async () => {
      const data = { amount: 0 };
      const context = createMockContext();

      await expect(createPaymentIntent(data, context)).rejects.toThrow(
        functions.https.HttpsError
      );
    });

    it('should handle Stripe errors', async () => {
      const data = { amount: 1000 };
      const context = createMockContext();

      mockStripe.paymentIntents.create.mockRejectedValue(
        new Error('Stripe error')
      );

      await expect(createPaymentIntent(data, context)).rejects.toThrow(
        functions.https.HttpsError
      );
    });
  });
}); 