import * as admin from 'firebase-admin';

// Mock Firebase Admin
jest.mock('firebase-admin', () => ({
  initializeApp: jest.fn(),
  apps: [],
  firestore: jest.fn(() => ({
    collection: jest.fn(),
  })),
}));

// Mock Stripe
const mockStripe = {
  paymentIntents: {
    create: jest.fn(),
  },
};
jest.mock('stripe', () => jest.fn(() => mockStripe));

// Mock validation schemas
jest.mock('../test/validation-schemas', () => ({
  validate: jest.fn((schema, data) => {
    if (data.amount <= 0) {
      throw { code: 'invalid-argument', message: 'Amount must be positive' };
    }
    return data;
  }),
  schemas: {
    createPaymentIntent: 'mock-schema',
  },
}));

// Mock Firebase Functions
jest.mock('firebase-functions', () => ({
  config: jest.fn(() => ({
    stripe: {
      secret_key: 'sk_test_mock_key',
      webhook_secret: 'whsec_mock_secret',
    },
  })),
  https: {
    onCall: jest.fn((handler) => handler),
    onRequest: jest.fn((handler) => handler),
    HttpsError: jest.fn((code, message, details) => ({ code, message, details })),
  },
  pubsub: {
    schedule: jest.fn(() => ({
      onRun: jest.fn((handler) => handler),
    })),
  },
}));

describe('Cloud Functions: createPaymentIntent', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    // Initialize Firebase Admin in test env
    if (!admin.apps.length) admin.initializeApp();
  });

  it('creates payment intent with correct parameters', async () => {
    // Mock Stripe SDK response
    const mockIntent = { 
      client_secret: 'sk_test_secret', 
      id: 'pi_123', 
      status: 'requires_payment_method' 
    };
    mockStripe.paymentIntents.create.mockResolvedValue(mockIntent);

    // Test the core logic by importing the function after mocking
    const { createPaymentIntent } = require('../src/stripe');
    
    const data = { amount: 42.5 };
    const context = { auth: { uid: 'user1' } };
    
    const result = await createPaymentIntent(data, context);
    
    expect(result.clientSecret).toBe('sk_test_secret');
    expect(result.paymentIntentId).toBe('pi_123');
    expect(result.status).toBe('requires_payment_method');
    
    // Verify Stripe was called correctly
    expect(mockStripe.paymentIntents.create).toHaveBeenCalledWith({
      amount: 4250, // 42.5 * 100
      currency: 'eur',
      payment_method_options: {
        card: { request_three_d_secure: 'any' },
      },
      metadata: {
        userId: 'user1',
        type: 'payment',
      },
    });
  });

  it('handles validation errors', async () => {
    const { createPaymentIntent } = require('../src/stripe');
    
    const data = { amount: -5 };
    const context = { auth: { uid: 'user1' } };
    
    await expect(createPaymentIntent(data, context))
      .rejects.toHaveProperty('code', 'invalid-argument');
  });

  it('handles anonymous user', async () => {
    const mockIntent = { 
      client_secret: 'sk_test_secret', 
      id: 'pi_123', 
      status: 'requires_payment_method' 
    };
    mockStripe.paymentIntents.create.mockResolvedValue(mockIntent);

    const { createPaymentIntent } = require('../src/stripe');
    
    const data = { amount: 10 };
    const context = {}; // No auth
    
    const result = await createPaymentIntent(data, context);
    
    expect(result.clientSecret).toBe('sk_test_secret');
    
    // Verify userId is 'anonymous' when no auth
    expect(mockStripe.paymentIntents.create).toHaveBeenCalledWith(
      expect.objectContaining({
        metadata: {
          userId: 'anonymous',
          type: 'payment',
        },
      })
    );
  });
}); 