const admin = require('firebase-admin');
const functions = require('firebase-functions-test')({
  projectId: 'test-project',
}, 'test-service-account-key.json');
const { validate, schemas } = require('./validation-schemas');

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
  pubsub: {
    schedule: jest.fn(() => ({
      onRun: jest.fn(),
    })),
  },
  firestore: {
    document: jest.fn(() => ({
      onWrite: jest.fn(),
      onUpdate: jest.fn(),
    })),
  },
  config: jest.fn(() => ({
    stripe: {
      secret_key: 'sk_test_123',
      webhook_secret: 'whsec_test_123',
    },
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
const {
  autoAssignAmbassadors,
  getQuotaStats,
  assignAmbassador,
  scheduledAutoAssign,
  dailyQuotaReport,
  checkAmbassadorEligibility,
  handleAmbassadorRemoval,
  ambassadorQuotas,
} = require('../index.js');

describe('Cloud Functions Unit Tests', () => {
  let adminInitStub;
  let dbStub;
  let messagingStub;

  beforeEach(() => {
    // Setup Firestore mocks
    dbStub = {
      collection: jest.fn(),
      runTransaction: jest.fn(),
    };
    
    admin.firestore.mockReturnValue(dbStub);
    
    // Setup messaging mocks
    messagingStub = {
      sendToDevice: jest.fn(),
    };
    admin.messaging.mockReturnValue(messagingStub);
    
    // Initialize admin
    adminInitStub = admin.initializeApp();
  });

  afterEach(() => {
    functions.cleanup();
    jest.clearAllMocks();
  });

  describe('HTTP Functions', () => {
    describe('autoAssignAmbassadors', () => {
      it('should return success with assigned count', async () => {
        // Mock the autoAssignAvailableSlots function
        const mockAssignedCount = 5;
        jest.spyOn(autoAssignAmbassadors, 'autoAssignAvailableSlots').mockResolvedValue(mockAssignedCount);

        const req = { body: {} };
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
        };

        await autoAssignAmbassadors(req, res);

        expect(res.json).toHaveBeenCalledWith({
          success: true,
          assignedCount: mockAssignedCount,
          message: `Successfully assigned ${mockAssignedCount} ambassadors`,
        });
      });

      it('should handle errors and return 500 status', async () => {
        const mockError = new Error('Database error');
        jest.spyOn(autoAssignAmbassadors, 'autoAssignAvailableSlots').mockRejectedValue(mockError);

        const req = { body: {} };
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
        };

        await autoAssignAmbassadors(req, res);

        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith({
          success: false,
          error: 'Database error',
        });
      });
    });

    describe('getQuotaStats', () => {
      it('should return quota statistics successfully', async () => {
        const mockStats = { 'US_en': { current: 100, quota: 345 } };
        const mockGlobalStats = { totalAmbassadors: 1000, totalQuota: 6675 };

        jest.spyOn(getQuotaStats, 'getQuotaStatistics').mockResolvedValue(mockStats);
        jest.spyOn(getQuotaStats, 'getGlobalStatistics').mockResolvedValue(mockGlobalStats);

        const req = {};
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
        };

        await getQuotaStats(req, res);

        expect(res.json).toHaveBeenCalledWith({
          success: true,
          globalStats: mockGlobalStats,
          countryStats: mockStats,
        });
      });

      it('should handle errors in getQuotaStats', async () => {
        const mockError = new Error('Stats calculation failed');
        jest.spyOn(getQuotaStats, 'getQuotaStatistics').mockRejectedValue(mockError);

        const req = {};
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
        };

        await getQuotaStats(req, res);

        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith({
          success: false,
          error: 'Stats calculation failed',
        });
      });
    });

    describe('assignAmbassador', () => {
      it('should assign ambassador successfully with valid data', async () => {
        const mockSuccess = true;
        jest.spyOn(assignAmbassador, 'assignAmbassador').mockResolvedValue(mockSuccess);

        const req = {
          body: {
            userId: 'user123',
            countryCode: 'US',
            languageCode: 'en',
          },
        };
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
        };

        await assignAmbassador(req, res);

        expect(res.json).toHaveBeenCalledWith({
          success: true,
          message: 'Ambassador assigned successfully',
        });
      });

      it('should handle validation errors', async () => {
        const validationError = new Error('Invalid input');
        validationError.code = 'invalid-argument';
        validationError.details = { field: 'userId' };

        jest.spyOn(assignAmbassador, 'assignAmbassador').mockRejectedValue(validationError);

        const req = {
          body: {
            userId: '', // Invalid empty userId
            countryCode: 'US',
            languageCode: 'en',
          },
        };
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
        };

        await assignAmbassador(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
          success: false,
          error: 'Invalid input',
          field: 'userId',
        });
      });

      it('should handle assignment failure', async () => {
        const mockSuccess = false;
        jest.spyOn(assignAmbassador, 'assignAmbassador').mockResolvedValue(mockSuccess);

        const req = {
          body: {
            userId: 'user123',
            countryCode: 'US',
            languageCode: 'en',
          },
        };
        const res = {
          json: jest.fn(),
          status: jest.fn().mockReturnThis(),
        };

        await assignAmbassador(req, res);

        expect(res.json).toHaveBeenCalledWith({
          success: false,
          message: 'Failed to assign ambassador',
        });
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

        const result = await dailyQuotaReport(data, context);

        expect(result).toEqual({
          success: true,
          subscription: mockSubscription,
        });
      });

      it('should throw HttpsError on failure', async () => {
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

        await expect(dailyQuotaReport(data, context))
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

        const result = await dailyQuotaReport(data, context);

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

        await expect(dailyQuotaReport(data, context))
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

        await expect(dailyQuotaReport(data, context))
          .rejects
          .toThrow('No FCM token found for studio');
      });
    });
  });

  describe('Firestore Triggers', () => {
    describe('checkAmbassadorEligibility', () => {
      it('should assign ambassador when user becomes eligible', async () => {
        const mockUserData = {
          countryCode: 'US',
          languageCode: 'en',
          isAdult: true,
          role: 'user',
        };
        const mockPreviousData = {
          isAdult: false,
          role: 'user',
        };

        jest.spyOn(checkAmbassadorEligibility, 'isUserEligible').mockResolvedValue(true);
        jest.spyOn(checkAmbassadorEligibility, 'hasAvailableSlots').mockResolvedValue(true);
        jest.spyOn(checkAmbassadorEligibility, 'assignAmbassador').mockResolvedValue(true);

        const change = {
          after: { data: () => mockUserData },
          before: { data: () => mockPreviousData },
        };
        const context = { params: { userId: 'user123' } };

        const result = await checkAmbassadorEligibility(change, context);

        expect(result).toBeNull();
        expect(checkAmbassadorEligibility.assignAmbassador).toHaveBeenCalledWith(
          'user123',
          'US',
          'en'
        );
      });

      it('should not assign ambassador when user is not eligible', async () => {
        const mockUserData = {
          countryCode: 'US',
          languageCode: 'en',
          isAdult: false,
          role: 'user',
        };

        jest.spyOn(checkAmbassadorEligibility, 'isUserEligible').mockResolvedValue(false);

        const change = {
          after: { data: () => mockUserData },
          before: { data: () => null },
        };
        const context = { params: { userId: 'user123' } };

        const result = await checkAmbassadorEligibility(change, context);

        expect(result).toBeNull();
        expect(checkAmbassadorEligibility.assignAmbassador).not.toHaveBeenCalled();
      });
    });

    describe('handleAmbassadorRemoval', () => {
      it('should log removal when ambassador becomes inactive', async () => {
        const mockNewData = {
          status: 'inactive',
          countryCode: 'US',
          languageCode: 'en',
        };
        const mockPreviousData = {
          status: 'active',
          countryCode: 'US',
          languageCode: 'en',
        };

        const mockAdd = jest.fn().mockResolvedValue({ id: 'log123' });
        dbStub.collection.mockReturnValue({
          add: mockAdd,
        });

        const change = {
          after: { data: () => mockNewData },
          before: { data: () => mockPreviousData },
        };
        const context = { params: { ambassadorId: 'ambassador123' } };

        const result = await handleAmbassadorRemoval(change, context);

        expect(result).toBeNull();
        expect(mockAdd).toHaveBeenCalledWith({
          ambassadorId: 'ambassador123',
          countryCode: 'US',
          languageCode: 'en',
          removedAt: expect.any(Object),
          reason: 'status_change_to_inactive',
        });
      });

      it('should not log when status change is not to inactive', async () => {
        const mockNewData = {
          status: 'active',
          countryCode: 'US',
          languageCode: 'en',
        };
        const mockPreviousData = {
          status: 'pending',
          countryCode: 'US',
          languageCode: 'en',
        };

        const mockAdd = jest.fn();
        dbStub.collection.mockReturnValue({
          add: mockAdd,
        });

        const change = {
          after: { data: () => mockNewData },
          before: { data: () => mockPreviousData },
        };
        const context = { params: { ambassadorId: 'ambassador123' } };

        const result = await handleAmbassadorRemoval(change, context);

        expect(result).toBeNull();
        expect(mockAdd).not.toHaveBeenCalled();
      });
    });
  });

  describe('Scheduled Functions', () => {
    describe('scheduledAutoAssign', () => {
      it('should run auto-assignment successfully', async () => {
        const mockAssignedCount = 3;
        jest.spyOn(scheduledAutoAssign, 'autoAssignAvailableSlots').mockResolvedValue(mockAssignedCount);

        const context = {};

        const result = await scheduledAutoAssign(context);

        expect(result).toBeNull();
        expect(scheduledAutoAssign.autoAssignAvailableSlots).toHaveBeenCalled();
      });

      it('should handle errors gracefully', async () => {
        const mockError = new Error('Scheduled assignment failed');
        jest.spyOn(scheduledAutoAssign, 'autoAssignAvailableSlots').mockRejectedValue(mockError);

        const context = {};

        const result = await scheduledAutoAssign(context);

        expect(result).toBeNull();
      });
    });

    describe('dailyQuotaReport', () => {
      it('should generate and store daily report', async () => {
        const mockStats = { 'US_en': { current: 100, quota: 345 } };
        const mockGlobalStats = { totalAmbassadors: 1000, totalQuota: 6675 };

        jest.spyOn(dailyQuotaReport, 'getQuotaStatistics').mockResolvedValue(mockStats);
        jest.spyOn(dailyQuotaReport, 'getGlobalStatistics').mockResolvedValue(mockGlobalStats);

        const mockAdd = jest.fn().mockResolvedValue({ id: 'report123' });
        dbStub.collection.mockReturnValue({
          add: mockAdd,
        });

        const context = {};

        const result = await dailyQuotaReport(context);

        expect(result).toBeNull();
        expect(mockAdd).toHaveBeenCalledWith({
          date: expect.any(Object),
          globalStats: mockGlobalStats,
          countryStats: mockStats,
          reportType: 'daily',
        });
      });
    });
  });
});

describe('Cloud Functions - Helper Functions', () => {
  let mockDb;
  let mockCollection;
  let mockDoc;

  beforeEach(() => {
    jest.clearAllMocks();
    
    mockDoc = {
      get: jest.fn(),
      set: jest.fn(),
      update: jest.fn(),
    };

    mockCollection = {
      doc: jest.fn(() => mockDoc),
      add: jest.fn(),
      where: jest.fn(),
    };

    mockDb = {
      collection: jest.fn(() => mockCollection),
    };

    admin.firestore.mockReturnValue(mockDb);
  });

  describe('ambassadorQuotas', () => {
    it('should contain valid quota data', () => {
      expect(ambassadorQuotas).toBeDefined();
      expect(typeof ambassadorQuotas).toBe('object');
      
      // Check some specific quotas
      expect(ambassadorQuotas['US_en']).toBe(345);
      expect(ambassadorQuotas['CA_en']).toBe(54);
      expect(ambassadorQuotas['JP_ja']).toBe(116);
      
      // Check total quota
      const totalQuota = Object.values(ambassadorQuotas).reduce((sum, quota) => sum + quota, 0);
      expect(totalQuota).toBe(6675);
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