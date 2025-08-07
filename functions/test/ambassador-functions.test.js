const admin = require('firebase-admin');
const functions = require('firebase-functions');

// Import the functions to test
const { 
  autoAssignAmbassadors, 
  getQuotaStats, 
  assignAmbassador,
  scheduledAutoAssign,
  dailyQuotaReport,
  checkAmbassadorEligibility,
  handleAmbassadorRemoval 
} = require('../index');

describe('Ambassador Functions', () => {
  let mockDb;
  let mockCollection;
  let mockDoc;
  let mockSnapshot;

  beforeEach(() => {
    // Reset all mocks
    jest.clearAllMocks();
    
    // Setup mock Firestore
    mockSnapshot = {
      size: 0,
      empty: true,
      docs: [],
      exists: false,
      data: jest.fn(() => null),
    };

    mockDoc = {
      get: jest.fn(() => Promise.resolve(mockSnapshot)),
      set: jest.fn(() => Promise.resolve()),
      update: jest.fn(() => Promise.resolve()),
      delete: jest.fn(() => Promise.resolve()),
    };

    mockCollection = {
      doc: jest.fn(() => mockDoc),
      where: jest.fn(() => mockCollection),
      orderBy: jest.fn(() => mockCollection),
      limit: jest.fn(() => mockCollection),
      add: jest.fn(() => Promise.resolve({ id: 'test-id' })),
      get: jest.fn(() => Promise.resolve(mockSnapshot)),
    };

    mockDb = {
      collection: jest.fn(() => mockCollection),
      runTransaction: jest.fn((callback) => callback({
        get: jest.fn(() => Promise.resolve(mockSnapshot)),
        update: jest.fn(),
        set: jest.fn(),
      })),
    };

    admin.firestore.mockReturnValue(mockDb);
  });

  describe('autoAssignAmbassadors', () => {
    it('should return success with assigned count', async () => {
      const req = createMockRequest();
      const res = createMockResponse();

      // Mock successful assignment
      mockDb.runTransaction.mockImplementation((callback) => {
        const transaction = {
          get: jest.fn(() => Promise.resolve({ size: 0 })),
          update: jest.fn(),
          set: jest.fn(),
        };
        return callback(transaction);
      });

      await autoAssignAmbassadors(req, res);

      expect(res.json).toHaveBeenCalledWith({
        success: true,
        assignedCount: expect.any(Number),
        message: expect.stringContaining('Successfully assigned'),
      });
    });

    it('should handle errors gracefully', async () => {
      const req = createMockRequest();
      const res = createMockResponse();

      mockDb.runTransaction.mockRejectedValue(new Error('Database error'));

      await autoAssignAmbassadors(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Database error',
      });
    });
  });

  describe('getQuotaStats', () => {
    it('should return quota statistics', async () => {
      const req = createMockRequest();
      const res = createMockResponse();

      await getQuotaStats(req, res);

      expect(res.json).toHaveBeenCalledWith({
        success: true,
        globalStats: expect.objectContaining({
          totalQuota: expect.any(Number),
          totalCurrent: expect.any(Number),
          totalAvailable: expect.any(Number),
          globalUtilizationPercentage: expect.any(Number),
        }),
        countryStats: expect.any(Object),
      });
    });

    it('should handle database errors', async () => {
      const req = createMockRequest();
      const res = createMockResponse();

      mockCollection.get.mockRejectedValue(new Error('Database error'));

      await getQuotaStats(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Database error',
      });
    });
  });

  describe('assignAmbassador', () => {
    it('should assign ambassador successfully', async () => {
      const req = createMockRequest({
        userId: 'test-user',
        countryCode: 'US',
        languageCode: 'en',
      });
      const res = createMockResponse();

      // Mock user eligibility
      mockDoc.get.mockResolvedValue({
        exists: true,
        data: () => ({
          isAdult: true,
          role: 'user',
          countryCode: 'US',
          languageCode: 'en',
        }),
      });

      // Mock available slots
      mockCollection.get.mockResolvedValue({ size: 0 });

      await assignAmbassador(req, res);

      expect(res.json).toHaveBeenCalledWith({
        success: true,
        message: 'Ambassador assigned successfully',
      });
    });

    it('should reject invalid parameters', async () => {
      const req = createMockRequest({
        userId: 'test-user',
        // Missing countryCode and languageCode
      });
      const res = createMockResponse();

      await assignAmbassador(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Missing required parameters: userId, countryCode, languageCode',
      });
    });

    it('should handle user not eligible', async () => {
      const req = createMockRequest({
        userId: 'test-user',
        countryCode: 'US',
        languageCode: 'en',
      });
      const res = createMockResponse();

      // Mock user not eligible
      mockDoc.get.mockResolvedValue({
        exists: true,
        data: () => ({
          isAdult: false, // Not an adult
          role: 'user',
        }),
      });

      await assignAmbassador(req, res);

      expect(res.json).toHaveBeenCalledWith({
        success: false,
        message: 'Failed to assign ambassador',
      });
    });
  });

  describe('scheduledAutoAssign', () => {
    it('should run scheduled assignment', async () => {
      const context = createMockContext();

      const result = await scheduledAutoAssign(context);

      expect(result).toBeNull();
    });

    it('should handle errors in scheduled function', async () => {
      const context = createMockContext();

      mockDb.runTransaction.mockRejectedValue(new Error('Scheduled error'));

      const result = await scheduledAutoAssign(context);

      expect(result).toBeNull();
    });
  });

  describe('dailyQuotaReport', () => {
    it('should generate daily report', async () => {
      const context = createMockContext();

      const result = await dailyQuotaReport(context);

      expect(result).toBeNull();
      expect(mockCollection.add).toHaveBeenCalledWith(
        expect.objectContaining({
          reportType: 'daily',
        })
      );
    });
  });

  describe('checkAmbassadorEligibility', () => {
    it('should check eligibility on user write', async () => {
      const change = {
        before: { data: () => null },
        after: {
          data: () => ({
            isAdult: true,
            role: 'user',
            countryCode: 'US',
            languageCode: 'en',
          }),
        },
      };
      const context = createMockContext({ userId: 'test-user' });

      const result = await checkAmbassadorEligibility(change, context);

      expect(result).toBeNull();
    });

    it('should not process if no relevant changes', async () => {
      const change = {
        before: { data: () => ({ role: 'user' }) },
        after: { data: () => ({ role: 'user' }) }, // No change
      };
      const context = createMockContext({ userId: 'test-user' });

      const result = await checkAmbassadorEligibility(change, context);

      expect(result).toBeNull();
    });
  });

  describe('handleAmbassadorRemoval', () => {
    it('should handle ambassador status change to inactive', async () => {
      const change = {
        before: { data: () => ({ status: 'active' }) },
        after: {
          data: () => ({
            status: 'inactive',
            countryCode: 'US',
            languageCode: 'en',
          }),
        },
      };
      const context = createMockContext({ ambassadorId: 'test-ambassador' });

      const result = await handleAmbassadorRemoval(change, context);

      expect(result).toBeNull();
      expect(mockCollection.add).toHaveBeenCalledWith(
        expect.objectContaining({
          ambassadorId: 'test-ambassador',
          countryCode: 'US',
          languageCode: 'en',
          reason: 'status_change_to_inactive',
        })
      );
    });

    it('should not process if status not changed to inactive', async () => {
      const change = {
        before: { data: () => ({ status: 'active' }) },
        after: { data: () => ({ status: 'active' }) }, // Still active
      };
      const context = createMockContext({ ambassadorId: 'test-ambassador' });

      const result = await handleAmbassadorRemoval(change, context);

      expect(result).toBeNull();
      expect(mockCollection.add).not.toHaveBeenCalled();
    });
  });
}); 