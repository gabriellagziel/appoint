import { describe, it, expect, beforeEach, afterEach, jest } from '@jest/globals';
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions-test';

// Mock Firebase Admin
jest.mock('firebase-admin', () => ({
  apps: { length: 0 },
  initializeApp: jest.fn(),
  firestore: jest.fn(() => ({
    collection: jest.fn(),
    batch: jest.fn(),
    FieldValue: {
      serverTimestamp: jest.fn(() => 'mock-timestamp'),
      increment: jest.fn((val: number) => `increment-${val}`),
    },
    Timestamp: {
      now: jest.fn(() => ({ seconds: 1234567890 })),
    },
  })),
  messaging: jest.fn(() => ({
    sendMulticast: jest.fn(),
  })),
}));

// Import functions after mocking
import { sendBroadcastMessage, processScheduledBroadcasts } from '../src/broadcasts';

const testEnv = functions();
const mockFirestore = admin.firestore();
const mockMessaging = admin.messaging();

describe('Broadcast Firebase Functions', () => {
  let mockCollection: any;
  let mockDoc: any;
  let mockGet: any;
  let mockUpdate: any;
  let mockBatch: any;

  beforeEach(() => {
    jest.clearAllMocks();
    
    // Setup Firestore mocks
    mockGet = jest.fn();
    mockUpdate = jest.fn();
    mockBatch = jest.fn();
    mockDoc = jest.fn(() => ({
      get: mockGet,
      update: mockUpdate,
    }));
    mockCollection = jest.fn(() => ({
      doc: mockDoc,
      where: jest.fn().mockReturnThis(),
      orderBy: jest.fn().mockReturnThis(),
      limit: jest.fn().mockReturnThis(),
      get: jest.fn(),
    }));

    (mockFirestore.collection as jest.Mock).mockImplementation(mockCollection);
    (mockFirestore.batch as jest.Mock).mockReturnValue({
      set: jest.fn(),
      commit: jest.fn(),
    });
  });

  afterEach(() => {
    testEnv.cleanup();
  });

  describe('sendBroadcastMessage', () => {
    const mockContext = {
      auth: { uid: 'admin-123' },
    };

    const mockData = {
      messageId: 'message-123',
      adminId: 'admin-123',
    };

    it('should require authentication', async () => {
      const wrapped = testEnv.wrap(sendBroadcastMessage);
      
      await expect(
        wrapped(mockData, { auth: null })
      ).rejects.toThrow('User must be authenticated');
    });

    it('should require admin privileges', async () => {
      const wrapped = testEnv.wrap(sendBroadcastMessage);
      
      // Mock user doc without admin role
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({ role: 'user' }),
      });

      await expect(
        wrapped(mockData, mockContext)
      ).rejects.toThrow('Admin privileges required');
    });

    it('should handle non-existent message', async () => {
      const wrapped = testEnv.wrap(sendBroadcastMessage);
      
      // Mock admin user
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({ role: 'admin' }),
      });

      // Mock non-existent message
      mockGet.mockResolvedValueOnce({
        exists: false,
      });

      await expect(
        wrapped(mockData, mockContext)
      ).rejects.toThrow('Broadcast message not found');
    });

    it('should handle message not in pending status', async () => {
      const wrapped = testEnv.wrap(sendBroadcastMessage);
      
      // Mock admin user
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({ role: 'admin' }),
      });

      // Mock message with wrong status
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({
          status: 'sent',
          title: 'Test Message',
          content: 'Test content',
        }),
      });

      await expect(
        wrapped(mockData, mockContext)
      ).rejects.toThrow('Message is not in pending status');
    });

    it('should successfully send broadcast to users with valid FCM tokens', async () => {
      const wrapped = testEnv.wrap(sendBroadcastMessage);
      
      // Mock admin user
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({ role: 'admin' }),
      });

      // Mock pending message
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({
          status: 'pending',
          title: 'Test Message',
          content: 'Test content',
          type: 'text',
          targetingFilters: {},
        }),
      });

      // Mock target users query
      const mockUsersQuery = {
        get: jest.fn().mockResolvedValue({
          forEach: (callback: any) => {
            // Mock 2 users with valid FCM tokens
            callback({
              id: 'user-1',
              data: () => ({ fcmToken: 'token-1' }),
            });
            callback({
              id: 'user-2',
              data: () => ({ fcmToken: 'token-2' }),
            });
          },
        }),
      };

      mockCollection.mockReturnValue({
        ...mockCollection(),
        where: jest.fn().mockReturnThis(),
        get: jest.fn().mockResolvedValue(mockUsersQuery.get()),
      });

      // Mock successful FCM response
      (mockMessaging.sendMulticast as jest.Mock).mockResolvedValue({
        successCount: 2,
        failureCount: 0,
        responses: [
          { success: true },
          { success: true },
        ],
      });

      const result = await wrapped(mockData, mockContext);

      expect(result.success).toBe(true);
      expect(result.deliveredCount).toBe(2);
      expect(result.failedCount).toBe(0);
      expect(mockUpdate).toHaveBeenCalledWith(
        expect.objectContaining({
          status: 'sent',
          deliveredCount: 2,
          failedCount: 0,
        })
      );
    });

    it('should handle partial failures with retries', async () => {
      const wrapped = testEnv.wrap(sendBroadcastMessage);
      
      // Mock admin user and pending message
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({ role: 'admin' }),
      });

      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({
          status: 'pending',
          title: 'Test Message',
          content: 'Test content',
          type: 'text',
          targetingFilters: {},
        }),
      });

      // Mock target users
      const mockUsersQuery = {
        get: jest.fn().mockResolvedValue({
          forEach: (callback: any) => {
            callback({
              id: 'user-1',
              data: () => ({ fcmToken: 'token-1' }),
            });
            callback({
              id: 'user-2',
              data: () => ({ fcmToken: 'token-2' }),
            });
          },
        }),
      };

      mockCollection.mockReturnValue({
        ...mockCollection(),
        where: jest.fn().mockReturnThis(),
        get: jest.fn().mockResolvedValue(mockUsersQuery.get()),
      });

      // Mock partial failure, then success on retry
      (mockMessaging.sendMulticast as jest.Mock)
        .mockResolvedValueOnce({
          successCount: 1,
          failureCount: 1,
          responses: [
            { success: true },
            { success: false, error: { code: 'quota-exceeded' } },
          ],
        })
        .mockResolvedValueOnce({
          successCount: 1,
          failureCount: 0,
          responses: [
            { success: true },
          ],
        });

      const result = await wrapped(mockData, mockContext);

      expect(result.deliveredCount).toBe(2);
      expect(result.failedCount).toBe(0);
      expect(result.retryCount).toBeGreaterThan(0);
    });

    it('should handle users without FCM tokens', async () => {
      const wrapped = testEnv.wrap(sendBroadcastMessage);
      
      // Mock admin user and pending message
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({ role: 'admin' }),
      });

      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({
          status: 'pending',
          title: 'Test Message',
          content: 'Test content',
          type: 'text',
          targetingFilters: {},
        }),
      });

      // Mock users without FCM tokens
      const mockUsersQuery = {
        get: jest.fn().mockResolvedValue({
          forEach: (callback: any) => {
            callback({
              id: 'user-1',
              data: () => ({ fcmToken: null }),
            });
            callback({
              id: 'user-2',
              data: () => ({ fcmToken: '' }),
            });
            callback({
              id: 'user-3',
              data: () => ({}), // No fcmToken field
            });
          },
        }),
      };

      mockCollection.mockReturnValue({
        ...mockCollection(),
        where: jest.fn().mockReturnThis(),
        get: jest.fn().mockResolvedValue(mockUsersQuery.get()),
      });

      const result = await wrapped(mockData, mockContext);

      expect(result.deliveredCount).toBe(0);
      expect(result.failedCount).toBe(0);
      expect(mockUpdate).toHaveBeenCalledWith(
        expect.objectContaining({
          status: 'sent',
          actualRecipients: 0,
        })
      );
    });

    it('should handle FCM payload creation for different message types', async () => {
      const wrapped = testEnv.wrap(sendBroadcastMessage);
      
      // Mock admin user
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({ role: 'admin' }),
      });

      // Mock image message
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({
          status: 'pending',
          title: 'Image Message',
          content: 'Check out this image',
          type: 'image',
          imageUrl: 'https://example.com/image.jpg',
          targetingFilters: {},
        }),
      });

      // Mock user with FCM token
      const mockUsersQuery = {
        get: jest.fn().mockResolvedValue({
          forEach: (callback: any) => {
            callback({
              id: 'user-1',
              data: () => ({ fcmToken: 'token-1' }),
            });
          },
        }),
      };

      mockCollection.mockReturnValue({
        ...mockCollection(),
        where: jest.fn().mockReturnThis(),
        get: jest.fn().mockResolvedValue(mockUsersQuery.get()),
      });

      (mockMessaging.sendMulticast as jest.Mock).mockResolvedValue({
        successCount: 1,
        failureCount: 0,
        responses: [{ success: true }],
      });

      await wrapped(mockData, mockContext);

      // Verify FCM payload includes image data
      const fcmCall = (mockMessaging.sendMulticast as jest.Mock).mock.calls[0][0];
      expect(fcmCall.data.imageUrl).toBe('https://example.com/image.jpg');
      expect(fcmCall.data.type).toBe('image');
    });
  });

  describe('processScheduledBroadcasts', () => {
    it('should process scheduled messages', async () => {
      const wrapped = testEnv.wrap(processScheduledBroadcasts);
      
      // Mock scheduled messages query
      const mockScheduledQuery = {
        empty: false,
        size: 1,
        docs: [
          {
            id: 'scheduled-message-1',
            data: () => ({
              status: 'pending',
              title: 'Scheduled Message',
              content: 'This is scheduled',
              type: 'text',
              targetingFilters: {},
              scheduledFor: { seconds: 1234567890 },
            }),
          },
        ],
      };

      mockCollection.mockReturnValue({
        where: jest.fn().mockReturnThis(),
        limit: jest.fn().mockReturnThis(),
        get: jest.fn().mockResolvedValue(mockScheduledQuery),
      });

      // Mock target users for scheduled message
      const mockUsersQuery = {
        get: jest.fn().mockResolvedValue({
          forEach: (callback: any) => {
            callback({
              id: 'user-1',
              data: () => ({ fcmToken: 'token-1' }),
            });
          },
        }),
      };

      // Mock successful FCM send
      (mockMessaging.sendMulticast as jest.Mock).mockResolvedValue({
        successCount: 1,
        failureCount: 0,
        responses: [{ success: true }],
      });

      await wrapped(null);

      expect(mockUpdate).toHaveBeenCalledWith(
        expect.objectContaining({
          status: 'sent',
        })
      );
    });

    it('should handle empty scheduled messages', async () => {
      const wrapped = testEnv.wrap(processScheduledBroadcasts);
      
      mockCollection.mockReturnValue({
        where: jest.fn().mockReturnThis(),
        limit: jest.fn().mockReturnThis(),
        get: jest.fn().mockResolvedValue({ empty: true }),
      });

      await wrapped(null);

      // Should complete without errors
      expect(mockUpdate).not.toHaveBeenCalled();
    });

    it('should handle errors in scheduled message processing', async () => {
      const wrapped = testEnv.wrap(processScheduledBroadcasts);
      
      const mockScheduledQuery = {
        empty: false,
        size: 1,
        docs: [
          {
            id: 'scheduled-message-1',
            data: () => ({
              status: 'pending',
              scheduledFor: { seconds: 1234567890 },
            }),
          },
        ],
      };

      mockCollection.mockReturnValue({
        where: jest.fn().mockReturnThis(),
        limit: jest.fn().mockReturnThis(),
        get: jest.fn().mockResolvedValue(mockScheduledQuery),
      });

      // Mock error in target users query
      mockCollection.mockImplementation(() => {
        throw new Error('Firestore error');
      });

      await wrapped(null);

      // Should update message with failed status
      expect(mockUpdate).toHaveBeenCalledWith(
        expect.objectContaining({
          status: 'failed',
          failureReason: expect.stringContaining('error'),
        })
      );
    });
  });

  describe('Batch Processing', () => {
    it('should handle large audiences with batching', async () => {
      const wrapped = testEnv.wrap(sendBroadcastMessage);
      
      // Mock admin user and pending message
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({ role: 'admin' }),
      });

      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({
          status: 'pending',
          title: 'Large Broadcast',
          content: 'Sending to many users',
          type: 'text',
          targetingFilters: {},
        }),
      });

      // Mock 250 users (should result in 3 batches of 100, 100, 50)
      const mockUsersQuery = {
        get: jest.fn().mockResolvedValue({
          forEach: (callback: any) => {
            for (let i = 1; i <= 250; i++) {
              callback({
                id: `user-${i}`,
                data: () => ({ fcmToken: `token-${i}` }),
              });
            }
          },
        }),
      };

      mockCollection.mockReturnValue({
        ...mockCollection(),
        where: jest.fn().mockReturnThis(),
        get: jest.fn().mockResolvedValue(mockUsersQuery.get()),
      });

      // Mock successful FCM responses for all batches
      (mockMessaging.sendMulticast as jest.Mock)
        .mockResolvedValueOnce({
          successCount: 100,
          failureCount: 0,
          responses: Array(100).fill({ success: true }),
        })
        .mockResolvedValueOnce({
          successCount: 100,
          failureCount: 0,
          responses: Array(100).fill({ success: true }),
        })
        .mockResolvedValueOnce({
          successCount: 50,
          failureCount: 0,
          responses: Array(50).fill({ success: true }),
        });

      const result = await wrapped({
        messageId: 'message-123',
        adminId: 'admin-123',
      }, {
        auth: { uid: 'admin-123' },
      });

      expect(result.deliveredCount).toBe(250);
      expect(result.failedCount).toBe(0);
      expect(mockMessaging.sendMulticast).toHaveBeenCalledTimes(3);
    });
  });

  describe('Error Handling', () => {
    it('should properly categorize retryable vs non-retryable errors', async () => {
      const wrapped = testEnv.wrap(sendBroadcastMessage);
      
      // Mock admin user and pending message
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({ role: 'admin' }),
      });

      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({
          status: 'pending',
          title: 'Test Message',
          content: 'Test content',
          type: 'text',
          targetingFilters: {},
        }),
      });

      // Mock target users
      const mockUsersQuery = {
        get: jest.fn().mockResolvedValue({
          forEach: (callback: any) => {
            callback({
              id: 'user-1',
              data: () => ({ fcmToken: 'token-1' }),
            });
            callback({
              id: 'user-2',
              data: () => ({ fcmToken: 'token-2' }),
            });
          },
        }),
      };

      mockCollection.mockReturnValue({
        ...mockCollection(),
        where: jest.fn().mockReturnThis(),
        get: jest.fn().mockResolvedValue(mockUsersQuery.get()),
      });

      // Mock retryable error, then non-retryable error
      (mockMessaging.sendMulticast as jest.Mock).mockResolvedValue({
        successCount: 0,
        failureCount: 2,
        responses: [
          { success: false, error: { code: 'quota-exceeded' } }, // Retryable
          { success: false, error: { code: 'invalid-registration-token' } }, // Non-retryable
        ],
      });

      const result = await wrapped({
        messageId: 'message-123',
        adminId: 'admin-123',
      }, {
        auth: { uid: 'admin-123' },
      });

      expect(result.deliveredCount).toBe(0);
      expect(result.failedCount).toBe(2);
      expect(result.errors).toHaveLength(2);
    });
  });
});