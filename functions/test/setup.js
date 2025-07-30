// Mock Firebase Admin
jest.mock('firebase-admin', () => ({
  initializeApp: jest.fn(),
  firestore: jest.fn(() => ({
    collection: jest.fn(() => ({
      doc: jest.fn(() => ({
        get: jest.fn(),
        set: jest.fn(),
        update: jest.fn(),
        delete: jest.fn(),
      })),
      where: jest.fn(() => ({
        where: jest.fn(() => ({
          where: jest.fn(() => ({
            orderBy: jest.fn(() => ({
              limit: jest.fn(() => ({
                get: jest.fn(),
              })),
            })),
          })),
        })),
      })),
      add: jest.fn(),
      get: jest.fn(),
    })),
    runTransaction: jest.fn(),
    FieldValue: {
      serverTimestamp: jest.fn(() => 'serverTimestamp'),
    },
  })),
  messaging: jest.fn(() => ({
    sendToDevice: jest.fn(),
    send: jest.fn(),
  })),
}));

// Mock Firebase Functions
jest.mock('firebase-functions', () => ({
  https: {
    onRequest: jest.fn((handler) => handler),
    onCall: jest.fn((handler) => handler),
  },
  pubsub: {
    schedule: jest.fn(() => ({
      onRun: jest.fn((handler) => handler),
    })),
  },
  firestore: {
    document: jest.fn(() => ({
      onWrite: jest.fn((handler) => handler),
      onUpdate: jest.fn((handler) => handler),
      onCreate: jest.fn((handler) => handler),
      onDelete: jest.fn((handler) => handler),
    })),
  },
  config: jest.fn(() => ({
    stripe: {
      secret_key: 'test_secret_key',
      webhook_secret: 'test_webhook_secret',
    },
  })),
}));

// Global test utilities
global.createMockRequest = (data = {}, headers = {}) => ({
  body: data,
  headers: {
    'content-type': 'application/json',
    ...headers,
  },
  method: 'POST',
  rawBody: JSON.stringify(data),
});

global.createMockResponse = () => {
  const res = {
    status: jest.fn(() => res),
    json: jest.fn(() => res),
    send: jest.fn(() => res),
    set: jest.fn(() => res),
  };
  return res;
};

global.createMockContext = (params = {}) => ({
  params,
  auth: {
    uid: 'test-user-id',
    email: 'test@example.com',
  },
}); 